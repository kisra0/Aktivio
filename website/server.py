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




articles_list = [("Healthy ageing","https://www.wired.com/story/sleep-apnea-biomarker-night-breathing/",random.randint(0, 9)),
                         ("Food & Nutrition / Diabetes","https://www.eatingwell.com/habit-to-break-for-blood-sugar-balance-11781367",random.randint(0, 9)),
                         ("Activity & Lifestyle","https://www.cdc.gov/physical-activity-basics/benefits/index.html",random.randint(0, 9)),
                         ("Heart & Cardiovascular Health","https://www.washingtonpost.com/wellness/2025/07/28/science-prevent-heart-disease/",random.randint(0, 9)),
                         ("The 8 Worst Foods to Eat for Inflammation","https://www.eatingwell.com/flavanoid-variety-cancer-study-11749936",random.randint(0, 9)),
                         ("Scientists Just Discovered a New Health Benefit of Coffee","https://www.eatingwell.com/new-health-benefit-of-coffee-study-11726744",random.randint(0, 9)),
                         ("Eating Chicken May Increase Your Mortality Risk","https://www.eatingwell.com/study-chicken-mortality-risk-11720104",random.randint(0, 9)),
                         ("4 ‘Healthy’ Trends That Need to End","https://www.eatingwell.com/healthy-trends-that-need-to-stop-11751762",random.randint(0, 9)),
                         (" Mediterranean Diet May Support Bone Health","https://www.eatingwell.com/bone-health-mediterranean-diet-11711574",random.randint(0, 9)),
                         ("Top 10 Food & Nutrition Trends for 2024","https://www.eatingwell.com/top-10-food-nutrition-trends-2024-8415701",random.randint(0, 9))
                         ]

@app.route('/articles', methods=["GET"])
def articles():
    if "user_id" in session:
       
        return render_template('articles.html',articles_list = articles_list)
    return render_template('home.html',not_log=True)

@app.route('/search', methods=["GET"])
def search():
    if "user_id" in session:
        kw = request.args.get("kw")
        searched_list = []
        for a in articles_list:
             if kw.lower() in a[0].lower():
                  searched_list.append(a)
                
        return render_template('articles.html',articles_list = searched_list)
    return render_template('home.html',not_log=True)

@app.route('/logout', methods=["GET"])
def logout():
        del session["user_id"]
        return render_template('home.html')

@app.route('/get_url_content', methods=["GET"])
def get_url_content():
         if "user_id" in session:
            url = request.args.get('url')
            return render_template('article_content.html', content=url)
        


@app.route('/home', methods=["GET"])
def home():
    if "user_id" in session:
        user_id = session["user_id"]
        today = datetime.now().date()
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT cards FROM profile WHERE user_id = %s
                    """, (user_id,))
        results = cursor.fetchone()
        cards = results[0]
        if "," in cards:
                cards = results[0].split(",")
        else:
                cards = list(results[0])
        added_cards = []
        not_added_cards = []
        for c in profiles_cards:
            if c["c_id"] in cards:
                     added_cards.append(c)
            else:
                       not_added_cards.append(c)
            #"added_cards":added_cards
        conn.close()     
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                    SELECT name, TIME_FORMAT(time, '%H:%i'),duration FROM event_table WHERE date = %s and user_id=%s
                """, (today,int(user_id)))
        results = cursor.fetchall()
        if results:
            print(results)
            return render_template('home.html',message={"login":"access","today":today,"events":results,"added_cards":added_cards })
        print(today)
        return render_template('home.html',message={"login":"access","today":today,"added_cards":added_cards })

    return render_template('home.html')
@app.route('/event_form', methods=["GET"])
def event_form():
    if "user_id" in session:
        return render_template('event_form.html')
    return render_template('home.html',not_log=True)

@app.route('/test_your_self', methods=["GET"])
def test_your_self():
    if "user_id" in session:
            return render_template('test_your_self.html')
    return render_template('home.html',not_log=True)


@app.route('/test_bmi', methods=["GET"])
def test_bmi():
    return render_template('test_bmi.html')

@app.route('/test_bmi_action', methods=["POST"])
def test_bmi_action():
    if "flutter" in request.form:
        user_id = request.form.get("user_id")
    else:
        user_id = session["user_id"]
    age = int(request.form.get('age'))
    gender = request.form.get('gender')
    w = float(request.form.get('weight'))
    h = float(request.form.get('height'))
    bmi = w/(h**2)
    level = ""
    if bmi<18.5:
        level = "Underweight"
    elif bmi >= 18.5 and bmi <= 24.9:
        level = "Normal weight"
    elif bmi>=25 and bmi<=29.9:
        level = "Overweight"
    elif bmi >=30:
        level = "Obese"
    bmi = round(bmi,1)
    try: 
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
       
        cursor = conn.cursor()
        cursor.execute("""
                INSERT INTO bmi_history (height, gender, age, weight,bmi,level,user_id)
                VALUES (%s, %s, %s, %s,%s,%s,%s)
            """, (h, gender, age, w,bmi,level,user_id))
        conn.commit()
        cursor.close()
    except Exception as e:
        print(e)
    print("#################",bmi,level)
    if "flutter" in request.form:
             print("******",bmi,"$$$$$$ ",level)
             return jsonify({
                "bmi": str(bmi),
                "level":level
                }), 200
    
    return render_template('test_bmi.html',bmi=bmi,level=level)

@app.route('/login', methods=["GET"])
def login():
    return render_template('login.html')

@app.route('/register', methods=["GET"])
def register():
    return render_template('register.html')

@app.route('/body_members', methods=["GET"])
def body_members():
    if "user_id" in session:
        return render_template('body_members.html')
    return render_template('home.html',not_log=True)

@app.route('/event_calender', methods=["GET"])
def event_calender():
    if "user_id" in session:
        return render_template('event_calender.html')
    return render_template('home.html',not_log=True)

@app.route('/date_selected_events', methods=["GET","POST"])
def date_selected_events():
    if request.method == 'POST':
        date = request.form.get('date')
    elif request.method == 'GET':
        date = request.args.get('date')
    if "flutter" in request.form:
         user_id = request.form.get("user_id")
    else:
         user_id = session["user_id"]
   
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    if "flutter" not in request.form:
        cursor.execute("""
                    SELECT name,time,duration,id FROM event_table WHERE date = %s and user_id=%s
                """, (date,int(user_id)))
    else:
        cursor.execute("""
                    SELECT name,TIME_FORMAT(time, '%H:%i') AS time,duration,id FROM event_table WHERE date = %s and user_id=%s
                """, (date,int(user_id)))
    results = cursor.fetchall()
    final_results = []
    for r in results:
        num = random.randint(0, 9)
        r = list(r)
        r.append(num)
        final_results.append(r)
    print(results)
    cursor.close()
    formatted_date = datetime.strptime(date, '%Y-%m-%d').strftime('%d.%b %Y')
    print("@@@@@@@",final_results)
    if "flutter" in request.form:
             return jsonify({
                "results": final_results
                }), 200
    return render_template('date_selected_events.html',results = final_results,date=formatted_date)

@app.route('/edit_event', methods=["GET","POST"])
def edit_event():
    if "flutter" in request.form:
         id = request.form.get('id')
    else:
        id = request.args.get('id')
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    if "flutter" not in request.form:
        cursor.execute("""
                    SELECT name,date,time,duration,id FROM event_table WHERE id = %s
                """, (id,))
    else:
        cursor.execute("""
                       SELECT name,DATE_FORMAT(date, '%e/%c/%Y') AS date,TIME_FORMAT(time, '%h:%i %p') AS time,duration,id FROM event_table WHERE id = %s
                """, (id,))
    result = cursor.fetchone()
    cursor.close()
    if "flutter" in request.form:
         return jsonify({
                "event": result
                }), 200
    return render_template('event_form.html',result = result)


@app.route('/edit_event_data', methods=["POST","GET"])
def edit_event_data():
    if "flutter" in request.form:
         id = request.form.get('id')
    else:
         id = request.form.get('id')
    name = request.form.get('name')
    date = request.form.get('datePicker')
    time = request.form.get('timePicker')
    duration = request.form.get('duration')
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    cursor.execute("""
                update event_table set name=%s,date=%s,time=%s,duration=%s where id = %s
            """, (name, date, time, duration,id))
    conn.commit()
    cursor.close()
    if "flutter" in request.form:
         return jsonify({
                "message": "True"
                }), 200
    return render_template('success_edit.html',date = date)

@app.route('/remove_event', methods=["GET","POST"])
def remove_event():
    if request.method == "POST":
         id = request.form.get('id')
         print(id)
    else:
        id = request.args.get('id')
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    cursor.execute("""
                delete FROM event_table WHERE id = %s
            """, (id,))
    conn.commit()
    cursor.close()
    if "flutter" in request.form:
             return jsonify({
                "results": "removed"
                }), 200
    return render_template('event_calender.html',message="removed")

@app.route('/add_event', methods=["POST"])
def add_event():
    try: 
       
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        name = request.form.get('name')
        date = request.form.get('datePicker')
        time = request.form.get('timePicker')
        duration = request.form.get('duration')
        if "flutter" in request.form:
             user_id = int(request.form.get("user_id"))
        else: 
            user_id = session["user_id"]
        print("##########",user_id)
        cursor = conn.cursor()
        cursor.execute("""
                INSERT INTO event_table (name, date, time, duration,user_id)
                VALUES (%s, %s, %s, %s,%s)
            """, (name, date, time, duration,user_id))
        conn.commit()
        cursor.close()
        if "flutter" in request.form:
             return jsonify({
                "success": True,
                "message": "Event is added successfully",
                }), 200
        return render_template('success.html')
    except Exception as e:
        print("eerere",e)
        if "flutter" in request.form:
             return jsonify({
                "success": False,
                "message": "Event is not added successfully",
                }), 200
        return render_template('event_form.html',message = "There is an error in adding event")
    

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
        if "flutter" in request.form:
             return jsonify({
                "success": True,
                "message": "Register is done successfully",
                }), 200
        return render_template('login.html')




@app.route('/login_process', methods=["POST"])
def login_process():
    email = request.form.get('email')
    password = request.form.get('password')
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    cursor.execute("""
                SELECT account.id,name,image FROM profile,account WHERE user_id = account.id and email = %s and password=%s
            """, (email,password))
    result = cursor.fetchall()
    if result:
         result = result[0]
    cursor.close()
    #############edit###############
    if result:
        session['user_id'] = result[0]
        session['img'] = result[2]
        session['name'] = result[1].split(" ")[0]
        user_id = session['user_id']
        today = datetime.now().date()
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT cards FROM profile WHERE user_id = %s
                    """, (user_id,))
        results = cursor.fetchone()
        cards = results[0]
        if "," in cards:
                cards = results[0].split(",")
        else:
                cards = list(results[0])
        added_cards = []
        not_added_cards = []
        for c in profiles_cards:
            if c["c_id"] in cards:
                     added_cards.append(c)
            else:
                       not_added_cards.append(c)
            #"added_cards":added_cards
        conn.close() 
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                    SELECT name, TIME_FORMAT(time, '%H:%i'),duration FROM event_table WHERE date = %s and user_id=%s
                """, (today,int(user_id)))
        results = cursor.fetchall()
        if results:
            print(results)
            if "flutter" in request.form:
                    print(session["user_id"])
                    return jsonify({
                        "success": True,
                        "today": today,
                        "events":results,
                         "user_id":session['user_id']
                        }), 200
            
            return render_template('home.html',message={"login":"access","today":today,"events":results,"added_cards":added_cards})
        print(today)
        if "flutter" in request.form:
                    print(session["user_id"])
                    return jsonify({
                        "success": True,
                        "today": today,
                        "user_id":session['user_id']
                        }), 200
        return render_template('home.html',message={"login":"access","today":today,"added_cards":added_cards})
    else:
        if "flutter" in request.form:
                    return jsonify({
                        "success": False,
                        "message": "Error in login please try again!"
                        }), 200
        return render_template('login.html',message="Error in login please try again!")

@app.route('/history', methods=["GET","POST"])
def bmi_history():
    if "flutter" in request.form:
         id = request.form.get("user_id")
    else:
        id = session['user_id']
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    
    cursor = conn.cursor()
    if "flutter" in request.form:
          cursor.execute("""
                SELECT gender,age,weight,height,DATE_FORMAT(date, '%e/%c/%Y') AS date,bmi,level FROM bmi_history WHERE user_id = %s
            """, (id,))
    else:
        cursor.execute("""
                    SELECT gender,age,weight,height,date,bmi,level FROM bmi_history WHERE user_id = %s
                """, (id,))
    results = cursor.fetchall()
    print(len(results))
    cursor.close()
    if "flutter" in request.form:
         return jsonify({
                        "results": results,
                        }), 200
    return render_template('bmi_history.html',message={"results":results})

profiles_cards = [
     {"img":"c1.png", "c_id":"1","title":"Steps"},
     {"img":"c2.png", "c_id":"2","title":"All activities"},
     {"img":"c3.png", "c_id":"3","title":"Sleep score"},
     {"img":"c4.png", "c_id":"4","title":"Blood pressure"},
     {"img":"c5.png", "c_id":"5","title":"Water"},
     {"img":"c6.png", "c_id":"6","title":"Heart rate"},
     {"img":"c7.png", "c_id":"7","title":"Burned calories"},
     {"img":"c8.png", "c_id":"8","title":"Weight"},
     {"img":"c9.png", "c_id":"9","title":"HRV status"},
]

@app.route('/profile', methods=["GET","POST"])
def profile():
     if "flutter" in request.form:
            id = request.form['user_id']
            conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
            cursor = conn.cursor()
            cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (id,))
            result = cursor.fetchone()
            cursor.close()
            return jsonify({
                        "prof": result,
                        }), 200
     if "user_id" in session:
            id = session['user_id']
            conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
            cursor = conn.cursor()
            cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (id,))
            result = cursor.fetchone()
            cursor.close()


            conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
            cursor = conn.cursor()
            cursor.execute("""
                        SELECT cards FROM profile WHERE user_id = %s
                    """, (id,))
            results = cursor.fetchone()
            cards = results[0]
            if "," in cards:
                cards = results[0].split(",")
            else:
                cards = list(results[0])
            added_cards = []
            not_added_cards = []
            for c in profiles_cards:
                 if c["c_id"] in cards:
                     added_cards.append(c)
                 else:
                       not_added_cards.append(c)
            return render_template('profile.html',message={"result":result,"added_cards":added_cards,"not_added_cards":not_added_cards})
     return render_template('home.html',not_log=True)


@app.route('/edit_profile', methods=["GET"])
def edit_profile():
     if "user_id" in session:
            id = session['user_id']
            conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
            cursor = conn.cursor()
            cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (id,))
            result = cursor.fetchone()
            cursor.close()
            return render_template('edit_profile.html',message={"result":result})
     return render_template('home.html',not_log=True)

@app.route('/edit_action', methods=["POST"])
def edit_action():
       
    if "flutter" in request.form:
        user_id = request.form["user_id"]
        if request.form["flutter"] == "img_yes":
                file = request.files["img"]
                if file and file.filename:
                    file_path = os.path.join(os.path.join(os.getcwd(), "static/images"), file.filename)
                    file.save(file_path)
                image = request.form.get('img_url')
                conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
                        )
                cursor = conn.cursor()
                cursor.execute("""
                update profile set image=%s where user_id=%s
                         """, (image, user_id))
                conn.commit()
                conn.close()
        else:
            conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
                        )
            name = request.form.get('name')
            email = request.form.get('email')
            age = request.form.get('age')
            city = request.form.get('city')
            country = request.form.get('country')
            cursor = conn.cursor()
            cursor.execute("""
                    update account set name=%s, email=%s where id=%s
                """, (name, email, user_id))
            conn.commit()
            cursor.execute("""
                    update profile set age=%s, city=%s,country=%s where user_id=%s
                """, (age, city,country, user_id))
            conn.commit()
        if "flutter" in request.form:
         return jsonify({
                        "results": "done",
                        }), 200

    else:
        file = request.files["img"]
        if file and file.filename:
            file_path = os.path.join(os.path.join(os.getcwd(), "static/images"), file.filename)
            file.save(file_path)
        name = request.form.get('name')
        email = request.form.get('email')
        age = request.form.get('age')
        city = request.form.get('city')
        country = request.form.get('country')
        image = request.form.get('img_url')
        user_id = session["user_id"]
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
        )
        cursor = conn.cursor()
        cursor.execute("""
                update account set name=%s, email=%s where id=%s
            """, (name, email, user_id))
        conn.commit()
        cursor.execute("""
                update profile set age=%s, city=%s,country=%s, image=%s where user_id=%s
            """, (age, city,country,image, user_id))
        conn.commit()
        session['img'] = image
        cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (user_id,))
        result = cursor.fetchone()
        cursor.close()
        return render_template('profile.html',message={"result":result})



@app.route('/disease', methods=["GET"])
def disease():
     d = request.args.get("d")
     return render_template(d+".html")


@app.route('/test_phq', methods=["GET"])
def test_phq():
    return render_template('test_phq.html')

@app.route('/test_phq_action', methods=["POST"])
def test_phq_action():
    if "flutter" in request.form:
         phq =  request.form.get('phq')
         print(phq)
         phq = phq.split("#")
         q1 = phq[0]
         q2 = phq[1]
         q3 = phq[2]
         q4 = phq[3]
         q5 = phq[4]
         q6 = phq[5]
         q7 = phq[6]
         q8 = phq[7]
         q9 = phq[8]
    else:
        q1 = request.form.get('q1')
        q2 = request.form.get('q2')
        q3 = request.form.get('q3')
        q4 = request.form.get('q4')
        q5 = request.form.get('q5')
        q6 = request.form.get('q6')
        q7 = request.form.get('q7')
        q8 = request.form.get('q8')
        q9 = request.form.get('q9')
    data = {
         "opt1":"Not at all",
         "opt2":"Several days",
         "opt3":"More than half the days",
         "opt4":"Nearly every day",
    }
    today = datetime.now().strftime("%Y-%m-%d")
    questionnaire = q1+","+q2+","+q3+","+q4+","+q5+","+q6+","+q7+","+q8+","+q9
    results = "Not set"
    try: 
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        if "flutter" in request.form:
              user_id = request.form.get("user_id")
        else:
            user_id = session["user_id"]
        cursor = conn.cursor()
        cursor.execute("""
                INSERT INTO phq_history (questionnaire, results,date_test,user_id)
                VALUES (%s, %s, %s,%s)
            """, ( questionnaire, results,today,user_id))
        conn.commit()
        cursor.close()
    except:
        print("Error")
    if "flutter" in request.form:
         return jsonify({
                        "results": "Done",
                        }), 200
    return render_template('test_phq_result.html',results=results)

@app.route('/phq_history', methods=["GET","POST"])
def phq_history():
    if "flutter" in request.form:
         id = request.form.get('user_id')
    else:
        id = session['user_id']
    conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
    cursor = conn.cursor()
    cursor.execute("""
                SELECT questionnaire,results,date_test FROM phq_history WHERE user_id = %s
            """, (id,))
    results = cursor.fetchall()
    print(results)
    data = {
         "opt1":"Not at all",
         "opt2":"Several days",
         "opt3":"More than half the days",
         "opt4":"Nearly every day",
    }
    questionnaires = []
    Questions_txt = ["Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9"]
    for r in results:
         tmp = []
         i=0
         for o in r[0].split(","):
            tmp.append(Questions_txt[i] + ":" + data[o])  
            i+=1
         questionnaires.append(tmp)
    print(len(results))
    cursor.close()
    if "flutter" in request.form:
        return jsonify({
                        "results": results,
                        "q":questionnaires
                        }), 200 
    return render_template('phq_history.html',message={"results":results,"q":questionnaires})


##############3dit


@app.route('/recommendation', methods=["GET"])
def recommendation():
    if "user_id" in session:
        return render_template('recommendations.html')
    return render_template('home.html',not_log=True)

@app.route('/add_goal', methods=["GET"])
def add_goal():
     if "user_id" in session:
        return render_template('add_goal.html')
     return render_template('home.html',not_log=True)

@app.route('/rec_waiting', methods=["GET"])
def rec_waiting():
     if "user_id" in session:
        return render_template('rec_waiting.html')
     return render_template('home.html',not_log=True)

@app.route('/gen_rec', methods=["GET"])
def gen_rec():
     if "user_id" in session:
        return render_template('gen_rec.html')
     return render_template('home.html',not_log=True)


@app.route('/health_ageing_article', methods=["GET"])
def health_ageing_article():
     if "user_id" in session:
        return render_template('health_ageing_article.html')
     return render_template('home.html',not_log=True)



workouts_data = [
     {"img":'images/wo1.png',"title":"Strength Trainings","icon":'images/c1.png',"diff":"Hard"},
     {"img":'images/wo2.png',"title":"Balance training","icon":'images/c2.png',"diff":"Easy"},
     {"img":'images/wo3.png',"title":"Cross-country skiing","icon":'images/c3.png',"diff":"Medium"},
     {"img":'images/wo4.png',"title":"Walking","icon":'images/c4.png',"diff":"Hard"},
     {"img":'images/wo5.png',"title":"Badminton","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo6.png',"title":"Stretching","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo7.png',"title":"Joga","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo8.png',"title":"Tai Chi","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo9.png',"title":"Cycling","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo10.png',"title":"30-Minute Blast","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo11.png',"title":"Dumbbell Strenght Build","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo12.png',"title":"Sommer Strength And Stability","icon":'images/c5.png',"diff":"Medium"},
     {"img":'images/wo13.png',"title":"Get Strong","icon":'images/c5.png',"diff":"Medium"},
]
@app.route('/workouts', methods=["GET"])
def workouts():
    if "user_id" in session:
        return render_template('workouts.html',workouts_data=workouts_data)
    return render_template('home.html',not_log=True)


@app.route('/workout_filter', methods=["GET"])
def workout_filter():
    if "user_id" in session:
        filter= request.args.get('filter')
        print(filter)
        if filter == "":
             return render_template('workouts.html',workouts_data=workouts_data)
        workouts_data_copy = []
        # for data in workouts_data:
        #      if data["title"] in filter.split(",") or data["diff"] in filter.split(","):
        #           workouts_data_copy.append(data)
        if "Anaerobic training (Strength workouts)" in filter.split(",") and "Hard" in filter.split(","):
                  workouts_data_copy.append(workouts_data[0])
        else:
             workouts_data_copy = workouts_data
        
        return render_template('workouts.html',workouts_data=workouts_data_copy)
    return render_template('home.html',not_log=True)

@app.route('/Strength Trainings', methods=["GET"])
def strength_training():
    if "user_id" in session:
        return render_template('Strength Trainings.html')
    return render_template('home.html',not_log=True)

@app.route('/add_profile_card', methods=["GET"])
def add_profile_card():
    card_id=request.args.get("c_id")
    if "user_id" in session:
        user_id=session["user_id"]
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                    SELECT cards FROM profile WHERE user_id = %s
                """, (user_id,))
        results = cursor.fetchone()
        print("######",results)
        if results[0]:
            cards = results[0]+","+card_id
        else:
             cards=card_id
        
        cursor.execute("""
                update profile set cards=%s where user_id=%s
            """, ( cards, user_id))
        conn.commit()
        cursor.close()
        id = session['user_id']
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (id,))
        result = cursor.fetchone()
        cursor.close()


        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT cards FROM profile WHERE user_id = %s
                    """, (id,))
        results = cursor.fetchone()
        cards = results[0]
        if "," in cards:
            cards = results[0].split(",")
        else:
             cards = list(results[0])
        added_cards = []
        not_added_cards = []
        for c in profiles_cards:
            if c["c_id"] in cards:
                     added_cards.append(c)
            else:
                       not_added_cards.append(c)
        return render_template('profile.html',message={"result":result,"added_cards":added_cards,"not_added_cards":not_added_cards})
    return render_template('home.html',not_log=True)


@app.route('/remove_profile_card', methods=["GET"])
def remove_profile_card():
    card_id=request.args.get("c_id")

    if "user_id" in session:
        user_id=session["user_id"]
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                    SELECT cards FROM profile WHERE user_id = %s
                """, (user_id,))
        results = cursor.fetchone()
        cards = results[0]
        if "," in cards:
            cards = results[0].split(",")
        else:
             cards = list(results[0])
        if card_id in cards:
             cards.remove(card_id)
        cards = ",".join(cards)
        cursor.execute("""
                update profile set cards=%s where user_id=%s
            """, ( cards, user_id))
        conn.commit()
        cursor.close()
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        id = session['user_id']
        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT name,email,age,city,country,image FROM profile,account WHERE user_id=account.id and user_id = %s
                    """, (id,))
        result = cursor.fetchone()
        cursor.close()


        conn = mysql.connector.connect(
                    host=conn_data["host"],
                    user=conn_data["user"],
                    password=conn_data["password"],
                    database=conn_data["database"]
            )
        cursor = conn.cursor()
        cursor.execute("""
                        SELECT cards FROM profile WHERE user_id = %s
                    """, (id,))
        results = cursor.fetchone()
        cards = results[0]
        if "," in cards:
            cards = results[0].split(",")
        else:
             cards = list(results[0])
        added_cards = []
        not_added_cards = []
        for c in profiles_cards:
            if c["c_id"] in cards:
                     added_cards.append(c)
            else:
                       not_added_cards.append(c)
        return render_template('profile.html',message={"result":result,"added_cards":added_cards,"not_added_cards":not_added_cards})
    return render_template('home.html',not_log=True)




if __name__ == '__main__':
    app.run(debug=True)



