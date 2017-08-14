Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:56325 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751567AbdHNB57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 21:57:59 -0400
Message-ID: <1636.49.228.115.25.1502675875.squirrel@mail>
In-Reply-To: <43770f5.b3ad169f.15ddd8226d3@gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
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
    <1358.49.228.115.25.1502632828.squirrel@mail>
    <43770f5.b3ad169f.15ddd8226d3@gmail.com>
Date: Mon, 14 Aug 2017 08:57:55 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "A L" <crimsoncottage@gmail.com>
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi "A L",

Thank you very much for your suggestion. I've got it.
It work properly right now.
what I have done are following.

mv all current mysql and snapshot mysql to mbroken and mbroken_yymmddhhmm
btrfs subvolume snapshot mbroken to mysql (to make it rw subvolume without Recieve
UUID)
btrfs subvolume snapshot mbroken_yymmddhhmm  to rw_yymmddhhmm (to make it rw
subvolume without Recieve UUID)
btrfs subvolume snap -r rw_yymmddhhmm  to mysql_yymmddhhmm ( to make ro snapshot)

after this just send full for the first ro snapshot (mysql_201708070830) and send
incremental until the end (mysql_201708130830).





[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708070830
rw_201708070830
Create a snapshot of 'mbroken_201708070830' in './rw_201708070830'
[root@backuplogC7 mariadb]# btrfs sub list .
ID 257 gen 542 top level 5 path mbroken
ID 317 gen 576 top level 5 path mbroken_201708070830
ID 318 gen 568 top level 5 path mbroken_201708080830
ID 319 gen 569 top level 5 path mbroken_201708090830
ID 320 gen 570 top level 5 path mbroken_201708100830
ID 321 gen 571 top level 5 path mbroken_201708110830
ID 322 gen 572 top level 5 path mbroken_201708120830
ID 323 gen 573 top level 5 path mbroken_201708130830
ID 324 gen 543 top level 5 path mysql
ID 348 gen 576 top level 5 path rw_201708070830
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708080830
rw_201708080830
Create a snapshot of 'mbroken_201708080830' in './rw_201708080830'
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708090830
rw_201708090830
Create a snapshot of 'mbroken_201708090830' in './rw_201708090830'
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708100830
rw_201708100830
Create a snapshot of 'mbroken_201708100830' in './rw_201708100830'
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708110830
rw_201708110830
Create a snapshot of 'mbroken_201708110830' in './rw_201708110830'
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708120830
rw_201708120830
Create a snapshot of 'mbroken_201708120830' in './rw_201708120830'
[root@backuplogC7 mariadb]# btrfs subvolume snapshot mbroken_201708130830
rw_201708130830
Create a snapshot of 'mbroken_201708130830' in './rw_201708130830'
[root@backuplogC7 mariadb]# btrfs sub list .
ID 257 gen 542 top level 5 path mbroken
ID 317 gen 576 top level 5 path mbroken_201708070830
ID 318 gen 577 top level 5 path mbroken_201708080830
ID 319 gen 578 top level 5 path mbroken_201708090830
ID 320 gen 579 top level 5 path mbroken_201708100830
ID 321 gen 580 top level 5 path mbroken_201708110830
ID 322 gen 581 top level 5 path mbroken_201708120830
ID 323 gen 582 top level 5 path mbroken_201708130830
ID 324 gen 543 top level 5 path mysql
ID 348 gen 576 top level 5 path rw_201708070830
ID 349 gen 577 top level 5 path rw_201708080830
ID 350 gen 578 top level 5 path rw_201708090830
ID 351 gen 579 top level 5 path rw_201708100830
ID 352 gen 580 top level 5 path rw_201708110830
ID 353 gen 581 top level 5 path rw_201708120830
ID 354 gen 582 top level 5 path rw_201708130830
[root@backuplogC7 mariadb]# btrfs subvolume list -a -R . | grep
"3ad0334a-4063-654c-add6-b1cbcdeaa639"
ID 257 gen 542 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken
ID 317 gen 576 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708070830
ID 318 gen 577 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708080830
ID 319 gen 578 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708090830
ID 320 gen 579 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708100830
ID 321 gen 580 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708110830
ID 322 gen 581 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708120830
ID 323 gen 582 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708130830
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708070830 mysql_201708070830
Create a readonly snapshot of 'rw_201708070830' in './mysql_201708070830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708080830 mysql_201708080830
Create a readonly snapshot of 'rw_201708080830' in './mysql_201708080830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708090830 mysql_201708090830
Create a readonly snapshot of 'rw_201708090830' in './mysql_201708090830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708100830 mysql_201708100830
Create a readonly snapshot of 'rw_201708100830' in './mysql_201708100830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708110830 mysql_201708110830
Create a readonly snapshot of 'rw_201708110830' in './mysql_201708110830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708120830 mysql_201708120830
Create a readonly snapshot of 'rw_201708120830' in './mysql_201708120830'
[root@backuplogC7 mariadb]# btrfs sub snap -r rw_201708130830 mysql_201708130830
Create a readonly snapshot of 'rw_201708130830' in './mysql_201708130830'
[root@backuplogC7 mariadb]# btrfs sub list .
ID 257 gen 542 top level 5 path mbroken
ID 317 gen 576 top level 5 path mbroken_201708070830
ID 318 gen 577 top level 5 path mbroken_201708080830
ID 319 gen 578 top level 5 path mbroken_201708090830
ID 320 gen 579 top level 5 path mbroken_201708100830
ID 321 gen 580 top level 5 path mbroken_201708110830
ID 322 gen 581 top level 5 path mbroken_201708120830
ID 323 gen 582 top level 5 path mbroken_201708130830
ID 324 gen 584 top level 5 path mysql
ID 348 gen 583 top level 5 path rw_201708070830
ID 349 gen 584 top level 5 path rw_201708080830
ID 350 gen 585 top level 5 path rw_201708090830
ID 351 gen 586 top level 5 path rw_201708100830
ID 352 gen 587 top level 5 path rw_201708110830
ID 353 gen 588 top level 5 path rw_201708120830
ID 354 gen 589 top level 5 path rw_201708130830
ID 355 gen 583 top level 5 path mysql_201708070830
ID 356 gen 584 top level 5 path mysql_201708080830
ID 357 gen 585 top level 5 path mysql_201708090830
ID 358 gen 586 top level 5 path mysql_201708100830
ID 359 gen 587 top level 5 path mysql_201708110830
ID 360 gen 588 top level 5 path mysql_201708120830
ID 361 gen 589 top level 5 path mysql_201708130830

[root@backuplogC7 mariadb]# btrfs subvolume list -a -R . | grep
"3ad0334a-4063-654c-add6-b1cbcdeaa639"
ID 257 gen 542 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken
ID 317 gen 576 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708070830
ID 318 gen 577 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708080830
ID 319 gen 578 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708090830
ID 320 gen 579 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708100830
ID 321 gen 580 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708110830
ID 322 gen 581 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708120830
ID 323 gen 582 top level 5 received_uuid 3ad0334a-4063-654c-add6-b1cbcdeaa639 path
mbroken_201708130830
[root@backuplogC7 mariadb]# btrfs send /var/lib/mariadb/mysql_201708070830 | ssh
192.168.45.166 btrfs receive /var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708070830
At subvol mysql_201708070830
[root@backuplogC7 mariadb]# btrfs sub show mysql_201708070830
/var/lib/mariadb/mysql_201708070830
        Name:                   mysql_201708070830
        UUID:                   70ee3c31-126d-574a-814c-e3b4c81b414e
        Parent UUID:            1d5bb8eb-b0df-2549-8b62-552cfa517609
        Received UUID:          -
        Creation time:          2017-08-14 07:00:08 +0700
        Subvolume ID:           355
        Generation:             583
        Gen at creation:        583
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708070830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708070830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  1083.43 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708070830
/var/lib/mariadb/mysql_201708080830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708080830
At snapshot mysql_201708080830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708080830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708080830/
sending incremental file list
./

sent 3769 bytes  received 19 bytes  688.73 bytes/sec
total size is 718361496  speedup is 189641.37 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708080830
/var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708090830
At snapshot mysql_201708090830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708090830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  583.38 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708090830
/var/lib/mariadb/mysql_201708100830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708100830
At snapshot mysql_201708100830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708100830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708100830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  689.45 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708100830
/var/lib/mariadb/mysql_201708110830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708110830
At snapshot mysql_201708110830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708110830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708110830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  689.45 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708110830
/var/lib/mariadb/mysql_201708120830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708120830
At snapshot mysql_201708120830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708120830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708120830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  689.45 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]# btrfs send -p /var/lib/mariadb/mysql_201708120830
/var/lib/mariadb/mysql_201708130830 | ssh 192.168.45.166 btrfs receive
/var/lib/mariadb
At subvol /var/lib/mariadb/mysql_201708130830
At snapshot mysql_201708130830
[root@backuplogC7 mariadb]# rsync -avnc /var/lib/mariadb/mysql_201708130830/
root@192.168.45.166:/var/lib/mariadb/mysql_201708130830/
sending incremental file list
./

sent 3773 bytes  received 19 bytes  689.45 bytes/sec
total size is 718361496  speedup is 189441.32 (DRY RUN)
[root@backuplogC7 mariadb]#


>
>
> ---- From: siranee.ja@tpc.co.th -- Sent: 2017-08-13 - 16:00 ----
>
>> Hi "A L",
>>
>> As your suggestion. Does it mean I have to make all my current subvolumes to clear
>> "Receive UUID" and send them with full snapshots?
>
> You need to clear all subvolumes with 'Received UUID' in order to use send-receive
> safely. once you have done that you can start over with new incremental sends (after
> the initial full send).
>
> I suggest to remove any existing snapshots of those volumes to avoid confusion.
>
>>>>                                  mysql
>>>>                                  mysql_201708060830
>>>>                                  mysql_201708070830
>>>>                                  mysql_201708080830
>>>>                                  mysql_201708090830
>>>>                                  mysql_201708100830
>>>>                                  mysql_201708110830
>>>>                                  mysql_201708120830
>>>>                                  mysql_201708130830
>>
>> The next day that I take snapshot with the script will be
>> mysql_201708140830
>>
>> which will be sent with incremental from mysql_201708130830 to mysql_201708140830
>>
>> Is this correct?
>
> yes, but your current snapshots can't be used because of the 'Received UUID'.
>>
>> I am not understand with the url that you gave me which said
>
> btrbk is a backup tool for btrfs. It detects the problem of the 'Received UUID'. The
> FAQ explains how to remove the 'Received UUID' from the source volumes and
> snapshots.
>
>  It is safer to remove all existing snapshots then trying to fix them and risking
> the integrity of the data.
>
>
>>
>> "I'm getting an error: Aborted: "Received UUID" is set
>>
>> You probably restored a backup with send-receive, and made it read/write using
>> btrfs
>> property set. This is bad, as all snapshots and backups will inherit this
>> identical
>> "Received UUID", which results in all these subvolumes will be treated as
>> "containing same data".
>>
>> To fix this, create a "proper" snapshot:
>>
>> - This is as your suggestion for the subvolume "mysql"
>>
>> # cd /mnt/btr_pool
>> # mv mysubvolume mysubvolume.broken
>> # btrfs subvolume snapshot mysubvolume.broken mysubvolume
>>
>> Now, mysubvolume should have an empty "Received UUID". Note that in order to have
>> a
>> clean environment, you also need to fix all subvolumes (snapshots as well as
>> backups) that you created with the broken subvolume.
>>
>> Check if there are more broken subvolumes:
>>
>> # btrfs subvolume show mysubvolume.broken
>> # btrfs subvolume list -a -R /mnt/btr_pool | grep <"Received UUID" from above>
>> # btrfs subvolume list -a -R /mnt/btr_backup | grep <"Received UUID" from above>
>>
>> - This guide seem that I have to clear <"Received UUID" > only the subvolume
>> "mysql"
>> and the others ("mysql_201708070830" should using btrfs subvolume snapshot -r
>> instead of btrfs subvolume snapshot. Is this correct?
>>
>> Now clean all subvolume listed (same as above, but using btrfs subvolume snapshot
>> -r
>> now). Then delete all the broken subvolumes:
>>
>> # btrfs subvolume delete *.broken
>>
>> Finally, you should have a clean environment, and btrbk will not complain any
>> more.
>>
>>
>> Best Regards,
>> Siranee Jaraswachirakul.
>>
>>>
>>>
>>> On 8/13/2017 12:52 PM, siranee.ja@tpc.co.th wrote:
>>>> Hi "A L",
>>>>
>>>> [root@backuplogC7 ~]# btrfs sub show /var/lib/mariadb/mysql
>>>> /var/lib/mariadb/mysql
>>>>          Name:                   mysql
>>>>          UUID:                   92f319c5-e132-3249-9b13-d39ee77a2b44
>>>>          Parent UUID:            -
>>>>          Received UUID:          3ad0334a-4063-654c-add6-b1cbcdeaa639
>>>>          Creation time:          2017-06-21 13:27:41 +0700
>>>>          Subvolume ID:           257
>>>>          Generation:             539
>>>>          Gen at creation:        9
>>>>          Parent ID:              5
>>>>          Top level ID:           5
>>>>          Flags:                  -
>>>>          Snapshot(s):
>>>>                                  mysql_201708060830
>>>>                                  mysql_201708070830
>>>>                                  mysql_201708080830
>>>>                                  mysql_201708090830
>>>>                                  mysql_201708100830
>>>>                                  mysql_201708110830
>>>>                                  mysql_201708120830
>>>>                                  mysql_201708130830
>>>>
>>>> yes I think it has Received UUID because I restored the source from snapshot
>>>> mysql_201708040830 for prove that the local snapshot was work.
>>>>
>>>> How to clear the Received UUID ?
>>>> What to do next?
>>> You need to make a read-write snapshot of? /var/lib/mariadb/mysql and
>>> then remove the old subvolume and all its snapshots.
>>>
>>> Example from https://github.com/digint/btrbk/blob/master/doc/FAQ.md
>>>
>>> # cd /mnt/btr_pool
>>> # mv mysubvolume mysubvolume.broken
>>> # btrfs subvolume snapshot mysubvolume.broken mysubvolume
>>>
>>> You can do the same with each of your snapshots too, and send them as
>>> full snapshots (without -p).
>>>
>>> ~A
>>>
>>>> Best Regards,
>>>> Siranee Jaraswachirakul.
>>>>
>>>>> Have you checked that there is no Received UUID on the source subvolume?
>>>>>
>>>>> # btrfs sub show volume/mysql/
>>>>> volume/mysql
>>>>>   ??????? Name:?????????????????? mysql
>>>>>   ??????? UUID:?????????????????? 8a94524e-a956-c14b-bb8d-d453627f27d5
>>>>>   ??????? Parent UUID:??????????? -
>>>>>   ??????? Received UUID:????????? -
>>>>>   ??????? Creation time:????????? 2017-04-17 11:46:20 +0200
>>>>>   ??????? Subvolume ID:?????????? 1469
>>>>>   ??????? Generation:???????????? 122934
>>>>>   ??????? Gen at creation:??????? 78671
>>>>>   ??????? Parent ID:????????????? 5
>>>>>   ??????? Top level ID:?????????? 5
>>>>>   ??????? Flags:????????????????? -
>>>>>   ??????? Snapshot(s):
>>>>>
>>>>> There is no Received UUID here. If it has, then btrfs send-receive will
>>>>> have problems, since all snapshots of the source subvolume will have the
>>>>> same Received UUID and it can't tell the differences between the snapshots.
>>>>>
>>>>> On 8/13/2017 5:40 AM, siranee.ja@tpc.co.th wrote:
>>>>>> Hi Chris,
>>>>>>
>>>>>> I started as your suggestion again. The diff occured since snapshot
>>>>>> mysql_201708090830 manually send. What should I do next?
>>>>>>
>>>>>> - delete all the bad/mismatching snapshots only on the destination computer.
>>>>>> [root@joytest ~]# date
>>>>>> Sun Aug 13 10:27:23 ICT 2017
>>>>>> [root@joytest ~]# cd /var/lib/mariadb
>>>>>> [root@joytest mariadb]# btrfs sub list .
>>>>>> ID 313 gen 220 top level 5 path mysql_201708070830
>>>>>> ID 316 gen 199 top level 5 path mysql_201708080830
>>>>>> ID 318 gen 205 top level 5 path mysql_201708090830
>>>>>> ID 320 gen 211 top level 5 path mysql_201708100830
>>>>>> ID 322 gen 219 top level 5 path mysql_201708110830
>>>>>> ID 323 gen 219 top level 5 path mysql_201708120830
>>>>>> ID 324 gen 224 top level 5 path mysql_201708130830
>>>>>> ID 325 gen 225 top level 5 path mysql
>>>>>> [root@joytest mariadb]# btrfs sub del mysql_201708130830
>>>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708130830'
>>>>>> [root@joytest mariadb]# btrfs sub del mysql_201708120830
>>>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708120830'
>>>>>> [root@joytest mariadb]# btrfs sub del mysql_201708110830
>>>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708110830'
>>>>>> [root@joytest mariadb]# btrfs sub del mysql_201708100830
>>>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708100830'
>>>>>> [root@joytest mariadb]# btrfs sub del mysql_201708090830
>>>>>> Delete subvolume (no-commit): '/var/lib/mariadb/mysql_201708090830'
>>>>>> [root@joytest mariadb]# btrfs sub sync .
>>>>>> [root@joytest mariadb]# systemctl status mariadb
>>>>>> &#226;? mariadb.service - MariaDB database server
>>>>>>      Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor
>>>>>> preset:
>>>>>> disabled)
>>>>>>      Active: failed (Result: exit-code) since Sun 2017-08-13 09:07:00 ICT; 1h
>>>>>> 24min
>>>>>> ago
>>>>>>     Process: 19871 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID
>>>>>> (code=exited, status=1/FAILURE)
>>>>>>     Process: 19870 ExecStart=/usr/bin/mysqld_safe --basedir=/usr (code=exited,
>>>>>> status=0/SUCCESS)
>>>>>>     Process: 19842 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n
>>>>>> (code=exited,
>>>>>> status=0/SUCCESS)
>>>>>>    Main PID: 19870 (code=exited, status=0/SUCCESS)
>>>>>>
>>>>>> Aug 13 09:06:58 joytest systemd[1]: Starting MariaDB database server...
>>>>>> Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe
>>>>>> Logging
>>>>>> to
>>>>>> '/var/log/mariadb/mariadb.log'.
>>>>>> Aug 13 09:06:58 joytest mysqld_safe[19870]: 170813 09:06:58 mysqld_safe
>>>>>> Starting
>>>>>> mysqld daemon with databases from /var/lib/mariadb/mysql
>>>>>> Aug 13 09:07:00 joytest systemd[1]: mariadb.service: control process exited,
>>>>>> code=exited status=1
>>>>>> Aug 13 09:07:00 joytest systemd[1]: Failed to start MariaDB database server.
>>>>>> Aug 13 09:07:00 joytest systemd[1]: Unit mariadb.service entered failed state.
>>>>>> Aug 13 09:07:00 joytest systemd[1]: mariadb.service failed.
>>>>>> [root@joytest mariadb]# btrfs sub list .
>>>>>> ID 313 gen 220 top level 5 path mysql_201708070830
>>>>>> ID 316 gen 199 top level 5 path mysql_201708080830
>>>>>> ID 325 gen 225 top level 5 path mysql
>>>>>> [root@joytest mariadb]#
>>>>>>
>>>>>> - The most recent good snapshot pair, which rsync shows origin and
>>>>>> destination match, is mysql_201708080830 so you can keep that one on
>>>>>> both sides.
>>>>>>
>>>>>> [root@backuplogC7 ~]# btrfs sub list /var/lib/mariadb
>>>>>> ID 257 gen 538 top level 5 path mysql
>>>>>> ID 316 gen 498 top level 5 path mysql_201708060830
>>>>>> ID 317 gen 503 top level 5 path mysql_201708070830
>>>>>> ID 318 gen 507 top level 5 path mysql_201708080830
>>>>>> ID 319 gen 514 top level 5 path mysql_201708090830
>>>>>> ID 320 gen 524 top level 5 path mysql_201708100830
>>>>>> ID 321 gen 529 top level 5 path mysql_201708110830
>>>>>> ID 322 gen 533 top level 5 path mysql_201708120830
>>>>>> ID 323 gen 538 top level 5 path mysql_201708130830
>>>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708070830/
>>>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708070830/
>>>>>> sending incremental file list
>>>>>> ./
>>>>>>
>>>>>> sent 3773 bytes  received 19 bytes  842.67 bytes/sec
>>>>>> total size is 718361496  speedup is 189441.32 (DRY RUN)
>>>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708080830/
>>>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708080830/
>>>>>> sending incremental file list
>>>>>> ./
>>>>>>
>>>>>> sent 3769 bytes  received 19 bytes  841.78 bytes/sec
>>>>>> total size is 718361496  speedup is 189641.37 (DRY RUN)
>>>>>> [root@backuplogC7 ~]# date
>>>>>> Sun Aug 13 10:34:05 ICT 2017
>>>>>> [root@backuplogC7 ~]#
>>>>>>
>>>>>> - manually do incremental send/receive, starting with
>>>>>> mysql_201708090830/, to make the destination current again with the
>>>>>> origin.
>>>>>>
>>>>>> [root@backuplogC7 ~]# btrfs send -p /var/lib/mariadb/mysql_201708080830
>>>>>> /var/lib/mariadb/mysql_201708090830 | ssh 192.168.45.166 btrfs receive
>>>>>> /var/lib/mariadb
>>>>>> At subvol /var/lib/mariadb/mysql_201708090830
>>>>>> At snapshot mysql_201708090830
>>>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830/
>>>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708090830/
>>>>>> sending incremental file list
>>>>>> ./
>>>>>> ib_logfile1
>>>>>> ibdata1
>>>>>>
>>>>>> sent 3779 bytes  received 25 bytes  507.20 bytes/sec
>>>>>> total size is 718361496  speedup is 188843.72 (DRY RUN)
>>>>>> [root@backuplogC7 ~]#
>>>>>>
>>>>>> Best Regards,
>>>>>>
>>>>>> Siranee Jaraswachirakul.
>>>>>>
>>>>>>> On Sat, Aug 12, 2017 at 8:20 PM,  <siranee.ja@tpc.co.th> wrote:
>>>>>>>
>>>>>>>> [root@backuplogC7 ~]# rsync -avnc /var/lib/mariadb/mysql_201708090830
>>>>>>>> root@192.168.45.166://var/lib/mariadb/mysql_201708090830
>>>>>>> You need trailing / for the first directory with -a option.
>>>>>>>
>>>>>>> rsync -a dir dir
>>>>>>>
>>>>>>> is not the same command as
>>>>>>>
>>>>>>> rsync -a dir/ dir
>>>>>>>
>>>>>>> It's confusing but your command is trying to create mysql_201708090830
>>>>>>> directory on the source, in the mysql_201708090830 on the destination.
>>>>>>> That is why everything mismatches. To make it mean "contents of" you
>>>>>>> need trailing slash on at least the origin.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Chris Murphy
>>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>
>>>
>>
>>
>
>
>


