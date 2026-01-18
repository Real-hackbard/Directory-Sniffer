# Directory-Sniffer:

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)  ![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![None](https://github.com/user-attachments/assets/30ebe930-c928-4aaf-a8e1-5f68ec1ff349)  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) ![Directory-Sniffer](https://github.com/user-attachments/assets/ad5250e8-45b5-4560-ac1d-7ec22621a53e)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) ![012026](https://github.com/user-attachments/assets/ae91e595-2dbf-4d94-b953-81e4fd25dcc3)   
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

Monitoring folders or entire partitions is a useful way to know what programs are doing on your hard drive.

This program allows you to track and analyze the activities of your programs. You can monitor individual folders or entire partitions. Monitoring can also be set up specifically if only conditional information is required.

When installing large programs, the setup creates many files in the system. In order to find these files, the sniffer can monitor the setup.

</br>

![DirectorySniffer](https://github.com/user-attachments/assets/f488ee2b-9b93-428f-a27f-be0a9e01e31c)

</br>

# Monitoring categories:
### 1. Add File:

Used to find out which files your program or setup has created.

### 2. Remove File:

Monitor which files your program has removed.

### 3. Renamed File:

Find out which files your program has renamed. A report will be provided, converting the original file into the renamed file.

### 4. Renamed Directory:

Find out which folders your program has renamed. A report will be provided showing the original folders and the renamed folders.

### 5. Modification File:

Programs also modify the contents of a file as soon as they have access rights. The path to the file whose contents were modified is provided here.

### 6. Last Access:

To find out when a file was last accessed, the time, date and path are provided here.

### 7. Last Write File:

To find out when the contents of a file were last changed, the time, date and path are provided here.

### 8. Creation Time File:

When files are created, the file management system signs the time and date of creation. This information is provided here.


| Categories             | Description |
| :--------------------: | :----------- |
| Add File     | Used to find out which files your program or setup has created.     |
| Remove File     | Monitor which files your program has removed.     |
| Renamed File     | Find out which files your program has renamed. A report will be provided, converting the original file into the renamed file.     |
| Renamed Directory     |Find out which folders your program has renamed. A report will be provided showing the original folders and the renamed folders.     |
| Modification File     | Programs also modify the contents of a file as soon as they have access rights. The path to the file whose contents were modified is provided here.     |
| Last Access     | To find out when a file was last accessed, the time, date and path are provided here.     |
| Last Write File     | To find out when the contents of a file were last changed, the time, date and path are provided here.     |
| Creation Time File     | When files are created, the file management system signs the time and date of creation. This information is provided here.     |


_______________________________________________________________________________________________________________


File monitoring involves tracking changes to files or directories on a system. This can be used to monitor file activity, detect unauthorized modifications, or track file creation, deletion, and modification times. 
Here's a breakdown of key aspects:

1. Purpose:
Security: Detecting unauthorized access, modification, or deletion of sensitive files.
Integrity: Ensuring that critical application files haven't been tampered with.
Backup Verification: Checking for the existence and age of backup files.
Performance Monitoring: Tracking the size and modification frequency of log files or other application-related files.
Compliance: Meeting regulatory requirements for data access and modification logs. 

2. Methods:
File System Events: Operating systems provide mechanisms (e.g., inotify on Linux, File System Watcher on Windows) to notify applications when file changes occur. 
Polling: Periodically checking file attributes (e.g., modification time, size). 
Specialized Tools: Tools like Checkmk, PRTG, and ManageEngine Applications Manager offer specific file monitoring features. 

3. What to Monitor:
File Changes: Tracking additions, deletions, and modifications. 
File Size: Detecting unusually large or small files. 
File Age: Identifying files that haven't been modified recently or that are older than a specified threshold. 
File Content: Analyzing file content for specific patterns or keywords. 
File Permissions: Monitoring changes to file access permissions. 

4. Examples:
Monitoring log files: Ensuring they are regularly rotated and not excessively large. 
Tracking configuration file changes: Notifying administrators of unauthorized modifications. 
Verifying the presence of backup files: Alerting if backups haven't been created as scheduled. 
Monitoring for unauthorized file uploads: Detecting potentially malicious files being added to a system.
