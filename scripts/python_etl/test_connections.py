"""
Test connections to SQLite and PostgreSQL databases
"""

from dotenv import dotenv_values
import sqlite3
import psycopg2
from psycopg2.extras import RealDictCursor
import sys


# Load configurations from .env file
config = dotenv_values(".env")

# Load values from environment variables
SQLITE_DB_PATH = config['SQLITE_DB_PATH']
HOST = config['HOST']
DATABASE = config['DATABASE']
USER = config['USER']
PASSWORD = config['PASSWORD']


#Database paths and configurations
SQLITE_DB_PATH = SQLITE_DB_PATH
POSTGRES_CONFIG = POSTGRES_CONFIG = {
    'host': HOST,
    'database': DATABASE,
    'user': USER,
    'password': PASSWORD
}


def test_sqlite_connection():
    """
    Test SQLite connection and get basic info
    """

    print("\n" + "="*50)
    print("Testing SQLite Connection...")
    print("="*50 + "\n")

    try:
        # Connect to SQLite
        conn = sqlite3.connect(SQLITE_DB_PATH)
        cursor = conn.cursor()

        print("Successfully connected to SQLite database")

        # Get all attached databases (main, temp, etc.)
        cursor.execute("PRAGMA database_list;")
        schemas = [row[1] for row in cursor.fetchall()]  # ['main', 'temp', ...]

        # Get list of tables
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()

        print(f"\nFound {len(tables)} tables:")
        for table in tables:
            table_name = table[0]
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            count = cursor.fetchone()[0]
            print(f"  - {table_name}: {count:,} rows")
    
        if len(tables) == 0:
            print("Warning: No tables found in the SQLite database.")
        
        conn.close()
        return True

    except sqlite3.Error as e:
        print(f"SQLite connection failed: {e}")
        return False
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return False

def test_postgres_connection():
    """
    Test PostgreSQL connection and get basic info
    """

    print("\n" + "="*50)
    print("Testing PostgreSQL Connection...")
    print("="*50 + "\n")

    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**POSTGRES_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        print(f"Successfully connected to PostgreSQL database '{POSTGRES_CONFIG['database']}' on host '{POSTGRES_CONFIG['host']}'")

        # Get a list of tables
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
        """)
        tables = cursor.fetchall()

        print(f'\nFound {len(tables)} tables in PostgreSQL database:')
        for table in tables:
            table_name = table['table_name']
            cursor.execute(f'SELECT COUNT(*) FROM "{table_name}"')
            count = cursor.fetchone()['count']
            print(f" - {table_name}: {count:,} rows")

        if len (tables) == 0:
            print("Warning: No tables found in the PostgreSQL database.")

        conn.close()
        return True

    except psycopg2.OperationalError as e:
        print(f"PostgreSQL connection failed: {e}")
        return False
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return False
    

def main():
    """
    Run all connection tests
    """

    print("\n" + "="*50)
    print("\n" + "F1 Database Migration - Connection Test".center(50))
    print("\n" + "="*50)

    sqlite_ok = test_sqlite_connection()
    postgres_ok = test_postgres_connection()

    print("\n" + "="*50)
    print("Connection Test Summary".center(50))
    print("="*50 + "\n")

    if sqlite_ok and postgres_ok:
        print("All connections successful!")
        return 0
    else:
        print("Some connections failed. Please check the logs above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
