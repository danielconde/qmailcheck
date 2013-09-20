qmailcheck by Daniel Conde Rodriguez
# Twitter: @daconde2 
# es.linkedin.com/in/daniconde
==========

Qmail and Postfix Mail Queue Monitor Script

This scripts will help you fighting against the spam. It will notify you when a limit of mails are queued in the mail queue of the server. Main Benefits are:
· Detect & Reduce the amount of outbound spam before being blacklisted.
· Maintain IP good reputation in Internet blocking lists and networks.
· Costs savings: Decrease the costs associated with the resolution of blocked IPs and staff workload assignment.
· Improve Customers Engadgement for dissatisfied customer management for being blocked by other blacklists or ISP providers

== INSTALLATION ==

1) Copy this three files anywhere in you server in the same directory. ie. /root/monitor

- monitormail.sh: Checks the mail queue and sends an email if the queue limit "qlimit_remote" variable is exceeded. 
- script_flag.sh: Checks which IP has been flagged (0,1) to avoid sending notifications every time monitormail.sh checks the server mail queue. Acts as notification delay.
- servers.txt: list of servers to be monitorized. 0 means not flagged. 1 means flagged = email notification already sent to email address specified by "notifyemail" in monitor.sh

 
2) chmod 755 monitormail.sh

3) Configure cron job for:
monitormail.sh will check your servers mail every X minutes (defined by your cron job)
script_flag.sh will reset to not flagged (0) every IP listed in servers.txt

Example:
Check every 5 minutes servers' mail queue and flush notify flag every 45 mins. If a server has lots of spam, only one email notification will be sent every 45 minutes.

*/5 * * * * root /root/monitor/monitormail.sh
*/45 * * * * root /root/monitor/script_flag.sh



==ADDING another IP ==


1) Enter the key "IP:0" in /root/monitor/servers.txt at the very end, one per line. ie -> "127.0.0.1:0"

2) Insert the RSA key on the target server to which the monitor connects directly via ssh. To do this copy the contents of id_rsa.pub where monitormail.sh is installed and add it at the end of the file /root/.ssh/authorized_keys on the remote mailserver we want to monitor. Create .ssh directory and authorized_keys file if does not exist. Google it about creating the id_rsa.pub file on your server.

CAUTION! There can be no spaces or gaps by copying and pasting the content, otherwise it will not allow direct ssh access to the server.

3) If you are using Plesk Control Panel, check out the version. Plesk 8.2 and below must be added as exception in the next step because the binary mailqueuemng does not work.

3.1) If you have plesk 8.0 or 8.2, you must uncomment LINE 35 and add the IP. You must also install qmHandle in the monitor server.

Uncomment LINE 35 -> # if [ "$line" = "YOUR_IP" ]  , if you need to add more than one IP, add OR operator and the bash code in brackets:
 Here's an example:

 [ "$ Line" = "127.0.0.1" ]; then

After adding a new IP would remain:

[ "$ Line" = "127.0.0.1" ] | | [ "$ line" = "NEWIP" ]; then

Easy, right!?

CAUTION! there must be a space after the end bracket.

4) Finally connect via the ssh directly with the target server. ie -> ssh root@NEWIP and accept the fingerprint "yes".

We are done!
