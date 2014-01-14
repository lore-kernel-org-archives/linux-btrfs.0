Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56292 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaANNVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:21:05 -0500
Received: by mail-qc0-f177.google.com with SMTP id i8so4088521qcq.22
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 05:21:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Jan 2014 14:21:03 +0100
Message-ID: <CAF1_xX3TX0JSEeDOG65p3e5g+R201T7HDkNVjm5zaaetPEhtGg@mail.gmail.com>
Subject: v3.13-rc3 OOPS
From: Ronald <ronald645@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear developers,

I have a 1250MHZ 512MB RAM x86 UP system. It contains several btrfs
partitions on top of LVM mounted with compress=lzo,space_cache,noatime
and some other standard options.

It uses a trimmed custom kernel. The -dirty part in it's name is
because the command 'hostname' was not there at the time of build.

This gave an OOPS. It's typed over from a photo, so please be careful.

------------[ cut here ]------------
kernel BUG at fs/btrfs/async-thread.c:619!
invalid opcode: 0000 [#1]
CPU: 0 PID: 16753 Comm: btrfs-endio-met Not tainted 3.13.0-rc3-dirty #3
Hardware name: MSI MS-6712/MS-6712, BIOS Version 07.00T
task: d2c45440 ti: c0096000 task.ti: c405e000
EIP: 0060:[<c11bd9b1>] EFLAGS: 00010046 CPU: 0
EIP is at btrfs_queue_worker+0x221/0x230
EAX: 00000000 EBX: cdf2256c ECX: 00000286 EDX: cdf22588
ESI: 00000000 EDI: 00000000 EBP: c0097e18 ESP: c0097e00
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 080e0000 CR3: 1132e000 CR4: 000007d0
Stack:
 cdf22588 c41b3e60 cdf22590 cdf22000 d7ef52f4 00000000 c0097e24 c1185e2b
 c77aa3c0 c0097e2c c10d0664 c0097e40 c11b3441 de4b2c00 d339a4f8 00000029
 c0097e48 c10d0664 c0097e80 c13e243e 00000000 c0097e5c c107fabe c0097e70
Call Trace:
 [<c1185e2b>] end_workqueue_bio+0x7b/0xa0
 [<c10d0664>] bio_endio+0x14/0x30
 [<c11b3441>] btrfs_end_bio+0xe1/0x150
 [<c10d0664>] bio_endio+0x14/0x30
 [<c13e243e>] dec_pending+0x11e/0x220
 [<c107fabe>] ? mempool_free_slab+0xe/0x10
 [<c107fa6b>] ? mempool_free+0x2b/0x60
 [<c13e2631>] clone_endio+0x71/0xa0
 [<c10d0664>] bio_endio+0x14/0x30
 [<c1213d5a>] blk_update_request+0x7a/0x2c0
 [<c12127a8>] ? __blk_run_queue+0x28/0x40
 [<c1213fb5>] blk_update_bidi_request+0x15/0x70
 [<c1214030>] blk_end_bidi_request+0x20/0x60
 [<c12140f2>] blk_end_request+0x12/0x20
 [<c1380d43>] scsi_io_completion+0x93/0x5c0
 [<c137b424>] scsi_finish_command+0x84/0xb0
 [<c1380bde>] scsi_softirq_done+0xee/0x120
 [<c103deb7>] ? put_cred_rcu+0x37/0x70
 [<c1218b68>] blk_done_softirq+0x58/0x70
 [<c1027661>] __do_softirq+0xa1/0x180
 [<c10275c0>] ? _local_bh_enable+0x40/0x40
<IRQ>
 [<c1027975>] ? irq_exit+0x95/0xa0
 [<c1003473>] ? do_IRQ+0x43/0xb0
 [<c11fcc70>] ? shm_try_destroy_orphaned+0x40/0x40
 [<c14e91b0>] ? common_interrupt+0x30/0x35
 [<c11fcc70>] ? shm_try_destroy_orphaned+0x40/0x40
 [<c11fcc7a>] ? shm_try_destroy_current+0xa/0x40
 [<c122ca4b>] ? idr_for_each+0xab/0x100
 [<c11fcc70>] ? shm_try_destroy_orphaned+0x40/0x40
 [<c1022b2b>] ? mm_release+0x6b/0xf0
 [<c11fd1d7>] ? exit_shm+0x57/0x60
 [<c1025b3b>] ? do_exit+0x1bb/0x7f0
 [<c11bd9c0>] ? btrfs_queue_worker+0x230/0x230
 [<c1039dee>] ? kthread+0x8e/0xb0
 [<c14e8c77>] ? ret_from_kernel_thread+0x1b/0x28
 [<c1039d60>] ? __kthread_parkme+0x60/0x60
Code: 83 c3 2e 89 59 1c 89 41 20 89 10 e9 e0 fe ff ff 66 90 c7 43 14
01 00 00 00 8b 73 24 8d 53 1c 8b 43 1c e?b bf 8b 75 f0 31 c?0 eb bc
<0f> 0b 8d
 b6 00 00 00 00 8d bc 27 00 00 00 00 55 8b 0d dc 01 61
EIP: [<c11bd9b1>] btrfs_queue_worker+0x221/0x230 SS:ESP 0068:c0097e00
Kernel panic - not syncing: Fatal exception in interrupt
drm_kms_helper: panic occurred, switching back to text console
