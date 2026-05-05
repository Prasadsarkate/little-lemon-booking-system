"""
little_lemon_client.py
----------------------
Python client for the Little Lemon booking system.
Demonstrates connecting to MySQL and calling all stored procedures.

Requirements:
    pip install mysql-connector-python

Usage:
    python little_lemon_client.py
"""

import mysql.connector
from mysql.connector import Error


# ── Connection Configuration ──────────────────────────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",          # change to your MySQL username
    "password": "your_password", # change to your MySQL password
    "database": "little_lemon",
}


# ── Helper ────────────────────────────────────────────────────────────────────
def get_connection():
    """Return a new MySQL connection or raise on failure."""
    conn = mysql.connector.connect(**DB_CONFIG)
    if conn.is_connected():
        print("[OK] Connected to MySQL — little_lemon database")
    return conn


def call_procedure(cursor, proc_name, args=()):
    """Call a stored procedure and pretty-print every result set."""
    print(f"\n{'='*55}")
    print(f"  CALL {proc_name}{args}")
    print("="*55)
    cursor.callproc(proc_name, args)
    for result in cursor.stored_results():
        columns = [d[0] for d in result.description]
        rows    = result.fetchall()
        # column widths
        widths = [max(len(c), max((len(str(r[i])) for r in rows), default=0))
                  for i, c in enumerate(columns)]
        header = " | ".join(c.ljust(widths[i]) for i, c in enumerate(columns))
        print(header)
        print("-" * len(header))
        for row in rows:
            print(" | ".join(str(v).ljust(widths[i]) for i, v in enumerate(row)))


# ── Procedure Wrappers ────────────────────────────────────────────────────────

def get_max_quantity(cursor):
    """P1 – Show the menu item with the highest single-order quantity."""
    call_procedure(cursor, "GetMaxQuantity")


def manage_booking(cursor, booking_date: str, table_id: int):
    """P2 – Check whether a table is free on a given date."""
    call_procedure(cursor, "ManageBooking", (booking_date, table_id))


def update_booking(cursor, booking_id: int, new_date: str):
    """P3 – Reschedule an existing booking."""
    call_procedure(cursor, "UpdateBooking", (booking_id, new_date))


def add_booking(cursor,
                customer_id:  int,
                table_id:     int,
                staff_id:     int,
                booking_date: str,
                booking_time: str,
                num_guests:   int):
    """P4 – Create a new booking (blocks if table already taken that day)."""
    call_procedure(cursor, "AddBooking",
                   (customer_id, table_id, staff_id,
                    booking_date, booking_time, num_guests))


def cancel_booking(cursor, booking_id: int):
    """P5 – Delete a booking record by ID."""
    call_procedure(cursor, "CancelBooking", (booking_id,))


# ── Main Demo ─────────────────────────────────────────────────────────────────
def main():
    conn   = None
    cursor = None
    try:
        conn   = get_connection()
        cursor = conn.cursor()

        # 1. What is the highest quantity ever ordered in one booking?
        get_max_quantity(cursor)

        # 2. Is table 1 free on 2022-10-10?  (should be TAKEN in sample data)
        manage_booking(cursor, "2022-10-10", 1)

        # 3. Is table 9 free on 2022-10-10?  (should be AVAILABLE)
        manage_booking(cursor, "2022-10-10", 9)

        # 4. Add a new booking on a free table
        add_booking(cursor,
                    customer_id=1,
                    table_id=9,
                    staff_id=5,
                    booking_date="2023-05-20",
                    booking_time="19:00:00",
                    num_guests=4)

        # 5. Reschedule booking #2
        update_booking(cursor, booking_id=2, new_date="2023-06-01")

        # 6. Cancel the newly created booking (fetch its ID first)
        cursor.execute("SELECT MAX(BookingID) FROM Bookings")
        latest_id = cursor.fetchone()[0]
        cancel_booking(cursor, booking_id=latest_id)

        conn.commit()
        print("\n[DONE] All demo calls completed successfully.\n")

    except Error as e:
        print(f"\n[ERROR] {e}")
    finally:
        if cursor:
            cursor.close()
        if conn and conn.is_connected():
            conn.close()
            print("[INFO] Connection closed.")


if __name__ == "__main__":
    main()
