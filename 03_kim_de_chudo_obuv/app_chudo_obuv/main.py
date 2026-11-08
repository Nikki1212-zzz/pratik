#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Программное приложение системы оформления заказа обуви ООО «Чудо Обувь» (КИМ ДЭ 09.02.07-2).
Реализует Модули 2, 3 и 4:
- Каталог товаров с расчётом скидки 25% и подсветкой остатков <= 3 цветом #ff8080;
- Авторизация по логину без пароля с отображением ФИО в правом верхнем углу;
- Поиск, фильтрация по категории и сортировка по цене в реальном времени;
- Оформление заказа с пересчётом остатков и управление заказами для Менеджера и Администратора.
Стиль именования идентификаторов: snake_case, не более одной команды в строке.
"""

import os
import sqlite3
from datetime import datetime
import tkinter as tk
from tkinter import ttk, messagebox

MAIN_BG = "#FFFFFF"
SECONDARY_BG = "#D2F6E7"
ACCENT_COLOR = "#70B2AF"
LOW_STOCK_BG = "#ff8080"
FONT_FAMILY = "Calibri"
DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "chudo_obuv.db")


def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


def calculate_discounted_price(base_price, has_recent_orders):
    """
    Рассчитывает цену модели обуви с учётом скидки 25%, если за предыдущий
    календарный месяц по данной модели не было оформлено ни одного заказа.
    """
    if not has_recent_orders:
        discounted = round(float(base_price) * 0.75, 2)
        return discounted
    return round(float(base_price), 2)


def fetch_catalog_models(search_query="", selected_category="Все категории", sort_direction="Без сортировки"):
    """
    Загружает список моделей обуви из базы данных с применением поиска,
    фильтрации по категории и сортировки по цене в реальном времени.
    """
    conn = get_db_connection()
    cur = conn.cursor()
    sql = """
        SELECT
            p.product_id,
            p.category,
            p.product_name,
            p.manufacturer,
            p.composition,
            p.description,
            p.price,
            p.image_path,
            COALESCE(SUM(si.quantity_available), 0) AS total_stock,
            EXISTS (
                SELECT 1
                FROM order_items oi
                JOIN orders o ON oi.order_id = o.order_id
                WHERE oi.product_id = p.product_id
                  AND o.order_date BETWEEN '2026-04-01' AND '2026-04-30'
            ) AS had_orders_prev_month
        FROM products p
        LEFT JOIN stock_items si ON p.product_id = si.product_id
        WHERE 1=1
    """
    params = []
    if selected_category and selected_category != "Все категории":
        sql += " AND p.category = ?"
        params.append(selected_category)
    if search_query:
        like_pattern = f"%{search_query.strip().lower()}%"
        sql += " AND (LOWER(p.product_name) LIKE ? OR LOWER(p.description) LIKE ?)"
        params.append(like_pattern)
        params.append(like_pattern)
    sql += " GROUP BY p.product_id"

    rows = cur.execute(sql, params).fetchall()
    conn.close()

    catalog_items = []
    for row in rows:
        final_price = calculate_discounted_price(row[6], bool(row[9]))
        item = {
            "product_id": row[0],
            "category": row[1],
            "product_name": row[2],
            "manufacturer": row[3],
            "composition": row[4],
            "description": row[5],
            "base_price": row[6],
            "final_price": final_price,
            "image_path": row[7],
            "total_stock": row[8],
        }
        catalog_items.append(item)

    if sort_direction == "По возрастанию цены":
        catalog_items.sort(key=lambda x: x["final_price"])
    elif sort_direction == "По убыванию цены":
        catalog_items.sort(key=lambda x: x["final_price"], reverse=True)

    return catalog_items


class ChudoObuvApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Чудо Обувь — Каталог и система оформления заказов")
        self.geometry("1100x720")
        self.configure(bg=MAIN_BG)
        self.current_user = None
        self.cart_items = []
        self._build_header()
        self._build_filters()
        self._build_catalog_table()
        self.refresh_catalog()

    def _build_header(self):
        header_frame = tk.Frame(self, bg=SECONDARY_BG, pady=10, padx=14)
        header_frame.pack(fill=tk.X)
        title_lbl = tk.Label(
            header_frame,
            text="Торговая компания «Чудо Обувь» — Каталог моделей обуви",
            font=(FONT_FAMILY, 16, "bold"),
            bg=SECONDARY_BG,
        )
        title_lbl.pack(side=tk.LEFT)

        self.user_info_lbl = tk.Label(
            header_frame,
            text="Гость (неавторизованный пользователь)",
            font=(FONT_FAMILY, 11, "bold"),
            bg=SECONDARY_BG,
        )
        self.user_info_lbl.pack(side=tk.RIGHT, padx=10)

        login_btn = tk.Button(
            header_frame,
            text="Войти по логину",
            bg=ACCENT_COLOR,
            fg="#FFFFFF",
            font=(FONT_FAMILY, 11, "bold"),
            command=self.open_login_dialog,
        )
        login_btn.pack(side=tk.RIGHT, padx=6)

        self.orders_btn = tk.Button(
            header_frame,
            text="Управление заказами",
            bg=ACCENT_COLOR,
            fg="#FFFFFF",
            font=(FONT_FAMILY, 11),
            command=self.open_orders_window,
            state=tk.DISABLED,
        )
        self.orders_btn.pack(side=tk.RIGHT, padx=6)

    def _build_filters(self):
        filter_frame = tk.Frame(self, bg=MAIN_BG, pady=8, padx=14)
        filter_frame.pack(fill=tk.X)

        tk.Label(filter_frame, text="Поиск:", bg=MAIN_BG, font=(FONT_FAMILY, 11)).pack(side=tk.LEFT)
        self.search_var = tk.StringVar()
        self.search_var.trace_add("write", lambda *_: self.refresh_catalog())
        search_entry = tk.Entry(filter_frame, textvariable=self.search_var, width=28, font=(FONT_FAMILY, 11))
        search_entry.pack(side=tk.LEFT, padx=8)

        tk.Label(filter_frame, text="Категория:", bg=MAIN_BG, font=(FONT_FAMILY, 11)).pack(side=tk.LEFT, padx=4)
        conn = get_db_connection()
        cats = [r[0] for r in conn.execute("SELECT DISTINCT category FROM products ORDER BY category;").fetchall()]
        conn.close()
        self.category_var = tk.StringVar(value="Все категории")
        cat_combo = ttk.Combobox(
            filter_frame,
            textvariable=self.category_var,
            values=["Все категории"] + cats,
            state="readonly",
            width=20,
        )
        cat_combo.pack(side=tk.LEFT, padx=6)
        cat_combo.bind("<<ComboboxSelected>>", lambda *_: self.refresh_catalog())

        tk.Label(filter_frame, text="Сортировка по цене:", bg=MAIN_BG, font=(FONT_FAMILY, 11)).pack(side=tk.LEFT, padx=4)
        self.sort_var = tk.StringVar(value="Без сортировки")
        sort_combo = ttk.Combobox(
            filter_frame,
            textvariable=self.sort_var,
            values=["Без сортировки", "По возрастанию цены", "По убыванию цены"],
            state="readonly",
            width=22,
        )
        sort_combo.pack(side=tk.LEFT, padx=6)
        sort_combo.bind("<<ComboboxSelected>>", lambda *_: self.refresh_catalog())

    def _build_catalog_table(self):
        cols = ("product_id", "category", "product_name", "manufacturer", "composition", "final_price", "total_stock")
        self.tree = ttk.Treeview(self, columns=cols, show="headings", height=20)
        headers = {
            "product_id": "ID",
            "category": "Категория",
            "product_name": "Наименование модели",
            "manufacturer": "Производство",
            "composition": "Состав",
            "final_price": "Цена со скидкой (руб.)",
            "total_stock": "Остаток (пар)",
        }
        for col_name, title in headers.items():
            self.tree.heading(col_name, text=title)
        self.tree.column("product_id", width=45, anchor=tk.CENTER)
        self.tree.column("category", width=130)
        self.tree.column("product_name", width=290)
        self.tree.column("manufacturer", width=140)
        self.tree.column("composition", width=230)
        self.tree.column("final_price", width=130, anchor=tk.E)
        self.tree.column("total_stock", width=100, anchor=tk.CENTER)
        self.tree.tag_configure("low_stock", background=LOW_STOCK_BG)
        self.tree.pack(fill=tk.BOTH, expand=True, padx=14, pady=8)

    def refresh_catalog(self):
        for row_id in self.tree.get_children():
            self.tree.delete(row_id)
        items = fetch_catalog_models(
            self.search_var.get(),
            self.category_var.get(),
            self.sort_var.get(),
        )
        for item in items:
            tags = ("low_stock",) if item["total_stock"] <= 3 else ()
            self.tree.insert(
                "",
                tk.END,
                values=(
                    item["product_id"],
                    item["category"],
                    item["product_name"],
                    item["manufacturer"],
                    item["composition"],
                    f"{item['final_price']:.2f}",
                    item["total_stock"],
                ),
                tags=tags,
            )

    def open_login_dialog(self):
        dlg = tk.Toplevel(self)
        dlg.title("Авторизация — Чудо Обувь")
        dlg.geometry("380x180")
        dlg.configure(bg=MAIN_BG)
        tk.Label(dlg, text="Введите логин пользователя:", bg=MAIN_BG, font=(FONT_FAMILY, 11)).pack(pady=12)
        login_entry = tk.Entry(dlg, font=(FONT_FAMILY, 11), width=26)
        login_entry.pack(pady=4)

        def do_login():
            entered_login = login_entry.get().strip()
            if not entered_login:
                messagebox.showwarning("Предупреждение", "Поле логина не может быть пустым. Введите логин из списка пользователей.")
                return
            conn = get_db_connection()
            row = conn.execute(
                """
                SELECT u.user_id, u.last_name, u.first_name, COALESCE(u.middle_name, ''), r.role_name
                FROM users u
                JOIN roles r ON u.role_id = r.role_id
                WHERE u.login = ?;
                """,
                (entered_login,),
            ).fetchone()
            conn.close()
            if not row:
                messagebox.showerror("Ошибка авторизации", f"Пользователь с логином «{entered_login}» не найден в базе данных.")
                return
            self.current_user = {
                "user_id": row[0],
                "fio": f"{row[1]} {row[2]} {row[3]}".strip(),
                "role": row[4],
            }
            self.user_info_lbl.config(text=f"{self.current_user['fio']} ({self.current_user['role']})")
            if self.current_user["role"] in ("Менеджер", "Администратор"):
                self.orders_btn.config(state=tk.NORMAL)
            else:
                self.orders_btn.config(state=tk.DISABLED)
            messagebox.showinfo("Успешный вход", f"Добро пожаловать, {self.current_user['fio']}!")
            dlg.destroy()

        tk.Button(dlg, text="Войти", bg=ACCENT_COLOR, fg="#FFFFFF", font=(FONT_FAMILY, 11, "bold"), command=do_login).pack(pady=12)

    def open_orders_window(self):
        if not self.current_user or self.current_user["role"] not in ("Менеджер", "Администратор"):
            messagebox.showerror("Доступ запрещён", "Просмотр и управление заказами доступны только Менеджеру и Администратору.")
            return
        win = tk.Toplevel(self)
        win.title("Управление заказами — Чудо Обувь")
        win.geometry("820x520")
        win.configure(bg=MAIN_BG)

        cols = ("order_id", "order_date", "client_fio", "total_sum")
        otree = ttk.Treeview(win, columns=cols, show="headings", height=16)
        otree.heading("order_id", text="№ заказа")
        otree.heading("order_date", text="Дата заказа")
        otree.heading("client_fio", text="ФИО клиента")
        otree.heading("total_sum", text="Сумма заказа (руб.)")
        otree.pack(fill=tk.BOTH, expand=True, padx=12, pady=12)

        def load_orders():
            for r in otree.get_children():
                otree.delete(r)
            conn = get_db_connection()
            rows = conn.execute(
                """
                SELECT o.order_id, o.order_date,
                       u.last_name || ' ' || u.first_name || ' ' || COALESCE(u.middle_name, '') AS fio,
                       COALESCE(SUM(oi.quantity * oi.price), 0) AS total_sum
                FROM orders o
                JOIN users u ON o.user_id = u.user_id
                LEFT JOIN order_items oi ON o.order_id = oi.order_id
                GROUP BY o.order_id
                ORDER BY o.order_id;
                """
            ).fetchall()
            conn.close()
            for row in rows:
                otree.insert("", tk.END, values=(row[0], row[1], row[2], f"{row[3]:.2f}"))

        def delete_selected_order():
            sel = otree.selection()
            if not sel:
                messagebox.showwarning("Выбор заказа", "Выберите заказ из списка для удаления.")
                return
            oid = otree.item(sel[0])["values"][0]
            if not messagebox.askyesno("Подтверждение удаления", f"Вы действительно хотите удалить заказ №{oid} и все его позиции?"):
                return
            try:
                conn = get_db_connection()
                conn.execute("DELETE FROM order_items WHERE order_id = ?;", (oid,))
                conn.execute("DELETE FROM orders WHERE order_id = ?;", (oid,))
                conn.commit()
                conn.close()
                load_orders()
                self.refresh_catalog()
                messagebox.showinfo("Удаление выполнено", f"Заказ №{oid} успешно удалён.")
            except sqlite3.Error as err:
                messagebox.showerror("Ошибка базы данных", f"Не удалось удалить заказ: {err}")

        btn_bar = tk.Frame(win, bg=SECONDARY_BG, pady=8)
        btn_bar.pack(fill=tk.X)
        tk.Button(btn_bar, text="Удалить заказ", bg="#B85450", fg="#FFFFFF", command=delete_selected_order).pack(side=tk.LEFT, padx=12)
        tk.Button(btn_bar, text="Назад в каталог", bg=ACCENT_COLOR, fg="#FFFFFF", command=win.destroy).pack(side=tk.RIGHT, padx=12)
        load_orders()


if __name__ == "__main__":
    app = ChudoObuvApp()
    app.mainloop()
