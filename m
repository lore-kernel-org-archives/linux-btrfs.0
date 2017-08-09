Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:47523 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750830AbdHIGgk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Aug 2017 02:36:40 -0400
Message-ID: <22169.183.88.87.49.1502260598.squirrel@mail>
In-Reply-To: <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
    <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
Date: Wed, 9 Aug 2017 13:36:38 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, voravat@tpcorp.co.th
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Sorry for the incompleted command that I used in the post.

This is the real command from Machine A

backup step :
in crontab
30 08 * * * root /root/script/backup/backupsnap.sh root password /var/lib/mariadb/mysql

[root@backuplogC7 ~]# cat  /root/script/backup/backupsnap.sh
#Backup
#
user=$1
password=$2
basepath=$3
datet=$(date +%Y%m%d%H%M)
snappath=${basepath}_${datet}
echo "Locking databases"
mysql -u$user -p$password << EOF
FLUSH TABLES WITH READ LOCK;
system btrfs sub snap -r $basepath $snappath
UNLOCK TABLES;
quit
EOF
echo "Databases unlocked"

The send incremental step :

 487  history|grep send
 488  btrfs send /var/lib/mariadb/mysql_201707210830 | ssh 192.168.10.29 btrfs
receive /var/lib/mariadb
  489  btrfs send -p /var/lib/mariadb/mysql_201707210830
/var/lib/mariadb/mysql_201707220830 |ssh 192.168.10.29 btrfs receive
/var/lib/mariadb
  490  btrfs send -p /var/lib/mariadb/mysql_201707220830
/var/lib/mariadb/mysql_201707230830 |pv| ssh 192.168.10.29 btrfs receive
/var/lib/mariadb

This is the real command from Machine B

 463  systemctl stop mariadb
  464  cd /var/lib/mariadb
  465  ls -l
  466  btrfs sub del mysql*
  467  btrfs sub sync .
  468  ip addr
  469  btrfs sub list
  470  btrfs sub list .
  471  btrfs sub snap mysql_201707210830 mysql
  472  systemctl start mariadb
  473  mysql -uroot -ppassword
  474  btrfs sub list
  475  btrfs sub list .
  476  mysql -uroot -ppassword
  477  systemctl stop mariadb
  478  btrfs sub list .
  479  btrfs sub del  mysql
  480  btrfs sub sync .
  481  btrfs sub snap mysql_201707220830 mysql
  482  systemctl start mariadb
  483  mysql -uroot -ppassword
  484  systemctl stop mariadb
  485  btrfs sub del  mysql
  486  btrfs sub sync .
  487  btrfs sub list .
  488  btrfs sub snap mysql_201707230830 mysql
  489  systemctl start mariadb
  490  btrfs sub list .
  491  cat /var/log/mariadb/mariadb.log

PS:  No any error in btrfs command or in /var/log/messages.

Best Regards
Siranee Jaraswachirakul.


> On Tue, Aug 8, 2017 at 10:32 PM,  <siranee.ja@tpc.co.th> wrote:
>> Hi btrfs support team,
>>
>> My name is siranee jaraswachirakul. I tested btrfs incremental send and receive
>> and
>> I found something incorrect.
>>
>> I posted detail in the url
>> http://www.linuxquestions.org/questions/showthread.php?p=5746238#post5746238
>>
>> Could you please help me to find the reason?
>
> The command "btrfs sub snap mysql_201707210830 mysql" is unexpected
> for two reasons:
>
> 1. This is a rw snapshot. It needs to be ro using -r flag to make it
> ro, and only ro snapshots can be used with btrfs send receive.
> 2. The naming convention seems reversed. The subvolume you're
> snapshotting should be first, and the resulting snapshot is second,
> and it is the second one that you'll send. So I think really what
> you'll end up wanting is:
>
> Machine A
> btrfs sub snap -r mysql mysql_20170721
> btrfs send mysql_20170721
>
> Machine B
> btrfs sub snap mysql_20170721 mysql
>
> That will make a rw snapshot from the ro snapshot.
>
> The next problem with the post is that you say "incremental" but I do
> not see the exact send receive command you're using. An incremental
> send requires -p option.
>
>
>
> Machine A
> btrfs sub snap -r mysql mysql_20170721
> btrfs send mysql_20170721
>
> Machine B
> btrfs sub snap mysql_20170721 mysql
> Test mysql
> btrfs sub del mysql
>
> Machine A (next day)
>
> Machine A
> btrfs sub snap -r mysql mysql_20170722
> btrfs send -p mysql_20170721 mysql_20170722
>
> Machine B
> btrfs sub snap mysql_20170722 mysql
> Test mysql
> btrfs sub del mysql
>
> And so on. You must have the -p snapshot on both file systems for the
> incremental send/receive to work.
>
>
>
> --
> Chris Murphy
>


