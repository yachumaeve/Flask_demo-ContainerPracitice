FROM python:3.9.5-slim

# Step 1: 安裝 Python 依賴
# 這裡應該不會失敗，因為基礎鏡像已經包含 pip
RUN pip install flask redis

# Step 2: 建立使用者和群組
# 使用 -s /bin/false 確保用戶不能登入，更安全
# 使用 -D 禁用家目錄創建，減少映像大小
RUN groupadd --gid 1000 flask && \
  useradd -r -g flask -s /bin/false -u 1000 flask

# Step 3: 設定工作目錄和權限
# 注意：為了安全起見，建議先創建 /src，再COPY
RUN mkdir /src && \
  chown -R flask:flask /src

USER flask

COPY app.py /src/app.py

WORKDIR /src

ENV FLASK_APP=app.py REDIS_HOST=redis

EXPOSE 5000

CMD ["flask", "run", "-h", "0.0.0.0"]