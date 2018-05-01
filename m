Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:40098 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbeEAIri (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 1 May 2018 04:47:38 -0400
Date: Tue, 1 May 2018 10:47:09 +0200
From: Jan Fajerski <jfajerski@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: stack trace during scrub
Message-ID: <20180501084709.cfu2mqayubq36er7@jf_suse_laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The system has multiple btrfs filesystems (RAID1 and single device). During last 
nights scrub the kernel logged the following stack trace about 1.5h into the 
scrub:

May 01 03:29:27 apollo kernel: ------------[ cut here ]------------
May 01 03:29:27 apollo kernel: WARNING: CPU: 1 PID: 24395 at /build/linux-3RM5ap/linux-4.14.13/fs/btrfs/ctree.h:1564 btrfs_update_devi
May 01 03:29:27 apollo kernel: Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs dm_mod ext4 crc16 mbcache jbd
May 01 03:29:27 apollo kernel:  sg battery rc_core ipmi_msghandler tpm_crb video shpchp button acpi_pad sunrpc coretemp ip_tables x_ta
May 01 03:29:27 apollo kernel: CPU: 1 PID: 24395 Comm: btrfs Not tainted 4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
May 01 03:29:27 apollo kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./E3C224D4I-14S, BIOS P3.20 05/29/2015
May 01 03:29:27 apollo kernel: task: ffff9330eacad1c0 task.stack: ffffa55acc6ec000
May 01 03:29:27 apollo kernel: RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
May 01 03:29:27 apollo kernel: RSP: 0018:ffffa55acc6efa18 EFLAGS: 00010206
May 01 03:29:27 apollo kernel: RAX: 0000000000000fff RBX: ffff932f75fdc2a0 RCX: 000002baa1371e00
May 01 03:29:27 apollo kernel: RDX: 0000000000001000 RSI: 0000000000003efa RDI: ffff93303754d7a8
May 01 03:29:27 apollo kernel: RBP: ffff93310f0bc000 R08: ffffa55acc6ef9c8 R09: ffffa55acc6ef9d0
May 01 03:29:27 apollo kernel: R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
May 01 03:29:27 apollo kernel: R13: 0000000000003eda R14: ffff93303754d7a8 R15: 00000000fffffff4
May 01 03:29:27 apollo kernel: FS:  00007f89d4c37700(0000) GS:ffff93311fd00000(0000) knlGS:0000000000000000
May 01 03:29:27 apollo kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 01 03:29:27 apollo kernel: CR2: 00007f23b69ed0a0 CR3: 0000000190c76002 CR4: 00000000000606e0
May 01 03:29:27 apollo kernel: Call Trace:
May 01 03:29:27 apollo kernel:  btrfs_finish_chunk_alloc+0x122/0x4a0 [btrfs]
May 01 03:29:27 apollo kernel:  ? btrfs_insert_item+0x7e/0xf0 [btrfs]
May 01 03:29:27 apollo kernel:  btrfs_create_pending_block_groups+0x144/0x250 [btrfs]
May 01 03:29:27 apollo kernel:  __btrfs_end_transaction+0x8e/0x2e0 [btrfs]
May 01 03:29:27 apollo kernel:  btrfs_inc_block_group_ro+0xcd/0x160 [btrfs]
May 01 03:29:27 apollo kernel:  scrub_enumerate_chunks+0x1f7/0x620 [btrfs]
May 01 03:29:27 apollo kernel:  ? remove_wait_queue+0x60/0x60
May 01 03:29:27 apollo kernel:  btrfs_scrub_dev+0x227/0x560 [btrfs]
May 01 03:29:27 apollo kernel:  ? __check_object_size+0xb3/0x190
May 01 03:29:27 apollo kernel:  btrfs_ioctl+0x134e/0x24e0 [btrfs]
May 01 03:29:27 apollo kernel:  ? kmem_cache_alloc_node+0x13b/0x5a0
May 01 03:29:27 apollo kernel:  ? do_vfs_ioctl+0x9f/0x600
May 01 03:29:27 apollo kernel:  do_vfs_ioctl+0x9f/0x600
May 01 03:29:27 apollo kernel:  ? get_task_io_context+0x43/0x80
May 01 03:29:27 apollo kernel:  SyS_ioctl+0x74/0x80
May 01 03:29:27 apollo kernel:  system_call_fast_compare_end+0xc/0x6f
May 01 03:29:27 apollo kernel: RIP: 0033:0x7f89d6d1cdd7
May 01 03:29:27 apollo kernel: RSP: 002b:00007f89d4c36d58 EFLAGS: 00000246
May 01 03:29:27 apollo kernel: Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 26 24 ff ff 4c 89 f7 e8 de f7 fc ff e9 de fe ff ff 4
May 01 03:29:27 apollo kernel: ---[ end trace 502b81f0556393a0 ]---
May 01 03:29:27 apollo kernel: ------------[ cut here ]------------

Everything seems to function normally, the scrub finished seemingly fine and no 
scrub errors where logged.

