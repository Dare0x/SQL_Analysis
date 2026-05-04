In this project, a global layoff database is analyzed through SQL queries. The first step in data processing was the creation of a staging table and the identification of duplicates with the help of window functions. The identified duplicates were separated and deleted to improve the overall quality of the data.

Next, the script standardizes the important attributes such as company name, industry, and country of operation to avoid inconsistency. It also converts the date attribute into a proper date format suitable for analysis.

For missing values, it uses existing records from other companies in the same industry to predict the missing industry type. Other data cleaning activities include the removal of redundant spaces and deleting NULL values.
