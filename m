Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35026 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdA2PjH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 10:39:07 -0500
Received: by mail-qk0-f195.google.com with SMTP id u25so15434499qki.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jan 2017 07:37:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
From: Subscription Account <4subsacct+btrfs@gmail.com>
Date: Sun, 29 Jan 2017 10:37:52 -0500
Message-ID: <CAHMMHbe0MB0cVu9-tQgKu9pKpHqOrBx8bSKqF6fdDGvVqPRpTw@mail.gmail.com>
Subject: Re: Raid1 won't mount degraded
To: Subscription Account <4subsacct+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I try to run any of the commands like init-csum-tree etc the
btrfs program core dumps. Here is an example

root@NAS:/root# btrfsck --init-csum-tree /dev/sdb1
Creating a new CRC tree
warning, device 2 is missing
parent transid verify failed on 8388608 wanted 136966 found 136967
parent transid verify failed on 8388608 wanted 136966 found 136967
Ignoring transid failure
Checking filesystem on /dev/sdb1
UUID: f89c12fb-2304-4dce-bed5-fda008b86bde
Reinitialize checksum tree
extent-tree.c:2703: btrfs_reserve_extent: BUG_ON `ret` triggered, value -28
btrfs check[0x44e371]
btrfs check(btrfs_reserve_extent+0xbc6)[0x4540e6]
btrfs check(btrfs_alloc_free_block+0x5a)[0x45415c]
btrfs check[0x41d788]
btrfs check(cmd_check+0x1270)[0x430633]
btrfs check(main+0x155)[0x40a813]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f4a89555830]
btrfs check(_start+0x29)[0x40a409]
Aborted (core dumped)




On Sun, Jan 29, 2017 at 8:12 AM, Subscription Account
<4subsacct+btrfs@gmail.com> wrote:
> Hi,
>
> I had to remove one disk from raid 1 and I rebooted the system and was
> able to mount in degraded mode. Then I powered off the system added a
> new disk and when I am trying to mount the btrfs filesystem in
> degraded mode it will no longer mount it read-write. I can mount
> read-only though.
>
> I tried running btrfs-zero-log as well and that gices a core dump.
>
> My system details as follows:
>
> rajeev@NAS:~$ uname -a
> Linux NAS 4.4.0-59-generic #80-Ubuntu SMP Fri Jan 6 17:47:47 UTC 2017
> x86_64 x86_64 x86_64 GNU/Linux
>
> root@NAS:~# btrfs --version
> Btrfs v3.12
>
> root@NAS:~# btrfs fi show
> Label: none  uuid: f89c12fb-2304-4dce-bed5-fda008b86bde
>         Total devices 2 FS bytes used 2.49TiB
>         devid    1 size 2.73TiB used 2.52TiB path /dev/sdb1
>         *** Some devices missing
>
> Btrfs v3.12
>
> root@NAS:~# mount -o degraded /dev/sdb1 /local/nas
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>
> root@NAS:~# dmesg | tail
> [ 2506.816795] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> [ 2506.878031] BTRFS: open_ctree failed
> [ 4590.339548] BTRFS info (device sdb1): allowing degraded mounts
> [ 4590.505739] BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 0, rd
> 90, flush 0, corrupt 0, gen 0
> [ 4609.481310] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> [ 4609.536509] BTRFS: open_ctree failed
> [ 4852.498305] BTRFS info (device sdb1): allowing degraded mounts
> [ 4853.294311] BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 0, rd
> 90, flush 0, corrupt 0, gen 0
> [ 4873.026855] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> [ 4873.083840] BTRFS: open_ctree failed
>
> root@NAS:~# mount -o degraded,ro /dev/sdb1 /local/nas
>
> root@NAS:~# btrfs fi df /local/nas
> Data, RAID1: total=2.51TiB, used=2.49TiB
> Data, single: total=1.01GiB, used=88.27MiB
> System, RAID1: total=8.00MiB, used=352.00KiB
> System, single: total=4.00MiB, used=12.00KiB
> Metadata, RAID1: total=6.00GiB, used=5.01GiB
> Metadata, single: total=8.00MiB, used=3.31MiB
> unknown, single: total=512.00MiB, used=0.00
>
> In the read-only mode I am not able to add a new device or replace :(.
> Please help.
>
> Thanks,
>
> --
> raj
