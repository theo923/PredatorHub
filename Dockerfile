# Stage 1 - Python Backend
FROM python:3.9 as backend
WORKDIR /app
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/theo923/predatorhub-python.git ./
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 - React Frontend Build
FROM node:16 as frontend
ENV VITE_API_URL=/api
WORKDIR /app
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/theo923/predatorhub-react.git ./
RUN yarn
COPY . .
RUN yarn build

# Stage 3 - Nginx for serving Frontend and proxy Backend
FROM nginx:1.19.0-alpine
# Install Python
RUN apk add --update python3 py3-pip
COPY --from=frontend /app/dist /var/www/html
COPY --from=backend /app /app
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./start.sh /app/
RUN chmod +x /app/start.sh
RUN pip3 install --no-cache-dir -r /app/requirements.txt

EXPOSE 80

CMD ["./app/start.sh"]
