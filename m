Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:46018 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752232AbdHMDkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:40:09 -0400
Message-ID: <1318.49.228.122.75.1502595606.squirrel@mail>
In-Reply-To: <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
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
    <6341.49.228.122.75.1502590802.squirrel@mail>
    <CAJCQCtTNw0Y_yg_dyOjE7JPm4rRZ-WMnexh+4E4mRmQ8BFPAWQ@mail.gmail.com>
Date: Sun, 13 Aug 2017 10:40:06 +0700 (ICT)
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

I started as your suggestion again. The diff occured since snapshot
mysql_201708090830 manually send. What should I do next?

- delete all the bad/mismatching snapshots only on the destination computer.
[root@joytest ~]# date
Sun Aug 13 10:27:23 ICT 2017
[root@joytest ~]# cd /var/lib/mariadb
[root@joytest mariadb]# btrfs sub list .
ID 313 gen 220 top level 5 path mysql_201708070830
ID 316 gen 199 top level 5 path mysql_201708080830
ID 318 gen 205 top level 5 path mysql_201708090830
ID 320 gen 211 top level 5 path mysql_201708100830
ID 322 gen 219 top level 5 path mysql_201708110830
ID 323 gen 219 top level 5 path mysql_201708120830
ID 324 gen 224 top level 5 path mysql_201708130830
ID 325 gen 225 top level 5 path mysql
[root@joytest mariadb]# btrfs sub del mysql_201708130830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708130830'
[root@joytest mariadb]# btrfs sub del mysql_201708120830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708120830'
[root@joytest mariadb]# btrfs sub del mysql_201708110830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708110830'
[root@joytest mariadb]# btrfs sub del mysql_201708100830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708100830'
[root@joytest mariadb]# btrfs sub del mysql_201708090830
Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708090830'
[root@joytest mariadb]# btrfs sub sync .
[root@joytest mariadb]# systemctl status mariadb
&#226;— mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset:
disabled)
   Active: failed (Result: exit-code) since Sun 2017-08-13 09:07:00 ICT; 1h 24min ago
  Process: 19871 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID
(code=exited, status=1/FAILURE)
  Process: 19870 ExecStart=/usr/bin/mysqld_safe --basedir=/usr (code=exited,
status=0/SUCCESS)
  Process: 19842 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n (code=exited,
status=0/SUCCESS)
 Main PID: 19870 (code=exited, status=0/SUCCESS)

Aug 13 09:06:58 joytest systemd[1]: Starting MariaDB database server...
Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe Logging to
'/var/log/mariadb/mariadb.log'.
Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe Starting
mysqld daemon with databases from /var/lib/mariadb/mysql
Aug 13 09:07:00 joytest systemd[1]: mariadb.service: control process exited,
code=exited status=1
Aug 13 09:07:00 joytest systemd[1]: Failed to start MariaDB database server.
Aug 13 09:07:00 joytest systemd[1]: Unit mariadb.service entered failed state.
Aug 13 09:07:00 joytest systemd[1]: mariadb.service failed.
[root@joytest mariadb]# btrfs sub list .
ID 313 gen 220 top level 5 path mysql_201708070830
ID 316 gen 199 top level 5 path mysql_201708080830
ID 325 gen 225 top level 5 path mysql
[root@joytest mariadb]#

- The most recent good snapshot pair, which rsync shows origin and
destination match, is mysql_201708080830 so you can keep that one on
both sides.

[root@backuplogC7 ~]# btrfs sub list /var/lib/mariadb
ID 257 gen 538 top level 5 path mysql
ID 316 gen 498 top level 5 path mysql_201708060830
ID 317 gen 503 top level 5 path mysql_201708070830
ID 318 gen 507 top level 5 path mysql_201708080830
ID 319 gen 514 top level 5 path mysql_201708090830
ID 320 gen 524 top level 5 path mysql_201708100830
ID 321 gen 529 top level 5 path mysql_201708110830
ID 322 gen 533 top level 5 path mysql_201708120830
ID 323 gen 538 top level 5 path mysql_201708130830
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830/
root@192.168.45.166://var/lib/mariadb/mysql_201708070830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  842.67 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708080830/
root@192.168.45.166://var/lib/mariadb/mysql_201708080830/
sending incremental file list
./

sent 3769 bytes  received 19 bytes  841.78 bytes/sec
total size is 718361496  speedup is 189641.37 (DRY RUN)
[root@backuplogC7 ~]# date
Sun Aug 13 10:34:05 ICT 2017
[root@backuplogC7 ~]#

- manually do incremental send/receive, starting with
mysql_201708090830/, to make the destination current again with the
origin.

[root@backuplogC7 ~]# btrfs send -p /var/lib/mariadb/mysql_201708080830
/var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708090830
At snapshot mysql_201708090830
[root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
root@192.168.45.166://var/lib/mariadb/mysql_201708090830/
sending incremental file list
./
ib_logfile1
ibdata1

sent 3779 bytes  received 25 bytes  507.20 bytes/sec
total size is 718361496  speedup is 188843.72 (DRY RUN)
[root@backuplogC7 ~]#

Best Regards,

Siranee Jaraswachirakul.

> On Sat, Aug 12, 2017 at 8:20 PM,  <siranee.ja@tpc.co.th> wrote:
>
>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830
>> root@192.168.45.166://var/lib/mariadb/mysql_201708090830
>
>
> You need trailing / for the first directory with -a option.
>
> rsync -a dir dir
>
> is not the same command as
>
> rsync -a dir/ dir
>
> It's confusing but your command is trying to create mysql_201708090830
> directory on the source, in the mysql_201708090830 on the destination.
> That is why everything mismatches. To make it mean "contents of" you
> need trailing slash on at least the origin.
>
>
>
> --
> Chris Murphy
>


