Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.a-tech.co.th ([202.149.98.155]:44290 "EHLO tpcorp.co.th"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752245AbdHNCEZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 22:04:25 -0400
Message-ID: <1646.49.228.115.25.1502676263.squirrel@mail>
In-Reply-To: <CAJCQCtSQWt51877J42bxF=4i66_axarS9JoKLYC4ub_teSyRww@mail.gmail.com>
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
    <CAJCQCtSQWt51877J42bxF=4i66_axarS9JoKLYC4ub_teSyRww@mail.gmail.com>
Date: Mon, 14 Aug 2017 09:04:23 +0700 (ICT)
Subject: Re: btrfs issue with mariadb incremental backup
From: siranee.ja@tpc.co.th
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "A L" <crimsoncottage@gmail.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=tis-620
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thank you very much for your suggestion.

I didn't remember which steps that I made a mistake and made the mysql had Received
UUID.

I have done the following and it work as it should be right now.

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


Best Regards,
Siranee Jaraswachirakul.






> On Sun, Aug 13, 2017 at 4:52 AM,  <siranee.ja@tpc.co.th> wrote:
>> Hi "A L",
>>
>> [root@backuplogC7 ~]# btrfs sub show /var/lib/mariadb/mysql
>> /var/lib/mariadb/mysql
>>         Name:                   mysql
>>         UUID:                   92f319c5-e132-3249-9b13-d39ee77a2b44
>>         Parent UUID:            -
>>         Received UUID:          3ad0334a-4063-654c-add6-b1cbcdeaa639
>>         Creation time:          2017-06-21 13:27:41 +0700
>>         Subvolume ID:           257
>>         Generation:             539
>>         Gen at creation:        9
>>         Parent ID:              5
>>         Top level ID:           5
>>         Flags:                  -
>>         Snapshot(s):
>>                                 mysql_201708060830
>>                                 mysql_201708070830
>>                                 mysql_201708080830
>>                                 mysql_201708090830
>>                                 mysql_201708100830
>>                                 mysql_201708110830
>>                                 mysql_201708120830
>>                                 mysql_201708130830
>>
>> yes I think it has Received UUID because I restored the source from snapshot
>> mysql_201708040830 for prove that the local snapshot was work.
>>
>> How to clear the Received UUID ?
>> What to do next?
>
>
> I'm using btrfs-progs 4.12, and I just did a btrfs send/receive from
> file system A to B; and then on B I took a rw snapshot of the ro
> snapshot. The ro snapshot has Received UUID, but the rw snapshot made
> from it does not have Received UUID. So now I'm confused how you have
> a rw snapshot with Received UUID set.
>
>
> Did you ever use 'btrfs property set' to change a ro snapshot to rw?
> That's the only way I can think it's possible. The only other thing is
> maybe the behavior has changed since btrfs-progs 4.4.
>
> It is possible this behavior has changed since btrfs-progs 4.4. The
> changelogs shows there are improvements in send/receive in particular
> 4.8.3 and 4.8.4, but also others. I have no idea which are related.
> But anyway, this is one of the reasons why the expert users on this
> almost always say use something newer because it's just too hard to
> remember, even with changelogs, what's fixed and where.
>
> My suggestion is to investigate moving to kernel 4.9 series; and it
> should be safe to move to btrfs-progs 4.12 now. Any new features in
> 4.12 that can't be supported with an older kernel should fail
> gracefully.
>
> No matter what, you must have separate backups. You can't depend
> exclusively on one backup, no matter the method. It's fine to use
> send/receive for backup1. But backup2 should be a conventional backup,
> e.g. XFS with rsync. Basically this is a game of risk and the more
> independent backups you have, the more failure cases (especially user
> error) you can recover from, at the expense of some complexity.
>
>
>
> --
> Chris Murphy
>


