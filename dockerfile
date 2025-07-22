FROM python:3.9-slim
WORKDIR /app
RUN pip install uv
COPY . .
RUN uv sync
CMD ["uv", "run", "streamlit", "run", "streamlit_bridge_app.py", "--server.port=8501"]