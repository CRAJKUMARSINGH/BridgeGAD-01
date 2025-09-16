<<<<<<< HEAD
FROM python:3.9-slim
WORKDIR /app
RUN pip install uv
COPY . .
RUN uv sync
=======
FROM python:3.9-slim
WORKDIR /app
RUN pip install uv
COPY . .
RUN uv sync
>>>>>>> 252cb8c9fcae0f94eaf6610a542bf6ecf871b62b
CMD ["uv", "run", "streamlit", "run", "streamlit_bridge_app.py", "--server.port=8501"]