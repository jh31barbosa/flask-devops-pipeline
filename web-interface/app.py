from flask import Flask, request, jsonify, render_template, redirect, url_for
from prometheus_client import Summary, Counter
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
tasks = []

# Prometheus metrics
metrics = PrometheusMetrics(app)
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
REQUEST_COUNT = Counter('app_request_total', 'Total number of requests')

# Home route to render the template
@app.route('/', methods=['GET'])
def home():
    REQUEST_COUNT.inc()  # Increment the counter for each request
    return render_template('index.html', tasks=tasks)

# Route to add a task from a form submission
@app.route('/tasks', methods=['POST'])
def create_task():
    REQUEST_COUNT.inc()  # Increment the counter for each request
    task_name = request.form.get('name')
    task_description = request.form.get('description')
    if task_name:
        task = {'name': task_name, 'description': task_description}
        tasks.append(task)
        return redirect(url_for('home'))
    return jsonify({"error": "Invalid task data"}), 400

# Route to delete a task
@app.route('/tasks/<int:task_id>', methods=['POST'])
def delete_task(task_id):
    REQUEST_COUNT.inc()  # Increment the counter for each request
    if 0 <= task_id < len(tasks):
        tasks.pop(task_id)
        return redirect(url_for('home'))
    return jsonify({"error": "Task not found"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
