Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33867 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbbKLRxZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 12:53:25 -0500
Received: by lffu14 with SMTP id u14so38748195lff.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 09:53:23 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Nov 2015 09:53:23 -0800
Message-ID: <CAKt7Gh6gRb=BOntmq0t1HSfqE1YCm7K_Mbg+CouKeCED-O7wDg@mail.gmail.com>
Subject: btrfs check error: btrfs_reserve_extent: Assertion `ret` failed.
From: Bryan Olmstead <bolmstead@chfund.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll try and keep this short, so if you would like anymore information
please let me know.  This is a 5 disk raid5 mdadm array used for
offsite backup.  There is no backup of it, it is the backup.  :)  I
would just like to save it if possible since it takes quite a long to
time to do the initial backup if it ends up lost.

root@nas:/home/olmstead/tempwatch# btrfs fi show
Label: none  uuid: eb0fcdf0-f8be-4d8d-9c62-02b1b01c2642
        Total devices 1 FS bytes used 1.94TiB
        devid    1 size 2.73TiB used 2.09TiB path /dev/mapper/md0

btrfs-progs v4.3

root@nas:~/scripts/raid# uname -a
Linux nas 4.1.12 #1 SMP PREEMPT Sun Nov 8 11:49:53 PST 2015 x86_64 AMD
Phenom(tm) 9600 Quad-Core Processor AuthenticAMD GNU/Linux


After a few days of trying to figure out why the kernel kept oopsing
(and it didn't appear to be btrfs related) and much searching I found
out that some ram had gone bad.  After fixing this I started to try
and fix the problems I'd found that had developed in the btrfs fs I
have.  At first it was many uncorrectable crc errors (reported by
btrfs check and btrfs scrub).  After much seraching and running the
various utilities I found a thread that talked about what the various
repair/check/fix commands do and in order of use:

  https://mail-archive.com/linux-btrfs%40vger.kernel.org/msg37929.html

I ran these again from top down and am at the point of:

root@nas:~/scripts/raid# btrfs check --repair --init-csum-tree
--init-extent-tree /dev/mapper/md0
enabling repair mode
Creating a new CRC tree
Checking filesystem on /dev/mapper/md0
UUID: eb0fcdf0-f8be-4d8d-9c62-02b1b01c2642
Creating a new extent tree
Failed to find [1407100010496, 168, 16384]
btrfs unable to find ref byte nr 1407100010496 parent 0 root 1  owner 1 offset 0
Failed to find [1572461953024, 168, 16384]
btrfs unable to find ref byte nr 1572461953024 parent 0 root 1  owner 0 offset 1
parent transid verify failed on 29442048 wanted 4 found 41583
Ignoring transid failure
Reinit crc root
extent-tree.c:2694: btrfs_reserve_extent: Assertion `ret` failed.
btrfs[0x442081]
btrfs(btrfs_reserve_extent+0xb88)[0x447879]
btrfs(btrfs_alloc_free_block+0x57)[0x447921]
btrfs[0x43a864]
btrfs(btrfs_search_slot+0x1334)[0x43c72b]
btrfs(btrfs_csum_file_block+0x352)[0x44c5a4]
btrfs[0x41c4dd]
btrfs(cmd_check+0x119c)[0x429bb8]
btrfs(main+0x155)[0x40a3b9]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f1a3136fea5]
btrfs[0x409f19]

Thank you in advance,

Bryan
