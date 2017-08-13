Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:54038 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750942AbdHMOAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 10:00:32 -0400
Message-ID: <1358.49.228.115.25.1502632828.squirrel@mail>
In-Reply-To: <65f71385-d462-f7c2-be5b-94e35b93cddb@gmail.com>
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
    <1318.49.228.122.75.1502595606.squirrel@mail>
    <f63baa3e-c955-ef5e-fe51-ef9d835bcae6@gmail.com>
    <7255.49.228.115.25.1502621539.squirrel@mail>
    <65f71385-d462-f7c2-be5b-94e35b93cddb@gmail.com>
Date: Sun, 13 Aug 2017 21:00:28 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "A L" <crimsoncottage@gmail.com>
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi "A L",

As your suggestion. Does it mean I have to make all my current subvolumes to clear
"Receive UUID" and send them with full snapshots?
>>                                  mysql
>>                                  mysql_201708060830
>>                                  mysql_201708070830
>>                                  mysql_201708080830
>>                                  mysql_201708090830
>>                                  mysql_201708100830
>>                                  mysql_201708110830
>>                                  mysql_201708120830
>>                                  mysql_201708130830

The next day that I take snapshot with the script will be
mysql_201708140830

which will be sent with incremental from mysql_201708130830 to mysql_201708140830

Is this correct?

I am not understand with the url that you gave me which said

"I'm getting an error: Aborted: "Received UUID" is set

You probably restored a backup with send-receive, and made it read/write using btrfs
property set. This is bad, as all snapshots and backups will inherit this identical
"Received UUID", which results in all these subvolumes will be treated as
"containing same data".

To fix this, create a "proper" snapshot:

- This is as your suggestion for the subvolume "mysql"

# cd /mnt/btr_pool
# mv mysubvolume mysubvolume.broken
# btrfs subvolume snapshot mysubvolume.broken mysubvolume

Now, mysubvolume should have an empty "Received UUID". Note that in order to have a
clean environment, you also need to fix all subvolumes (snapshots as well as
backups) that you created with the broken subvolume.

Check if there are more broken subvolumes:

# btrfs subvolume show mysubvolume.broken
# btrfs subvolume list -a -R /mnt/btr_pool | grep <"Received UUID" from above>
# btrfs subvolume list -a -R /mnt/btr_backup | grep <"Received UUID" from above>

- This guide seem that I have to clear <"Received UUID" > only the subvolume "mysql"
and the others ("mysql_201708070830" should using btrfs subvolume snapshot -r 
instead of btrfs subvolume snapshot. Is this correct?

Now clean all subvolume listed (same as above, but using btrfs subvolume snapshot -r
now). Then delete all the broken subvolumes:

# btrfs subvolume delete *.broken

Finally, you should have a clean environment, and btrbk will not complain any more.


Best Regards,
Siranee Jaraswachirakul.

>
>
> On 8/13/2017 12:52 PM, siranee.ja@tpc.co.th wrote:
>> Hi "A L",
>>
>> [root@backuplogC7 ~]# btrfs sub show /var/lib/mariadb/mysql
>> /var/lib/mariadb/mysql
>>          Name:                   mysql
>>          UUID:                   92f319c5-e132-3249-9b13-d39ee77a2b44
>>          Parent UUID:            -
>>          Received UUID:          3ad0334a-4063-654c-add6-b1cbcdeaa639
>>          Creation time:          2017-06-21 13:27:41 +0700
>>          Subvolume ID:           257
>>          Generation:             539
>>          Gen at creation:        9
>>          Parent ID:              5
>>          Top level ID:           5
>>          Flags:                  -
>>          Snapshot(s):
>>                                  mysql_201708060830
>>                                  mysql_201708070830
>>                                  mysql_201708080830
>>                                  mysql_201708090830
>>                                  mysql_201708100830
>>                                  mysql_201708110830
>>                                  mysql_201708120830
>>                                  mysql_201708130830
>>
>> yes I think it has Received UUID because I restored the source from snapshot
>> mysql_201708040830 for prove that the local snapshot was work.
>>
>> How to clear the Received UUID ?
>> What to do next?
> You need to make a read-write snapshot of  /var/lib/mariadb/mysql and
> then remove the old subvolume and all its snapshots.
>
> Example from https://github.com/digint/btrbk/blob/master/doc/FAQ.md
>
> # cd /mnt/btr_pool
> # mv mysubvolume mysubvolume.broken
> # btrfs subvolume snapshot mysubvolume.broken mysubvolume
>
> You can do the same with each of your snapshots too, and send them as
> full snapshots (without -p).
>
> ~A
>
>> Best Regards,
>> Siranee Jaraswachirakul.
>>
>>> Have you checked that there is no Received UUID on the source subvolume?
>>>
>>> # btrfs sub show volume/mysql/
>>> volume/mysql
>>>           Name:                   mysql
>>>           UUID:                   8a94524e-a956-c14b-bb8d-d453627f27d5
>>>           Parent UUID:            -
>>>           Received UUID:          -
>>>           Creation time:          2017-04-17 11:46:20 +0200
>>>           Subvolume ID:           1469
>>>           Generation:             122934
>>>           Gen at creation:        78671
>>>           Parent ID:              5
>>>           Top level ID:           5
>>>           Flags:                  -
>>>           Snapshot(s):
>>>
>>> There is no Received UUID here. If it has, then btrfs send-receive will
>>> have problems, since all snapshots of the source subvolume will have the
>>> same Received UUID and it can't tell the differences between the snapshots.
>>>
>>> On 8/13/2017 5:40 AM, siranee.ja@tpc.co.th wrote:
>>>> Hi Chris,
>>>>
>>>> I started as your suggestion again. The diff occured since snapshot
>>>> mysql_201708090830 manually send. What should I do next?
>>>>
>>>> - delete all the bad/mismatching snapshots only on the destination computer.
>>>> [root@joytest ~]# date
>>>> Sun Aug 13 10:27:23 ICT 2017
>>>> [root@joytest ~]# cd /var/lib/mariadb
>>>> [root@joytest mariadb]# btrfs sub list .
>>>> ID 313 gen 220 top level 5 path mysql_201708070830
>>>> ID 316 gen 199 top level 5 path mysql_201708080830
>>>> ID 318 gen 205 top level 5 path mysql_201708090830
>>>> ID 320 gen 211 top level 5 path mysql_201708100830
>>>> ID 322 gen 219 top level 5 path mysql_201708110830
>>>> ID 323 gen 219 top level 5 path mysql_201708120830
>>>> ID 324 gen 224 top level 5 path mysql_201708130830
>>>> ID 325 gen 225 top level 5 path mysql
>>>> [root@joytest mariadb]# btrfs sub del mysql_201708130830
>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708130830'
>>>> [root@joytest mariadb]# btrfs sub del mysql_201708120830
>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708120830'
>>>> [root@joytest mariadb]# btrfs sub del mysql_201708110830
>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708110830'
>>>> [root@joytest mariadb]# btrfs sub del mysql_201708100830
>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708100830'
>>>> [root@joytest mariadb]# btrfs sub del mysql_201708090830
>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708090830'
>>>> [root@joytest mariadb]# btrfs sub sync .
>>>> [root@joytest mariadb]# systemctl status mariadb
>>>> &#226;— mariadb.service - MariaDB database server
>>>>      Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor
>>>> preset:
>>>> disabled)
>>>>      Active: failed (Result: exit-code) since Sun 2017-08-13 09:07:00 ICT; 1h
>>>> 24min
>>>> ago
>>>>     Process: 19871 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID
>>>> (code=exited, status=1/FAILURE)
>>>>     Process: 19870 ExecStart=/usr/bin/mysqld_safe --basedir=/usr (code=exited,
>>>> status=0/SUCCESS)
>>>>     Process: 19842 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n
>>>> (code=exited,
>>>> status=0/SUCCESS)
>>>>    Main PID: 19870 (code=exited, status=0/SUCCESS)
>>>>
>>>> Aug 13 09:06:58 joytest systemd[1]: Starting MariaDB database server...
>>>> Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe Logging
>>>> to
>>>> '/var/log/mariadb/mariadb.log'.
>>>> Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe Starting
>>>> mysqld daemon with databases from /var/lib/mariadb/mysql
>>>> Aug 13 09:07:00 joytest systemd[1]: mariadb.service: control process exited,
>>>> code=exited status=1
>>>> Aug 13 09:07:00 joytest systemd[1]: Failed to start MariaDB database server.
>>>> Aug 13 09:07:00 joytest systemd[1]: Unit mariadb.service entered failed state.
>>>> Aug 13 09:07:00 joytest systemd[1]: mariadb.service failed.
>>>> [root@joytest mariadb]# btrfs sub list .
>>>> ID 313 gen 220 top level 5 path mysql_201708070830
>>>> ID 316 gen 199 top level 5 path mysql_201708080830
>>>> ID 325 gen 225 top level 5 path mysql
>>>> [root@joytest mariadb]#
>>>>
>>>> - The most recent good snapshot pair, which rsync shows origin and
>>>> destination match, is mysql_201708080830 so you can keep that one on
>>>> both sides.
>>>>
>>>> [root@backuplogC7 ~]# btrfs sub list /var/lib/mariadb
>>>> ID 257 gen 538 top level 5 path mysql
>>>> ID 316 gen 498 top level 5 path mysql_201708060830
>>>> ID 317 gen 503 top level 5 path mysql_201708070830
>>>> ID 318 gen 507 top level 5 path mysql_201708080830
>>>> ID 319 gen 514 top level 5 path mysql_201708090830
>>>> ID 320 gen 524 top level 5 path mysql_201708100830
>>>> ID 321 gen 529 top level 5 path mysql_201708110830
>>>> ID 322 gen 533 top level 5 path mysql_201708120830
>>>> ID 323 gen 538 top level 5 path mysql_201708130830
>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830/
>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708070830/
>>>> sending incremental file list
>>>> ./
>>>>
>>>> sent 3773 bytes  received 19 bytes  842.67 bytes/sec
>>>> total size is 718361496  speedup is 189441.32 (DRY RUN)
>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708080830/
>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708080830/
>>>> sending incremental file list
>>>> ./
>>>>
>>>> sent 3769 bytes  received 19 bytes  841.78 bytes/sec
>>>> total size is 718361496  speedup is 189641.37 (DRY RUN)
>>>> [root@backuplogC7 ~]# date
>>>> Sun Aug 13 10:34:05 ICT 2017
>>>> [root@backuplogC7 ~]#
>>>>
>>>> - manually do incremental send/receive, starting with
>>>> mysql_201708090830/, to make the destination current again with the
>>>> origin.
>>>>
>>>> [root@backuplogC7 ~]# btrfs send -p /var/lib/mariadb/mysql_201708080830
>>>> /var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
>>>> /var/lib/mariadb
>>>> At subvol /var/lib/mariadb/mysql_201708090830
>>>> At snapshot mysql_201708090830
>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708090830/
>>>> sending incremental file list
>>>> ./
>>>> ib_logfile1
>>>> ibdata1
>>>>
>>>> sent 3779 bytes  received 25 bytes  507.20 bytes/sec
>>>> total size is 718361496  speedup is 188843.72 (DRY RUN)
>>>> [root@backuplogC7 ~]#
>>>>
>>>> Best Regards,
>>>>
>>>> Siranee Jaraswachirakul.
>>>>
>>>>> On Sat, Aug 12, 2017 at 8:20 PM,  <siranee.ja@tpc.co.th> wrote:
>>>>>
>>>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830
>>>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708090830
>>>>> You need trailing / for the first directory with -a option.
>>>>>
>>>>> rsync -a dir dir
>>>>>
>>>>> is not the same command as
>>>>>
>>>>> rsync -a dir/ dir
>>>>>
>>>>> It's confusing but your command is trying to create mysql_201708090830
>>>>> directory on the source, in the mysql_201708090830 on the destination.
>>>>> That is why everything mismatches. To make it mean "contents of" you
>>>>> need trailing slash on at least the origin.
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Chris Murphy
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>


