Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51955 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbdAWNQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 08:16:01 -0500
Received: from [10.0.0.4] ([178.190.95.118]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lwnem-1cTiey2AG0-016S5R for
 <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 14:15:56 +0100
To: linux-btrfs@vger.kernel.org
From: Simon Waid <simon_waid@gmx.net>
Subject: RAID5: btrfs rescue chunk-recover segfaults.
Message-ID: <55a30f16-3793-ebac-68a5-d377b023a91e@gmx.net>
Date: Mon, 23 Jan 2017 14:15:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I have a btrfs raid5 array that has become unmountable. When trying to
mount dmesg containes the following:

[ 5686.334384] BTRFS info (device sdb): disk space caching is enabled
[ 5688.377244] BTRFS info (device sdb): bdev /dev/sdb errs: wr 2517, rd
77, flush 0, corrupt 0, gen 0
[ 5688.377254] BTRFS info (device sdb): bdev /dev/sdc errs: wr 0, rd 0,
flush 0, corrupt 10, gen 0
[ 5688.377261] BTRFS info (device sdb): bdev /dev/sdd1 errs: wr 0, rd 0,
flush 0, corrupt 5, gen 0
[ 5688.377268] BTRFS info (device sdb): bdev /dev/sde errs: wr 21, rd
8807, flush 0, corrupt 0, gen 0
[ 5688.744249] BTRFS error (device sdb): parent transid verify failed on
16227387371520 wanted 88711 found 88395
[ 5689.533817] BTRFS error (device sdb): parent transid verify failed on
16227388260352 wanted 88711 found 88395
[ 5689.609355] BTRFS error (device sdb): parent transid verify failed on
16227415158784 wanted 88711 found 88397
[ 5689.627715] BTRFS error (device sdb): parent transid verify failed on
16227415158784 wanted 88711 found 88397
[ 5689.627731] BTRFS error (device sdb): failed to read block groups: -5
[ 5689.675017] BTRFS error (device sdb): open_ctree failed

I tried to recover from the problem using:

btrfs rescue chunk-recover -v /dev/sdb

The command runs for a few minutes. Then it segfaults. I used gdb to
debug. This is the backtrace:

Starting program: btrfs-progs/btrfs rescue chunk-recover -v /dev/sdb
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
All Devices:
     Device: id = 4, name = /dev/sde
     Device: id = 1, name = /dev/sdd1
     Device: id = 2, name = /dev/sdc
     Device: id = 3, name = /dev/sdb

[New Thread 0x7ffff6f6e700 (LWP 8155)]
[New Thread 0x7ffff676d700 (LWP 8156)]
[New Thread 0x7ffff5f6c700 (LWP 8157)]
[New Thread 0x7ffff576b700 (LWP 8158)]
Scanning: 24603734016 in dev0, 32581337088 in dev1, 37911248896 in dev2,
32217350144 in dev3
Thread 2 "btrfs" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff6f6e700 (LWP 8155)]
btrfs_new_device_extent_record (leaf=leaf@entry=0x7ffff00008c0,
key=key@entry=0x7ffff6f6dc90, slot=slot@entry=12)
     at cmds-check.c:6656
6656        rec->chunk_objecteid =
(gdb) backtrace
#0  btrfs_new_device_extent_record (leaf=leaf@entry=0x7ffff00008c0,
key=key@entry=0x7ffff6f6dc90, slot=slot@entry=12)
     at cmds-check.c:6656
#1  0x00000000004370d2 in process_device_extent_item (slot=12,
key=0x7ffff6f6dc90, leaf=0x7ffff00008c0,
     devext_cache=0x7fffffffe410) at chunk-recover.c:332
#2  extract_metadata_record (rc=rc@entry=0x7fffffffe3c0,
leaf=leaf@entry=0x7ffff00008c0) at chunk-recover.c:727
#3  0x000000000043759b in scan_one_device (dev_scan_struct=0x6ae420) at
chunk-recover.c:807
#4  0x00007ffff733f6ba in start_thread (arg=0x7ffff6f6e700) at
pthread_create.c:333
#5  0x00007ffff707582d in clone () at
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Information about the system:

uname -a: Linux 4.10.0-041000rc4-generic #201701152031 SMP Mon Jan 16
01:33:39 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs --version: v4.9 (from
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git)
sudo btrfs fi show
Label: none  uuid: a27cc0cf-1665-43ba-8c63-bf236d31fcd2
     Total devices 4 FS bytes used 6.51TiB
     devid    1 size 2.73TiB used 2.73TiB path /dev/sdd1
     devid    2 size 7.28TiB used 2.73TiB path /dev/sdc
     devid    3 size 3.64TiB used 3.56TiB path /dev/sdb
     devid    4 size 1.82TiB used 1.46TiB path /dev/sde
btrfs fi df wont work as the filesystem is not mountable.

Any help would be appreciated!

Best regards,
Simon


PS: I'd also like to mention how the raid array became unmountable.

The system I was running at that time was:
Kernel: 4.8.0-34 generic #36~16.04.1 Ubuntu SMP
btrfs-progs --version: v4.4

- I issued a replace command on disk 2. During the replace, disc 4 was
disconnected. I noticed it and rebooted the system just a few second
after the event. After the reboot, the replace continued and eventually
finished. However, dmesg would showed errors like: parent transid verify
failed on 16227387371520 wanted 88711 found 88395.

- I issued a resize command on the new drive to free additional space:
btrfs resize 2:max, which completed without errors.

- I issued a balance without any filters in the hope it would correct
the "parent transid verify failed" errors. The balance started normally.
However, after about one hour, I saw that no I/O would happen and lots
of errors appeared in dmesg. I tried to reboot but the command had no
effect, so disconnected the PC from the power supply.

I have attached the dmesg for the resize and balance operations.



