Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:33479 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751972AbdHLCi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 22:38:58 -0400
Message-ID: <1243.49.228.123.163.1502505534.squirrel@mail>
In-Reply-To: <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
    <22169.183.88.87.49.1502260598.squirrel@mail>
    <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
    <27218.183.88.87.49.1502426431.squirrel@mail>
    <13031.192.168.42.222.1502431206.squirrel@mail>
    <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
Date: Sat, 12 Aug 2017 09:38:54 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Chris Murphy" <lists@colorremedies.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20170812093854_48916"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

------=_20170812093854_48916
Content-Type: text/plain; charset="tis-620"
Content-Transfer-Encoding: 8bit

Hi Chris,

I explain what I have done in the attached file.

Please suggest me what I should do next?

I plan to reproduce the data mannually for the daily inserted data to check the
detail step by step to know exactly which steps make the btrfs send /receive result
diff on the Second box (Machine Y).  I will start with the first btrfs snapshot that
I already had (mysql_201707210830).


Do you think I should do others?

Best Regards,
Siranee Jaraswachirakul.

> On Fri, Aug 11, 2017 at 12:00 AM,  <siranee.ja@tpc.co.th> wrote:
>> Sorry Chris,
>>
>> I forgot to send the diff from rsync -anc result
>>
>> the source container A start data as data on snapshot  mysql_201708040830
>>
>> [root@backuplogC7 tmp]# ls -l /var/lib/mariadb
>> total 0
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql
>> drwxrwxr-x+ 1 mysql mysql 260 Jul 12 08:29 mysql_201708040830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708050830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708060830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708070830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708080830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708090830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708100830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708110830
>>
>> the dest    container B start data as data on snapshot mysql_201708070830
>>
>> [root@joytest tmp]# ls -l /var/lib/mariadb
>> total 0
>> drwxrwxr-x+ 1 mysql mysql 260 Aug 11 10:24 mysql
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708070830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708080830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708090830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708100830
>> drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708110830
>>
>>
>>
>> tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708110830.txt
>> dest_mysql_201708110830.txt
>> 1c1
>> < drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708110830
>> ---
>>> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708110830
>> 5c5
>> < -rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708110830/ib_logfile1
>> ---
>>> -rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708110830/ib_logfile1
>>
>
> I don't really understand this. I don't see the actual rsync -anc
> command, what I see is a diff of two text files whose contents I also
> don't understand. So I have to guess that ib_logfile1 is a file inside
> of a snapshot on machine A, that was btrfs send -p / receive to
> machine B and is now different for some reason?
>
> If the problem is that ib_logfile1 is wrong only on machine B after
> Btrfs send receive, that suggests it might be a network problem. The
> Btrfs send receive stream only checksums btrfs metadata (the internal
> commands in the stream). The data is not checksummed so it is possible
> an uncaught network error can inject silent data corruption which
> Btrfs will not catch - it's just the normal TCP/IP network
> checksumming happening.
>
> Anyway, I'm still confused whether the problem is a change only during
> send/receive, or if there's a change happening on a machine in
> isolation just when you delete other snapshots.
>
>
> --
> Chris Murphy
>

------=_20170812093854_48916
Content-Type: text/plain; name="detail_explain_more.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="detail_explain_more.txt"

Hi Chris,

I would like to describe what I have done.

Exactly I have 3 boxes of ubuntu 16.04 LTS in mycompany environment and the other on hosting provider.

Overall steps
First -> started first box in company environment and send btrfs offline (batch) to receive with scp to remote box on hosting provider.
After incorrect result of incremental I had to send the new base to start over on remote box around 3 times I changed to the Second step.
Second -> Setup the second box in company environment on the different network segment of the first box and still send btrfs offline (batch) to receive with scp from first box to second box
Yes the result still the same as the First even different date but the incremental unusable vary (not only on the second incremental send)
Third -> Change from test with 2 boxes to be only one box with 2 containers and use online send and receive btrfs as you see the current result of btrfs sub volumes.
The result still incorrect some day which I had to start send the new base btrfs snapshot whenever it started to be incorrect.
I suspect the send/recieve machanism then I uses the snapshot on mysql_201708040830 to be the start base on the source btrfs in container A (backuplogC7) (As I said the local without send/receive it work) until now.
Since   mysql_201708040830 the incremental still work until mysql_201708110830 it start to incorrect.




1. I started with the first box (Machine X called "virtualtrust3") 
tpcorp@virtualtrust3:~$ uname -a
Linux virtualtrust3 4.4.0-79-generic #100-Ubuntu SMP Wed May 17 19:58:14 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
tpcorp@virtualtrust3:~$ cat /etc/*release*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.2 LTS"
NAME="Ubuntu"
VERSION="16.04.2 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.2 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial


2. I have a container for the mariadb databases with have data inserted every day at 7:30 AM.

tpcorp@virtualtrust3:~$ lxc list backuplog
+-------------+---------+-----------------------+------+------------+-----------+
|    NAME     |  STATE  |         IPV4          | IPV6 |    TYPE    | SNAPSHOTS |
+-------------+---------+-----------------------+------+------------+-----------+
| backuplogC7 | RUNNING | 192.168.47.185 (eth0) |      | PERSISTENT | 0         |
+-------------+---------+-----------------------+------+------------+-----------+

inside container backuplogC7 (Container A) 
tpcorp@virtualtrust3:~$ lxc exec backuplogC7 -- bash
[root@backuplogC7 ~]# uname -a
Linux backuplogC7 4.4.0-79-generic #100-Ubuntu SMP Wed May 17 19:58:14 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
[root@backuplogC7 ~]# cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
[root@backuplogC7 ~]#

[root@backuplogC7 ~]# btrfs sub list /var/lib/mariadb
ID 257 gen 532 top level 5 path mysql
ID 315 gen 491 top level 5 path mysql_201708050830
ID 316 gen 498 top level 5 path mysql_201708060830
ID 317 gen 503 top level 5 path mysql_201708070830
ID 318 gen 507 top level 5 path mysql_201708080830
ID 319 gen 514 top level 5 path mysql_201708090830
ID 320 gen 524 top level 5 path mysql_201708100830
ID 321 gen 529 top level 5 path mysql_201708110830
[root@backuplogC7 ~]# ls -l /var/lib/mariadb
total 0
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708050830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708060830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708070830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708080830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708090830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708100830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708110830
[root@backuplogC7 ~]#

3. First time I created the container A I took the first snapshot at mysql_201707210830 

[root@backuplogC7 ~]# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

30 08 * * * root /root/script/backup/backupsnap.sh root password /var/lib/mariadb/mysql >> /var/log/btrfs_snap.log
05 09 * * * root /root/script/backupbtrfs_inc.sh /var/lib/mariadb 192.168.45.166 /var/lib/mariadb >> /var/log/btrfs_send.log
0 19 * * * root /root/script/backup/doBackup_file_backuplog.sh
30 19 * * * root /root/script/delete_btrfs_sub_snap_volume.sh /var/lib/mariadb 7 >> /var/log/btrfs_del.log

# temp
##00 09 * * * root /root/script/backupbtrfs_all.sh /var/lib/mariadb /backupbtrfs mysql_201707210830

You will see the /root/script/backupbtrfs_all.sh because I stated with batch send and receive to the box on hosting provider.
Daily Routine Steps to test still be the same except change from offline (batch) to online 
3.1 I had application to insert data to mariadb everyday around 7:30 AM
3.2 the snapshot has been took every day around 8:30 AM with the backupsnap.sh script/backup/backupsnap
3.3 First test I have to use the 09:00 AM /root/script/backupbtrfs_all.sh to btrfs send to files on /backupbtrfs with the starting snapshot mysql_201707210830
3.4 at 19:00 root/script/backup/doBackup_file_backuplog.sh for the ordinary online backup of mariadb just mysqldump
3.5 after backup ordinary I delete the old snapshot to keep only 7 snapshots


Now the offline btrfs send is commented out
and the Daily Routine Steps are
3.1 I had application to insert data to mariadb everyday around 7:30 AM
3.2 the snapshot has been took every day around 8:30 AM with the backupsnap.sh script/backup/backupsnap
3.3 09:05 AM /root/script/backupbtrfs_inc.sh to btrfs send to receive at destination  online
3.4 at 19:00 root/script/backup/doBackup_file_backuplog.sh for the ordinary online backup of mariadb just mysqldump
3.5 after backup ordinary I delete the old snapshot to keep only 7 snapshots



As you would like to see the rsync command

[root@backuplogC7 ~]# history|grep rsync
  436  rsync
  437  yum install rsync
  444  rsync -anc mysql_201708110830 > /tmp/source_mysql_201708110830.txt
  453  history|grep rsync
  454  rsync -anc mysql_201708100830 > /tmp/source_mysql_201708100830.txt
  455  rsync -anc /var/lib/mariadb/mysql_201708100830 > /tmp/source_mysql_201708100830.txt
  462  history|grep rsync
  463  rsync -anc /var/lib/mariadb/mysql_201708090830 > /tmp/source_mysql_201708090830.txt
  464  rsync -anc /var/lib/mariadb/mysql_201708080830 > /tmp/source_mysql_201708080830.txt
  465  rsync -anc /var/lib/mariadb/mysql_201708070830 > /tmp/source_mysql_201708070830.txt

[root@joytest ~]# history|grep rsync
  423  rsync -anc /var/lib/mariadb/mysql_201708090830
  424  yum install rsync
  425  rsync -anc /var/lib/mariadb/mysql_201708090830
  439  rsync -anc mysql_201708110830 > /tmp/dest_mysql_201708110830.txt
  448  hsitory|grep rsync
  449  history|grep rsync
  450  rsync -anc /var/lib/mariadb/mysql_201708100830  > /tmp/dest_mysql_201708100830.txt
  451  rsync -anc /var/lib/mariadb/mysql_201708090830  > /tmp/dest_mysql_201708090830.txt
  452  rsync -anc /var/lib/mariadb/mysql_201708080830  > /tmp/dest_mysql_201708080830.txt
  453  rsync -anc /var/lib/mariadb/mysql_201708070830  > /tmp/dest_mysql_201708070830.txt
  461  rsync -anc mysql_201708110830 > /tmp/dest_mysql_201708110830.txt2
  462  rsync -anc /var/lib/mariadb/mysql_201708110830 > /tmp/dest_mysql_201708110830.txt2
  485  history|grep rsync
  486  rsync -anc /var/lib/mariadb/mysql_201708110830 > /tmp/dest_mysql_201708110830.txt3
  501  history|grep rsync
  
tpcorp@virtualtrust3:~$ history|grep pull

1966  lxc file pull backuplogC7/tmp/source_/tmp/dest_mysql_201708110830.txt
 1967  lxc file pull backuplogC7/tmp/source_mysql_201708110830.txt .
 1968  lxc file pull joytest/tmp/dest_mysql_201708110830.txt .
 1975  history|grep pull
 1976  lxc file pull backuplogC7/tmp/source_mysql_201708100830.txt .
 1977  lxc file pull joytest/tmp/dest_mysql_201708100830.txt .
 1982  lxc file pull joytest/tmp/dest_mysql_*.txt .
 1983  history|grep pull
 1984  lxc file pull joytest/tmp/dest_mysql_201708090830.txt .
 1985  lxc file pull joytest/tmp/dest_mysql_201708080830.txt .
 1986  lxc file pull joytest/tmp/dest_mysql_201708070830.txt .
 1987  lxc file pull backuplogC7/tmp/source_mysql_201708090830.txt .
 1988  lxc file pull backuplogC7/tmp/source_mysql_201708080830.txt .
 1989  lxc file pull backuplogC7/tmp/source_mysql_201708070830.txt .


tpcorp@virtualtrust3:~$ history|grep diff
 1970  diff source_mysql_201708110830.txt  dest_mysql_201708110830.txt
 1972  diff source_mysql_201708110830.txt  dest_mysql_201708110830.txt
 1978  diff source_mysql_201708100830.txt dest_mysql_201708100830.txt
 1991  diff source_mysql_201708070830.txt dest_mysql_201708070830.txt
 1992  diff source_mysql_201708080830.txt dest_mysql_201708080830.txt
 1993  diff source_mysql_201708090830.txt dest_mysql_201708090830.txt
 1994  diff source_mysql_201708100830.txt dest_mysql_201708100830.txt
 1995  diff source_mysql_201708110830.txt dest_mysql_201708110830.txt

"The diff command just display only the difference between source and destination"

"The following means the source differs from destination not only subvolume "mysql_201708110830" diff at datetime but also file "ib_logfile1" which diff only one second. The mariadb can not start.

tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708110830.txt  dest_mysql_201708110830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708110830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708110830
5c5
< -rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708110830/ib_logfile1
---
> -rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708110830/ib_logfile1


"The following means the source differs from destination only diff at datetime

tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708100830.txt dest_mysql_201708100830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708100830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708100830
tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708090830.txt dest_mysql_201708090830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708090830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708090830
tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708080830.txt dest_mysql_201708080830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708080830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708080830
tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708070830.txt dest_mysql_201708070830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708070830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708070830

The Last snapshot send /receive

tpcorp@virtualtrust3:/tmp$ lxc file pull backuplogC7/tmp/source_mysql_201708120830.txt .
tpcorp@virtualtrust3:/tmp$ lxc file pull joytest/tmp/dest_mysql_201708120830.txt .
tpcorp@virtualtrust3:/tmp$ diff /tmp/source_mysql_201708120830.txt /tmp/dest_mysql_201708120830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708120830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708120830
5c5
< -rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708120830/ib_logfile1
---
> -rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708120830/ib_logfile1
tpcorp@virtualtrust3:/tmp$


-----------------
As you request for the real output on screen of source (container A) rsync
-----------------

[root@backuplogC7 ~]# rsync -anc /var/lib/mariadb/mysql_201708110830
drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708110830
-rw-rwx---       16384 2017/08/04 13:08:08 mysql_201708110830/aria_log.00000001
-rw-rwx---          52 2017/08/04 13:08:08 mysql_201708110830/aria_log_control
-rw-rwx---     5242880 2017/08/11 08:29:07 mysql_201708110830/ib_logfile0
-rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708110830/ib_logfile1
-rw-rwx---   706740224 2017/08/11 08:29:07 mysql_201708110830/ibdata1
-rw-rw----         264 2017/03/30 08:40:47 mysql_201708110830/mysql-bin.000001
-rw-rw----          19 2017/03/30 08:38:29 mysql_201708110830/mysql-bin.index
drwx------         644 2017/03/31 09:39:55 mysql_201708110830/backups_db
-rw-rw----          61 2017/03/28 15:14:28 mysql_201708110830/backups_db/db.opt
-rw-rw----        8554 2017/03/28 15:17:54 mysql_201708110830/backups_db/ints.frm
-rw-rw----        8766 2017/03/31 09:14:26 mysql_201708110830/backups_db/tpc_backup_detail.frm
-rw-rw----        8836 2017/03/31 09:25:41 mysql_201708110830/backups_db/tpc_backup_header.frm
-rw-rw----        9020 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_history.frm
-rw-rw----        8730 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_schedule_level_master.frm
-rw-rw----        8774 2017/03/31 09:39:55 mysql_201708110830/backups_db/tpc_backup_schedule_master.frm
-rw-rw----        8774 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_schedule_master_extra.frm
-rw-rw----        8774 2017/03/28 15:18:59 mysql_201708110830/backups_db/tpc_backup_schedule_old.frm
-rw-rw----        8672 2017/03/28 15:18:59 mysql_201708110830/backups_db/tpc_backup_server.frm
-rw-rw----        8888 2017/03/31 09:13:41 mysql_201708110830/backups_db/tpc_backup_step.frm
-rw-rw----        8722 2017/03/28 15:19:10 mysql_201708110830/backups_db/tpc_backup_user.frm
-rw-rw----        1851 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_backup_header_status.frm
-rw-rw----         716 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_calendar.frm
-rw-rw----        1611 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_dup_backup.frm
drwxrwx---        2094 2017/03/28 14:54:08 mysql_201708110830/mysql
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.MYI
-rw-rw----        8820 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.frm
-rw-rw----         440 2017/08/01 17:00:06 mysql_201708110830/mysql/db.MYD
-rw-rw----        5120 2017/08/02 08:30:01 mysql_201708110830/mysql/db.MYI
-rw-rw----        9582 2017/03/28 14:54:06 mysql_201708110830/mysql/db.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/event.MYD
-rw-rw----        2048 2017/03/28 14:54:06 mysql_201708110830/mysql/event.MYI
-rw-rw----       10239 2017/03/28 14:54:06 mysql_201708110830/mysql/event.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/func.MYD
-rw-rw----        1024 2017/03/28 14:54:06 mysql_201708110830/mysql/func.MYI
-rw-rw----        8665 2017/03/28 14:54:06 mysql_201708110830/mysql/func.frm
-rw-rwx---          35 2017/08/11 08:30:01 mysql_201708110830/mysql/general_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708110830/mysql/general_log.CSV
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708110830/mysql/general_log.frm
-rw-rw----        1092 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.MYD
-rw-rw----        3072 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.MYI
-rw-rw----        8700 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.frm
-rw-rw----       91408 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.MYD
-rw-rw----       16384 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.MYI
-rw-rw----        8612 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.frm
-rw-rw----        9252 2017/03/28 14:54:07 mysql_201708110830/mysql/help_relation.MYD
-rw-rw----       17408 2017/03/28 14:54:07 mysql_201708110830/mysql/help_relation.MYI
-rw-rw----        8630 2017/03/28 14:54:06 mysql_201708110830/mysql/help_relation.frm
-rw-rw----      450388 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.MYD
-rw-rw----       20480 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.MYI
-rw-rw----        8770 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/host.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708110830/mysql/host.MYI
-rw-rw----        9510 2017/03/28 14:54:07 mysql_201708110830/mysql/host.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.MYI
-rw-rw----        8778 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.MYI
-rw-rw----        8586 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.MYI
-rw-rw----       10012 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.MYI
-rw-rw----        8875 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.frm
-rw-rw----        1386 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.MYD
-rw-rw----        5120 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.MYI
-rw-rw----        8800 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.MYI
-rw-rw----        8838 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.frm
-rw-rwx---          35 2017/08/11 08:30:01 mysql_201708110830/mysql/slow_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708110830/mysql/slow_log.CSV
-rw-rwx---        8976 2017/03/22 14:30:05 mysql_201708110830/mysql/slow_log.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.MYI
-rw-rw----        8955 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.MYI
-rw-rw----        8636 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.MYI
-rw-rw----        8624 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.MYI
-rw-rw----        8606 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.MYI
-rw-rw----        8686 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.MYI
-rw-rw----        8748 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.frm
-rw-rw----         668 2017/08/01 17:00:06 mysql_201708110830/mysql/user.MYD
-rw-rw----        2048 2017/08/02 08:30:01 mysql_201708110830/mysql/user.MYI
-rw-rw----       10630 2017/03/28 14:54:07 mysql_201708110830/mysql/user.frm
drwxrwx---         868 2017/03/22 14:30:05 mysql_201708110830/performance_schema
-rw-rwx---        8624 2017/03/22 14:30:05 mysql_201708110830/performance_schema/cond_instances.frm
-rw-rwx---          61 2017/03/22 14:30:05 mysql_201708110830/performance_schema/db.opt
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_current.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_history.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_history_long.frm
-rw-rwx---        8878 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_by_instance.frm
-rw-rwx---        8854 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
-rw-rwx---        8814 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_global_by_event_name.frm
-rw-rwx---        8654 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_instances.frm
-rw-rwx---        8800 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_summary_by_event_name.frm
-rw-rwx---        8840 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_summary_by_instance.frm
-rw-rwx---        8684 2017/03/22 14:30:05 mysql_201708110830/performance_schema/mutex_instances.frm
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708110830/performance_schema/performance_timers.frm
-rw-rwx---        8758 2017/03/22 14:30:05 mysql_201708110830/performance_schema/rwlock_instances.frm
-rw-rwx---        8605 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_consumers.frm
-rw-rwx---        8637 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_instruments.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_timers.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708110830/performance_schema/threads.frm
drwx------          12 2017/03/29 13:29:07 mysql_201708110830/test
-rw-rw----          61 2017/03/29 13:11:26 mysql_201708110830/test/db.opt


[root@backuplogC7 ~]# rsync -anc /var/lib/mariadb/mysql_201708120830
drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708120830
-rw-rwx---       16384 2017/08/04 13:08:08 mysql_201708120830/aria_log.00000001
-rw-rwx---          52 2017/08/04 13:08:08 mysql_201708120830/aria_log_control
-rw-rwx---     5242880 2017/08/12 07:30:46 mysql_201708120830/ib_logfile0
-rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708120830/ib_logfile1
-rw-rwx---   706740224 2017/08/12 07:30:46 mysql_201708120830/ibdata1
-rw-rw----         264 2017/03/30 08:40:47 mysql_201708120830/mysql-bin.000001
-rw-rw----          19 2017/03/30 08:38:29 mysql_201708120830/mysql-bin.index
drwx------         644 2017/03/31 09:39:55 mysql_201708120830/backups_db
-rw-rw----          61 2017/03/28 15:14:28 mysql_201708120830/backups_db/db.opt
-rw-rw----        8554 2017/03/28 15:17:54 mysql_201708120830/backups_db/ints.frm
-rw-rw----        8766 2017/03/31 09:14:26 mysql_201708120830/backups_db/tpc_backup_detail.frm
-rw-rw----        8836 2017/03/31 09:25:41 mysql_201708120830/backups_db/tpc_backup_header.frm
-rw-rw----        9020 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_history.frm
-rw-rw----        8730 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_schedule_level_master.frm
-rw-rw----        8774 2017/03/31 09:39:55 mysql_201708120830/backups_db/tpc_backup_schedule_master.frm
-rw-rw----        8774 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_schedule_master_extra.frm
-rw-rw----        8774 2017/03/28 15:18:59 mysql_201708120830/backups_db/tpc_backup_schedule_old.frm
-rw-rw----        8672 2017/03/28 15:18:59 mysql_201708120830/backups_db/tpc_backup_server.frm
-rw-rw----        8888 2017/03/31 09:13:41 mysql_201708120830/backups_db/tpc_backup_step.frm
-rw-rw----        8722 2017/03/28 15:19:10 mysql_201708120830/backups_db/tpc_backup_user.frm
-rw-rw----        1851 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_backup_header_status.frm
-rw-rw----         716 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_calendar.frm
-rw-rw----        1611 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_dup_backup.frm
drwxrwx---        2094 2017/03/28 14:54:08 mysql_201708120830/mysql
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.MYI
-rw-rw----        8820 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.frm
-rw-rw----         440 2017/08/01 17:00:06 mysql_201708120830/mysql/db.MYD
-rw-rw----        5120 2017/08/02 08:30:01 mysql_201708120830/mysql/db.MYI
-rw-rw----        9582 2017/03/28 14:54:06 mysql_201708120830/mysql/db.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/event.MYD
-rw-rw----        2048 2017/03/28 14:54:06 mysql_201708120830/mysql/event.MYI
-rw-rw----       10239 2017/03/28 14:54:06 mysql_201708120830/mysql/event.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/func.MYD
-rw-rw----        1024 2017/03/28 14:54:06 mysql_201708120830/mysql/func.MYI
-rw-rw----        8665 2017/03/28 14:54:06 mysql_201708120830/mysql/func.frm
-rw-rwx---          35 2017/08/12 08:30:01 mysql_201708120830/mysql/general_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708120830/mysql/general_log.CSV
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708120830/mysql/general_log.frm
-rw-rw----        1092 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.MYD
-rw-rw----        3072 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.MYI
-rw-rw----        8700 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.frm
-rw-rw----       91408 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.MYD
-rw-rw----       16384 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.MYI
-rw-rw----        8612 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.frm
-rw-rw----        9252 2017/03/28 14:54:07 mysql_201708120830/mysql/help_relation.MYD
-rw-rw----       17408 2017/03/28 14:54:07 mysql_201708120830/mysql/help_relation.MYI
-rw-rw----        8630 2017/03/28 14:54:06 mysql_201708120830/mysql/help_relation.frm
-rw-rw----      450388 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.MYD
-rw-rw----       20480 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.MYI
-rw-rw----        8770 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/host.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708120830/mysql/host.MYI
-rw-rw----        9510 2017/03/28 14:54:07 mysql_201708120830/mysql/host.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.MYI
-rw-rw----        8778 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.MYI
-rw-rw----        8586 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.MYI
-rw-rw----       10012 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.MYI
-rw-rw----        8875 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.frm
-rw-rw----        1386 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.MYD
-rw-rw----        5120 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.MYI
-rw-rw----        8800 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.MYI
-rw-rw----        8838 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.frm
-rw-rwx---          35 2017/08/12 08:30:01 mysql_201708120830/mysql/slow_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708120830/mysql/slow_log.CSV
-rw-rwx---        8976 2017/03/22 14:30:05 mysql_201708120830/mysql/slow_log.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.MYI
-rw-rw----        8955 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.MYI
-rw-rw----        8636 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.MYI
-rw-rw----        8624 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.MYI
-rw-rw----        8606 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.MYI
-rw-rw----        8686 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.MYI
-rw-rw----        8748 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.frm
-rw-rw----         668 2017/08/01 17:00:06 mysql_201708120830/mysql/user.MYD
-rw-rw----        2048 2017/08/02 08:30:01 mysql_201708120830/mysql/user.MYI
-rw-rw----       10630 2017/03/28 14:54:07 mysql_201708120830/mysql/user.frm
drwxrwx---         868 2017/03/22 14:30:05 mysql_201708120830/performance_schema
-rw-rwx---        8624 2017/03/22 14:30:05 mysql_201708120830/performance_schema/cond_instances.frm
-rw-rwx---          61 2017/03/22 14:30:05 mysql_201708120830/performance_schema/db.opt
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_current.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_history.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_history_long.frm
-rw-rwx---        8878 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_by_instance.frm
-rw-rwx---        8854 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
-rw-rwx---        8814 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_global_by_event_name.frm
-rw-rwx---        8654 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_instances.frm
-rw-rwx---        8800 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_summary_by_event_name.frm
-rw-rwx---        8840 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_summary_by_instance.frm
-rw-rwx---        8684 2017/03/22 14:30:05 mysql_201708120830/performance_schema/mutex_instances.frm
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708120830/performance_schema/performance_timers.frm
-rw-rwx---        8758 2017/03/22 14:30:05 mysql_201708120830/performance_schema/rwlock_instances.frm
-rw-rwx---        8605 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_consumers.frm
-rw-rwx---        8637 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_instruments.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_timers.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708120830/performance_schema/threads.frm
drwx------          12 2017/03/29 13:29:07 mysql_201708120830/test
-rw-rw----          61 2017/03/29 13:11:26 mysql_201708120830/test/db.opt


-----------------
As you request for the real output on screen of source (container B) rsync
----------------- 

tpcorp@virtualtrust3:/tmp$ lxc exec joytest -- bash
[root@joytest ~]# rsync -anc /var/lib/mariadb/mysql_201708110830
drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708110830
-rw-rwx---       16384 2017/08/04 13:08:08 mysql_201708110830/aria_log.00000001
-rw-rwx---          52 2017/08/04 13:08:08 mysql_201708110830/aria_log_control
-rw-rwx---     5242880 2017/08/11 08:29:07 mysql_201708110830/ib_logfile0
-rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708110830/ib_logfile1
-rw-rwx---   706740224 2017/08/11 08:29:07 mysql_201708110830/ibdata1
-rw-rw----         264 2017/03/30 08:40:47 mysql_201708110830/mysql-bin.000001
-rw-rw----          19 2017/03/30 08:38:29 mysql_201708110830/mysql-bin.index
drwx------         644 2017/03/31 09:39:55 mysql_201708110830/backups_db
-rw-rw----          61 2017/03/28 15:14:28 mysql_201708110830/backups_db/db.opt
-rw-rw----        8554 2017/03/28 15:17:54 mysql_201708110830/backups_db/ints.frm
-rw-rw----        8766 2017/03/31 09:14:26 mysql_201708110830/backups_db/tpc_backup_detail.frm
-rw-rw----        8836 2017/03/31 09:25:41 mysql_201708110830/backups_db/tpc_backup_header.frm
-rw-rw----        9020 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_history.frm
-rw-rw----        8730 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_schedule_level_master.frm
-rw-rw----        8774 2017/03/31 09:39:55 mysql_201708110830/backups_db/tpc_backup_schedule_master.frm
-rw-rw----        8774 2017/03/28 15:18:58 mysql_201708110830/backups_db/tpc_backup_schedule_master_extra.frm
-rw-rw----        8774 2017/03/28 15:18:59 mysql_201708110830/backups_db/tpc_backup_schedule_old.frm
-rw-rw----        8672 2017/03/28 15:18:59 mysql_201708110830/backups_db/tpc_backup_server.frm
-rw-rw----        8888 2017/03/31 09:13:41 mysql_201708110830/backups_db/tpc_backup_step.frm
-rw-rw----        8722 2017/03/28 15:19:10 mysql_201708110830/backups_db/tpc_backup_user.frm
-rw-rw----        1851 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_backup_header_status.frm
-rw-rw----         716 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_calendar.frm
-rw-rw----        1611 2017/03/28 15:19:11 mysql_201708110830/backups_db/v_dup_backup.frm
drwxrwx---        2094 2017/03/28 14:54:08 mysql_201708110830/mysql
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.MYI
-rw-rw----        8820 2017/03/28 14:54:06 mysql_201708110830/mysql/columns_priv.frm
-rw-rw----         440 2017/08/01 17:00:06 mysql_201708110830/mysql/db.MYD
-rw-rw----        5120 2017/08/02 08:30:01 mysql_201708110830/mysql/db.MYI
-rw-rw----        9582 2017/03/28 14:54:06 mysql_201708110830/mysql/db.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/event.MYD
-rw-rw----        2048 2017/03/28 14:54:06 mysql_201708110830/mysql/event.MYI
-rw-rw----       10239 2017/03/28 14:54:06 mysql_201708110830/mysql/event.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708110830/mysql/func.MYD
-rw-rw----        1024 2017/03/28 14:54:06 mysql_201708110830/mysql/func.MYI
-rw-rw----        8665 2017/03/28 14:54:06 mysql_201708110830/mysql/func.frm
-rw-rwx---          35 2017/08/11 08:30:01 mysql_201708110830/mysql/general_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708110830/mysql/general_log.CSV
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708110830/mysql/general_log.frm
-rw-rw----        1092 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.MYD
-rw-rw----        3072 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.MYI
-rw-rw----        8700 2017/03/28 14:54:06 mysql_201708110830/mysql/help_category.frm
-rw-rw----       91408 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.MYD
-rw-rw----       16384 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.MYI
-rw-rw----        8612 2017/03/28 14:54:06 mysql_201708110830/mysql/help_keyword.frm
-rw-rw----        9252 2017/03/28 14:54:07 mysql_201708110830/mysql/help_relation.MYD
-rw-rw----       17408 2017/03/28 14:54:07 mysql_201708110830/mysql/help_relation.MYI
-rw-rw----        8630 2017/03/28 14:54:06 mysql_201708110830/mysql/help_relation.frm
-rw-rw----      450388 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.MYD
-rw-rw----       20480 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.MYI
-rw-rw----        8770 2017/03/28 14:54:07 mysql_201708110830/mysql/help_topic.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/host.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708110830/mysql/host.MYI
-rw-rw----        9510 2017/03/28 14:54:07 mysql_201708110830/mysql/host.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.MYI
-rw-rw----        8778 2017/03/28 14:54:07 mysql_201708110830/mysql/ndb_binlog_index.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.MYI
-rw-rw----        8586 2017/03/28 14:54:07 mysql_201708110830/mysql/plugin.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.MYI
-rw-rw----       10012 2017/03/28 14:54:07 mysql_201708110830/mysql/proc.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.MYI
-rw-rw----        8875 2017/03/28 14:54:07 mysql_201708110830/mysql/procs_priv.frm
-rw-rw----        1386 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.MYD
-rw-rw----        5120 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.MYI
-rw-rw----        8800 2017/03/28 14:54:07 mysql_201708110830/mysql/proxies_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.MYI
-rw-rw----        8838 2017/03/28 14:54:07 mysql_201708110830/mysql/servers.frm
-rw-rwx---          35 2017/08/11 08:30:01 mysql_201708110830/mysql/slow_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708110830/mysql/slow_log.CSV
-rw-rwx---        8976 2017/03/22 14:30:05 mysql_201708110830/mysql/slow_log.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.MYI
-rw-rw----        8955 2017/03/28 14:54:07 mysql_201708110830/mysql/tables_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.MYI
-rw-rw----        8636 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.MYI
-rw-rw----        8624 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_leap_second.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.MYI
-rw-rw----        8606 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_name.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.MYI
-rw-rw----        8686 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.MYI
-rw-rw----        8748 2017/03/28 14:54:07 mysql_201708110830/mysql/time_zone_transition_type.frm
-rw-rw----         668 2017/08/01 17:00:06 mysql_201708110830/mysql/user.MYD
-rw-rw----        2048 2017/08/02 08:30:01 mysql_201708110830/mysql/user.MYI
-rw-rw----       10630 2017/03/28 14:54:07 mysql_201708110830/mysql/user.frm
drwxrwx---         868 2017/03/22 14:30:05 mysql_201708110830/performance_schema
-rw-rwx---        8624 2017/03/22 14:30:05 mysql_201708110830/performance_schema/cond_instances.frm
-rw-rwx---          61 2017/03/22 14:30:05 mysql_201708110830/performance_schema/db.opt
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_current.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_history.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_history_long.frm
-rw-rwx---        8878 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_by_instance.frm
-rw-rwx---        8854 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
-rw-rwx---        8814 2017/03/22 14:30:05 mysql_201708110830/performance_schema/events_waits_summary_global_by_event_name.frm
-rw-rwx---        8654 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_instances.frm
-rw-rwx---        8800 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_summary_by_event_name.frm
-rw-rwx---        8840 2017/03/22 14:30:05 mysql_201708110830/performance_schema/file_summary_by_instance.frm
-rw-rwx---        8684 2017/03/22 14:30:05 mysql_201708110830/performance_schema/mutex_instances.frm
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708110830/performance_schema/performance_timers.frm
-rw-rwx---        8758 2017/03/22 14:30:05 mysql_201708110830/performance_schema/rwlock_instances.frm
-rw-rwx---        8605 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_consumers.frm
-rw-rwx---        8637 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_instruments.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708110830/performance_schema/setup_timers.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708110830/performance_schema/threads.frm
drwx------          12 2017/03/29 13:29:07 mysql_201708110830/test
-rw-rw----          61 2017/03/29 13:11:26 mysql_201708110830/test/db.opt

[root@joytest ~]# rsync -anc /var/lib/mariadb/mysql_201708120830
drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708120830
-rw-rwx---       16384 2017/08/04 13:08:08 mysql_201708120830/aria_log.00000001
-rw-rwx---          52 2017/08/04 13:08:08 mysql_201708120830/aria_log_control
-rw-rwx---     5242880 2017/08/12 07:30:46 mysql_201708120830/ib_logfile0
-rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708120830/ib_logfile1
-rw-rwx---   706740224 2017/08/12 07:30:46 mysql_201708120830/ibdata1
-rw-rw----         264 2017/03/30 08:40:47 mysql_201708120830/mysql-bin.000001
-rw-rw----          19 2017/03/30 08:38:29 mysql_201708120830/mysql-bin.index
drwx------         644 2017/03/31 09:39:55 mysql_201708120830/backups_db
-rw-rw----          61 2017/03/28 15:14:28 mysql_201708120830/backups_db/db.opt
-rw-rw----        8554 2017/03/28 15:17:54 mysql_201708120830/backups_db/ints.frm
-rw-rw----        8766 2017/03/31 09:14:26 mysql_201708120830/backups_db/tpc_backup_detail.frm
-rw-rw----        8836 2017/03/31 09:25:41 mysql_201708120830/backups_db/tpc_backup_header.frm
-rw-rw----        9020 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_history.frm
-rw-rw----        8730 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_schedule_level_master.frm
-rw-rw----        8774 2017/03/31 09:39:55 mysql_201708120830/backups_db/tpc_backup_schedule_master.frm
-rw-rw----        8774 2017/03/28 15:18:58 mysql_201708120830/backups_db/tpc_backup_schedule_master_extra.frm
-rw-rw----        8774 2017/03/28 15:18:59 mysql_201708120830/backups_db/tpc_backup_schedule_old.frm
-rw-rw----        8672 2017/03/28 15:18:59 mysql_201708120830/backups_db/tpc_backup_server.frm
-rw-rw----        8888 2017/03/31 09:13:41 mysql_201708120830/backups_db/tpc_backup_step.frm
-rw-rw----        8722 2017/03/28 15:19:10 mysql_201708120830/backups_db/tpc_backup_user.frm
-rw-rw----        1851 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_backup_header_status.frm
-rw-rw----         716 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_calendar.frm
-rw-rw----        1611 2017/03/28 15:19:11 mysql_201708120830/backups_db/v_dup_backup.frm
drwxrwx---        2094 2017/03/28 14:54:08 mysql_201708120830/mysql
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.MYI
-rw-rw----        8820 2017/03/28 14:54:06 mysql_201708120830/mysql/columns_priv.frm
-rw-rw----         440 2017/08/01 17:00:06 mysql_201708120830/mysql/db.MYD
-rw-rw----        5120 2017/08/02 08:30:01 mysql_201708120830/mysql/db.MYI
-rw-rw----        9582 2017/03/28 14:54:06 mysql_201708120830/mysql/db.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/event.MYD
-rw-rw----        2048 2017/03/28 14:54:06 mysql_201708120830/mysql/event.MYI
-rw-rw----       10239 2017/03/28 14:54:06 mysql_201708120830/mysql/event.frm
-rw-rw----           0 2017/03/28 14:54:06 mysql_201708120830/mysql/func.MYD
-rw-rw----        1024 2017/03/28 14:54:06 mysql_201708120830/mysql/func.MYI
-rw-rw----        8665 2017/03/28 14:54:06 mysql_201708120830/mysql/func.frm
-rw-rwx---          35 2017/08/12 08:30:01 mysql_201708120830/mysql/general_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708120830/mysql/general_log.CSV
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708120830/mysql/general_log.frm
-rw-rw----        1092 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.MYD
-rw-rw----        3072 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.MYI
-rw-rw----        8700 2017/03/28 14:54:06 mysql_201708120830/mysql/help_category.frm
-rw-rw----       91408 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.MYD
-rw-rw----       16384 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.MYI
-rw-rw----        8612 2017/03/28 14:54:06 mysql_201708120830/mysql/help_keyword.frm
-rw-rw----        9252 2017/03/28 14:54:07 mysql_201708120830/mysql/help_relation.MYD
-rw-rw----       17408 2017/03/28 14:54:07 mysql_201708120830/mysql/help_relation.MYI
-rw-rw----        8630 2017/03/28 14:54:06 mysql_201708120830/mysql/help_relation.frm
-rw-rw----      450388 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.MYD
-rw-rw----       20480 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.MYI
-rw-rw----        8770 2017/03/28 14:54:07 mysql_201708120830/mysql/help_topic.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/host.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708120830/mysql/host.MYI
-rw-rw----        9510 2017/03/28 14:54:07 mysql_201708120830/mysql/host.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.MYI
-rw-rw----        8778 2017/03/28 14:54:07 mysql_201708120830/mysql/ndb_binlog_index.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.MYI
-rw-rw----        8586 2017/03/28 14:54:07 mysql_201708120830/mysql/plugin.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.MYD
-rw-rw----        2048 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.MYI
-rw-rw----       10012 2017/03/28 14:54:07 mysql_201708120830/mysql/proc.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.MYI
-rw-rw----        8875 2017/03/28 14:54:07 mysql_201708120830/mysql/procs_priv.frm
-rw-rw----        1386 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.MYD
-rw-rw----        5120 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.MYI
-rw-rw----        8800 2017/03/28 14:54:07 mysql_201708120830/mysql/proxies_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.MYI
-rw-rw----        8838 2017/03/28 14:54:07 mysql_201708120830/mysql/servers.frm
-rw-rwx---          35 2017/08/12 08:30:01 mysql_201708120830/mysql/slow_log.CSM
-rw-rwx---           0 2017/03/22 14:30:05 mysql_201708120830/mysql/slow_log.CSV
-rw-rwx---        8976 2017/03/22 14:30:05 mysql_201708120830/mysql/slow_log.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.MYD
-rw-rw----        4096 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.MYI
-rw-rw----        8955 2017/03/28 14:54:07 mysql_201708120830/mysql/tables_priv.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.MYI
-rw-rw----        8636 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.MYI
-rw-rw----        8624 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_leap_second.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.MYI
-rw-rw----        8606 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_name.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.MYI
-rw-rw----        8686 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition.frm
-rw-rw----           0 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.MYD
-rw-rw----        1024 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.MYI
-rw-rw----        8748 2017/03/28 14:54:07 mysql_201708120830/mysql/time_zone_transition_type.frm
-rw-rw----         668 2017/08/01 17:00:06 mysql_201708120830/mysql/user.MYD
-rw-rw----        2048 2017/08/02 08:30:01 mysql_201708120830/mysql/user.MYI
-rw-rw----       10630 2017/03/28 14:54:07 mysql_201708120830/mysql/user.frm
drwxrwx---         868 2017/03/22 14:30:05 mysql_201708120830/performance_schema
-rw-rwx---        8624 2017/03/22 14:30:05 mysql_201708120830/performance_schema/cond_instances.frm
-rw-rwx---          61 2017/03/22 14:30:05 mysql_201708120830/performance_schema/db.opt
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_current.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_history.frm
-rw-rwx---        9220 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_history_long.frm
-rw-rwx---        8878 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_by_instance.frm
-rw-rwx---        8854 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
-rw-rwx---        8814 2017/03/22 14:30:05 mysql_201708120830/performance_schema/events_waits_summary_global_by_event_name.frm
-rw-rwx---        8654 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_instances.frm
-rw-rwx---        8800 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_summary_by_event_name.frm
-rw-rwx---        8840 2017/03/22 14:30:05 mysql_201708120830/performance_schema/file_summary_by_instance.frm
-rw-rwx---        8684 2017/03/22 14:30:05 mysql_201708120830/performance_schema/mutex_instances.frm
-rw-rwx---        8776 2017/03/22 14:30:05 mysql_201708120830/performance_schema/performance_timers.frm
-rw-rwx---        8758 2017/03/22 14:30:05 mysql_201708120830/performance_schema/rwlock_instances.frm
-rw-rwx---        8605 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_consumers.frm
-rw-rwx---        8637 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_instruments.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708120830/performance_schema/setup_timers.frm
-rw-rwx---        8650 2017/03/22 14:30:05 mysql_201708120830/performance_schema/threads.frm
drwx------          12 2017/03/29 13:29:07 mysql_201708120830/test
-rw-rw----          61 2017/03/29 13:11:26 mysql_201708120830/test/db.opt

 


------=_20170812093854_48916--


