import streamlit as st
from db_conn import db_chain
from gemini_model import gen_sql_prompt

# streamlit application

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
    st.session_state.response = gen_sql_prompt(question)
    
    # Check if response is generated
    if st.session_state.response:
        st.caption("Here's what we did to get your answer:")
        st.code(st.session_state.response)
        data = db_chain(st.session_state.response)
        st.caption("Response to your Query:")
        #data = db_chain(st.session_state.response)  # Run the generated SQL query
        st.write(data)
