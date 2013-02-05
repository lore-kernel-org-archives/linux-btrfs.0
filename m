Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45670 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3BEXfS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 18:35:18 -0500
Received: by mail-oa0-f44.google.com with SMTP id h1so884173oag.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 15:35:18 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Feb 2013 15:35:15 -0800
Message-ID: <CAOOVQY+pXRQgfx2U0U31sodKYwqPDwu9wkZ6a7=CEyBcy4X0YA@mail.gmail.com>
Subject: Kernel Panic while defragging a large file
From: Chris Kastorff <encryptio@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs volume spread over three 3TB disks, RAID1 data and metadata.

The machine is old and underpowered; a 32-bit Atom box with 2GB of RAM.

On it is a 1TB sparse file which is a dm-crypt volume containing an
ext4 filesystem. For the past few months, I've been writing very
slowly to the inner ext4 filesystem (~20KB/s.)

I have not been running with autodefrag, so this file is very heavily
fragmented (259627 extents according to filefrag.)

The box is running the latest archlinux kernel:
$ uname -a
Linux cracker 3.7.5-1-ARCH #1 SMP PREEMPT Mon Jan 28 10:38:12 CET 2013
i686 GNU/Linux

And the latest btrfs-progs in archlinux (forever v0.19 (ugh))

Running:
btrfs fi defrag /media/lake/pu9

Results in work for about 15 seconds, then several kernel BUGs over a
short period, followed soon after by a kernel panic.

There are several scattered "wrong amount of free space" messages
before this, which I assume are the result of previous crashes and are
harmless.

Note: this trace has some long lines truncated due to journalctl
truncating by default. If desired, I can reproduce while telling
journalctl not to truncate. Also, gmail might hard-wrap others (ugh.)

block group 8580959109120 has an wrong amount of free space
btrfs: failed to load free space cache for block group 8580959109120
BUG: unable to handle kernel paging request at 80000829
IP: [<c022f968>] __kmalloc+0x58/0x160
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: nfsd auth_rpcgss nfs_acl tun ext4 crc16 jbd2
mbcache sha... i2c_a
 pata_acpi ata_piix uhci_hcd libata scsi_mod ehci_hcd usbcore usb_common
Pid: 1149, comm: btrfs-worker-4 Tainted: G           O 3.7.5-1-ARCH #1
ASUS.../1000H
EIP: 0060:[<c022f968>] EFLAGS: 00010282 CPU: 1
EIP is at __kmalloc+0x58/0x160
EAX: 00000000 EBX: ef638000 ECX: 80000829 EDX: 0000a341
ESI: c0723f50 EDI: f5802480 EBP: f035be88 ESP: f035be60
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 80000829 CR3: 3015a000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process btrfs-worker-4 (pid: 1149, ti=f035a000 task=f0072530 task.ti=f035a000)
Stack:
 f035bec8 f871f909 f4c2e800 f86eb754 000000e0 00008050 80000829 ef638000
 00000000 00000000 f035bee4 f86eb754 e6f42780 eff90c00 f32b7d01 f1665dc4
 eff90de0 00000000 f32b7c00 f4c2ef80 efc0c480 802a001f 00000000 00000000
Call Trace:
 [<f871f909>] ? btrfs_map_bio+0x179/0x240 [btrfs]
 [<f86eb754>] ? btrfs_csum_one_bio+0x54/0x2e0 [btrfs]
 [<f86eb754>] btrfs_csum_one_bio+0x54/0x2e0 [btrfs]
 [<f86fa3df>] __btrfs_submit_bio_start+0x2f/0x40 [btrfs]
 [<f86ee1dd>] run_one_async_start+0x3d/0x60 [btrfs]
 [<f8722ac3>] worker_loop+0xe3/0x480 [btrfs]
 [<c0164365>] ? __wake_up_common+0x45/0x70
 [<f87229e0>] ? btrfs_queue_worker+0x2b0/0x2b0 [btrfs]
 [<c015b2f4>] kthread+0x94/0xa0
 [<c0160000>] ? hrtimer_start+0x30/0x30
 [<c04fdbf7>] ret_from_kernel_thread+0x1b/0x28
 [<c015b260>] ? kthread_freezable_should_stop+0x50/0x50
Code: 89 c7 76 63 8b 4d 04 89 4d e4 8b 07 64 03 05 f4 e6 71 c0 8b 50
04 8b ... cb 8b
EIP: [<c022f968>] __kmalloc+0x58/0x160 SS:ESP 0068:f035be60
CR2: 0000000080000829
---[ end trace 8efd563dc8ae9b53 ]---

Several other kernel BUG lines and stack traces about "unable to
handle paging request at %x" occur soon after, on various PIDs and
various stack traces (including some from a writev to a socket, a
fairly well-tested operation.)

Eventually (~10 seconds) the kernel panics. My screen is too small to
see the whole message, but I can probably scrounge it up with some
effort if that's desired.

This feels like a kernel running out of ram problem. I'm running rsync
-avPS to defragment the file more manually, but will keep the old
version around in case further testing is desired.

    -Chris K
