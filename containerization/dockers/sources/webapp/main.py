from flask import Flask

from flask_cors import CORS

import psycopg2
import os
import socket 

app = Flask(__name__)

@app.route('/')
def index():
    try:
        connect = psycopg2.connect(os.environ[
            'DATABASE_URL'
        ])
        cursor = connect.cursor()
        cursor.execute("SELECT version();")
        db_version = cursor.fetchone()
        cursor.close()
        hostname = socket.gethostname()
        return f"database connection: {db_version},source come from hostname: {hostname}"
    except Exception as err: 
        print(f"Throw execptions as: {err}")
        pass

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)