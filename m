Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:53507 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752390AbdHMCUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 22:20:07 -0400
Message-ID: <6341.49.228.122.75.1502590802.squirrel@mail>
In-Reply-To: <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
    <22169.183.88.87.49.1502260598.squirrel@mail>
    <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
    <27218.183.88.87.49.1502426431.squirrel@mail>
    <13031.192.168.42.222.1502431206.squirrel@mail>
    <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
    <1243.49.228.123.163.1502505534.squirrel@mail>
    <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
    <1420.49.228.123.163.1502514511.squirrel@mail>
    <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
Date: Sun, 13 Aug 2017 09:20:02 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Chris Murphy" <lists@colorremedies.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I did as you suggest and the result was bad then I decided to start over with
snapshot mysql_201708070830 and manually send incremental the result rsync always
said "a log diff" but the dest can start mariadb until snapshot "mysql_201708100830"
it couldn't start mariadb.

The following are the result.

- delete all the bad/mismatching snapshots only on the destination computer.
tpcorp@virtualtrust3:~$ lxc exec joytest -- bash
[root@joytest ~]# btrfs sub list /var/lib/mariadb
ID 298 gen 177 top level 5 path mysql_201708070830
ID 301 gen 148 top level 5 path mysql_201708080830
ID 303 gen 156 top level 5 path mysql_201708090830
ID 305 gen 162 top level 5 path mysql_201708100830
ID 309 gen 175 top level 5 path mysql_201708110830
ID 310 gen 176 top level 5 path mysql
ID 311 gen 180 top level 5 path mysql_201708120830
[root@joytest ~]# cd /var/lib/mariadb
[root@joytest mariadb]# btrfs sub list .
ID 298 gen 177 top level 5 path mysql_201708070830
ID 301 gen 148 top level 5 path mysql_201708080830
ID 303 gen 156 top level 5 path mysql_201708090830
ID 305 gen 162 top level 5 path mysql_201708100830
ID 309 gen 175 top level 5 path mysql_201708110830
ID 310 gen 176 top level 5 path mysql
ID 311 gen 180 top level 5 path mysql_201708120830
[root@joytest mariadb]# btrfs sub del mysql_201708090830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708090830'
[root@joytest mariadb]# btrfs sub del mysql_201708100830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708100830'
[root@joytest mariadb]# btrfs sub del mysql_201708110830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708110830'
[root@joytest mariadb]# btrfs sub del mysql_201708120830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708120830'
[root@joytest mariadb]# btrfs sub sync .

- The most recent good snapshot pair, which rsync shows origin and
destination match, is mysql_201708080830 so you can keep that one on
both sides.
[root@joytest mariadb]# btrfs sub list .
ID 298 gen 177 top level 5 path mysql_201708070830
ID 301 gen 148 top level 5 path mysql_201708080830
ID 310 gen 176 top level 5 path mysql

- manually do incremental send/receive, starting with
mysql_201708090830/, to make the destination current again with the
origin.

tpcorp@virtualtrust3:~$ lxc exec backuplogC7 -- bash
[root@backuplogC7 ~]# btrfs sub list /var/lib/mariadb
ID 257 gen 537 top level 5 path mysql
ID 316 gen 498 top level 5 path mysql_201708060830
ID 317 gen 503 top level 5 path mysql_201708070830
ID 318 gen 507 top level 5 path mysql_201708080830
ID 319 gen 514 top level 5 path mysql_201708090830
ID 320 gen 524 top level 5 path mysql_201708100830
ID 321 gen 529 top level 5 path mysql_201708110830
ID 322 gen 533 top level 5 path mysql_201708120830


[root@backuplogC7 ~]# more /var/log/btrfs_send.log
Start Send 201708040905
btrfs send -p /var/lib/mariadb/mysql_201708030830
/var/lib/mariadb/mysql_201708040830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708040830
Stop Send 201708040905
Start Send 201708050905
btrfs send -p /var/lib/mariadb/mysql_201708040830
/var/lib/mariadb/mysql_201708050830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708050830
Stop Send 201708050905
Start Send 201708060905
btrfs send -p /var/lib/mariadb/mysql_201708050830
/var/lib/mariadb/mysql_201708060830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708060830
Stop Send 201708060905
Start Send 201708070905
btrfs send -p /var/lib/mariadb/mysql_201708060830
/var/lib/mariadb/mysql_201708070830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708070830
Stop Send 201708070905
Start Send 201708080905
btrfs send -p /var/lib/mariadb/mysql_201708070830
/var/lib/mariadb/mysql_201708080830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708080830
Stop Send 201708080905
Start Send 201708090905
btrfs send -p /var/lib/mariadb/mysql_201708080830
/var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708090830
Stop Send 201708090905
Start Send 201708100905
btrfs send -p /var/lib/mariadb/mysql_201708090830
/var/lib/mariadb/mysql_201708100830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708100830
Stop Send 201708100905
Start Send 201708110905
btrfs send -p /var/lib/mariadb/mysql_201708100830
/var/lib/mariadb/mysql_201708110830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708110830
Stop Send 201708110905
Start Send 201708120905
btrfs send -p /var/lib/mariadb/mysql_201708110830
/var/lib/mariadb/mysql_201708120830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708120830
Stop Send 201708120905
[root@backuplogC7 ~]# btrfs send -p /var/lib/mariadb/mysql_201708080830
/var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708090830
At snapshot mysql_201708090830
[root@backuplogC7 ~]# history|grep rsync
  416  rsync
  417  yum install rsync
  424  rsync -anc mysql_201708110830 > /tmp/source_mysql_201708110830.txt
  433  history|grep rsync
  434  rsync -anc mysql_201708100830 > /tmp/source_mysql_201708100830.txt
  435  rsync -anc /var/lib/mariadb/mysql_201708100830 >
/tmp/source_mysql_201708100830.txt
  442  history|grep rsync
  443  rsync -anc /var/lib/mariadb/mysql_201708090830 >
/tmp/source_mysql_201708090830.txt
  444  rsync -anc /var/lib/mariadb/mysql_201708080830 >
/tmp/source_mysql_201708080830.txt
  445  rsync -anc /var/lib/mariadb/mysql_201708070830 >
/tmp/source_mysql_201708070830.txt
  486  history|grep rsync
  495  history|grep rsync
  496  rsync -anc /var/lib/mariadb/mysql_201708120830 >
/tmp/source_mysql_201708120830.txt
  498  rsync -anc /var/lib/mariadb/mysql_201708120830
  499  rsync -anc /var/lib/mariadb/mysql_201708110830
  504  history|grep rsync
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830
root@192.168.45.166://var/lib/mariadb/mysql_201708090830
sending incremental file list
mysql_201708090830/
mysql_201708090830/aria_log.00000001
mysql_201708090830/aria_log_control
mysql_201708090830/ib_logfile0
mysql_201708090830/ib_logfile1
mysql_201708090830/ibdata1
mysql_201708090830/mysql-bin.000001
mysql_201708090830/mysql-bin.index
mysql_201708090830/backups_db/
mysql_201708090830/backups_db/db.opt
mysql_201708090830/backups_db/ints.frm
mysql_201708090830/backups_db/tpc_backup_detail.frm
mysql_201708090830/backups_db/tpc_backup_header.frm
mysql_201708090830/backups_db/tpc_backup_history.frm
mysql_201708090830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708090830/backups_db/tpc_backup_schedule_master.frm
mysql_201708090830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708090830/backups_db/tpc_backup_schedule_old.frm
mysql_201708090830/backups_db/tpc_backup_server.frm
mysql_201708090830/backups_db/tpc_backup_step.frm
mysql_201708090830/backups_db/tpc_backup_user.frm
mysql_201708090830/backups_db/v_backup_header_status.frm
mysql_201708090830/backups_db/v_calendar.frm
mysql_201708090830/backups_db/v_dup_backup.frm
mysql_201708090830/mysql/
mysql_201708090830/mysql/columns_priv.MYD
mysql_201708090830/mysql/columns_priv.MYI
mysql_201708090830/mysql/columns_priv.frm
mysql_201708090830/mysql/db.MYD
mysql_201708090830/mysql/db.MYI
mysql_201708090830/mysql/db.frm
mysql_201708090830/mysql/event.MYD
mysql_201708090830/mysql/event.MYI
mysql_201708090830/mysql/event.frm
mysql_201708090830/mysql/func.MYD
mysql_201708090830/mysql/func.MYI
mysql_201708090830/mysql/func.frm
mysql_201708090830/mysql/general_log.CSM
mysql_201708090830/mysql/general_log.CSV
mysql_201708090830/mysql/general_log.frm
mysql_201708090830/mysql/help_category.MYD
mysql_201708090830/mysql/help_category.MYI
mysql_201708090830/mysql/help_category.frm
mysql_201708090830/mysql/help_keyword.MYD
mysql_201708090830/mysql/help_keyword.MYI
mysql_201708090830/mysql/help_keyword.frm
mysql_201708090830/mysql/help_relation.MYD
mysql_201708090830/mysql/help_relation.MYI
mysql_201708090830/mysql/help_relation.frm
mysql_201708090830/mysql/help_topic.MYD
mysql_201708090830/mysql/help_topic.MYI
mysql_201708090830/mysql/help_topic.frm
mysql_201708090830/mysql/host.MYD
mysql_201708090830/mysql/host.MYI
mysql_201708090830/mysql/host.frm
mysql_201708090830/mysql/ndb_binlog_index.MYD
mysql_201708090830/mysql/ndb_binlog_index.MYI
mysql_201708090830/mysql/ndb_binlog_index.frm
mysql_201708090830/mysql/plugin.MYD
mysql_201708090830/mysql/plugin.MYI
mysql_201708090830/mysql/plugin.frm
mysql_201708090830/mysql/proc.MYD
mysql_201708090830/mysql/proc.MYI
mysql_201708090830/mysql/proc.frm
mysql_201708090830/mysql/procs_priv.MYD
mysql_201708090830/mysql/procs_priv.MYI
mysql_201708090830/mysql/procs_priv.frm
mysql_201708090830/mysql/proxies_priv.MYD
mysql_201708090830/mysql/proxies_priv.MYI
mysql_201708090830/mysql/proxies_priv.frm
mysql_201708090830/mysql/servers.MYD
mysql_201708090830/mysql/servers.MYI
mysql_201708090830/mysql/servers.frm
mysql_201708090830/mysql/slow_log.CSM
mysql_201708090830/mysql/slow_log.CSV
mysql_201708090830/mysql/slow_log.frm
mysql_201708090830/mysql/tables_priv.MYD
mysql_201708090830/mysql/tables_priv.MYI
mysql_201708090830/mysql/tables_priv.frm
mysql_201708090830/mysql/time_zone.MYD
mysql_201708090830/mysql/time_zone.MYI
mysql_201708090830/mysql/time_zone.frm
mysql_201708090830/mysql/time_zone_leap_second.MYD
mysql_201708090830/mysql/time_zone_leap_second.MYI
mysql_201708090830/mysql/time_zone_leap_second.frm
mysql_201708090830/mysql/time_zone_name.MYD
mysql_201708090830/mysql/time_zone_name.MYI
mysql_201708090830/mysql/time_zone_name.frm
mysql_201708090830/mysql/time_zone_transition.MYD
mysql_201708090830/mysql/time_zone_transition.MYI
mysql_201708090830/mysql/time_zone_transition.frm
mysql_201708090830/mysql/time_zone_transition_type.MYD
mysql_201708090830/mysql/time_zone_transition_type.MYI
mysql_201708090830/mysql/time_zone_transition_type.frm
mysql_201708090830/mysql/user.MYD
mysql_201708090830/mysql/user.MYI
mysql_201708090830/mysql/user.frm
mysql_201708090830/performance_schema/
mysql_201708090830/performance_schema/cond_instances.frm
mysql_201708090830/performance_schema/db.opt
mysql_201708090830/performance_schema/events_waits_current.frm
mysql_201708090830/performance_schema/events_waits_history.frm
mysql_201708090830/performance_schema/events_waits_history_long.frm
mysql_201708090830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708090830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708090830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708090830/performance_schema/file_instances.frm
mysql_201708090830/performance_schema/file_summary_by_event_name.frm
mysql_201708090830/performance_schema/file_summary_by_instance.frm
mysql_201708090830/performance_schema/mutex_instances.frm
mysql_201708090830/performance_schema/performance_timers.frm
mysql_201708090830/performance_schema/rwlock_instances.frm
mysql_201708090830/performance_schema/setup_consumers.frm
mysql_201708090830/performance_schema/setup_instruments.frm
mysql_201708090830/performance_schema/setup_timers.frm
mysql_201708090830/performance_schema/threads.frm
mysql_201708090830/test/
mysql_201708090830/test/db.opt

sent 4157 bytes  received 371 bytes  1811.20 bytes/sec
total size is 718361496  speedup is 158648.74 (DRY RUN)
[root@backuplogC7 ~]#

[root@joytest mariadb]# btrfs sub list .
ID 298 gen 182 top level 5 path mysql_201708070830
ID 301 gen 148 top level 5 path mysql_201708080830
ID 310 gen 176 top level 5 path mysql
ID 312 gen 185 top level 5 path mysql_201708090830

- now resume using the modified script, which will do snapshot -> sync -> send.

[root@backuplogC7 ~]# more /etc/crontab
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

30 08 * * * root /root/script/backup/backupsnap.sh root password
/var/lib/mariadb/mysql >> /var/log/btrfs_snap.log
05 09 * * * root /root/script/backupbtrfs_inc.sh /var/lib/mariadb 192.168.45.166
/var/lib/mariadb >> /var/log/btrfs_send.log
0 19 * * * root /root/script/backup/doBackup_file_backuplog.sh
30 19 * * * root /root/script/delete_btrfs_sub_snap_volume.sh /var/lib/mariadb 7 >>
/var/log/btrfs_del.log

# temp
##00 09 * * * root /root/script/backupbtrfs_all.sh /var/lib/mariadb /backupbtrfs
mysql_201707210830

[root@backuplogC7 ~]# vi /root/script/backup/backupsnap.sh
[root@backuplogC7 ~]# ls -l /root/script/backup/backupsnap.sh
-rwxr--r-- 1 root root 314 Aug 13 08:12 /root/script/backup/backupsnap.sh
[root@backuplogC7 ~]# cat /root/script/backup/backupsnap.sh
#Backup
#
user=$1
password=$2
basepath=$3
datet=$(date +%Y%m%d%H%M)
snappath=${basepath}_${datet}
echo "Locking databases ${datet}"
mysql -u$user -p$password << EOF
FLUSH TABLES WITH READ LOCK;
system btrfs sub snap -r $basepath $snappath
system sync
UNLOCK TABLES;
quit
EOF
echo "Databases unlocked ${datet}"

[root@backuplogC7 ~]#

[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708080830 
root@192.168.45.166://var/lib/mariadb/mysql_201708080830
sending incremental file list
mysql_201708080830/
mysql_201708080830/aria_log.00000001
mysql_201708080830/aria_log_control
mysql_201708080830/ib_logfile0
mysql_201708080830/ib_logfile1
mysql_201708080830/ibdata1
mysql_201708080830/mysql-bin.000001
mysql_201708080830/mysql-bin.index
mysql_201708080830/backups_db/
mysql_201708080830/backups_db/db.opt
mysql_201708080830/backups_db/ints.frm
mysql_201708080830/backups_db/tpc_backup_detail.frm
mysql_201708080830/backups_db/tpc_backup_header.frm
mysql_201708080830/backups_db/tpc_backup_history.frm
mysql_201708080830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708080830/backups_db/tpc_backup_schedule_master.frm
mysql_201708080830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708080830/backups_db/tpc_backup_schedule_old.frm
mysql_201708080830/backups_db/tpc_backup_server.frm
mysql_201708080830/backups_db/tpc_backup_step.frm
mysql_201708080830/backups_db/tpc_backup_user.frm
mysql_201708080830/backups_db/v_backup_header_status.frm
mysql_201708080830/backups_db/v_calendar.frm
mysql_201708080830/backups_db/v_dup_backup.frm
mysql_201708080830/mysql/
mysql_201708080830/mysql/columns_priv.MYD
mysql_201708080830/mysql/columns_priv.MYI
mysql_201708080830/mysql/columns_priv.frm
mysql_201708080830/mysql/db.MYD
mysql_201708080830/mysql/db.MYI
mysql_201708080830/mysql/db.frm
mysql_201708080830/mysql/event.MYD
mysql_201708080830/mysql/event.MYI
mysql_201708080830/mysql/event.frm
mysql_201708080830/mysql/func.MYD
mysql_201708080830/mysql/func.MYI
mysql_201708080830/mysql/func.frm
mysql_201708080830/mysql/general_log.CSM
mysql_201708080830/mysql/general_log.CSV
mysql_201708080830/mysql/general_log.frm
mysql_201708080830/mysql/help_category.MYD
mysql_201708080830/mysql/help_category.MYI
mysql_201708080830/mysql/help_category.frm
mysql_201708080830/mysql/help_keyword.MYD
mysql_201708080830/mysql/help_keyword.MYI
mysql_201708080830/mysql/help_keyword.frm
mysql_201708080830/mysql/help_relation.MYD
mysql_201708080830/mysql/help_relation.MYI
mysql_201708080830/mysql/help_relation.frm
mysql_201708080830/mysql/help_topic.MYD
mysql_201708080830/mysql/help_topic.MYI
mysql_201708080830/mysql/help_topic.frm
mysql_201708080830/mysql/host.MYD
mysql_201708080830/mysql/host.MYI
mysql_201708080830/mysql/host.frm
mysql_201708080830/mysql/ndb_binlog_index.MYD
mysql_201708080830/mysql/ndb_binlog_index.MYI
mysql_201708080830/mysql/ndb_binlog_index.frm
mysql_201708080830/mysql/plugin.MYD
mysql_201708080830/mysql/plugin.MYI
mysql_201708080830/mysql/plugin.frm
mysql_201708080830/mysql/proc.MYD
mysql_201708080830/mysql/proc.MYI
mysql_201708080830/mysql/proc.frm
mysql_201708080830/mysql/procs_priv.MYD
mysql_201708080830/mysql/procs_priv.MYI
mysql_201708080830/mysql/procs_priv.frm
mysql_201708080830/mysql/proxies_priv.MYD
mysql_201708080830/mysql/proxies_priv.MYI
mysql_201708080830/mysql/proxies_priv.frm
mysql_201708080830/mysql/servers.MYD
mysql_201708080830/mysql/servers.MYI
mysql_201708080830/mysql/servers.frm
mysql_201708080830/mysql/slow_log.CSM
mysql_201708080830/mysql/slow_log.CSV
mysql_201708080830/mysql/slow_log.frm
mysql_201708080830/mysql/tables_priv.MYD
mysql_201708080830/mysql/tables_priv.MYI
mysql_201708080830/mysql/tables_priv.frm
mysql_201708080830/mysql/time_zone.MYD
mysql_201708080830/mysql/time_zone.MYI
mysql_201708080830/mysql/time_zone.frm
mysql_201708080830/mysql/time_zone_leap_second.MYD
mysql_201708080830/mysql/time_zone_leap_second.MYI
mysql_201708080830/mysql/time_zone_leap_second.frm
mysql_201708080830/mysql/time_zone_name.MYD
mysql_201708080830/mysql/time_zone_name.MYI
mysql_201708080830/mysql/time_zone_name.frm
mysql_201708080830/mysql/time_zone_transition.MYD
mysql_201708080830/mysql/time_zone_transition.MYI
mysql_201708080830/mysql/time_zone_transition.frm
mysql_201708080830/mysql/time_zone_transition_type.MYD
mysql_201708080830/mysql/time_zone_transition_type.MYI
mysql_201708080830/mysql/time_zone_transition_type.frm
mysql_201708080830/mysql/user.MYD
mysql_201708080830/mysql/user.MYI
mysql_201708080830/mysql/user.frm
mysql_201708080830/performance_schema/
mysql_201708080830/performance_schema/cond_instances.frm
mysql_201708080830/performance_schema/db.opt
mysql_201708080830/performance_schema/events_waits_current.frm
mysql_201708080830/performance_schema/events_waits_history.frm
mysql_201708080830/performance_schema/events_waits_history_long.frm
mysql_201708080830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708080830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708080830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708080830/performance_schema/file_instances.frm
mysql_201708080830/performance_schema/file_summary_by_event_name.frm
mysql_201708080830/performance_schema/file_summary_by_instance.frm
mysql_201708080830/performance_schema/mutex_instances.frm
mysql_201708080830/performance_schema/performance_timers.frm
mysql_201708080830/performance_schema/rwlock_instances.frm
mysql_201708080830/performance_schema/setup_consumers.frm
mysql_201708080830/performance_schema/setup_instruments.frm
mysql_201708080830/performance_schema/setup_timers.frm
mysql_201708080830/performance_schema/threads.frm
mysql_201708080830/test/
mysql_201708080830/test/db.opt

sent 4153 bytes  received 371 bytes  1809.60 bytes/sec
total size is 718361496  speedup is 158789.01 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830 
root@192.168.45.166://var/lib/mariadb/mysql_201708070830
sending incremental file list
mysql_201708070830/
mysql_201708070830/aria_log.00000001
mysql_201708070830/aria_log_control
mysql_201708070830/ib_logfile0
mysql_201708070830/ib_logfile1
mysql_201708070830/ibdata1
mysql_201708070830/mysql-bin.000001
mysql_201708070830/mysql-bin.index
mysql_201708070830/backups_db/
mysql_201708070830/backups_db/db.opt
mysql_201708070830/backups_db/ints.frm
mysql_201708070830/backups_db/tpc_backup_detail.frm
mysql_201708070830/backups_db/tpc_backup_header.frm
mysql_201708070830/backups_db/tpc_backup_history.frm
mysql_201708070830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708070830/backups_db/tpc_backup_schedule_master.frm
mysql_201708070830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708070830/backups_db/tpc_backup_schedule_old.frm
mysql_201708070830/backups_db/tpc_backup_server.frm
mysql_201708070830/backups_db/tpc_backup_step.frm
mysql_201708070830/backups_db/tpc_backup_user.frm
mysql_201708070830/backups_db/v_backup_header_status.frm
mysql_201708070830/backups_db/v_calendar.frm
mysql_201708070830/backups_db/v_dup_backup.frm
mysql_201708070830/mysql/
mysql_201708070830/mysql/columns_priv.MYD
mysql_201708070830/mysql/columns_priv.MYI
mysql_201708070830/mysql/columns_priv.frm
mysql_201708070830/mysql/db.MYD
mysql_201708070830/mysql/db.MYI
mysql_201708070830/mysql/db.frm
mysql_201708070830/mysql/event.MYD
mysql_201708070830/mysql/event.MYI
mysql_201708070830/mysql/event.frm
mysql_201708070830/mysql/func.MYD
mysql_201708070830/mysql/func.MYI
mysql_201708070830/mysql/func.frm
mysql_201708070830/mysql/general_log.CSM
mysql_201708070830/mysql/general_log.CSV
mysql_201708070830/mysql/general_log.frm
mysql_201708070830/mysql/help_category.MYD
mysql_201708070830/mysql/help_category.MYI
mysql_201708070830/mysql/help_category.frm
mysql_201708070830/mysql/help_keyword.MYD
mysql_201708070830/mysql/help_keyword.MYI
mysql_201708070830/mysql/help_keyword.frm
mysql_201708070830/mysql/help_relation.MYD
mysql_201708070830/mysql/help_relation.MYI
mysql_201708070830/mysql/help_relation.frm
mysql_201708070830/mysql/help_topic.MYD
mysql_201708070830/mysql/help_topic.MYI
mysql_201708070830/mysql/help_topic.frm
mysql_201708070830/mysql/host.MYD
mysql_201708070830/mysql/host.MYI
mysql_201708070830/mysql/host.frm
mysql_201708070830/mysql/ndb_binlog_index.MYD
mysql_201708070830/mysql/ndb_binlog_index.MYI
mysql_201708070830/mysql/ndb_binlog_index.frm
mysql_201708070830/mysql/plugin.MYD
mysql_201708070830/mysql/plugin.MYI
mysql_201708070830/mysql/plugin.frm
mysql_201708070830/mysql/proc.MYD
mysql_201708070830/mysql/proc.MYI
mysql_201708070830/mysql/proc.frm
mysql_201708070830/mysql/procs_priv.MYD
mysql_201708070830/mysql/procs_priv.MYI
mysql_201708070830/mysql/procs_priv.frm
mysql_201708070830/mysql/proxies_priv.MYD
mysql_201708070830/mysql/proxies_priv.MYI
mysql_201708070830/mysql/proxies_priv.frm
mysql_201708070830/mysql/servers.MYD
mysql_201708070830/mysql/servers.MYI
mysql_201708070830/mysql/servers.frm
mysql_201708070830/mysql/slow_log.CSM
mysql_201708070830/mysql/slow_log.CSV
mysql_201708070830/mysql/slow_log.frm
mysql_201708070830/mysql/tables_priv.MYD
mysql_201708070830/mysql/tables_priv.MYI
mysql_201708070830/mysql/tables_priv.frm
mysql_201708070830/mysql/time_zone.MYD
mysql_201708070830/mysql/time_zone.MYI
mysql_201708070830/mysql/time_zone.frm
mysql_201708070830/mysql/time_zone_leap_second.MYD
mysql_201708070830/mysql/time_zone_leap_second.MYI
mysql_201708070830/mysql/time_zone_leap_second.frm
mysql_201708070830/mysql/time_zone_name.MYD
mysql_201708070830/mysql/time_zone_name.MYI
mysql_201708070830/mysql/time_zone_name.frm
mysql_201708070830/mysql/time_zone_transition.MYD
mysql_201708070830/mysql/time_zone_transition.MYI
mysql_201708070830/mysql/time_zone_transition.frm
mysql_201708070830/mysql/time_zone_transition_type.MYD
mysql_201708070830/mysql/time_zone_transition_type.MYI
mysql_201708070830/mysql/time_zone_transition_type.frm
mysql_201708070830/mysql/user.MYD
mysql_201708070830/mysql/user.MYI
mysql_201708070830/mysql/user.frm
mysql_201708070830/performance_schema/
mysql_201708070830/performance_schema/cond_instances.frm
mysql_201708070830/performance_schema/db.opt
mysql_201708070830/performance_schema/events_waits_current.frm
mysql_201708070830/performance_schema/events_waits_history.frm
mysql_201708070830/performance_schema/events_waits_history_long.frm
mysql_201708070830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708070830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708070830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708070830/performance_schema/file_instances.frm
mysql_201708070830/performance_schema/file_summary_by_event_name.frm
mysql_201708070830/performance_schema/file_summary_by_instance.frm
mysql_201708070830/performance_schema/mutex_instances.frm
mysql_201708070830/performance_schema/performance_timers.frm
mysql_201708070830/performance_schema/rwlock_instances.frm
mysql_201708070830/performance_schema/setup_consumers.frm
mysql_201708070830/performance_schema/setup_instruments.frm
mysql_201708070830/performance_schema/setup_timers.frm
mysql_201708070830/performance_schema/threads.frm
mysql_201708070830/test/
mysql_201708070830/test/db.opt

sent 4157 bytes  received 371 bytes  1811.20 bytes/sec
total size is 718361496  speedup is 158648.74 (DRY RUN)
[root@backuplogC7 ~]#

- I decide to start with new send "mysql_201708070830"
[root@joytest mariadb]# btrfs sub del mysql*
Delete subvolume (no-commit): '/var/lib/mariadb/mysql'
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708070830'
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708080830'
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708090830'
[root@joytest mariadb]# btrfs sub sync .
^C
[root@joytest mariadb]# systemctl status mariadb
&#226;— mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset:
disabled)
   Active: failed (Result: exit-code) since Fri 2017-08-11 14:00:20 ICT; 1 day 18h ago
  Process: 15671 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID
(code=exited, status=1/FAILURE)
  Process: 15670 ExecStart=/usr/bin/mysqld_safe --basedir=/usr (code=exited,
status=0/SUCCESS)
  Process: 15642 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n (code=exited,
status=0/SUCCESS)
 Main PID: 15670 (code=exited, status=0/SUCCESS)

Aug 11 14:00:19 joytest systemd[1]: Starting MariaDB database server...
Aug 11 14:00:19 joytest mysqld_safe[15670]: 170811 14:00:19 mysqld_safe Logging to
'/var/log/mariadb/mariadb.log'.
Aug 11 14:00:19 joytest mysqld_safe[15670]: 170811 14:00:19 mysqld_safe Starting
mysqld daemon with databases from /var/lib/mariadb/mysql
Aug 11 14:00:20 joytest systemd[1]: mariadb.service: control process exited,
code=exited status=1
Aug 11 14:00:20 joytest systemd[1]: Failed to start MariaDB database server.
Aug 11 14:00:20 joytest systemd[1]: Unit mariadb.service entered failed state.
Aug 11 14:00:20 joytest systemd[1]: mariadb.service failed.
[root@joytest mariadb]# btrfs sub sync .
[root@joytest mariadb]# btrfs sub list .

[root@backuplogC7 ~]# btrfs send /var/lib/mariadb/mysql_201708070830 | ssh
192.168.45.166 btrfs receive /var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708070830
At subvol mysql_201708070830
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830 
root@192.168.45.166://var/lib/mariadb/mysql_201708070830
sending incremental file list
mysql_201708070830/
mysql_201708070830/aria_log.00000001
mysql_201708070830/aria_log_control
mysql_201708070830/ib_logfile0
mysql_201708070830/ib_logfile1
mysql_201708070830/ibdata1
mysql_201708070830/mysql-bin.000001
mysql_201708070830/mysql-bin.index
mysql_201708070830/backups_db/
mysql_201708070830/backups_db/db.opt
mysql_201708070830/backups_db/ints.frm
mysql_201708070830/backups_db/tpc_backup_detail.frm
mysql_201708070830/backups_db/tpc_backup_header.frm
mysql_201708070830/backups_db/tpc_backup_history.frm
mysql_201708070830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708070830/backups_db/tpc_backup_schedule_master.frm
mysql_201708070830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708070830/backups_db/tpc_backup_schedule_old.frm
mysql_201708070830/backups_db/tpc_backup_server.frm
mysql_201708070830/backups_db/tpc_backup_step.frm
mysql_201708070830/backups_db/tpc_backup_user.frm
mysql_201708070830/backups_db/v_backup_header_status.frm
mysql_201708070830/backups_db/v_calendar.frm
mysql_201708070830/backups_db/v_dup_backup.frm
mysql_201708070830/mysql/
mysql_201708070830/mysql/columns_priv.MYD
mysql_201708070830/mysql/columns_priv.MYI
mysql_201708070830/mysql/columns_priv.frm
mysql_201708070830/mysql/db.MYD
mysql_201708070830/mysql/db.MYI
mysql_201708070830/mysql/db.frm
mysql_201708070830/mysql/event.MYD
mysql_201708070830/mysql/event.MYI
mysql_201708070830/mysql/event.frm
mysql_201708070830/mysql/func.MYD
mysql_201708070830/mysql/func.MYI
mysql_201708070830/mysql/func.frm
mysql_201708070830/mysql/general_log.CSM
mysql_201708070830/mysql/general_log.CSV
mysql_201708070830/mysql/general_log.frm
mysql_201708070830/mysql/help_category.MYD
mysql_201708070830/mysql/help_category.MYI
mysql_201708070830/mysql/help_category.frm
mysql_201708070830/mysql/help_keyword.MYD
mysql_201708070830/mysql/help_keyword.MYI
mysql_201708070830/mysql/help_keyword.frm
mysql_201708070830/mysql/help_relation.MYD
mysql_201708070830/mysql/help_relation.MYI
mysql_201708070830/mysql/help_relation.frm
mysql_201708070830/mysql/help_topic.MYD
mysql_201708070830/mysql/help_topic.MYI
mysql_201708070830/mysql/help_topic.frm
mysql_201708070830/mysql/host.MYD
mysql_201708070830/mysql/host.MYI
mysql_201708070830/mysql/host.frm
mysql_201708070830/mysql/ndb_binlog_index.MYD
mysql_201708070830/mysql/ndb_binlog_index.MYI
mysql_201708070830/mysql/ndb_binlog_index.frm
mysql_201708070830/mysql/plugin.MYD
mysql_201708070830/mysql/plugin.MYI
mysql_201708070830/mysql/plugin.frm
mysql_201708070830/mysql/proc.MYD
mysql_201708070830/mysql/proc.MYI
mysql_201708070830/mysql/proc.frm
mysql_201708070830/mysql/procs_priv.MYD
mysql_201708070830/mysql/procs_priv.MYI
mysql_201708070830/mysql/procs_priv.frm
mysql_201708070830/mysql/proxies_priv.MYD
mysql_201708070830/mysql/proxies_priv.MYI
mysql_201708070830/mysql/proxies_priv.frm
mysql_201708070830/mysql/servers.MYD
mysql_201708070830/mysql/servers.MYI
mysql_201708070830/mysql/servers.frm
mysql_201708070830/mysql/slow_log.CSM
mysql_201708070830/mysql/slow_log.CSV
mysql_201708070830/mysql/slow_log.frm
mysql_201708070830/mysql/tables_priv.MYD
mysql_201708070830/mysql/tables_priv.MYI
mysql_201708070830/mysql/tables_priv.frm
mysql_201708070830/mysql/time_zone.MYD
mysql_201708070830/mysql/time_zone.MYI
mysql_201708070830/mysql/time_zone.frm
mysql_201708070830/mysql/time_zone_leap_second.MYD
mysql_201708070830/mysql/time_zone_leap_second.MYI
mysql_201708070830/mysql/time_zone_leap_second.frm
mysql_201708070830/mysql/time_zone_name.MYD
mysql_201708070830/mysql/time_zone_name.MYI
mysql_201708070830/mysql/time_zone_name.frm
mysql_201708070830/mysql/time_zone_transition.MYD
mysql_201708070830/mysql/time_zone_transition.MYI
mysql_201708070830/mysql/time_zone_transition.frm
mysql_201708070830/mysql/time_zone_transition_type.MYD
mysql_201708070830/mysql/time_zone_transition_type.MYI
mysql_201708070830/mysql/time_zone_transition_type.frm
mysql_201708070830/mysql/user.MYD
mysql_201708070830/mysql/user.MYI
mysql_201708070830/mysql/user.frm
mysql_201708070830/performance_schema/
mysql_201708070830/performance_schema/cond_instances.frm
mysql_201708070830/performance_schema/db.opt
mysql_201708070830/performance_schema/events_waits_current.frm
mysql_201708070830/performance_schema/events_waits_history.frm
mysql_201708070830/performance_schema/events_waits_history_long.frm
mysql_201708070830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708070830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708070830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708070830/performance_schema/file_instances.frm
mysql_201708070830/performance_schema/file_summary_by_event_name.frm
mysql_201708070830/performance_schema/file_summary_by_instance.frm
mysql_201708070830/performance_schema/mutex_instances.frm
mysql_201708070830/performance_schema/performance_timers.frm
mysql_201708070830/performance_schema/rwlock_instances.frm
mysql_201708070830/performance_schema/setup_consumers.frm
mysql_201708070830/performance_schema/setup_instruments.frm
mysql_201708070830/performance_schema/setup_timers.frm
mysql_201708070830/performance_schema/threads.frm
mysql_201708070830/test/
mysql_201708070830/test/db.opt

sent 4157 bytes  received 371 bytes  3018.67 bytes/sec
total size is 718361496  speedup is 158648.74 (DRY RUN)

- "A lot diff" but dest mariadb can start and the data is correct.

[root@joytest mariadb]# btrfs sub list .
ID 313 gen 190 top level 5 path mysql_201708070830
[root@joytest mariadb]# btrfs sub snap mysql_201708070830 mysql
Create a snapshot of 'mysql_201708070830' in './mysql'
[root@joytest mariadb]# systemctl start mariadb
[root@joytest mariadb]# systemctl status mariadb
&#226;— mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset:
disabled)
   Active: active (running) since Sun 2017-08-13 08:30:17 ICT; 4min 36s ago
  Process: 17079 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID
(code=exited, status=0/SUCCESS)
  Process: 17050 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n (code=exited,
status=0/SUCCESS)
 Main PID: 17078 (mysqld_safe)
   CGroup: /system.slice/mariadb.service
           &#226;”&#339;&#226;”€17078 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
           &#226;””&#226;”€17630 /usr/libexec/mysqld --basedir=/usr
--datadir=/var/lib/mariadb/mysql --plugin-dir=/usr/lib64/mysql/plugin
--log-error=/var/log/mariadb/mariadb.log --pid-file=/var/run/mariadb/m...

Aug 13 08:30:12 joytest systemd[1]: Starting MariaDB database server...
Aug 13 08:30:13 joytest mysqld_safe[17078]: 170813 08:30:13 mysqld_safe Logging to
'/var/log/mariadb/mariadb.log'.
Aug 13 08:30:13 joytest mysqld_safe[17078]: 170813 08:30:13 mysqld_safe Starting
mysqld daemon with databases from /var/lib/mariadb/mysql
Aug 13 08:30:17 joytest systemd[1]: Started MariaDB database server.
[root@joytest mariadb]# mysql -uroot -ppassword
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 5.5.52-MariaDB MariaDB Server

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use backups_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

^[[ADatabase changed
MariaDB [backups_db]> select max(backup_start_date) from tpc_backup_header order by
backup_start_date desc;
+------------------------+
| max(backup_start_date) |
+------------------------+
| 2017-08-07 06:30:01    |
+------------------------+
1 row in set (0.09 sec)

MariaDB [backups_db]> Ctrl-C -- exit!
Aborted

- I continuously send the incremental and it work fine on dest (even rsync said "a
lot diff")  until the snapshot mysql_201708100830 mariadb can not start

[root@backuplogC7 ~]# btrfs send -p /var/lib/mariadb/mysql_201708090830
/var/lib/mariadb/mysql_201708100830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708100830
At snapshot mysql_201708100830
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708100830
root@192.168.45.166:/var/lib/mariadb/mysql_201708100830
sending incremental file list
mysql_201708100830/
mysql_201708100830/aria_log.00000001
mysql_201708100830/aria_log_control
mysql_201708100830/ib_logfile0
mysql_201708100830/ib_logfile1
mysql_201708100830/ibdata1
mysql_201708100830/mysql-bin.000001
mysql_201708100830/mysql-bin.index
mysql_201708100830/backups_db/
mysql_201708100830/backups_db/db.opt
mysql_201708100830/backups_db/ints.frm
mysql_201708100830/backups_db/tpc_backup_detail.frm
mysql_201708100830/backups_db/tpc_backup_header.frm
mysql_201708100830/backups_db/tpc_backup_history.frm
mysql_201708100830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708100830/backups_db/tpc_backup_schedule_master.frm
mysql_201708100830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708100830/backups_db/tpc_backup_schedule_old.frm
mysql_201708100830/backups_db/tpc_backup_server.frm
mysql_201708100830/backups_db/tpc_backup_step.frm
mysql_201708100830/backups_db/tpc_backup_user.frm
mysql_201708100830/backups_db/v_backup_header_status.frm
mysql_201708100830/backups_db/v_calendar.frm
mysql_201708100830/backups_db/v_dup_backup.frm
mysql_201708100830/mysql/
mysql_201708100830/mysql/columns_priv.MYD
mysql_201708100830/mysql/columns_priv.MYI
mysql_201708100830/mysql/columns_priv.frm
mysql_201708100830/mysql/db.MYD
mysql_201708100830/mysql/db.MYI
mysql_201708100830/mysql/db.frm
mysql_201708100830/mysql/event.MYD
mysql_201708100830/mysql/event.MYI
mysql_201708100830/mysql/event.frm
mysql_201708100830/mysql/func.MYD
mysql_201708100830/mysql/func.MYI
mysql_201708100830/mysql/func.frm
mysql_201708100830/mysql/general_log.CSM
mysql_201708100830/mysql/general_log.CSV
mysql_201708100830/mysql/general_log.frm
mysql_201708100830/mysql/help_category.MYD
mysql_201708100830/mysql/help_category.MYI
mysql_201708100830/mysql/help_category.frm
mysql_201708100830/mysql/help_keyword.MYD
mysql_201708100830/mysql/help_keyword.MYI
mysql_201708100830/mysql/help_keyword.frm
mysql_201708100830/mysql/help_relation.MYD
mysql_201708100830/mysql/help_relation.MYI
mysql_201708100830/mysql/help_relation.frm
mysql_201708100830/mysql/help_topic.MYD
mysql_201708100830/mysql/help_topic.MYI
mysql_201708100830/mysql/help_topic.frm
mysql_201708100830/mysql/host.MYD
mysql_201708100830/mysql/host.MYI
mysql_201708100830/mysql/host.frm
mysql_201708100830/mysql/ndb_binlog_index.MYD
mysql_201708100830/mysql/ndb_binlog_index.MYI
mysql_201708100830/mysql/ndb_binlog_index.frm
mysql_201708100830/mysql/plugin.MYD
mysql_201708100830/mysql/plugin.MYI
mysql_201708100830/mysql/plugin.frm
mysql_201708100830/mysql/proc.MYD
mysql_201708100830/mysql/proc.MYI
mysql_201708100830/mysql/proc.frm
mysql_201708100830/mysql/procs_priv.MYD
mysql_201708100830/mysql/procs_priv.MYI
mysql_201708100830/mysql/procs_priv.frm
mysql_201708100830/mysql/proxies_priv.MYD
mysql_201708100830/mysql/proxies_priv.MYI
mysql_201708100830/mysql/proxies_priv.frm
mysql_201708100830/mysql/servers.MYD
mysql_201708100830/mysql/servers.MYI
mysql_201708100830/mysql/servers.frm
mysql_201708100830/mysql/slow_log.CSM
mysql_201708100830/mysql/slow_log.CSV
mysql_201708100830/mysql/slow_log.frm
mysql_201708100830/mysql/tables_priv.MYD
mysql_201708100830/mysql/tables_priv.MYI
mysql_201708100830/mysql/tables_priv.frm
mysql_201708100830/mysql/time_zone.MYD
mysql_201708100830/mysql/time_zone.MYI
mysql_201708100830/mysql/time_zone.frm
mysql_201708100830/mysql/time_zone_leap_second.MYD
mysql_201708100830/mysql/time_zone_leap_second.MYI
mysql_201708100830/mysql/time_zone_leap_second.frm
mysql_201708100830/mysql/time_zone_name.MYD
mysql_201708100830/mysql/time_zone_name.MYI
mysql_201708100830/mysql/time_zone_name.frm
mysql_201708100830/mysql/time_zone_transition.MYD
mysql_201708100830/mysql/time_zone_transition.MYI
mysql_201708100830/mysql/time_zone_transition.frm
mysql_201708100830/mysql/time_zone_transition_type.MYD
mysql_201708100830/mysql/time_zone_transition_type.MYI
mysql_201708100830/mysql/time_zone_transition_type.frm
mysql_201708100830/mysql/user.MYD
mysql_201708100830/mysql/user.MYI
mysql_201708100830/mysql/user.frm
mysql_201708100830/performance_schema/
mysql_201708100830/performance_schema/cond_instances.frm
mysql_201708100830/performance_schema/db.opt
mysql_201708100830/performance_schema/events_waits_current.frm
mysql_201708100830/performance_schema/events_waits_history.frm
mysql_201708100830/performance_schema/events_waits_history_long.frm
mysql_201708100830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708100830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708100830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708100830/performance_schema/file_instances.frm
mysql_201708100830/performance_schema/file_summary_by_event_name.frm
mysql_201708100830/performance_schema/file_summary_by_instance.frm
mysql_201708100830/performance_schema/mutex_instances.frm
mysql_201708100830/performance_schema/performance_timers.frm
mysql_201708100830/performance_schema/rwlock_instances.frm
mysql_201708100830/performance_schema/setup_consumers.frm
mysql_201708100830/performance_schema/setup_instruments.frm
mysql_201708100830/performance_schema/setup_timers.frm
mysql_201708100830/performance_schema/threads.frm
mysql_201708100830/test/
mysql_201708100830/test/db.opt

sent 4157 bytes  received 371 bytes  1811.20 bytes/sec
total size is 718361496  speedup is 158648.74 (DRY RUN)
[root@backuplogC7 ~]#

[root@joytest mariadb]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
57: eth0@if58: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
qlen 1000
    link/ether 00:16:3e:e3:b3:6f brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.45.166/21 brd 192.168.47.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fee3:b36f/64 scope link
       valid_lft forever preferred_lft forever
[root@joytest mariadb]# systemctl mariadb stop
Unknown operation 'mariadb'.
[root@joytest mariadb]# systemctl stop mariadb
[root@joytest mariadb]# btrfs sub list .
ID 313 gen 201 top level 5 path mysql_201708070830
ID 316 gen 199 top level 5 path mysql_201708080830
ID 317 gen 204 top level 5 path mysql
ID 318 gen 204 top level 5 path mysql_201708090830
[root@joytest mariadb]# btrfs sub del mysql
Delete subvolume (no-commit): '/var/lib/mariadb/mysql'
[root@joytest mariadb]# btrfs sub sync .
Subvolume id 317 is gone
[root@joytest mariadb]# btrfs sub snap mysql_201708090830 mysql
Create a snapshot of 'mysql_201708090830' in './mysql'
[root@joytest mariadb]# systemctl start mariadb
[root@joytest mariadb]# mysql -uroot -ppassword
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 2
Server version: 5.5.52-MariaDB MariaDB Server

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> use backups_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [backups_db]> select max(backup_start_date) from tpc_backup_header order by
backup_start_date desc;
+------------------------+
| max(backup_start_date) |
+------------------------+
| 2017-08-09 06:30:01    |
+------------------------+
1 row in set (0.09 sec)

MariaDB [backups_db]> exit
Bye
[root@joytest mariadb]# systemctl stop mariadb
[root@joytest mariadb]# btrfs sub list .
ID 313 gen 207 top level 5 path mysql_201708070830
ID 316 gen 199 top level 5 path mysql_201708080830
ID 318 gen 205 top level 5 path mysql_201708090830
ID 319 gen 206 top level 5 path mysql
ID 320 gen 208 top level 5 path mysql_201708100830
[root@joytest mariadb]# btrfs sub del mysql
Delete subvolume (no-commit): '/var/lib/mariadb/mysql'
[root@joytest mariadb]# btrfs sub sync .
[root@joytest mariadb]# btrfs sub snap mysql_201708100830 mysql
Create a snapshot of 'mysql_201708100830' in './mysql'
[root@joytest mariadb]# systemctl start mariadb
Job for mariadb.service failed because the control process exited with error code.
See "systemctl status mariadb.service" and "journalctl -xe" for details.
[root@joytest mariadb]#

- I still send the incremetal
[root@joytest mariadb]# btrfs sub list .
ID 313 gen 220 top level 5 path mysql_201708070830
ID 316 gen 199 top level 5 path mysql_201708080830
ID 318 gen 205 top level 5 path mysql_201708090830
ID 320 gen 211 top level 5 path mysql_201708100830
ID 321 gen 212 top level 5 path mysql
ID 322 gen 219 top level 5 path mysql_201708110830
ID 323 gen 219 top level 5 path mysql_201708120830
ID 324 gen 223 top level 5 path mysql_201708130830
[root@joytest mariadb]# btrfs sub del mysql
Delete subvolume (no-commit): '/var/lib/mariadb/mysql'
[root@joytest mariadb]# btrfs sub sync .
Subvolume id 321 is gone
[root@joytest mariadb]# btrfs sub snap mysql_201708130830 mysql
Create a snapshot of 'mysql_201708130830' in './mysql'
[root@joytest mariadb]# systemctl start mariadb
Job for mariadb.service failed because the control process exited with error code.
See "systemctl status mariadb.service" and "journalctl -xe" for details.
[root@joytest mariadb]#

- The latest log from the source send tested at 201708130818 for comfirm that the
script run with correct syntax.
Start Send 201708130818
btrfs send -p /var/lib/mariadb/mysql_201708110830
/var/lib/mariadb/mysql_201708120830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
rsync -avnc /var/lib/mariadb/mysql_201708120830
root@192.168.45.166://var/lib/mariadb/mysql_201708120830
Stop Send 201708130818

- the real send log after change include rsync in send script
Start Send 201708130905
btrfs send -p /var/lib/mariadb/mysql_201708120830
/var/lib/mariadb/mysql_201708130830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At snapshot mysql_201708130830
rsync -avnc /var/lib/mariadb/mysql_201708130830
root@192.168.45.166://var/lib/mariadb/mysql_201708130830
sending incremental file list
mysql_201708130830/
mysql_201708130830/aria_log.00000001
mysql_201708130830/aria_log_control
mysql_201708130830/ib_logfile0
mysql_201708130830/ib_logfile1
mysql_201708130830/ibdata1
mysql_201708130830/mysql-bin.000001
mysql_201708130830/mysql-bin.index
mysql_201708130830/backups_db/
mysql_201708130830/backups_db/db.opt
mysql_201708130830/backups_db/ints.frm
mysql_201708130830/backups_db/tpc_backup_detail.frm
mysql_201708130830/backups_db/tpc_backup_header.frm
mysql_201708130830/backups_db/tpc_backup_history.frm
mysql_201708130830/backups_db/tpc_backup_schedule_level_master.frm
mysql_201708130830/backups_db/tpc_backup_schedule_master.frm
mysql_201708130830/backups_db/tpc_backup_schedule_master_extra.frm
mysql_201708130830/backups_db/tpc_backup_schedule_old.frm
mysql_201708130830/backups_db/tpc_backup_server.frm
mysql_201708130830/backups_db/tpc_backup_step.frm
mysql_201708130830/backups_db/tpc_backup_user.frm
mysql_201708130830/backups_db/v_backup_header_status.frm
mysql_201708130830/backups_db/v_calendar.frm
mysql_201708130830/backups_db/v_dup_backup.frm
mysql_201708130830/mysql/
mysql_201708130830/mysql/columns_priv.MYD
mysql_201708130830/mysql/columns_priv.MYI
mysql_201708130830/mysql/columns_priv.frm
mysql_201708130830/mysql/db.MYD
mysql_201708130830/mysql/db.MYI
mysql_201708130830/mysql/db.frm
mysql_201708130830/mysql/event.MYD
mysql_201708130830/mysql/event.MYI
mysql_201708130830/mysql/event.frm
mysql_201708130830/mysql/func.MYD
mysql_201708130830/mysql/func.MYI
mysql_201708130830/mysql/func.frm
mysql_201708130830/mysql/general_log.CSM
mysql_201708130830/mysql/general_log.CSV
mysql_201708130830/mysql/general_log.frm
mysql_201708130830/mysql/help_category.MYD
mysql_201708130830/mysql/help_category.MYI
mysql_201708130830/mysql/help_category.frm
mysql_201708130830/mysql/help_keyword.MYD
mysql_201708130830/mysql/help_keyword.MYI
mysql_201708130830/mysql/help_keyword.frm
mysql_201708130830/mysql/help_relation.MYD
mysql_201708130830/mysql/help_relation.MYI
mysql_201708130830/mysql/help_relation.frm
mysql_201708130830/mysql/help_topic.MYD
mysql_201708130830/mysql/help_topic.MYI
mysql_201708130830/mysql/help_topic.frm
mysql_201708130830/mysql/host.MYD
mysql_201708130830/mysql/host.MYI
mysql_201708130830/mysql/host.frm
mysql_201708130830/mysql/ndb_binlog_index.MYD
mysql_201708130830/mysql/ndb_binlog_index.MYI
mysql_201708130830/mysql/ndb_binlog_index.frm
mysql_201708130830/mysql/plugin.MYD
mysql_201708130830/mysql/plugin.MYI
mysql_201708130830/mysql/plugin.frm
mysql_201708130830/mysql/proc.MYD
mysql_201708130830/mysql/proc.MYI
mysql_201708130830/mysql/proc.frm
mysql_201708130830/mysql/procs_priv.MYD
mysql_201708130830/mysql/procs_priv.MYI
mysql_201708130830/mysql/procs_priv.frm
mysql_201708130830/mysql/proxies_priv.MYD
mysql_201708130830/mysql/proxies_priv.MYI
mysql_201708130830/mysql/proxies_priv.frm
mysql_201708130830/mysql/servers.MYD
mysql_201708130830/mysql/servers.MYI
mysql_201708130830/mysql/servers.frm
mysql_201708130830/mysql/slow_log.CSM
mysql_201708130830/mysql/slow_log.CSV
mysql_201708130830/mysql/slow_log.frm
mysql_201708130830/mysql/tables_priv.MYD
mysql_201708130830/mysql/tables_priv.MYI
mysql_201708130830/mysql/tables_priv.frm
mysql_201708130830/mysql/time_zone.MYD
mysql_201708130830/mysql/time_zone.MYI
mysql_201708130830/mysql/time_zone.frm
mysql_201708130830/mysql/time_zone_leap_second.MYD
mysql_201708130830/mysql/time_zone_leap_second.MYI
mysql_201708130830/mysql/time_zone_leap_second.frm
mysql_201708130830/mysql/time_zone_name.MYD
mysql_201708130830/mysql/time_zone_name.MYI
mysql_201708130830/mysql/time_zone_name.frm
mysql_201708130830/mysql/time_zone_transition.MYD
mysql_201708130830/mysql/time_zone_transition.MYI
mysql_201708130830/mysql/time_zone_transition.frm
mysql_201708130830/mysql/time_zone_transition_type.MYD
mysql_201708130830/mysql/time_zone_transition_type.MYI
mysql_201708130830/mysql/time_zone_transition_type.frm
mysql_201708130830/mysql/user.MYD
mysql_201708130830/mysql/user.MYI
mysql_201708130830/mysql/user.frm
mysql_201708130830/performance_schema/
mysql_201708130830/performance_schema/cond_instances.frm
mysql_201708130830/performance_schema/db.opt
mysql_201708130830/performance_schema/events_waits_current.frm
mysql_201708130830/performance_schema/events_waits_history.frm
mysql_201708130830/performance_schema/events_waits_history_long.frm
mysql_201708130830/performance_schema/events_waits_summary_by_instance.frm
mysql_201708130830/performance_schema/events_waits_summary_by_thread_by_event_name.frm
mysql_201708130830/performance_schema/events_waits_summary_global_by_event_name.frm
mysql_201708130830/performance_schema/file_instances.frm
mysql_201708130830/performance_schema/file_summary_by_event_name.frm
mysql_201708130830/performance_schema/file_summary_by_instance.frm
mysql_201708130830/performance_schema/mutex_instances.frm
mysql_201708130830/performance_schema/performance_timers.frm
mysql_201708130830/performance_schema/rwlock_instances.frm
mysql_201708130830/performance_schema/setup_consumers.frm
mysql_201708130830/performance_schema/setup_instruments.frm
mysql_201708130830/performance_schema/setup_timers.frm
mysql_201708130830/performance_schema/threads.frm
mysql_201708130830/test/
mysql_201708130830/test/db.opt

sent 4157 bytes  received 371 bytes  823.27 bytes/sec
total size is 718361496  speedup is 158648.74 (DRY RUN)
Stop Send 201708130905
[root@backuplogC7 ~]# ^C
[root@backuplogC7 ~]#

Am I lost?

Best Regards,
Siranee Jaraswachirakul.


> On Fri, Aug 11, 2017 at 11:08 PM,  <siranee.ja@tpc.co.th> wrote:
>
>
>> The backup script has the btrfs sync command since Aug 3
>
>
> From your script:
>> system btrfs sub snap -r $basepath $snappath
>> system btrfs sub sync $basepath
>
> From the man page: sync <path> [subvolid...]
>            Wait until given subvolume(s) are completely removed from the
>            filesystem after deletion.
>
>
> This 'subvolume sync' command, per the man page, is only about
> subvolume deletion. I suggest replacing it with a regular sync
> command.
>
> I think the problem is that the script does things so fast that the
> snapshot is not always consistent on disk before btrfs send starts.
> It's just a guess though. If I'm right, this means the rsync mismaches
> mean the destination snapshots are bad. Here's what I would do:
>
>
> - delete all the bad/mismatching snapshots only on the destination computer.
>
> - he most recent good snapshot pair, which rsync shows origin and
> destination match, is mysql_201708080830 so you can keep that one on
> both sides.
>
> - manually do incremental send/receive, starting with
> mysql_201708090830/, to make the destination current again with the
> origin.
>
> - confirm with rsync that the snapshot pairs on origin and destination
> are the same
>
> - now resume using the modified script, which will do snapshot -> sync -> send.
>
> OPTIONAL, you could add to your script an rsync -avnc to double check
> that the incremental send receive is working. This is admittedly
> inefficient because it checks the *entire* contents of the snapshots
> on both sides, it's not just checking the incremental data. But if it
> doesn't take too long, it will help restore trust in send/receive, and
> confirm that a regular sync is needed in between snapshot and send.
>
>
>
>
> --
> Chris Murphy
>


