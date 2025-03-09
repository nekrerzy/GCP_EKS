import asyncio
import asyncpg

async def test_db_connection():
    try:
        # Connect to the database
        conn = await asyncpg.connect(
            user='app-user',
            password='uSFcyPegj2TULCVPFk8Shg==',
            database='app-database',
            host='postgres.internal.synthaud.app',
            port=5432  # Default PostgreSQL port
        )
        print("Connected to the database successfully!")

        # Get database version
        version = await conn.fetchval("SELECT version();")
        print(f"PostgreSQL version: {version}")

        # Get current database name
        db_name = await conn.fetchval("SELECT current_database();")
        print(f"Current database: {db_name}")

        # Close connection
        await conn.close()
        print("Connection closed.")
    except Exception as e:
        print(f"Error: {e}")

# Run the async function
asyncio.run(test_db_connection())