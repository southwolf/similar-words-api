FROM python:3-alpine


RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py /usr/src/app/

COPY GoogleNews-vectors-negative300.bin.gz /usr/src/app/
# Expose the Flask port
EXPOSE 5000

CMD [ "python", "./app.py" ]