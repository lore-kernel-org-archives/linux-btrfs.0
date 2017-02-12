Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33757 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdBLBRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 20:17:08 -0500
Received: by mail-lf0-f68.google.com with SMTP id x1so5758252lff.0
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Feb 2017 17:17:07 -0800 (PST)
MIME-Version: 1.0
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Sun, 12 Feb 2017 01:17:06 +0000
Message-ID: <CAKinxcUt24bFWUAVesbLpZDifa3gxVTvKVbk9TAvHRWedkjLAg@mail.gmail.com>
Subject: FS gives kernel UPS on attempt to create snapshot and after running
 balance it's unmountable.
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

So my main storage filesystem got some sort of veird corruption (that
I can gather). Everything seems to work OK, but when I try to create a
snapshot or run balance (no filters) it will get remounted read only.

Fun part is that balance seems to be running even on read only FS, and
I continuously get kernel traces in /var/log/messages .... so it might
as well in the back ground silently eat my data away :/


UPDATE:

Yeah, after rebooting the system it does not even mount the FS,
mount.btrfs sits in some sort of spinlock and consumes 100% of singe
core.



UPDATE 2:

System is completelly cooked :/

[root@server ~]# btrfs fi show
Label: 'rockstor_server'  uuid: 5581a647-40ef-4a7a-9d73-847bf35a142b
    Total devices 1 FS bytes used 5.72GiB
    devid    1 size 53.17GiB used 7.03GiB path /dev/sda2

Label: 'broken_pool'  uuid: 26095277-a234-455b-8c97-8dac8ad934c8
    Total devices 2 FS bytes used 193.52GiB
    devid    1 size 1.82TiB used 196.03GiB path /dev/sdb
    devid    2 size 1.82TiB used 196.03GiB path /dev/sdi

Label: 'main_pool'  uuid: 0576d577-8954-4a60-a02b-9492b3c29318
    Total devices 8 FS bytes used 5.83TiB
    devid    1 size 1.82TiB used 1.50TiB path /dev/sdc
    devid    2 size 1.82TiB used 1.50TiB path /dev/sdd
    devid    3 size 1.82TiB used 1.50TiB path /dev/sde
    devid    4 size 1.82TiB used 1.50TiB path /dev/sdf
    devid    5 size 1.82TiB used 1.50TiB path /dev/sdg
    devid    6 size 1.82TiB used 1.50TiB path /dev/sdh
    devid    7 size 1.82TiB used 1.50TiB path /dev/sdj
    devid    8 size 1.82TiB used 1.50TiB path /dev/sdk

[root@server ~]# mount /dev/sdc /mnt2/main_pool/
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
[root@server ~]# mount /dev/sdd /mnt2/main_pool/
mount: wrong fs type, bad option, bad superblock on /dev/sdd,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
[root@server ~]# mount /dev/sde /mnt2/main_pool/
mount: wrong fs type, bad option, bad superblock on /dev/sde,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


dmesg tail retuns:
[ 9507.835629] systemd-udevd[1873]: Validate module index
[ 9507.835656] systemd-udevd[1873]: Check if link configuration needs reloading.
[ 9507.835690] systemd-udevd[1873]: seq 3698 queued, 'add' 'bdi'
[ 9507.835873] systemd-udevd[1873]: seq 3698 forked new worker [13858]
[ 9507.836202] BTRFS info (device sdd): disk space caching is enabled
[ 9507.836204] BTRFS info (device sdd): has skinny extents
[ 9507.836322] systemd-udevd[13858]: seq 3698 running
[ 9507.836443] systemd-udevd[13858]: no db file to read
/run/udev/data/+bdi:btrfs-4: No such file or directory
[ 9507.836474] systemd-udevd[13858]: RUN '/bin/mknod
/dev/btrfs-control c 10 234' /etc/udev/rules.d/64-btrfs.rules:1
[ 9507.837366] systemd-udevd[13861]: starting '/bin/mknod
/dev/btrfs-control c 10 234'
[ 9507.837833] BTRFS error (device sdd): failed to read the system array: -5
[ 9507.838231] systemd-udevd[13858]: '/bin/mknod /dev/btrfs-control c
10 234'(err) '/bin/mknod: '/dev/btrfs-control': File exists'
[ 9507.838262] systemd-udevd[13858]: '/bin/mknod /dev/btrfs-control c
10 234' [13861] exit with return code 1
[ 9507.854757] BTRFS: open_ctree failed
[ 9511.370878] BTRFS info (device sdd): disk space caching is enabled
[ 9511.370881] BTRFS info (device sdd): has skinny extents
[ 9511.375097] BTRFS error (device sdd): failed to read the system array: -5
[ 9511.392792] BTRFS: open_ctree failed
[ 9514.233627] BTRFS: device label main_pool devid 3 transid 150680 /dev/sde
[ 9514.234399] systemd-udevd[1873]: Validate module index
[ 9514.234431] systemd-udevd[1873]: Check if link configuration needs reloading.
[ 9514.234465] systemd-udevd[1873]: seq 3702 queued, 'add' 'bdi'
[ 9514.234522] systemd-udevd[1873]: passed 142 bytes to netlink
monitor 0x5628f65d40d0
[ 9514.234554] systemd-udevd[13882]: seq 3702 running
[ 9514.234780] systemd-udevd[13882]: no db file to read
/run/udev/data/+bdi:btrfs-6: No such file or directory
[ 9514.234790] BTRFS info (device sde): disk space caching is enabled
[ 9514.234792] BTRFS info (device sde): has skinny extents
[ 9514.234798] systemd-udevd[13882]: RUN '/bin/mknod
/dev/btrfs-control c 10 234' /etc/udev/rules.d/64-btrfs.rules:1
[ 9514.235181] systemd-udevd[13906]: starting '/bin/mknod
/dev/btrfs-control c 10 234'
[ 9514.236448] systemd-udevd[13882]: '/bin/mknod /dev/btrfs-control c
10 234'(err) '/bin/mknod: '/dev/btrfs-control': File exists'
[ 9514.236514] systemd-udevd[13882]: '/bin/mknod /dev/btrfs-control c
10 234' [13906] exit with return code 1
[ 9514.238726] BTRFS error (device sde): failed to read the system array: -5
[ 9514.255472] BTRFS: open_ctree failed
