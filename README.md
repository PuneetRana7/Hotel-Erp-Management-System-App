# 🏨 Hotel ERP Management System

A professional **Hotel ERP** built in pure Java (Swing + SQLite).

---

## Quick Start

### Prerequisites
- **Java JDK 17+** installed (JDK 25 detected on this machine)

### Run the application
Double-click `run.bat` **or** open a terminal and type:

```bat
run.bat
```

Default login → `admin` / `admin123`

---

## Project Structure

```
Hotel erp system/
├── src/
│   ├── Main.java          Entry point
│   ├── Database.java      SQLite JDBC layer (all CRUD operations)
│   ├── Login.java         Frameless login screen + shared theme utils
│   ├── Dashboard.java     Main window, sidebar nav, stat cards
│   ├── Management.java    Rooms · Guests · Reservations · Staff tabs
│   └── Billing.java       Generate bills · Mark paid · Receipt preview
├── lib/
│   └── sqlite-jdbc-*.jar  SQLite JDBC driver (bundled)
├── out/                   Compiled .class files
├── run.bat                Windows build & run script
└── run.sh                 Linux / macOS build & run script
```

The database file `hotel_erp.db` is created automatically on first run.

---

## Features

| Module | Features |
|---|---|
| **Dashboard** | 8 live stat cards (rooms, guests, revenue, check-ins/outs, staff) + recent reservations table |
| **Rooms** | Add / Edit / Delete rooms · Standard · Deluxe · Suite · Track availability |
| **Guests** | Register guests · Store name, phone, email, address, ID proof · Full CRUD |
| **Reservations** | Book rooms · Auto-block occupied rooms · Check-In / Check-Out / Cancel · Auto room status update |
| **Billing** | Generate bill with service charges · Mark Paid/Pending · Receipt preview · Revenue summary |
| **Staff** | Add / Edit / Delete staff · Role, salary, join date · Status tracking |
| **Theme** | 🌙 Dark / ☀ Light toggle in top bar |

---

## Windows Desktop Installer (.EXE)

A complete standalone Windows setup wizard has been generated with `jpackage`:

- **Installer File:** `dist/Hotel ERP Management System-1.0.0.exe` (54 MB)
- **Features Included:**
  - Embedded OpenJDK 25 Runtime (target machines do not need Java installed)
  - SQLite JDBC driver bundled and pre-configured
  - Windows Desktop shortcut creation
  - Windows Start Menu integration
  - Custom branded application icon
  - Standard directory chooser and uninstaller support

Double-click `dist/Hotel ERP Management System-1.0.0.exe` to run the installation wizard.


On first launch the application seeds:
- **8 rooms** (Standard · Deluxe · Suite)
- **4 staff members**
- **1 admin user** (`admin` / `admin123`)

---

## Compile Manually

```bat
javac -cp lib\sqlite-jdbc-3.47.1.0.jar -d out src\*.java
java  -cp out;lib\sqlite-jdbc-3.47.1.0.jar Main
```

