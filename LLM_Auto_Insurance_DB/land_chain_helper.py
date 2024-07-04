from langchain.llms import GooglePalm
from langchain.utilities import SQLDatabase
from langchain_experimental.sql import SQLDatabaseChain
from langchain.prompts import SemanticSimilarityExampleSelector
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import Chroma
from langchain.prompts import FewShotPromptTemplate
from langchain.chains.sql_database.prompt import PROMPT_SUFFIX, _mysql_prompt
from langchain.prompts.prompt import PromptTemplate


import os
from dotenv import load_dotenv
load_dotenv()  # take environment variables from .env (especially openai api key)


def db_chain():
    db_user = os.getenv("db_user")
    db_password = os.getenv("db_password")
    db_host = os.getenv("db_host")
    db_name = os.getenv("db_name")

    db = SQLDatabase.from_uri(f"mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}",sample_rows_in_table_info=3)
    llm = GooglePalm(google_api_key=os.getenv("GOOGLE_API_KEY"), temperature=0.1)
    
#os.environ[]
    db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)

    return db_chain