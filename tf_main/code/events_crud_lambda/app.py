from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)
# Database parameters
username = "dbadmin"
password = "dbadmin179"
hostname = "" #todo
port = "" #todo
databasename = "events_db"

# Configuration for AWS Aurora Postgres
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql+psycopg2://'+username+':'+password+'@'+hostname+':'+port+'/'+databasename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Event(db.Model):
    __tablename__ = 'events'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(80), nullable=False)
    description = db.Column(db.String(200))
    location = db.Column(db.String(100))
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    creation_time = db.Column(db.DateTime, default=datetime.utcnow)
    popularity = db.Column(db.Integer, default=0)
    reminders = db.relationship('Reminder', backref='event', lazy=True)

class Reminder(db.Model):
    __tablename__ = 'reminders'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), nullable=False)
    event_id = db.Column(db.Integer, db.ForeignKey('events.id'), nullable=False)

# Create the database tables
@app.before_first_request
def create_table():
    db.create_all()

# API Endpoints
@app.route('/events', methods=['POST'])
def schedule_event():
    data = request.get_json()
    new_event = Event(
        title=data['title'],
        description=data['description'],
        location=data['location'],
        start_time=datetime.fromisoformat(data['start_time']),
        end_time=datetime.fromisoformat(data['end_time'])
    )
    db.session.add(new_event)
    db.session.commit()
    if 'reminders' in data:
        for email in data['reminders']:
            reminder = Reminder(email=email, event_id=new_event.id)
            db.session.add(reminder)

    db.session.commit()
    return jsonify({"message": "Event and reminders scheduled successfully!"}), 201

@app.route('/events', methods=['GET'])
def retrieve_events():
    events = Event.query.all()
    return jsonify([{'id': event.id, 'title': event.title} for event in events])

@app.route('/events/<int:id>', methods=['GET'])
def retrieve_event(id):
    event = Event.query.get_or_404(id)
    return jsonify({'title': event.title, 'description': event.description})

@app.route('/events/<int:id>', methods=['PUT'])
def update_event(id):
    event = Event.query.get_or_404(id)
    data = request.get_json()
    event.title = data['title']
    event.description = data['description']
    db.session.commit()
    return jsonify({"message": "Event updated successfully!"})

@app.route('/events/<int:id>', methods=['DELETE'])
def delete_event(id):
    event = Event.query.get_or_404(id)
    db.session.delete(event)
    db.session.commit()
    return jsonify({"message": "Event deleted successfully!"})

if __name__ == '__main__':
    app.run()