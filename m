Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:33596 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750909AbdHKGAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 02:00:08 -0400
Message-ID: <13031.192.168.42.222.1502431206.squirrel@mail>
In-Reply-To: <27218.183.88.87.49.1502426431.squirrel@mail>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
    <22169.183.88.87.49.1502260598.squirrel@mail>
    <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
    <27218.183.88.87.49.1502426431.squirrel@mail>
Date: Fri, 11 Aug 2017 13:00:06 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: siranee.ja@tpc.co.th
Cc: "Chris Murphy" <lists@colorremedies.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry Chris,

I forgot to send the diff from rsync -anc result

the source container A start data as data on snapshot  mysql_201708040830

[root@backuplogC7 tmp]# ls -l /var/lib/mariadb
total 0
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql
drwxrwxr-x+ 1 mysql mysql 260 Jul 12 08:29 mysql_201708040830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708050830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708060830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708070830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708080830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708090830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708100830
drwxrwxr-x+ 1 mysql mysql 260 Aug  4 13:10 mysql_201708110830

the dest    container B start data as data on snapshot mysql_201708070830

[root@joytest tmp]# ls -l /var/lib/mariadb
total 0
drwxrwxr-x+ 1 mysql mysql 260 Aug 11 10:24 mysql
drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708070830
drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708080830
drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708090830
drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708100830
drwxrwxr-x+ 1 mysql mysql 260 Aug  7 09:26 mysql_201708110830



tpcorp@virtualtrust3:/tmp$ diff source_mysql_201708110830.txt
dest_mysql_201708110830.txt
1c1
< drwxrwxr-x         260 2017/08/04 13:10:56 mysql_201708110830
---
> drwxrwxr-x         260 2017/08/07 09:26:32 mysql_201708110830
5c5
< -rw-rwx---     5242880 2017/08/10 07:30:35 mysql_201708110830/ib_logfile1
---
> -rw-rwx---     5242880 2017/08/07 07:30:36 mysql_201708110830/ib_logfile1

Best Regards,
Siranee Jaraswachirakul.

> Hi Chris,
> The kernel version that I test is "4.4.0-89-generic" as I tested on ubuntu lxd If I
> want to change the kernel version I have to upgrade the host box.
>
> As you suggest the rsync to  compare the subvolumes. I found the point.
> the subvolumes are different only after I start to del old subvolumes on machine A
> the steps are
>
> 30 08 * * * root /root/script/backup/backupsnap.sh root password
> /var/lib/mariadb/mysql >> /var/log/btrfs_snap.log
> 05 09 * * * root /root/script/backupbtrfs_inc.sh /var/lib/mariadb 192.168.45.166
> /var/lib/mariadb >> /var/log/btrfs_send.log
> 30 19 * * * root /root/script/delete_btrfs_sub_snap_volume.sh /var/lib/mariadb 7 >>
> /var/log/btrfs_del.log
>
>
> The following script maintain snapshot to currently only 7 snapshots.
> [root@backuplogC7 ~]# cat /root/script/delete_btrfs_sub_snap_volume.sh
> basepath=$1
> keepcount=$2
> havecount=`btrfs sub list -s ${basepath}|cut -d' ' -f14|wc -l`
> delcount=$[$keepcount-$havecount];
> datet=$(date +%Y%m%d%H%M)
> echo "Start Delete ${datet}"
> if [ $delcount -lt 0 ]; then
> # list only snapshot subvolume
> for i in `btrfs sub list -s ${basepath}|cut -d' ' -f14|head ${delcount}`
> do
>         echo "btrfs sub delete ${basepath}/$i"
>         btrfs sub delete ${basepath}/$i
>         btrfs sub sync ${basepath}
> done
> else
>         echo "$delcount -gt 0 nothing to delete"
> fi
> echo "Stop Delete ${datet}"
>
> Does it mean my delete script is not the properly way of the btrfs purge old
> snapshot on source?
>
> Best Regards,
>
> Siranee Jarwachirakul.
>
>> On Wed, Aug 9, 2017 at 12:36 AM,  <siranee.ja@tpc.co.th> wrote:
>>
>>>   488  btrfs sub snap mysql_201707230830 mysql
>>>   489  systemctl start mariadb
>>>   490  btrfs sub list .
>>>   491  cat /var/log/mariadb/mariadb.log
>>
>> OK so mysql_201707230830 once on machine B is inconsistent somehow. So
>> the questions I have are:
>>
>> Is mysql_201707230830 on machine A really identical to
>> mysql_201707230830 on machine B? You can do an rsync -anc (double
>> check those options) which should independently check whether those
>> two subvolumes are in fact identical. The -n is a no op, which doesn't
>> really matter much because as read only subvolumes any attempt to sync
>> will just result in noisy messages. The -c causes rsync to do its own
>> checksum verification on both sides.
>>
>> If the subvolumes are different, we need to find out why.
>>
>> If the subvolumes are the same, then I wonder if you can reproduce the
>> mariadb complaint on machine A merely by making a rw snapshot of
>> mysql_201707230830 and trying to start it. If so, then it's not a send
>> receive problem, it sounds like the snapshot itself is inconsistent,
>> maybe mariadb hasn't actually completely closed out the database at
>> the time the read only snapshot was taken? I'm not sure.
>>
>> If the subvolumes are different, I'm going to recommend updating at
>> least the btrfs-progs because 4.4 is kinda old at this point. The
>> kernel code is what's mainly responsible for the send stream, and the
>> user space code is mainly responsible for receiving. And I don't off
>> hand know or want to look up all the send receive changes between 4.4
>> and 4.12 to speculate on whether this is has already been fixed.
>>
>> What's the kernel version?
>>
>> --
>> Chris Murphy
>>
>
>


