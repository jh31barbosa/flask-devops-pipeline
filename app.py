from flask import Flask, request, jsonify
from prometheus_client import start_http_server, Summary, Counter

app = Flask(__name__)
tasks = []

# Prometheus metrics
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
REQUEST_COUNT = Counter('app_request_total', 'Total number of requests')

# Start Prometheus server to expose metrics
start_http_server(9090)  # Prometheus server running on port 9090

# Time the GET request for /tasks
@REQUEST_TIME.time()
@app.route('/tasks', methods=['GET'])
def get_tasks():
    REQUEST_COUNT.inc()  # Increment the counter for each request
    return jsonify(tasks)

@app.route('/tasks', methods=['POST'])
def create_task():
    task = request.json
    tasks.append(task)
    return jsonify(task), 201

@app.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    if task_id < 0 or task_id >= len(tasks):
        return jsonify({"error": "Task not found"}), 404
    task = tasks.pop(task_id)
    return jsonify(task)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
