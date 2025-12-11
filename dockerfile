FROM python:3.9.5-slim

# Step 0: 升級 pip 到最新版本 (關鍵修正)
RUN pip install --no-cache-dir --upgrade pip

# Step 1: 安裝 Python 依賴
# 使用 --no-cache-dir 確保不保留下載的快取
RUN pip install --no-cache-dir flask redis

# Step 2: 建立使用者和群組 (經測試，此步驟在 amd64 上已成功)
RUN groupadd --gid 1000 flask && \
  useradd -r -g flask -s /bin/false -u 1000 flask

# Step 3: 設定工作目錄和權限
RUN mkdir /src && \
  chown -R flask:flask /src

USER flask

COPY app.py /src/app.py

WORKDIR /src

ENV FLASK_APP=app.py REDIS_HOST=redis

EXPOSE 5000

CMD ["flask", "run", "-h", "0.0.0.0"]