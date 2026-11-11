#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  Hotel ERP Management System – Build & Run Script (Linux / macOS)
#  Usage:  ./run.sh
#
#  Prerequisites:
#    1. Java JDK 17+ installed (java / javac on PATH)
#    2. sqlite-jdbc-*.jar present in the lib/ folder
# ═══════════════════════════════════════════════════════════════════════════

SRC_DIR="src"
OUT_DIR="out"
LIB_DIR="lib"
MAIN_CLASS="Main"

# ── Locate SQLite JAR ────────────────────────────────────────────────────
SQLITE_JAR=$(ls ${LIB_DIR}/sqlite-jdbc-*.jar 2>/dev/null | head -1)

if [ -z "$SQLITE_JAR" ]; then
  echo ""
  echo "  [ERROR] SQLite JDBC driver not found in lib/"
  echo ""
  echo "  Please download from:"
  echo "    https://github.com/xerial/sqlite-jdbc/releases"
  echo "  and place the .jar in lib/, then re-run."
  echo ""
  exit 1
fi

echo "  [INFO]  Using: $SQLITE_JAR"

mkdir -p "$OUT_DIR"

echo "  [INFO]  Compiling sources..."
javac -cp "$SQLITE_JAR" -d "$OUT_DIR" "$SRC_DIR"/*.java

if [ $? -ne 0 ]; then
  echo "  [ERROR] Compilation failed."
  exit 1
fi

echo "  [INFO]  Compilation successful."
echo "  [INFO]  Launching Hotel ERP..."
echo ""
java -cp "${OUT_DIR}:${SQLITE_JAR}" "$MAIN_CLASS"

