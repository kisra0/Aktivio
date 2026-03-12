```markdown
# Aktivio – Health & Activity Management Platform

## Overview
Aktivio is a web-based platform designed to help individuals manage their physical activities and monitor their health. The system allows users to organize fitness events, track health indicators, and access useful health-related information through an integrated web interface.

The platform combines activity scheduling, health monitoring, and personal data tracking to help users maintain consistent and healthy exercise routines.

---

## Features

- User registration and login
- Personal profile management
- Add and manage fitness events
- Calendar-based event scheduling
- Daily activity reminders
- BMI health test and history tracking
- PHQ mental health questionnaire and history
- Workout suggestions
- Health-related articles
- Body information and educational pages

---

## Technology Stack

### Backend
- Python
- Flask

### Frontend
- HTML
- CSS
- JavaScript
- Jinja2 templates

### Database
- MySQL

### Python Libraries

- Flask
- mysql-connector-python
- requests

---

## Project Structure

```

Aktivio/
│
├── templates/          # HTML pages (frontend templates)
│
├── static/
│   ├── css/            # Stylesheets
│   ├── js/             # JavaScript files
│   └── images/         # Images and assets
│
├── server.py           # Flask backend application
│
└── README.md

```

---

## Backend Communication

The backend logic is implemented in `server.py`, which runs a Flask web server.  
This server handles all requests coming from the web interface through HTTP requests and renders the corresponding HTML templates.

In addition to serving the website, the same backend also provides API responses for a mobile application. Some endpoints detect requests coming from the mobile app through specific parameters (such as `flutter` in the request). When such requests are received, the server returns data in **JSON format** instead of rendering HTML pages. This allows the same backend to support both the web platform and the mobile application while sharing the same database and business logic.

---

## Requirements

Before running the project, install the following software:

- Python 3.x
- XAMPP (for MySQL database)
- pip (Python package manager)

---

## Install Python Packages

Install required libraries:

```

pip install flask mysql-connector-python requests

```

Or install using a requirements file:

```

pip install -r requirements.txt

```

Example `requirements.txt`:

```

Flask
mysql-connector-python
requests

```

---

## Database Setup (Using XAMPP)

1. Install **XAMPP**
2. Start the following services:
   - Apache
   - MySQL

3. Open phpMyAdmin:

```

[http://localhost/phpmyadmin](http://localhost/phpmyadmin)

```

4. Create a database named:

```

event

```

5. Create the following tables.

### Account
```

id
name
email
password

```

### Profile
```

id
age
city
country
image
user_id

```

### Event_table
```

id
name
date
time
duration
user_id

```

### Bmi_history
```

id
date
gender
age
weight
height
bmi
level
user_id

```

### Phq_history
```

id
questionnaire
results
user_id
date_test

```

---

## Running the Website

### Step 1: Open Terminal / Command Line

Navigate to the project folder:

```

cd path/to/Aktivio

```

Example:

```

cd Desktop/Aktivio

```

---

### Step 2: Run the Flask Server

Start the server using:

```

python server.py

```

The server will start and display:

```

Running on [http://127.0.0.1:5000](http://127.0.0.1:5000)

```

---

### Step 3: Open the Website

Open your browser and go to:

```

[http://127.0.0.1:5000](http://127.0.0.1:5000)

````

---

## Database Configuration

The backend connects to MySQL using the following configuration:

```python
conn_data = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "event"
}
````

Make sure the MySQL configuration matches your local XAMPP setup.

---

## System Architecture

The system follows a client–server architecture.

```
Web Browser / Mobile App
        │
        │ HTTP Requests
        ▼
Flask Backend (server.py)
        │
        │ SQL Queries
        ▼
MySQL Database
```

The browser provides the user interface, the Flask backend processes application logic, and the MySQL database stores user data and activity records.

```
```
