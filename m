Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:40086 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3D2Kc2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 06:32:28 -0400
Message-ID: <517E4C3A.6020205@jan-o-sch.net>
Date: Mon, 29 Apr 2013 12:32:26 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [BUG] crash after failed mount of btrfs-image
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

tried your btrfs-image tool (which didn't work for me but that's not that
important).

# ~/btrfs-image /dev/sdt1 /var/tmp/janosch.btrfsimage
# mount -o loop /var/tmp/janosch.btrfsimage /mnt/test
mount: you must specify the filesystem type

Doesn't mount, okay. Use -r:

# ~/btrfs-image -r /var/tmp/janosch.btrfsimage /var/tmp/removeme
# mount -o loop /var/tmp/removeme /mnt/test

That failed in open_ctree - probably related. The following loopback mount of a
different dd dump of the same file system lead to a null pointer dereference.

# mount -o loop /var/tmp/janosch.dump /mnt/test

I'm just guessing, should btrfs-image patch the uuid in the blocks and generate
a fresh one?

<1>[ 2287.927943] BUG: unable to handle kernel
<6>[ 2287.927944] SysRq : Changing Loglevel
<4>[ 2287.927945] Loglevel set to 3
<4>[ 2288.061561] NULL pointer dereference at 00000000000001e8
<1>[ 2288.061563] IP: [<ffffffffa048da30>] start_transaction+0x20/0x4f0 [btrfs]
<4>[ 2288.143091] PGD 232f5c067 PUD 2279dd067 PMD 0
<4>[ 2288.143094] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
<4>[ 2288.143098] Modules linked in: btrfs raid6_pq xor mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
<4>[ 2288.143104] CPU 2
<4>[ 2288.143107] Pid: 22375, comm: btrfs-qgroup-re Not tainted 3.8.0+ #15 Supermicro X8SIL/X8SIL
<4>[ 2288.143109] RIP: 0010:[<ffffffffa048da30>]  [<ffffffffa048da30>] start_transaction+0x20/0x4f0 [btrfs]
<4>[ 2288.143122] RSP: 0018:ffff880232d79c28  EFLAGS: 00010296
<4>[ 2288.143123] RAX: 0000000000000014 RBX: ffffffffffffffe2 RCX: 0000000000000002
<4>[ 2288.143125] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
<4>[ 2288.143126] RBP: ffff880232d79c78 R08: 0000000000000000 R09: 0000000000000000
<4>[ 2288.143128] R10: 0000000000000001 R11: 000000000000074b R12: ffff880231c31378
<4>[ 2288.143129] R13: ffff880227ce5158 R14: 0000000000000000 R15: ffff880231c31368
<4>[ 2288.143131] FS:  0000000000000000(0000) GS:ffff880236a00000(0000) knlGS:0000000000000000
<4>[ 2288.143133] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[ 2288.143134] CR2: 00000000000001e8 CR3: 000000022fdd0000 CR4: 00000000000007e0
<4>[ 2288.143136] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[ 2288.143137] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[ 2288.143139] Process btrfs-qgroup-re (pid: 22375, threadinfo ffff880232d78000, task ffff880234eb0000)
<4>[ 2288.143140] Stack:
<4>[ 2288.143141]  ffff880200000010 ffff880232d79c98 ffff880232d79c58 0000000000000298
<4>[ 2288.143144]  ffffffffa050658d 00000000fffffff4 ffff880231c31378 ffff880227ce5158
<4>[ 2288.143147]  ffff880232d79dd8 ffff880231c31368 ffff880232d79c88 ffffffffa048e298
<4>[ 2288.143151] Call Trace:
<4>[ 2288.143164]  [<ffffffffa048e298>] btrfs_start_transaction+0x18/0x20 [btrfs]
<4>[ 2288.143180]  [<ffffffffa04ef035>] btrfs_qgroup_rescan_worker+0xd5/0x840 [btrfs]
<4>[ 2288.143184]  [<ffffffff810ec06d>] ? trace_hardirqs_off+0xd/0x10
<4>[ 2288.143187]  [<ffffffff810c99ab>] ? local_clock+0x4b/0x60
<4>[ 2288.143191]  [<ffffffff819b9420>] ? _raw_spin_unlock_irq+0x30/0x60
<4>[ 2288.143206]  [<ffffffffa04bc26f>] worker_loop+0x13f/0x5b0 [btrfs]
<4>[ 2288.143221]  [<ffffffffa04bc130>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
<4>[ 2288.143224]  [<ffffffff810b4ebe>] kthread+0xde/0xf0
<4>[ 2288.143227]  [<ffffffff810b4de0>] ? __init_kthread_worker+0x70/0x70
<4>[ 2288.143231]  [<ffffffff819c0bdc>] ret_from_fork+0x7c/0xb0
<4>[ 2288.143233]  [<ffffffff810b4de0>] ? __init_kthread_worker+0x70/0x70
<4>[ 2288.143235] Code: c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 66 66 66 66 90 48 c7 c3 e2 ff ff ff 49 89 f6 <48> 8b b7 e8 01 00 00 49 89 fc 41 89 d5 48 8b 86 a0 33 00 00 a8
<1>[ 2288.143266] RIP  [<ffffffffa048da30>] start_transaction+0x20/0x4f0 [btrfs]
<4>[ 2288.225868]  RSP <ffff880232d79c28>
<4>[ 2288.225870] CR2: 00000000000001e8
<4>[ 2288.226363] ---[ end trace 64cb1c6d4f6c2fa7 ]---

The corresponding line of code from start_transaction is 334:

 324 static struct btrfs_trans_handle *
 325 start_transaction(struct btrfs_root *root, u64 num_items, int type,
 326                   enum btrfs_reserve_flush_enum flush)
 327 {
 328         struct btrfs_trans_handle *h;
 329         struct btrfs_transaction *cur_trans;
 330         u64 num_bytes = 0;
 331         int ret;
 332         u64 qgroup_reserved = 0;
 333 
 334         if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 335                 return ERR_PTR(-EROFS);

With the mentioned steps I could reproduce the problem once, a second attempt
failed.

-Jan
