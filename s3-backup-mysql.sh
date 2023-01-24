#!/usr/bin/env bash
 
# Set the folder name formate with date (2022-05-28_10:16:40)
DATE_FORMAT=$(date +"%Y-%m-%d_%H:%M:%S")
 
# MySQL server credentials
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="user"
MYSQL_PASSWORD="password"
 
# Path to local backup directory
LOCAL_BACKUP_DIR="/backup"
 
# Set s3 bucket name and directory path
S3_BUCKET_NAME="s3-bucket-name"
S3_BUCKET_PATH="backup"
 
# Number of days to store local backup files
BACKUP_RETAIN_DAYS=10
 
# Use a single database or space separated database's names
DATABASES="DB1 DB2 DB3"
 
##### Do not change below this line
 
mkdir -p ${LOCAL_BACKUP_DIR}/${DATE_FORMAT}
 
LOCAL_DIR=${LOCAL_BACKUP_DIR}/${DATE_FORMAT}
REMOTE_DIR=s3://${S3_BUCKET_NAME}/${S3_BUCKET_PATH}
 
for db in $DATABASES; do
   mysqldump \
        -h ${MYSQL_HOST} \
        -P ${MYSQL_PORT} \
        -u ${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        --single-transaction ${db} | gzip -9 > ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz
 
        aws s3 cp ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz ${REMOTE_DIR}/${DATE_FORMAT}/
done
 
DBDELDATE=`date +"${DATE_FORMAT}" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${LOCAL_BACKUP_DIR} ]; then
 cd ${LOCAL_BACKUP_DIR}
 if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
 rm -rf ${DBDELDATE}
 
 fi
fi
 
## Script ends here
