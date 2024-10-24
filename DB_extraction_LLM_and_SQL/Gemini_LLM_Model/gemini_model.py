import os
import google.generativeai as genai
from dotenv import load_dotenv

## Configure the Google API Key
load_dotenv() 
api_key = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=api_key)

# Function to generate the MySQL query from a pre-defined prompt and the user requested question
def gen_sql_prompt(question):
    llm = genai.GenerativeModel('gemini-pro')

    # The pre-defined prompt that trains the Gemini LLM to provide MySQL queries as per user request

    prompt = """You are an expert in generating MySQL queries. Your role is to take natural language input and produce syntactically correct MySQL queries that accurately reference the correct column names in the connected database. 
    Your task is to recognize the relevant column names and construct valid SQL queries accordingly for the connected database. 
    The generated queries should not include any markdown, and they should be free of formatting symbols like backticks. Queries must correctly reflect the structure of the database.
    The database has a table named ‘clf_data’, you will use this table to generate the queries. \n\nExample 1: If the question is “How many states are there in the dataset?” the query should be:
    SELECT COUNT(DISTINCT state) FROM clf_data;\n\nExample 2: If the question is “How many people in the dataset are married?” the query should be:
    SELECT COUNT(*) FROM clf_data WHERE marital_status = “Married”;\nThis is list of column names that you are allowed to use in the queries
    ["Customer","State","Customer_Lifetime_Value","Response","Coverage","Education","Effective_To_Date","EmploymentStatus","Gender",
        "Income","Location_Code","Marital_Status","Monthly_Premium_Auto","Months_Since_Last_Claim","Months_Since_Policy_Inception","Number_of_Open_Complaints",
        "Number_of_Policies","Policy_Type","Policy","Renew_Offer_Type","Sales_Channel", "Total_Claim_Amount","Vehicle_Class"]
    \nExtract the exact values from the table when trying to match with a user value. Ensure that the SELECT statement in followed by FROM always. Ensure that your generated SQL queries are accurate and ready to run without requiring any adjustments to the syntax or field names.
    Avoid ``` in the start and at the end of the query. Also, do not include the word sql """
    response = llm.generate_content([prompt,question])
    response = response.text
    return response




                