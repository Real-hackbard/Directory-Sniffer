# Directory-Sniffer:

Monitoring folders or entire partitions is a useful way to know what programs are doing on your hard drive.

This program allows you to track and analyze the activities of your programs. You can monitor individual folders or entire partitions. Monitoring can also be set up specifically if only conditional information is required.

When installing large programs, the setup creates many files in the system. In order to find these files, the sniffer can monitor the setup.


![DirSniffer](https://github.com/user-attachments/assets/b6dc1a2c-d09c-4e03-bcd4-acc9502703f4)



Monitoring categories:
1. Add File:

Used to find out which files your program or setup has created.

2. Remove File:

Monitor which files your program has removed.

3. Renamed File:

Find out which files your program has renamed. A report will be provided, converting the original file into the renamed file.

4. Renamed Directory:

Find out which folders your program has renamed. A report will be provided showing the original folders and the renamed folders.

5. Modification File:

Programs also modify the contents of a file as soon as they have access rights. The path to the file whose contents were modified is provided here.

6. Last Access:

To find out when a file was last accessed, the time, date and path are provided here.

7. Last Write File:

To find out when the contents of a file were last changed, the time, date and path are provided here.

8. Creation Time File:

_______________________________________________________________________________________________________________

When files are created, the file management system signs the time and date of creation. This information is provided here.

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
