FROM python:3.9-alpine
WORKDIR /app
COPY requirements.txt python_web_app.py .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "python_web_app.py", port=5000]