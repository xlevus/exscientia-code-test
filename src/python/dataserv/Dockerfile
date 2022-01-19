FROM python:3.9

EXPOSE 8080

COPY serve_data.py /


ENTRYPOINT ["python3", "/serve_data.py", "--port", "8080"]
CMD ["/data"]