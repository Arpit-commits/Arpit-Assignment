import os
import logging
import boto3
from flask import Flask, render_template, send_from_directory

app = Flask(__name__, static_folder='/app/static')

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Environment variables
BACKGROUND_IMAGE_URL = os.getenv('BACKGROUND_IMAGE_URL', 'background.jpg')
S3_BUCKET_NAME = os.getenv('S3_BUCKET_NAME', 'arpit-clo835-backgrounds')
GROUP_NAME = os.getenv('GROUP_NAME', 'TechTitans')
GROUP_SLOGAN = os.getenv('GROUP_SLOGAN', 'Innovate Always')
MYSQL_HOST = os.getenv('MYSQL_HOST', 'mysql-service')
MYSQL_DB = os.getenv('MYSQL_DB', 'mydb')
MYSQL_USER = os.getenv('MYSQL_USER')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD')
MYSQL_PORT = os.getenv('MYSQL_PORT', '3306')

# Download and copy background image from S3
s3_client = boto3.client('s3')
def download_background_image():
    local_path = '/tmp/background.jpg'
    static_path = '/app/static/background.jpg'
    static_dir = '/app/static'
    try:
        if not os.path.exists(static_dir):
            os.makedirs(static_dir, 0o755)
        s3_client.download_file(S3_BUCKET_NAME, BACKGROUND_IMAGE_URL, local_path)
        with open(local_path, 'rb') as src, open(static_path, 'wb') as dst:
            dst.write(src.read())
        logger.info(f"Downloaded and copied background image to {static_path}")
    except Exception as e:
        logger.error(f"Failed to download or copy image: {e}")
    return static_path

download_background_image()

# MySQL connection (optional)
import pymysql
def get_db_connection():
    try:
        return pymysql.connect(
            user=MYSQL_USER,
            password=MYSQL_PASSWORD,
            host=MYSQL_HOST,
            database=MYSQL_DB,
            port=int(MYSQL_PORT)
        )
    except Exception:
        return None

@app.route('/')
def index():
    db_status = "No MySQL server configured (expected in development)"
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.close()
            conn.close()
            db_status = "Connected"
        except Exception as e:
            db_status = f"Error: {e}"
    return render_template('index.html',
                          group_name=GROUP_NAME,
                          group_slogan=GROUP_SLOGAN,
                          name='Arpit',
                          db_status=db_status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)