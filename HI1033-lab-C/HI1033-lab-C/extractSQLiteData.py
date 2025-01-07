import sqlite3
import pandas as pd

# Connect to SQLite database
conn = sqlite3.connect("activities.db")

# Query 1: Extract data from the 'Activities' table
activities_query = "SELECT * FROM Activities;"
activities_df = pd.read_sql_query(activities_query, conn)

# Query 2: Extract data from the 'MoodEvaluation' table
mood_query = "SELECT * FROM MoodEvaluation;"
mood_df = pd.read_sql_query(mood_query, conn)

# Query 3: Extract data from the 'TotalDistance' table
distance_query = "SELECT * FROM TotalDistance;"
distance_df = pd.read_sql_query(distance_query, conn)

# Close the database connection
conn.close()

# Output DataFrames (optional)
print("Activities Data:")
print(activities_df.head())

print("\nMood Evaluation Data:")
print(mood_df.head())

print("\nTotal Distance Data:")
print(distance_df.head())
