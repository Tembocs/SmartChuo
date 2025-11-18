# College Library System - Architecture Document

## **UI Overview**

Layout: **Left vertical sidebar** for major sections, **Top horizontal tabs** inside each module.

**Primary Sections:**

1. Dashboard
2. Catalog
3. Circulation
4. Members
5. Inventory
6. Reports
7. Admin
8. Help

---

## **1. Dashboard**

**Tabs:**

* **Overview** — shows counts (books, issued, overdue, users). *Info widgets.*
* **Quick Actions** — buttons for frequent tasks (check-in/out, add book). *Buttons panel.*
* **Alerts** — overdue notifications, pending reservations. *List view.*

**Access:** All authenticated users; alerts only for librarians/admins.

---

## **2. Catalog**

**Tabs:**

* **Intake / Acquisition** — record source, price, vendor. *Form.* Access: Librarian/Admin
* **Accessioning** — assign accession numbers. *Form + auto generator.* Access: Librarian/Admin
* **Cataloguing** — enter metadata (ISBN, authors, edition). *Form.* Access: Cataloguer/Librarian
* **Classification** — assign Dewey/LOC, subject, shelf. *Form + dropdown.* Access: Cataloguer
* **Labeling/Barcode** — generate & print barcode labels. *Action panel.* Access: Librarian
* **Bulk Import** — upload CSV/Excel for many books. *Upload tool.* Access: Admin

---

## **3. Circulation**

**Tabs:**

* **Find / OPAC** — search UI. *Search + list.* Access: All users
* **Checkout** — borrow book. *Form + scanner input.* Access: Librarian
* **Check-in** — return book. *Form + scanner input.* Access: Librarian
* **Renewals** — extend loan period. *Table + action.* Access: Librarian
* **Reservations** — manage holds. *Table.* Access: Librarian
* **Overdues & Fines** — list and process fines. *Table + payment record form.* Access: Librarian/Admin

---

## **4. Members**

**Tabs:**

* **Register Member** — student/staff registration. *Form.* Access: Librarian
* **Member List** — table of members. *Table.* Access: Librarian/Admin
* **Profiles** — view loans history, fines. *Info + table.* Access: Librarian
* **Import Members** — bulk upload. *Upload tool.* Access: Admin
* **ID Cards** — generate printable library cards. *Grid + export.* Access: Librarian

---

## **5. Inventory**

**Tabs:**

* **Stocktake** — verify physical vs system. *Checklist table.* Access: Librarian
* **Shelf Management** — manage shelf codes. *Form/table.* Access: Admin
* **Damaged/Repairs** — record books under repair. *Table + form.* Access: Librarian
* **Withdrawals** — decommission books. *Table + confirm action.* Access: Admin

---

## **6. Reports**

**Tabs:**

* **Circulation Reports** — loans stats. *Charts + table.* Access: Librarian/Admin
* **Overdue Reports** — overdue list. *Table.* Access: Librarian
* **Inventory Reports** — total, damaged, withdrawn. *Charts + table.* Access: Admin
* **Acquisition Reports** — cost tracking. *Table.* Access: Admin
* **Export Data** — CSV/PDF. *Buttons.* Access: Admin

---

## **7. Admin**

**Tabs:**

* **Users & Roles** — manage staff accounts. *Table + form.* Access: Admin
* **Loan Policies** — loan period, limits, fines config. *Form.* Access: Admin
* **Shelves/Locations** — define shelf structure. *Form/table.* Access: Admin
* **Integrations** — barcode/RFID config. *Settings page.* Access: Admin
* **Backup & Sync** — backup DB. *Button + cloud config.* Access: Admin
* **Audit Log** — track actions. *Table.* Access: Admin

---

## **8. Help**

**Tabs:**

* **User Guide** — documentation view. *Text/UI blocks.*
* **Shortcuts** — list of keyboard shortcuts. *Table.*
* **Support** — contact/help link. *Links.*

Access: All users

---

## **Database & Logic Notes**

* SQLite locally (offline-first)
* Sync layer optional (API later)
* Tables: books, accession_log, users, roles, loans, reservations, fines, shelves, audit_log, settings
* State management: flutter_bloc
* DI: get_it
* PDF/barcode generation
* Scanner support

---

## **Security & Roles**

* Admin: full control
* Librarian: circulation, catalog, member mgmt
* Cataloguer: catalog tasks only
* Student/Staff: OPAC only (view)
