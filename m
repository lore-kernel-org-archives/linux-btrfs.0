Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36054 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbcIVM6D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 08:58:03 -0400
Received: by mail-lf0-f52.google.com with SMTP id g62so66276536lfe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 05:58:02 -0700 (PDT)
MIME-Version: 1.0
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Thu, 22 Sep 2016 13:58:00 +0100
Message-ID: <CAKinxcV_hevuT594C0YGdbYHg-dQqodGccnPiOpoD75MQDKL3Q@mail.gmail.com>
Subject: Enabling compression = lzo + defrag + balance grinded system to a
 halt :)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Folks ... it's me again :)

Just a preliminary word of warning - I did backup a data before doing
that, so I can rebuild array back ... just want to present this
problem to you because it's a interesting problem / use case issue /
bug. So please no bitching because I don't bitch either !

So, I got my self a spare server at work (some xeon with ECC ram) and
installed a rockstor on it. it's more or less a vanila centos with
tinny bit of python on top of it to do a GUI. Fair play to them, a
nice automation of terminal tasks ...

Anyway since I've installed a owncloud in docker there, that me and my
colleagues use as a form of backup / exchange of test data between us
(it's a text logs from vehicle CAN bus ... 50mb file usually with zip
compresses down to 2MB) I decided to go with LZO compression.

They have a lot of quirky ways of setting compression per subvolume (I
think it's per directory trick way) but I decided to go the old
fashion mount option.

Did set it, remounted & rebooted for sanity sake and did run:
btrfs defragment -r -v -clzo /mnt2/main_pool/

after a short time (20minutes) it did how ever NOT do anything with
disks - no IO, not physical operation of disks ... disk were just
spinning there and not doing anything.

So I decided to it even more old fashion
btrfs fi balance start /mnt2/main_pool/

Now this did make system virtually not usable ... CPU was stuck at
100%, all docker apps were not accessible BUT balance was chugging
along. I've got roughly 245 GB of occupied space in RAID1 on two 2TB
drives that I was using for this fun project and balance got up to 104
chunks out of 202 considered.

SInce I needed to access docker I performed a
btrfs fi balance cancel/mnt2/main_pool/
and let it finish gracefully. Did reboot afterwards to try to get to
the server and physically do something about it.

BUT, after a reboot system was still performing badly, high CPU
utilisation ... no disk activity for some reason :/ ... but I did
check and after a reboot a balance reappeared - I know that btrfs will
resume balance after reboot but I'm 105% sure that balance did cancel
before I rebooted.
Now, this balance is seems to be stuck for past 12 hours in:
2 out of about 4 chunks balanced (204 considered), 50% left

And what funnier, I did attempt to cancel it 2 hours ago and cancel
command is stuck in one terminal and in another terminal I've got
this:

[root@tevva-server ~]# btrfs balance status /mnt2/main_pool/
Balance on '/mnt2/main_pool/' is running, cancel requested
2 out of about 4 chunks balanced (204 considered),  50% left

So gents:
- before I drop a nuke on this FS and start over, anybody want to use
this as a guinea pig ?
- any way of telling what's going on ?
- any way of telling whenever defragment is working or not ? original
defragment command exited straight away :/



ps. Some data that I know people will ask for:


[root@tevva-server ~]# top
top - 13:56:55 up  1:23,  2 users,  load average: 10.62, 8.58, 8.28
Tasks: 432 total,   4 running, 428 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.1 us, 25.1 sy,  0.0 ni, 74.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 16372092 total, 10027296 free,  3868152 used,  2476644 buff/cache
KiB Swap: 15624188 total, 15624188 free,        0 used. 11973620 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 2476 root      20   0       0      0      0 R 100.0  0.0   4:46.46
kworker/u24:5
 5015 root      20   0       0      0      0 R 100.0  0.0  72:14.08
btrfs-transacti
29799 root      20   0       0      0      0 R 100.0  0.0  23:57.08
kworker/u24:2
    7 root      20   0       0      0      0 S   0.3  0.0   0:17.89 rcu_sched
    9 root      20   0       0      0      0 S   0.3  0.0   0:01.62 rcuos/0
 3187 systemd+  20   0 2440028 346268  14200 S   0.3  2.1   0:27.73 bundle
 4928 root      20   0  562168  49756  11296 S   0.3  0.3   0:17.58
data-collector
19951 root      20   0       0      0      0 S   0.3  0.0   0:00.27 kworker/0:0
20931 systemd+  20   0   18176   3092   2704 S   0.3  0.0   0:00.73
gitlab-unicorn-
25531 root      20   0  157988   4764   3732 R   0.3  0.0   0:00.04 top



[root@tevva-server ~]# btrfs fi df /mnt2/main_pool/
Data, RAID1: total=245.00GiB, used=244.16GiB
System, RAID1: total=32.00MiB, used=64.00KiB
Metadata, RAID1: total=2.00GiB, used=635.42MiB
GlobalReserve, single: total=224.00MiB, used=7.83MiB

[root@tevva-server ~]# btrfs fi show
Label: 'rockstor_tevva-server'  uuid: 1348a9ac-a247-432a-8307-84b5d03c9e62
        Total devices 1 FS bytes used 1.77GiB
        devid    1 size 96.40GiB used 7.06GiB path /dev/sdb3

Label: 'backup_pool'  uuid: c766d968-470c-451c-ab53-59b647c6eb43
        Total devices 3 FS bytes used 61.97GiB
        devid    1 size 1.82TiB used 42.00GiB path /dev/sdf
        devid    2 size 1.82TiB used 42.01GiB path /dev/sde
        devid    3 size 1.82TiB used 42.01GiB path /dev/sdc

Label: 'main_pool'  uuid: 98eff16e-10b2-4e84-a301-3d724b37b6fc
        Total devices 2 FS bytes used 244.79GiB
        devid    1 size 1.82TiB used 247.03GiB path /dev/sdd
        devid    2 size 1.82TiB used 247.03GiB path /dev/sda

[root@tevva-server ~]# uname -a
Linux tevva-server 4.6.0-1.el7.elrepo.x86_64 #1 SMP Mon May 16
10:54:52 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux

[root@tevva-server ~]# btrfs --version
btrfs-progs v4.6
