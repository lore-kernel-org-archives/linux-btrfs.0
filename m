Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kawka.in.waw.pl ([178.63.212.103]:44807 "EHLO kawka.in.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab3DKVji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 17:39:38 -0400
Received: from zbyszek by kawka.in.waw.pl with local (Exim 4.72)
	(envelope-from <zbyszek@in.waw.pl>)
	id 1UQOX9-0002vq-BF
	for linux-btrfs@vger.kernel.org; Thu, 11 Apr 2013 22:55:51 +0200
Date: Thu, 11 Apr 2013 22:55:51 +0200
From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/extent-tree.c:5406!
Message-ID: <20130411205550.GD3394@in.waw.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I managed to break my btrfs root partition in the following way:

[   68.149871] ------------[ cut here ]------------
[   68.149904] kernel BUG at fs/btrfs/extent-tree.c:5406!
[   68.149918] invalid opcode: 0000 [#1] SMP 
[   68.150490] Modules linked in: btrfs zlib_deflate raid6_pq libcrc32c xor nouveau mxm_wmi wmi ast video crc32_pclmul igb crc32c_intel drm_kms_helper dca isci ttm ghash_clmulni_intel usb_storage ptp pps_core libsas i2c_algo_bit drm scsi_transport_sas i2c_core sunrpc
[   68.151744] CPU 9 
[   68.151754] Pid: 427, comm: btrfs-delayed-m Not tainted 3.9.0-0.rc4.git0.1.fc19.x86_64 #1 ASUSTeK COMPUTER INC. Z9PE-D16 Series/Z9PE-D16 Series
[   68.153179] RIP: 0010:[<ffffffffa03e3736>]  [<ffffffffa03e3736>] __btrfs_free_extent+0x736/0x840 [btrfs]
[   68.153995] RSP: 0018:ffff880462b47a88  EFLAGS: 00010206
[   68.154816] RAX: 0000000000000001 RBX: ffff880867e781d8 RCX: ffff880869178000
[   68.155649] RDX: 000000000000000b RSI: 0000000000000610 RDI: ffff88086ba40ba0
[   68.156489] RBP: ffff880462b47b48 R08: 0000000000001000 R09: ffff880462b47a40
[   68.157331] R10: 0000000000000000 R11: 0000000000000000 R12: 000000035c9e1000
[   68.158174] R13: 000000000000002f R14: 0000000000000610 R15: 000000000000002f
[   68.159021] FS:  0000000000000000(0000) GS:ffff88086f000000(0000) knlGS:0000000000000000
[   68.159866] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.160710] CR2: 0000000002463ed8 CR3: 0000000001c0c000 CR4: 00000000000407e0
[   68.161559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.162420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   68.163279] Process btrfs-delayed-m (pid: 427, threadinfo ffff880462b46000, task ffff8804636ba6e0)
[   68.164134] Stack:
[   68.164993]  0000000000000000 0000000000000005 0000000000067fe9 0000000000001000
[   68.165883]  ffffe8ff00000000 0000003500000246 0000000000000001 ffff88086ba40ba0
[   68.166783]  ffff880463711148 00000001016ba6e0 ffff880462df4520 ffff88086bbd8000
[   68.167659] Call Trace:
[   68.168552]  [<ffffffffa03e7cf2>] run_clustered_refs+0x3c2/0xc60 [btrfs]
[   68.169445]  [<ffffffffa03ecaa0>] btrfs_run_delayed_refs+0xd0/0x530 [btrfs]
[   68.170346]  [<ffffffffa03e49cd>] ? btrfs_delayed_refs_qgroup_accounting+0x9d/0xd0 [btrfs]
[   68.171260]  [<ffffffffa03fec07>] __btrfs_end_transaction+0xc7/0x310 [btrfs]
[   68.172181]  [<ffffffffa03ff5b3>] btrfs_end_transaction_dmeta+0x13/0x20 [btrfs]
[   68.173121]  [<ffffffffa044eec0>] btrfs_async_run_delayed_root+0x100/0x1e0 [btrfs]
[   68.174066]  [<ffffffffa042c0e0>] worker_loop+0x140/0x580 [btrfs]
[   68.175010]  [<ffffffffa042bfa0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
[   68.175967]  [<ffffffff810948fd>] kthread+0xed/0x100
[   68.176932]  [<ffffffff81094810>] ? insert_kthread_work+0x80/0x80
[   68.177894]  [<ffffffff8172726c>] ret_from_fork+0x7c/0xb0
[   68.178854]  [<ffffffff81094810>] ? insert_kthread_work+0x80/0x80
[   68.179808] Code: 48 8b 33 48 8b 7d 90 e8 39 a8 00 00 44 8b 95 78 ff ff ff e9 c9 fb ff ff 0f 0b 45 89 d0 44 89 55 a0 b9 da 14 00 00 e9 e3 fa ff ff <0f> 0b be 1a 15 00 00 48 c7 c7 2e 24 47 a0 e8 77 57 c8 e0 44 8b 
[   68.180884] RIP  [<ffffffffa03e3736>] __btrfs_free_extent+0x736/0x840 [btrfs]
[   68.181912]  RSP <ffff880462b47a88>

Seems to be quite reproducible... I still have the partition, so I can
provide further information if necessary. The setup is btrfs mount with -o compress,discard,
on LVM with issue_discards=1, on a single SSD.
Kernel is:
Linux version 3.9.0-0.rc4.git0.1.fc19.x86_64 (mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 4.8.0 20130322 (
Red Hat 4.8.0-1) (GCC) ) #1 SMP Mon Mar 25 02:31:02 UTC 2013

Following the first one, there are further oopsen:
[   68.374221] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[   68.374813] in_atomic(): 1, irqs_disabled(): 0, pid: 427, name: btrfs-delayed-m
[   68.375641] INFO: lockdep is turned off.
[   68.376655] Pid: 427, comm: btrfs-delayed-m Tainted: G      D      3.9.0-0.rc4.git0.1.fc19.x86_64 #1
[   68.377693] Call Trace:
[   68.378729]  [<ffffffff810a3319>] __might_sleep+0x179/0x230
[   68.379755]  [<ffffffff8171a93a>] down_read+0x2a/0xa0
[   68.380784]  [<ffffffff81083644>] exit_signals+0x24/0x130
[   68.381809]  [<ffffffff8106f51c>] do_exit+0xbc/0xcd0
[   68.382834]  [<ffffffff8106c928>] ? kmsg_dump+0x1b8/0x240
[   68.383864]  [<ffffffff8106c795>] ? kmsg_dump+0x25/0x240
[   68.384894]  [<ffffffff8171f334>] oops_end+0xa4/0xe0
[   68.385903]  [<ffffffff8101db0b>] die+0x4b/0x70
[   68.386901]  [<ffffffff8171ebc0>] do_trap+0x60/0x170
[   68.387897]  [<ffffffff8101aff5>] do_invalid_op+0x95/0xb0
[   68.388885]  [<ffffffffa03e3736>] ? __btrfs_free_extent+0x736/0x840 [btrfs]
[   68.389871]  [<ffffffffa0414809>] ? btrfs_get_token_64+0x59/0xe0 [btrfs]
[   68.390842]  [<ffffffff81367a2d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   68.391809]  [<ffffffff8171e423>] ? restore_args+0x30/0x30
[   68.392774]  [<ffffffff817284ee>] invalid_op+0x1e/0x30
[   68.393745]  [<ffffffffa03e3736>] ? __btrfs_free_extent+0x736/0x840 [btrfs]
[   68.394705]  [<ffffffffa03e3484>] ? __btrfs_free_extent+0x484/0x840 [btrfs]
[   68.395672]  [<ffffffffa03e7cf2>] run_clustered_refs+0x3c2/0xc60 [btrfs]
[   68.396633]  [<ffffffffa03ecaa0>] btrfs_run_delayed_refs+0xd0/0x530 [btrfs]
[   68.397592]  [<ffffffffa03e49cd>] ? btrfs_delayed_refs_qgroup_accounting+0x9d/0xd0 [btrfs]
[   68.398557]  [<ffffffffa03fec07>] __btrfs_end_transaction+0xc7/0x310 [btrfs]
[   68.399523]  [<ffffffffa03ff5b3>] btrfs_end_transaction_dmeta+0x13/0x20 [btrfs]
[   68.400512]  [<ffffffffa044eec0>] btrfs_async_run_delayed_root+0x100/0x1e0 [btrfs]
[   68.401503]  [<ffffffffa042c0e0>] worker_loop+0x140/0x580 [btrfs]
[   68.402428]  [<ffffffffa042bfa0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
[   68.403320]  [<ffffffff810948fd>] kthread+0xed/0x100
[   68.404220]  [<ffffffff81094810>] ? insert_kthread_work+0x80/0x80
[   68.405097]  [<ffffffff8172726c>] ret_from_fork+0x7c/0xb0
[   68.405951]  [<ffffffff81094810>] ? insert_kthread_work+0x80/0x80
[   68.406805] note: btrfs-delayed-m[427] exited with preempt_count 2

Full dmesg is at http://in.waw.pl/~zbyszek/dmesg-root20 .

Thanks,
Zbyszek
