# Hotel ERP Management System - Technology Stack & Architecture Documentation

## 1. Project Overview & Purpose

The **Hotel ERP Management System** is a standalone, lightweight desktop Enterprise Resource Planning (ERP) application developed in pure Java. It is designed to manage day-to-day hospitality operations efficiently with zero external framework overhead.

### Primary Purpose
- **Front-Desk & Reservations Management:** Handle guest check-ins, check-outs, room booking status, and prevent double-booking.
- **Room Management:** Comprehensive cataloging of hotel rooms (Standard, Deluxe, Suite) including dynamic status tracking (Available, Occupied, Maintenance).
- **Guest Profiles:** Management of guest records, contact information, and stay history.
- **Billing & Point of Sale:** Automated computation of room nights, additional services (dining, laundry, airport transfer), and receipt generation.
- **Staff Administration:** Directory of active hotel personnel across departments with role allocation.
- **Executive Operations Dashboard:** Real-time KPI visibility covering total rooms, occupancy rates, daily check-ins/check-outs, active staff count, and revenue summaries.

---

## 2. Programming Language & Java Version

| Parameter | Details |
|---|---|
| **Language** | Java |
| **Java Platform** | Java Standard Edition (Java SE) |
| **Runtime / JDK Version** | OpenJDK 25 LTS (Eclipse Adoptium Temurin-25.0.3+9-LTS) |
| **Minimum Compatibility** | Java SE 17+ (supports Java 17, 21, and 25) |
| **Language Features Used** | Text blocks (`"""`), Switch expressions with arrow syntax (`->`), Try-with-resources, Lambda expressions, Streams, Records/Type inference (`var`) |

---

## 3. GUI Framework

The graphical user interface is built entirely using standard Java desktop GUI technologies without third-party UI toolkits:

- **Framework:** **Java Swing** (`javax.swing.*`)
- **Abstract Window Toolkit:** **Java AWT** (`java.awt.*`, `java.awt.geom.*`, `java.awt.event.*`)
- **Look and Feel (L&F):** Cross-platform Look and Feel (`javax.swing.UIManager`) configured to prioritize **Nimbus Look and Feel** with custom component renderers and fallback to the System Look and Feel.
- **Concurrency & Thread Safety:** All UI creations and frame updates are dispatched on the **AWT Event Dispatch Thread (EDT)** using `SwingUtilities.invokeLater()`.

---

## 4. Database & Database Connectivity

| Component | Specification |
|---|---|
| **Database Engine** | **SQLite 3** |
| **Storage Model** | Embedded / Serverless single-file relational database (`hotel_erp.db`) |
| **Connectivity Interface** | **JDBC (Java Database Connectivity)** via `java.sql.*` |
| **Connection String** | `jdbc:sqlite:hotel_erp.db` |
| **Integrity Enforcement** | Foreign key constraints enforced at connection initiation (`PRAGMA foreign_keys = ON`) |
| **Data Safety & Transactions** | Parametrized SQL execution using `PreparedStatement` to prevent SQL injection vulnerabilities |

### Managed Tables
1. `users` — Authentication credentials and system roles.
2. `rooms` — Room numbers, types, rates, and operational statuses.
3. `guests` — Customer demographics and contact records.
4. `reservations` — Check-in/out scheduling, assigned rooms, and statuses (`Booked`, `Checked-In`, `Checked-Out`, `Cancelled`).
5. `billing` — Invoicing records, subtotal breakdowns, service fees, and payment status (`Paid` / `Pending`).
6. `staff` — Employee records, departmental duties, contact numbers, and employment status.

---

## 5. External Libraries & Dependencies

The project maintains an ultra-lean architecture by relying on a single external JAR dependency for database communication:

| Dependency | JAR File | Location | Purpose |
|---|---|---|---|
| **SQLite JDBC Driver** | `sqlite-jdbc-3.47.1.0.jar` | `lib/` | Provides the native JDBC bridge (`org.sqlite.JDBC`) between Java and the SQLite relational engine. |

*No heavy frameworks (Spring, Hibernate, JavaFX, or Lombok) are utilized, ensuring instant start-up time and portability across operating systems.*

---

## 6. UI Design Technologies & Styling Engine

The system achieves a modern, commercial-grade appearance through custom Java2D vector graphics and component paint overrides:

- **2D Graphics Subsystem:** `java.awt.Graphics2D` with bilinear interpolation and antialiasing hints (`RenderingHints.KEY_ANTIALIASING`, `KEY_INTERPOLATION_BILINEAR`, `KEY_TEXT_ANTIALIASING_ON`).
- **Dynamic Theming:** Centralized theme registry (`Login.java`) providing dual-theme support (**Light Mode** and **Dark Mode**):
  - **Sidebar:** Deep Navy (`#17243A` / `#101827`)
  - **Accent:** Champagne Gold (`#C5A46D` / `#D6B477`)
  - **Background:** Crisp Soft Gray/White (`#F4F6F9`) / Deep Slate (`#151B26`)
  - **Card Surfaces:** Pure White (`#FFFFFF`) / Dark Slate (`#202A39`)
  - **High-Contrast Text:** Rich Slate (`#0F172A`) and Crisp Secondary Slate (`#475569`)
- **Custom Vector Iconography:** Pure Java2D vector-drawn icons via `Dashboard$NavIcon` (zero external emoji fonts or bitmap icons).
- **Banner Engine:** Hero banner with local image rendering (`assets/hotel_banner.jpg`), smooth bilinear scaling, and a dark overlay ensuring legible typography.
- **Frameless Window Support:** Custom drag listeners (`MouseAdapter`, `MouseMotionAdapter`) and shape clipping (`RoundRectangle2D`).
- **Table Components:** Custom `TableCellRenderer` for alternate row highlighting and custom status badge rendering.

---

## 7. Project Architecture & File Structure

The project strictly follows a clean, single-tier modular design pattern separating persistence, business logic, and view presentation across 6 core Java source files:

```
Hotel erp system/
├── assets/
│   └── hotel_banner.jpg          # Luxury hotel lobby hero banner image
├── lib/
│   └── sqlite-jdbc-3.47.1.0.jar  # SQLite JDBC driver
├── out/                          # Compiled bytecode class files
├── src/
│   ├── Main.java                 # Entry point; DB initialization & Look-and-Feel launcher
│   ├── Database.java             # SQLite connection pool, schema migrations & CRUD DAO methods
│   ├── Login.java                # Frameless authentication screen & global theme color registry
│   ├── Dashboard.java            # Main window, navigation sidebar, hero banner & KPI cards
│   ├── Management.java           # Subsystems: Rooms, Guests, Reservations & Staff management
│   └── Billing.java              # Invoicing, charge calculations, and receipt modal view
├── hotel_erp.db                  # SQLite database file (created automatically on startup)
├── README.md                     # Quick start and project reference
├── run.bat                       # Windows automated compile & launch script
├── run.sh                        # Linux / macOS automated compile & launch script
└── TECHNOLOGY_STACK.md           # Technical stack and architectural specifications
```

---

## 8. Development Tools & IDE Compatibility

- **Primary IDE:** Compatible with **VS Code**, **IntelliJ IDEA**, **Eclipse Adoptium IDE**, and **Apache NetBeans**.
- **Build System:** Standard Java compiler (`javac`) paired with platform shell scripts (`run.bat` / `run.sh`).
- **Version Control:** Git compatible (`.gitignore` targets `out/` and `*.db`).

---

## 9. Application Execution Process

The lifecycle of the application follows an automated sequential flow:

```
[Start run.bat / run.sh]
        │
        ▼
[Locate JDK (17/21/25)] ───► [Compile src/*.java to out/ with sqlite-jdbc in classpath]
        │
        ▼
[Launch Main.java]
        │
        ├──► Database.initializeDatabase()
        │       ├── Connects to hotel_erp.db via JDBC
        │       ├── Sets PRAGMA foreign_keys = ON
        │       ├── Executes CREATE TABLE IF NOT EXISTS for all 6 tables
        │       └── Seeds default administrator (admin / admin123) and sample rooms
        │
        └──► Swing Event Dispatch Thread (EDT)
                ├── Sets Nimbus / System Look and Feel
                ├── Launches Frameless Login window
                └── On successful authentication, instantiates Dashboard with Sidebar & Management modules
```

---

## 10. Purpose of Each Technology Used

| Technology | Role & Justification |
|---|---|
| **Java SE (Standard Edition)** | Provides cross-platform object-oriented runtime, memory management, and strong typing. |
| **Java Swing & AWT** | Delivers an instant, native desktop interface without requiring web browsers, node runtimes, or heavy Electron bundles. |
| **Java2D Vector Engine** | Enables crisp high-DPI custom UI components, rounded borders, gradient overlays, and lightweight vector icons. |
| **SQLite 3** | Zero-configuration, serverless SQL database stored as a portable file (`hotel_erp.db`), ideal for standalone enterprise software. |
| **SQLite JDBC Driver** | Facilitates standard JDBC database operations, connection pooling, and secure parameterized queries. |
| **Batch (`.bat`) & Shell (`.sh`) Scripts** | Provides automated one-click compilation and execution without requiring complex build tools like Maven or Gradle. |

---

## 11. Complete Technology Stack Summary

```
┌────────────────────────────────────────────────────────┐
│               PRESENTATION LAYER (GUI)                 │
│   • Java Swing (JFrame, JPanel, JTable, CardLayout)     │
│   • Java AWT (Graphics2D, Geometric Shapes, Events)     │
│   • Custom Theme Engine (Light / Dark Mode Palette)    │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│               BUSINESS & LOGIC LAYER                   │
│   • OpenJDK 25 LTS / Java SE (Main, Dashboard, etc.)   │
│   • Role-based Access Control (Admin / Staff)          │
│   • Transaction Validators & Auto-Calculators          │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                DATA PERSISTENCE LAYER                  │
│   • JDBC API (java.sql.Connection, PreparedStatement)  │
│   • SQLite JDBC Bridge (sqlite-jdbc-3.47.1.0.jar)       │
│   • SQLite 3 Embedded Database (hotel_erp.db)          │
└────────────────────────────────────────────────────────┘
```

