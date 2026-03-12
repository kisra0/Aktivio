from flask import Flask, render_template, request,session,jsonify
import mysql.connector
import random
from datetime import datetime
import requests
import os
from datetime import date

app = Flask(__name__)

app.secret_key = '12345678'
conn_data = {
     "host":'localhost',
    "user":'root',
    "password":'',
    "database":'event'
}

@app.route('/add_account', methods=["POST"])
def add_account():
       
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        name = request.form.get('name')
        email = request.form.get('email')
        password = request.form.get('password')
        cursor = conn.cursor()
        cursor.execute("""
                INSERT INTO account (name, email, password)
                VALUES (%s, %s, %s)
            """, (name, email, password))
        conn.commit()
        conn.close()
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                    SELECT id FROM account WHERE email = %s and password=%s
                """, (email,password))
        user_id = cursor.fetchall()[0][0]
        print("@@@@@@@@@@@@@@",user_id)

        cursor.execute("""
                INSERT INTO profile (user_id)
                VALUES (%s)
            """, (user_id,))
        conn.commit()
        cursor.close()
        return jsonify({
        "success": True,
        "message": "Register successful",
        }), 200


