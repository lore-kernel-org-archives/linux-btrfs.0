Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:38651 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750757AbdHLFIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 01:08:35 -0400
Message-ID: <1420.49.228.123.163.1502514511.squirrel@mail>
In-Reply-To: <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
    <22169.183.88.87.49.1502260598.squirrel@mail>
    <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
    <27218.183.88.87.49.1502426431.squirrel@mail>
    <13031.192.168.42.222.1502431206.squirrel@mail>
    <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
    <1243.49.228.123.163.1502505534.squirrel@mail>
    <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
Date: Sat, 12 Aug 2017 12:08:31 +0700 (ICT)
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

Sorry for the misunderstanding and inappropriate attached the file (I thought that
too long text in the mail message so I used the attached file).

The backup script has the btrfs sync command since Aug 3
I sent the following rsync command as you said (sorry for the misunderstanding with
the rsync command that I'd never used before)
The snapshot has been different since snapshot mysql_201708090830 but the mariadb
can recovery and start until mysql_201708110830 seems too much differences that can
not start.



[root@backuplogC7 ~]# more /root/script/backup/backupsnap.sh
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
system btrfs sub sync $basepath
UNLOCK TABLES;
quit
EOF
echo "Databases unlocked ${datet}"

[root@backuplogC7 ~]# ls -l /root/script/backup/backupsnap.sh
-rwxr--r-- 1 root root 333 Aug  3 09:11 /root/script/backup/backupsnap.sh


[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708070830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  1083.43 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708080830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708080830/
sending incremental file list
./

sent 3769 bytes  received 19 bytes  841.78 bytes/sec
total size is 718361496  speedup is 189641.37 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708090830/
sending incremental file list
./
ib_logfile1
ibdata1

sent 3779 bytes  received 25 bytes  1086.86 bytes/sec
total size is 718361496  speedup is 188843.72 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708100830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708100830/
sending incremental file list
./
ib_logfile1
ibdata1

sent 3779 bytes  received 25 bytes  1086.86 bytes/sec
total size is 718361496  speedup is 188843.72 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708110830/
root@192.168.45.166:/var/lib/mariadb/mysql_20170811830/
sending incremental file list
created directory /var/lib/mariadb/mysql_20170811830
./
aria_log.00000001
aria_log_control
ib_logfile0
ib_logfile1
ibdata1
mysql-bin.000001
mysql-bin.index
backups_db/
backups_db/db.opt
backups_db/ints.frm
backups_db/tpc_backup_detail.frm
backups_db/tpc_backup_header.frm
backups_db/tpc_backup_history.frm
backups_db/tpc_backup_schedule_level_master.frm
backups_db/tpc_backup_schedule_master.frm
backups_db/tpc_backup_schedule_master_extra.frm
backups_db/tpc_backup_schedule_old.frm
backups_db/tpc_backup_server.frm
backups_db/tpc_backup_step.frm
backups_db/tpc_backup_user.frm
backups_db/v_backup_header_status.frm
backups_db/v_calendar.frm
backups_db/v_dup_backup.frm
mysql/
mysql/columns_priv.MYD
mysql/columns_priv.MYI
mysql/columns_priv.frm
mysql/db.MYD
mysql/db.MYI
mysql/db.frm
mysql/event.MYD
mysql/event.MYI
mysql/event.frm
mysql/func.MYD
mysql/func.MYI
mysql/func.frm
mysql/general_log.CSM
mysql/general_log.CSV
mysql/general_log.frm
mysql/help_category.MYD
mysql/help_category.MYI
mysql/help_category.frm
mysql/help_keyword.MYD
mysql/help_keyword.MYI
mysql/help_keyword.frm
mysql/help_relation.MYD
mysql/help_relation.MYI
mysql/help_relation.frm
mysql/help_topic.MYD
mysql/help_topic.MYI
mysql/help_topic.frm
mysql/host.MYD
mysql/host.MYI
mysql/host.frm
mysql/ndb_binlog_index.MYD
mysql/ndb_binlog_index.MYI
mysql/ndb_binlog_index.frm
mysql/plugin.MYD
mysql/plugin.MYI
mysql/plugin.frm
mysql/proc.MYD
mysql/proc.MYI
mysql/proc.frm
mysql/procs_priv.MYD
mysql/procs_priv.MYI
mysql/procs_priv.frm
mysql/proxies_priv.MYD
mysql/proxies_priv.MYI
mysql/proxies_priv.frm
mysql/servers.MYD
mysql/servers.MYI
mysql/servers.frm
mysql/slow_log.CSM
mysql/slow_log.CSV
mysql/slow_log.frm
mysql/tables_priv.MYD
mysql/tables_priv.MYI
mysql/tables_priv.frm
mysql/time_zone.MYD
mysql/time_zone.MYI
mysql/time_zone.frm
mysql/time_zone_leap_second.MYD
mysql/time_zone_leap_second.MYI
mysql/time_zone_leap_second.frm
mysql/time_zone_name.MYD
mysql/time_zone_name.MYI
mysql/time_zone_name.frm
mysql/time_zone_transition.MYD
mysql/time_zone_transition.MYI
mysql/time_zone_transition.frm
mysql/time_zone_transition_type.MYD
mysql/time_zone_transition_type.MYI
mysql/time_zone_transition_type.frm
mysql/user.MYD
mysql/user.MYI
mysql/user.frm
performance_schema/
performance_schema/cond_instances.frm
performance_schema/db.opt
performance_schema/events_waits_current.frm
performance_schema/events_waits_history.frm
performance_schema/events_waits_history_long.frm
performance_schema/events_waits_summary_by_instance.frm
performance_schema/events_waits_summary_by_thread_by_event_name.frm
performance_schema/events_waits_summary_global_by_event_name.frm
performance_schema/file_instances.frm
performance_schema/file_summary_by_event_name.frm
performance_schema/file_summary_by_instance.frm
performance_schema/mutex_instances.frm
performance_schema/performance_timers.frm
performance_schema/rwlock_instances.frm
performance_schema/setup_consumers.frm
performance_schema/setup_instruments.frm
performance_schema/setup_timers.frm
performance_schema/threads.frm
test/
test/db.opt

sent 4124 bytes  received 370 bytes  1797.60 bytes/sec
total size is 718361496  speedup is 159849.02 (DRY RUN)
[root@backuplogC7 ~]#
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708120830/
root@192.168.45.166:/var/lib/mariadb/mysql_20170812830/
sending incremental file list
created directory /var/lib/mariadb/mysql_20170812830
./
aria_log.00000001
aria_log_control
ib_logfile0
ib_logfile1
ibdata1
mysql-bin.000001
mysql-bin.index
backups_db/
backups_db/db.opt
backups_db/ints.frm
backups_db/tpc_backup_detail.frm
backups_db/tpc_backup_header.frm
backups_db/tpc_backup_history.frm
backups_db/tpc_backup_schedule_level_master.frm
backups_db/tpc_backup_schedule_master.frm
backups_db/tpc_backup_schedule_master_extra.frm
backups_db/tpc_backup_schedule_old.frm
backups_db/tpc_backup_server.frm
backups_db/tpc_backup_step.frm
backups_db/tpc_backup_user.frm
backups_db/v_backup_header_status.frm
backups_db/v_calendar.frm
backups_db/v_dup_backup.frm
mysql/
mysql/columns_priv.MYD
mysql/columns_priv.MYI
mysql/columns_priv.frm
mysql/db.MYD
mysql/db.MYI
mysql/db.frm
mysql/event.MYD
mysql/event.MYI
mysql/event.frm
mysql/func.MYD
mysql/func.MYI
mysql/func.frm
mysql/general_log.CSM
mysql/general_log.CSV
mysql/general_log.frm
mysql/help_category.MYD
mysql/help_category.MYI
mysql/help_category.frm
mysql/help_keyword.MYD
mysql/help_keyword.MYI
mysql/help_keyword.frm
mysql/help_relation.MYD
mysql/help_relation.MYI
mysql/help_relation.frm
mysql/help_topic.MYD
mysql/help_topic.MYI
mysql/help_topic.frm
mysql/host.MYD
mysql/host.MYI
mysql/host.frm
mysql/ndb_binlog_index.MYD
mysql/ndb_binlog_index.MYI
mysql/ndb_binlog_index.frm
mysql/plugin.MYD
mysql/plugin.MYI
mysql/plugin.frm
mysql/proc.MYD
mysql/proc.MYI
mysql/proc.frm
mysql/procs_priv.MYD
mysql/procs_priv.MYI
mysql/procs_priv.frm
mysql/proxies_priv.MYD
mysql/proxies_priv.MYI
mysql/proxies_priv.frm
mysql/servers.MYD
mysql/servers.MYI
mysql/servers.frm
mysql/slow_log.CSM
mysql/slow_log.CSV
mysql/slow_log.frm
mysql/tables_priv.MYD
mysql/tables_priv.MYI
mysql/tables_priv.frm
mysql/time_zone.MYD
mysql/time_zone.MYI
mysql/time_zone.frm
mysql/time_zone_leap_second.MYD
mysql/time_zone_leap_second.MYI
mysql/time_zone_leap_second.frm
mysql/time_zone_name.MYD
mysql/time_zone_name.MYI
mysql/time_zone_name.frm
mysql/time_zone_transition.MYD
mysql/time_zone_transition.MYI
mysql/time_zone_transition.frm
mysql/time_zone_transition_type.MYD
mysql/time_zone_transition_type.MYI
mysql/time_zone_transition_type.frm
mysql/user.MYD
mysql/user.MYI
mysql/user.frm
performance_schema/
performance_schema/cond_instances.frm
performance_schema/db.opt
performance_schema/events_waits_current.frm
performance_schema/events_waits_history.frm
performance_schema/events_waits_history_long.frm
performance_schema/events_waits_summary_by_instance.frm
performance_schema/events_waits_summary_by_thread_by_event_name.frm
performance_schema/events_waits_summary_global_by_event_name.frm
performance_schema/file_instances.frm
performance_schema/file_summary_by_event_name.frm
performance_schema/file_summary_by_instance.frm
performance_schema/mutex_instances.frm
performance_schema/performance_timers.frm
performance_schema/rwlock_instances.frm
performance_schema/setup_consumers.frm
performance_schema/setup_instruments.frm
performance_schema/setup_timers.frm
performance_schema/threads.frm
test/
test/db.opt

sent 4124 bytes  received 370 bytes  1797.60 bytes/sec
total size is 718361496  speedup is 159849.02 (DRY RUN)


Best Regards,
Siranee Jaraswachirakul

> On Fri, Aug 11, 2017 at 8:38 PM,  <siranee.ja@tpc.co.th> wrote:
>> Hi Chris,
>>
>> I explain what I have done in the attached file.
>
> That is way too long. And please don't attach files directed at me,
> that's not appropriate. Just message the list normally, so it can be
> searched by others down the road.
>
> There is a problem with your rsync command, you really don't
> understand what I was asking. The whole point of rsync is to compare
> the origin and destination subvolumes to see if they are different
> from each other. You ran the command on a single subvolume on a single
> machine which is pointless.
>
> On machine A:
>
> $ rsync -avnc /mnt/snapshot6/ chris@192.168.1.116:/mnt/snapshot6/
> chris@192.168.1.116's password:
> sending incremental file list
>
> sent 125 bytes  received 12 bytes  39.14 bytes/sec
> total size is 30,686  speedup is 223.99 (DRY RUN)
> [chris@f26h ~]$
>
> Because no files are listed, all are confirmed to be identical. If
> files are listed, there's a difference.
>
>
>
>> Please suggest me what I should do next?
>
> Check this. I wonder if you're running into this obscure bug where
> maybe your read only snapshot is not yet synced before it's being
> sent. Hence it *is* changing on origin machine, but not because of
> other snapshots being deleted. I have no idea if your scripting
> handles errors like the bogus stale NFS handle error, maybe it's
> possible it happens but you're not seeing it? Anyway, you might try
> just adding a single sync right after taking the snapshot, change
> nothing else and see if the problem reproduces itself.
>
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping
>
> I'm pretty sure this is fixed in newer kernels, I haven't run into it
> in a long time myself. But I don't know when it was fixed.
>
>
>
> --
> Chris Murphy
>


