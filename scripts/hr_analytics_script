import pandas as pd
from sqlalchemy import create_engine

# 1. Load your CSV file into Python
df = pd.read_csv('EmployeeDataset.csv')

# 2. Cleaning the column names so they don't have spaces
df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_')

# 3. Connect to your local MySQL Database
username = 'root'
password = 'root1234'
host = 'localhost'
port = '3306'
database = 'hr_analytics'

#connection engine
engine = create_engine(f"mysql+mysqlconnector://{username}:{password}@{host}:{port}/{database}")

# 4. Pushing data directly into MySQL
# This drops the table if it exists and creates a fresh one with data
df.to_sql('employee_data', con=engine, if_exists='replace', index=False)

print("🎉 Success! Your dataset has been forced into MySQL Workbench.")

print("\n🔄 Starting Phase 3: Fetching data from MySQL for programmatic cleaning...")

# 1. Pull the data back from your MySQL table into a fresh DataFrame
df = pd.read_sql("SELECT * FROM employee_data", con=engine)

# 2. Fix Duplicate Emails (Handling the duplicate anomaly found in Query 19!)
is_duplicate = df.duplicated(subset=['email'], keep=False)
df.loc[is_duplicate, 'email'] = df.loc[is_duplicate, 'employee_id'].astype(str) + "_" + df.loc[is_duplicate, 'email']
print("✔️ Fixed data integrity issue: Resolved duplicate emails.")

# 3. Standardize Text Formatting across columns
for col in ['first_name', 'last_name', 'gender', 'department', 'position']:
    if col in df.columns:
        df[col] = df[col].str.strip().str.title()

# 4. Feature Engineering: Create Full Name
df['full_name'] = df['first_name'] + " " + df['last_name']

# 5. Feature Engineering: Age Group Buckets
df['age_group'] = df['age'].apply(lambda x: 'Under 30' if x < 30 else ('30-45' if x <= 45 else 'Over 45'))

# 6. Feature Engineering: Salary Tiers
df['salary_tier'] = df['salary'].apply(
    lambda x: 'Tier 1: Executive (>90k)' if x >= 90000
    else ('Tier 2: Senior (75k-90k)' if x >= 75000
    else ('Tier 3: Mid-Level (60k-75k)' if x >= 60000 else 'Tier 4: Associate (<60k)'))
)

# 7. Feature Engineering: Experience Tenure (Years in company based on current year 2026)
df['clean_date'] = pd.to_datetime(df['start_date'], errors='coerce')
df['years_of_tenure'] = 2026 - df['clean_date'].dt.year

# 8. Drop temporary cleaning helper column
df = df.drop(columns=['clean_date'])

# PHASE 4: EXPORT TO FINAL CSV
# Saving dataset to PC
output_file = 'Cleaned_Employee_Dataset.csv'
df.to_csv(output_file, index=False)

print(f"\n🚀 SUCCESS! The clean file '{output_file}' is saved and ready for Power BI.")
print(df[['full_name', 'age_group', 'salary_tier', 'years_of_tenure']].head())