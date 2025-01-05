#
//  helperScript.py
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import sqlite3

def print_database_data(db_file):
  """
  Prints all data from the specified SQLite database.

  Args:
    db_file: Path to the SQLite database file.
  """

  conn = sqlite3.connect(db_file)
  cursor = conn.cursor()

  # Print data from Activities table
  print("\nActivities Table:")
  for row in cursor.execute("SELECT * FROM Activities"):
    print(row)

  # Print data from MoodEvaluation table
  print("\nMoodEvaluation Table:")
  for row in cursor.execute("SELECT * FROM MoodEvaluation"):
    print(row)

  # Print data from TotalDistance table
  print("\nTotalDistance Table:")
  for row in cursor.execute("SELECT * FROM TotalDistance"):
    print(row)

  conn.close()

if __name__ == "__main__":
  db_file = "activities-3.db"  # Replace with the actual database file name
  print_database_data(db_file)
