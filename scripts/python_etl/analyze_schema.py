"""
SQLite to PostgreSQL Schema Analyzer
------------------------------------
Extract schema from SQLite database and generate PostgreSQL-compatible DDL statements.
"""

from dotenv import dotenv_values
import sqlite3
import re
from datetime import datetime

# Load configurations from .env file
config = dotenv_values(".env")
# Load values from environment variables
SQLITE_DB_PATH = config['SQLITE_DB_PATH']


class SchemaAnalyzer:
    """
    Analyzes SQLite schema and converts to PostgreSQL
    """
    
    # SQLite to PostgreSQL type mapping
    TYPE_MAPPING = {
        'INTEGER': 'INTEGER',
        'INT': 'INTEGER',
        'TINYINT': 'SMALLINT',
        'SMALLINT': 'SMALLINT',
        'MEDIUMINT': 'INTEGER',
        'BIGINT': 'BIGINT',
        'UNSIGNED BIG INT': 'BIGINT',
        'INT2': 'SMALLINT',
        'INT8': 'BIGINT',
        'TEXT': 'TEXT',
        'CHARACTER': 'VARCHAR',
        'VARCHAR': 'VARCHAR',
        'VARYING CHARACTER': 'VARCHAR',
        'NCHAR': 'VARCHAR',
        'NATIVE CHARACTER': 'VARCHAR',
        'NVARCHAR': 'VARCHAR',
        'CLOB': 'TEXT',
        'REAL': 'DOUBLE PRECISION',
        'DOUBLE': 'DOUBLE PRECISION',
        'DOUBLE PRECISION': 'DOUBLE PRECISION',
        'FLOAT': 'REAL',
        'NUMERIC': 'NUMERIC',
        'DECIMAL': 'DECIMAL',
        'BOOLEAN': 'BOOLEAN',
        'DATE': 'DATE',
        'DATETIME': 'TIMESTAMP',
        'TIMESTAMP': 'TIMESTAMP',
        'BLOB': 'BYTEA',
    }
    
    def __init__(self, db_path):
        self.db_path = db_path
        self.conn = None
        self.cursor = None

    def connect(self):
        """
        Connect to the SQLite database
        """
        
        try:
            self.conn = sqlite3.connect(self.db_path)
            self.cursor = self.conn.cursor()
            print(f"Connected to SQLite database at {self.db_path}")
            return True
        except sqlite3.Error as e:
            print(f"Error connecting to SQLite database: {e}")
            return False
    
    def close(self):
        """
        Close the database connection
        """
        
        if self.conn:
            self.conn.close()
            print("SQLite connection closed")

    def get_tables(self):
        """
        Retrieve all table names from the SQLite database (excluding system tables)
        """
        
        self.cursor.execute("""
            SELECT name 
            FROM sqlite_master 
            WHERE type='table' 
            AND name NOT LIKE 'sqlite_%'
            ORDER BY name
        """)
        tables = [row[0] for row in self.cursor.fetchall()]
        return tables
    
    def get_table_info(self, table_name):
        """
        Get detailed column informaiton for a given table
        """

        self.cursor.execute(f'PRAGMA table_info("{table_name}")')
        columns = []
        for row in self.cursor.fetchall():
            columns.append({
                'cid': row[0],
                'name': row[1],
                'type': row[2],
                'notnull': bool(row[3]),
                'default_value': row[4],
                'pk': bool(row[5])
            })
        return columns
    
    def get_foreign_keys(self, table_name):
        """
        Get foreign key information for a given table
        """

        self.cursor.execute(f'PRAGMA foreign_key_list("{table_name}")')
        fkeys = []
        for row in self.cursor.fetchall():
            fkeys.append({
                'id': row[0],
                'seq': row[1],
                'table': row[2],
                'from': row[3],
                'to': row[4],
                'on_update': row[5],
                'on_delete': row[6],
                'match': row[7]
            })
        return fkeys
    
    def get_indexes(self, table_name):
        """
        Get index information for a given table
        """

        self.cursor.execute(f'PRAGMA index_list("{table_name}")')
        indexes = []
        for row in self.cursor.fetchall():
            index_name = row[1]
            is_unique = bool(row[2])

            # Get indexed columns
            self.cursor.execute(f'PRAGMA index_info("{index_name}")')
            colunms = [col_row[2] for col_row in self.cursor.fetchall()]

            indexes.append({
                'name': index_name,
                'unique': is_unique,
                'columns': colunms
            })
        return indexes
    
    def map_data_type(self, sqlite_type):
        """
        Map SQLite data type to PostgreSQL data type
        """
        
        if not sqlite_type:
            return 'TEXT'  # Default type
        
        # Extract base type and size (e.g., VARCHAR(255) -> VARCHAR, 255))
        match = re.match(r'^(\w+)(?:\((\d+)\))?', sqlite_type.upper())

        if match:
            base_type = match.group(1)
            size = match.group(2)

            pg_type = self.TYPE_MAPPING.get(base_type, 'TEXT')
            
            # Handle size for VARCHAR types
            if pg_type == 'VARCHAR' and size:
                return f'VARCHAR({size})'
            
            return pg_type
        
        return 'TEXT'  # Fallback type
    
    def generate_ddl(self, table_name):
        """
        Generate PostgreSQL DDL statements from SQLite schema
        """
        
        columns = self.get_table_info(table_name)
        fkeys = self.get_foreign_keys(table_name)
        
        ddl = f"CERATE TABLE IF NOT EXISTS {table_name} (\n"

        # Column definitions
        col_defs = []
        pk_columns = []

        for col in columns:
            col_name = col['name']
            pg_type = self.map_data_type(col['type'])

            col_def = f'    "{col_name}" {pg_type}'

            # Pimary key
            if col['pk']:
                pk_columns.append(col_name)
                #Do not add PK if composite key
                if col['pk'] == 1 and len([c for c in columns if c['pk']]) == 1:
                    col_def += ' PRIMARY KEY'

            # Not null constraint
            if col['notnull'] and not col['pk']:
                col_def += ' NOT NULL'

            # Default value
            if col ['default_value'] is not None:
                default_val = col['default_value']
                # Handle string default values
                if not default_val.startswith("'"):
                    if pg_type in ['TEXT', 'VARCHAR', 'DATE', 'TIMESTAMP']:
                        default_val = f"'{default_val}'"
                col_def += f' DEFAULT {default_val}'

            col_defs.append(col_def)

        # Add composite primary key if needed
        if len(pk_columns) > 1:
            pk_def = f"    PRIMARY KEY ({", ".join([f'"{col}"' for col in pk_columns])})"
            col_defs.append(pk_def)

        # Foreign key constraints
        for fk in fkeys:
            fk_def = f"    FOREIGN KEY (\"{fk['from']}\") REFERENCES \"{fk['table']}\"(\"{fk['to']}\")"

            if fk['on_delete'] and fk['on_delete'] != 'NO ACTION':
                fk_def += f' ON DELETE {fk["on_delete"]}'
            if fk['on_update'] and fk['on_update'] != 'NO ACTION':
                fk_def += f' ON UPDATE {fk["on_update"]}'

            col_defs.append(fk_def)

        ddl += ",\n".join(col_defs) + "\n);\n"

        return ddl
    
    def generate_indexes(self, table_name):
        """
        Generate PostgreSQL index creation statements
        """
        
        indexes = self.get_indexes(table_name)
        index_ddls = []

        for index in indexes:
            #Skip auto increment primary key indexes
            if index['name'].startswith('sqlite_autoindex_'):
                continue

            unique = 'UNIQUE ' if index['unique'] else ''
            cols = ', '.join([f'"{col}"' for col in index['columns']])
            
            ddl = f'CREATE {unique}INDEX IF NOT EXISTS "{index["name"]}" ON "{table_name}" ({cols});'
            index_ddls.append(ddl)

        return index_ddls
    
    def analyze_schema(self):
        """
        Analyze the entire schema and generate report
        """

        if not self.connect():
            return

        tables = self.get_tables()

        print(f"\n{'='*60}")
        print(f"Schema Analysis Report".center(60))
        print(f"{'='*60}\n")

        schema_report = {
            'database': self.db_path,
            'timestamp': datetime.now().isoformat(),
            'total_tables': len(tables),
            'tables': {}
        }

        for table in tables:
            cols = self.get_table_info(table)
            fkeys = self.get_foreign_keys(table)
            indexes = self.get_indexes(table)

            #Get row count
            self.cursor.execute(f'SELECT COUNT(*) FROM "{table}"')
            row_count = self.cursor.fetchone()[0]

            schema_report['tables'][table] = {
                'columns': len(cols),
                'foreign_keys': len(fkeys),
                'indexes': len(indexes),
                'rows': row_count
            }

            print(f"Table: {table}")
            print(f"  Columns: {len(cols)}")
            print(f"  Foreign Keys: {len(fkeys)}")
            print(f"  Indexes: {len(indexes)}")
            print(f"  Rows: {row_count}\n")

        print(f"\n{'='*60}\n")

        self.close()
        return schema_report

    def generate_full_ddl(self, output_file='schema_postgresql.sql'):
        """
        Generate full PostgreSQL DDL for the entire SQLite schema
        """

        if not self.connect():
            return False
        
        tables = self.get_tables()

        with open(output_file, 'w') as f:
            #Write header
            f.write(f"-- PostgreSQL Schema\n")
            f.write(f"-- Generated from SQLite database at {self.db_path}\n")
            f.write(f"-- Total Tables: {len(tables)}\n\n")

            f.write(f"-- DROP SCHEMA public CASCADE;\n")
            f.write(f"-- CREATE SCHEMA IF NOT EXISTS public;\n\n")

            
            f.write(f"\n{'='*60}\n")
            f.write(f"-- TABLE DEFINITIONS")
            f.write(f"\n{'='*60}\n")

            for table in tables:
                f.write(f"-- Table: {table}\n")
                ddl = self.generate_ddl(table)
                f.write(ddl + "\n")

            # Generate indexes
            f.write(f"\n{'='*60}\n")
            f.write(f"-- INDEX DEFINITIONS\n")
            f.write(f"\n{'='*60}\n")

            for table in tables:
                index_ddls = self.generate_indexes(table)
                if index_ddls:
                    f.write(f"-- Indexes for table: {table}\n")
                    for index_ddl in index_ddls:
                        f.write(index_ddl + "\n")
                    f.write("\n")

        self.close()

        print(f"\n{'='*60}")
        print(f"PostgreSQL DDL script generated at {output_file}")
        print(f"Total Tables Processed: {len(tables)}")
        print(f"{'='*60}\n")
        
        return True
    

def main():
    """
    Main execution method
    """
    
    print(f"\n{'='*60}")
    print(f"SQLite to PostgreSQL Schema Analyzer".center(60))
    print(f"{'='*60}\n")

    analyzer = SchemaAnalyzer(SQLITE_DB_PATH)

    #Analyze schema
    print("Analyzing SQLite schema...\n")
    schema_report = analyzer.analyze_schema()

    if not schema_report:
        print("Schema analysis failed.")
        return 1

    #Generate PostgreSQL DDL
    print("Generating PostgreSQL DDL script...\n")
    success = analyzer.generate_full_ddl('postgresql_ddl.sql')

    if success:
        print("DDL generation completed successfully.")
        return 0
    else:
        print("DDL generation failed.")
        return 1

if __name__ == "__main__":
    import sys
    sys.exit(main())