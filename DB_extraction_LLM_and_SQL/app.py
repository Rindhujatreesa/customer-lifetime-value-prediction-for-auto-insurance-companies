import streamlit as st
import os
import google.generativeai as genai
import mysql.connector
from dotenv import load_dotenv

## Configure the Google API Key
load_dotenv() 
api_key = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=api_key)

def gen_sql_prompt(prompt,question):
    llm = genai.GenerativeModel('gemini-pro')
    response = llm.generate_content([prompt,question])
    return response.text

def db_chain(query):
    connection = mysql.connector.connect(
        host = os.getenv("db_host"),
        database = os.getenv("db_name"),
        user = os.getenv("db_user"),
        password = os.getenv("db_password")
    )
    # Create a cursor object
    cursor = connection.cursor()

    # Execute the SQL query generated by the Gemini LLM
    cursor.execute(query)

    # Fetch the result
    rows = cursor.fetchall()

    cursor.close()
    connection.close()
    return rows


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

st.set_page_config(page_title="Query the Insurance Database", page_icon="dashboard.PNG")
st.title("Auto insurance: Database Q&A ")
st.image("dashboard.PNG", caption = "Autoinsurance dashboard")

question = st.text_input("How can I help you retrieve data today?")
st.markdown("Tip: Make sure to include the column names for accurate results")
submit = st.button("Convert to SQL Query and Get the Response")


if 'response' not in st.session_state:
    st.session_state.response = None
if 'run_query' not in st.session_state:
    st.session_state.run_query = False

if submit:
    st.session_state.response = gen_sql_prompt(prompt, question)
    
    # Check if response is generated
    if st.session_state.response:
        st.caption("Here's what we did to get your answer:")
        st.code(st.session_state.response)
        data = db_chain(st.session_state.response)
        st.caption("Response to your Query:")
        #data = db_chain(st.session_state.response)  # Run the generated SQL query
        st.write(data)
                