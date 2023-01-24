### 1. Install AWS CLI
Ubuntu and Debian Systems
```
sudo apt install awscli
```
Fedora and CentOS 8
```
sudo dnf install awscli
```
CentOS 7 and Scientific Linux
```
sudo yum install awscli
```
Other than the package manager, you can directly install using source code. This will install the latest awscli version on any Linux platform.
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
unzip awscliv2.zip 
sudo ./aws/install 
```


### 2. Configure AWS CLI
```
aws configure
```
This will prompt for AWS Access Key ID and Secret Access Key created in the above step.

### 3. Shell Script to Backup MySQL database to S3
Copy the below shell script to a file like db-backup.sh. This script uses mysqldump command to create databases backups. Then use gzip command to archive backup files and finally use aws command to upload backup files to Amazon S3 bucket.

Create a file like /backup/s3-backup-mysql.sh in edit your favorite text editor. Then add the below content:  [s3-backup-mysql.sh](https://github.com/FTM-7/backup-mysql-to-aws-s3/blob/main/s3-backup-mysql.sh)

### 4. How to run backup script
Set the execute (x) permission on script:
```
chmod +x s3-backup-mysql.sh 
```
Then run the backup script.
```
./s3-backup-mysql.sh
```

### 5. Schedule backup script to run daily
CentOS 7
```
nano /var/spool/cron/root
```
Run every 6 hours
```
0 */6 * * * /backup/s3-backup-mysql.sh > -O /dev/null 2>&1
```
