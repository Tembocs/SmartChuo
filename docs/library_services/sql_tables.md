# SQL Tables

Based on everything you’ve discussed so far in the **Library Project** — including book acquisition, cataloguing (with barcode scanning), lending, and returns — the following **database tables** will be needed:

---

### 📚 **Core Tables**

1. **books** – stores detailed information about each book in the library.
2. **authors** – stores author details; supports multiple authors per book.
3. **publishers** – stores publisher information.
4. **categories** – defines subjects/genres (e.g., Medicine, History, etc.).
5. **shelves** – represents physical or virtual locations in the library.
6. **book_copies** – individual physical copies of a book, each with its own barcode or unique ID.

---

### 👥 **User & Access Tables**

7. **members** – library members (students, staff, or external users).
8. **staff** – library staff and administrators with login privileges.
9. **roles** – defines role-based permissions (e.g., Librarian, Assistant, Admin).
10. **users** – authentication and login table linking to staff or members.

---

### 🔄 **Transaction Tables**

11. **loans** – records when a book copy is borrowed.
12. **returns** – records when a book copy is returned.
13. **fines** – manages fines for late returns or lost books.
14. **reservations** – when a member reserves a book before it becomes available.
15. **loan_history** – keeps historical records of all borrow/return transactions.

---

### 🧾 **Acquisition & Inventory Tables**

16. **suppliers** – book suppliers or vendors.
17. **acquisitions** – tracks new books purchased or donated.
18. **stock_audit** – for periodic stock taking and reconciliation.

---

### 🧠 **Reference & Support Tables**

19. **languages** – list of book languages (English, Kiswahili, etc.).
20. **book_tags** – optional tags for easy search (keywords, topics).
21. **system_logs** – records user activities (e.g., who edited what).
22. **settings** – stores configurable system parameters (loan period, fine rates, etc.).

---


# Tables Grouped By Module

Here is the **clean modular grouping** of all the tables for the Library Management System:

---

## **1. Cataloguing Module**

(For managing books and their metadata)

* **books**
* **authors**
* **publishers**
* **categories**
* **languages**
* **book_tags**
* **shelves**
* **book_copies**

---

## **2. Circulation Module**

(For borrowing, returning, reserving, and fines)

* **loans**
* **returns**
* **reservations**
* **fines**
* **loan_history**

---

## **3. Membership Module**

(For students, staff, and external library member records)

* **members**
* **staff**
* **users**
* **roles**

---

## **4. Acquisition & Inventory Module**

(For book sourcing and stock management)

* **suppliers**
* **acquisitions**
* **stock_audit**

---

## **5. System & Support Module**

(Internal system functions)

* **system_logs**
* **settings**

---
