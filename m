Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45997 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbcG3XS4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 19:18:56 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id A63D4600A7
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 01:18:37 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Balance and subvolume delete causes deadlock and metadata corruption
Message-ID: <426e3db1-f06b-523a-be2c-261f47091f64@mendix.com>
Date: Sun, 31 Jul 2016 01:18:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

tl;dr: concurrent metadata balance and subvol delete caused deadlock and
metadata corruption. could mount ro, copied data off of the filesystem.
filesystem still available for science, can possibly mount rw, but
crashes when space_tree v2 bails out when it sees the metadata corruption.

Yesterday, I changed a btrfs filesystem to start using skinny metadata,
and did a metadata balance for fun to convert all backrefs to skinny ones.

-# btrfstune -x /dev/xvdb
-# mount /mnt

-# btrfs fi df /mnt
Data, single: total=2.05TiB, used=1.68TiB
System, single: total=32.00MiB, used=368.00KiB
Metadata, single: total=30.00GiB, used=26.70GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

-# btrfs balance start -musage=100 /mnt

Balance on '/mnt' is running
1 out of about 31 chunks balanced (299 considered),  97% left
Data, single: total=2101.01GiB, used=1722.78GiB
System, single: total=0.03GiB, used=0.00GiB
Metadata, single: total=30.00GiB, used=26.70GiB
GlobalReserve, single: total=0.50GiB, used=0.05GiB

This went fine, until somewhere on the filesystem, a btrfs subvolume
delete happened. I already try to avoid all possible non-trivial things
from happening when using balance because of bad experiences with
crashes and deadlocks with balance and subvolume operations at the same
time... but I apparently forgot a very specific cron job creeping around
in a corner that was awaking and causing a subvolume delete...

The btrfs subvol delete hung in state D. I lost the ps axfu output.

This happened with kernel 4.5.4(-1~bpo8+1):

INFO: task kworker/u8:1:16983 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:1    D ffff8801f5c15e00     0 16983      2 0x00000000
Workqueue: writeback wb_workfn (flush-btrfs-2)
 ffff8801f29f23c0 ffff8801f2f30440 ffff8800179f0000 ffff8800132b3cc0
 ffff8800132b3cd8 ffff8800179ef9f8 ffff8800132b3cb8 0000000000000001
 ffffffff815b6451 ffff8800132b3c58 ffffffffc00c6664 ffff880000000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc00c6664>] ? btrfs_tree_lock+0x74/0x210 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc00a804c>] ? lock_extent_buffer_for_io+0x1dc/0x1f0 [btrfs]
 [<ffffffffc00aedd5>] ? btree_write_cache_pages+0x285/0x3a0 [btrfs]
 [<ffffffff81218a4d>] ? __writeback_single_inode+0x3d/0x320
 [<ffffffff812191fd>] ? writeback_sb_inodes+0x23d/0x470
 [<ffffffff812194b7>] ? __writeback_inodes_wb+0x87/0xb0
 [<ffffffff81219830>] ? wb_writeback+0x280/0x310
 [<ffffffff81219f73>] ? wb_workfn+0x213/0x3e0
 [<ffffffff81091dab>] ? process_one_work+0x14b/0x400
 [<ffffffff81092855>] ? worker_thread+0x65/0x4a0
 [<ffffffff810927f0>] ? rescuer_thread+0x340/0x340
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task kworker/u8:2:7762 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:2    D ffff8801f5d15e00     0  7762      2 0x00000000
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
 ffff880151d85140 ffff8801f4dfe180 ffff88012aac4000 ffff8801c9ccf9f0
 ffff8801c9ccf800 ffff8801c9ccf9f0 0000000000000001 ffff880151d85140
 ffffffff815b6451 ffff880160aad050 ffffffffc0089d0d ffff880100000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc0089d0d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc008b596>] ? start_transaction+0x286/0x4d0 [btrfs]
 [<ffffffffc0075883>] ? delayed_ref_async_start+0x13/0x80 [btrfs]
 [<ffffffffc00bce16>] ? normal_work_helper+0xc6/0x2c0 [btrfs]
 [<ffffffff81091dab>] ? process_one_work+0x14b/0x400
 [<ffffffff81092855>] ? worker_thread+0x65/0x4a0
 [<ffffffff810927f0>] ? rescuer_thread+0x340/0x340
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs-transacti:8607 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff8801f5d95e00     0  8607      2 0x00000000
 ffff8800fe2ff100 ffff8801f4e08f80 ffff88005ad38000 ffff88002ab9d978
 ffff88002ab9d990 ffff88005ad37c50 ffff88002ab9d970 0000000000000001
 ffffffff815b6451 ffff88002ab9d910 ffffffffc00c6664 ffff880100000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc00c6664>] ? btrfs_tree_lock+0x74/0x210 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc0064b4d>] ? btrfs_search_slot+0x6cd/0x9e0 [btrfs]
 [<ffffffffc007bd8e>] ? btrfs_update_root+0x5e/0x340 [btrfs]
 [<ffffffffc01052b9>] ? commit_fs_roots.isra.19+0x110/0x160 [btrfs]
 [<ffffffffc008addc>] ? btrfs_commit_transaction+0x4fc/0xa30 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc0085d52>] ? transaction_kthread+0x1d2/0x240 [btrfs]
 [<ffffffffc0085b80>] ? btrfs_cleanup_transaction+0x590/0x590 [btrfs]
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs-uuid:8608 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-uuid      D ffff8801f5c15e00     0  8608      2 0x00000000
 ffff8800b5744f00 ffffffff81a13540 ffff8800df940000 ffff8800df93fbe8
 ffff8801756f6d18 ffff8800b5744f00 0000000000000000 ffff880160aad050
 ffffffff815b6451 ffff8801756f6d20 ffffffff815b943f 7fffffffffffffff
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffff815b943f>] ? schedule_timeout+0x22f/0x2c0
 [<ffffffff813d0caa>] ? notify_remote_via_irq+0x4a/0x70
 [<ffffffff810a1e90>] ? check_preempt_curr+0x50/0x90
 [<ffffffff810a1ee4>] ? ttwu_do_wakeup+0x14/0xe0
 [<ffffffff815b9cf6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
 [<ffffffff810a2a73>] ? try_to_wake_up+0x43/0x380
 [<ffffffff815b6e8a>] ? wait_for_completion+0xfa/0x130
 [<ffffffff810a2e30>] ? wake_up_q+0x60/0x60
 [<ffffffffc006fcbd>] ? btrfs_async_run_delayed_refs+0x11d/0x140 [btrfs]
 [<ffffffffc008bad5>] ? __btrfs_end_transaction+0x1f5/0x330 [btrfs]
 [<ffffffffc00b14e6>] ? btrfs_uuid_scan_kthread+0x86/0x370 [btrfs]
 [<ffffffffc00b17d0>] ? btrfs_uuid_scan_kthread+0x370/0x370 [btrfs]
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs:8632 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs           D ffff8801f5c15e00     0  8632   8617 0x00000000
 ffff8801f3341140 ffffffff81a13540 ffff8800c8418000 ffff8800b90f19f0
 ffff8800b90f1800 ffff8800b90f19f0 0000000000000001 ffff8801f3341140
 ffffffff815b6451 ffff880160aad050 ffffffffc0089d0d ffff880100000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc0089d0d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc008b605>] ? start_transaction+0x2f5/0x4d0 [btrfs]
 [<ffffffffc00de366>] ? relocate_block_group+0x336/0x710 [btrfs]
 [<ffffffffc00a68be>] ? btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
 [<ffffffffc00de8e0>] ? btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
 [<ffffffffc00b4561>] ? btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
 [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
 [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370 [btrfs]
 [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
 [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
 [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
 [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
 [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
 [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
 [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
 [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b

Everything hangs, so I have to crash/reboot.

After booting again:

BTRFS: detected SSD devices, enabling SSD mode
BTRFS error (device xvdb): incorrect extent count for 3648599883776;
counted 3282, expected 3286
BTRFS: checking UUID tree

And yes, 3648599883776 is the METADATA block group that was being
balanced when the lockup occured.

BTRFS info (device xvdb): continuing balance
BTRFS info (device xvdb): relocating block group 4049743118336 flags 2
BTRFS info (device xvdb): found 20 extents
BTRFS info (device xvdb): relocating block group 3682959622144 flags 4

Also note that btrfs balance does not actually resumes, it just starts
over at the beginning... O_o

Just hangs again... 0% disk IO, 0% cpu usage.

root       300  0.3  0.0      0     0 ?        D    20:12   0:00  \_
[btrfs-transacti]
root       301  0.0  0.0      0     0 ?        D    20:12   0:00  \_
[btrfs-balance]
root       302  0.1  0.0      0     0 ?        D    20:12   0:00  \_
[btrfs-uuid]

And again:

INFO: task kworker/u8:0:6 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:0    D ffff8801f5d15e00     0     6      2 0x00000000
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
 ffff8801f4dd60c0 ffff8801f4dfe180 ffff8801f4de4000 ffff8801f218d1f0
 ffff8801f218d000 ffff8801f218d1f0 0000000000000001 ffff8801f4dd60c0
 ffffffff815b6451 ffff8801f1a81010 ffffffffc0089d0d ffff880100000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc0089d0d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc008b596>] ? start_transaction+0x286/0x4d0 [btrfs]
 [<ffffffffc0075883>] ? delayed_ref_async_start+0x13/0x80 [btrfs]
 [<ffffffffc00bce16>] ? normal_work_helper+0xc6/0x2c0 [btrfs]
 [<ffffffff81091dab>] ? process_one_work+0x14b/0x400
 [<ffffffff81092855>] ? worker_thread+0x65/0x4a0
 [<ffffffff810927f0>] ? rescuer_thread+0x340/0x340
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs-transacti:300 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff8801f5d95e00     0   300      2 0x00000000
 ffff8801f2fc9140 ffff8801f4e08f80 ffff8801f14e8000 ffff8800fd59c820
 ffff8800fd59c838 ffff8801f14e7c50 ffff8800fd59c818 0000000000000001
 ffffffff815b6451 ffff8800fd59c7b8 ffffffffc00c6664 ffff880000000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc00c6664>] ? btrfs_tree_lock+0x74/0x210 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc0064b4d>] ? btrfs_search_slot+0x6cd/0x9e0 [btrfs]
 [<ffffffffc007bd8e>] ? btrfs_update_root+0x5e/0x340 [btrfs]
 [<ffffffffc01052b9>] ? commit_fs_roots.isra.19+0x110/0x160 [btrfs]
 [<ffffffffc008addc>] ? btrfs_commit_transaction+0x4fc/0xa30 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc0085d52>] ? transaction_kthread+0x1d2/0x240 [btrfs]
 [<ffffffffc0085b80>] ? btrfs_cleanup_transaction+0x590/0x590 [btrfs]
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs-balance:301 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-balance   D ffff8801f5c95e00     0   301      2 0x00000000
 ffff8800ff7a11c0 ffff8801f4dfef40 ffff8801f3ca0000 ffff8801f46589f0
 ffff8801f4658800 ffff8801f46589f0 0000000000000001 ffff8800ff7a11c0
 ffffffff815b6451 ffff8801f1a81010 ffffffffc0089d0d 0000000000000000
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffffc0089d0d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
 [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
 [<ffffffffc008b605>] ? start_transaction+0x2f5/0x4d0 [btrfs]
 [<ffffffffc00de366>] ? relocate_block_group+0x336/0x710 [btrfs]
 [<ffffffffc00a68be>] ? btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
 [<ffffffffc00de8e0>] ? btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
 [<ffffffffc00b4561>] ? btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
 [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
 [<ffffffffc00b6548>] ? balance_kthread+0x58/0x80 [btrfs]
 [<ffffffffc00b64f0>] ? btrfs_balance+0x11b0/0x11b0 [btrfs]
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
INFO: task btrfs-uuid:302 blocked for more than 120 seconds.
      Tainted: G        W   E   4.5.0-0.bpo.2-amd64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-uuid      D ffff8801f5c15e00     0   302      2 0x00000000
 ffff8800ff9420c0 ffffffff81a13540 ffff8801f3ca4000 ffff8801f3ca3be8
 ffff8801e1b8fdd8 ffff8800ff9420c0 0000000000000000 ffff8801f1a81010
 ffffffff815b6451 ffff8801e1b8fde0 ffffffff815b943f 7fffffffffffffff
Call Trace:
 [<ffffffff815b6451>] ? schedule+0x31/0x80
 [<ffffffff815b943f>] ? schedule_timeout+0x22f/0x2c0
 [<ffffffff813d0caa>] ? notify_remote_via_irq+0x4a/0x70
 [<ffffffff810a1e90>] ? check_preempt_curr+0x50/0x90
 [<ffffffff810a1ee4>] ? ttwu_do_wakeup+0x14/0xe0
 [<ffffffff815b9cf6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
 [<ffffffff810a2a73>] ? try_to_wake_up+0x43/0x380
 [<ffffffff815b6e8a>] ? wait_for_completion+0xfa/0x130
 [<ffffffff810a2e30>] ? wake_up_q+0x60/0x60
 [<ffffffffc006fcbd>] ? btrfs_async_run_delayed_refs+0x11d/0x140 [btrfs]
 [<ffffffffc008bad5>] ? __btrfs_end_transaction+0x1f5/0x330 [btrfs]
 [<ffffffffc00b14e6>] ? btrfs_uuid_scan_kthread+0x86/0x370 [btrfs]
 [<ffffffffc00b17d0>] ? btrfs_uuid_scan_kthread+0x370/0x370 [btrfs]
 [<ffffffff81097b3f>] ? kthread+0xdf/0x100
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50
 [<ffffffff815ba5df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81097a60>] ? kthread_park+0x50/0x50

What I did next was mounting with skip_balance and then a balance cancel.

This made the filesystem mountable and read/writable again.

I went to look for the place where the "incorrect extent count for
3648599883776" message is generated. It's from the v2 space tree code
(which is in use here).

At this point I'm able to get all data off the filesystem, because I
cannot trust it anymore. I could copy all necessary data.

When continuing the metadata balance, this happens:

btrfs balance -musage=100

[54254.809776] BTRFS info (device xvdb): relocating block group
4053098561536 flags 4
[55571.620076] BTRFS info (device xvdb): found 63116 extents
[55571.688813] BTRFS info (device xvdb): relocating block group
3662558527488 flags 4
[56496.275115] BTRFS info (device xvdb): found 62683 extents
[56496.482275] BTRFS info (device xvdb): relocating block group
3661484785664 flags 4
[57378.876919] BTRFS info (device xvdb): found 63505 extents
[57378.974579] BTRFS info (device xvdb): relocating block group
3660411043840 flags 4
[58304.033805] BTRFS info (device xvdb): found 64123 extents
[58304.154116] BTRFS info (device xvdb): relocating block group
3659337302016 flags 4
[59288.209145] BTRFS info (device xvdb): found 64631 extents
[59288.241048] BTRFS info (device xvdb): relocating block group
3658263560192 flags 4
[60258.466520] BTRFS info (device xvdb): found 64692 extents
[60258.700293] BTRFS info (device xvdb): relocating block group
3657189818368 flags 4
[61180.320753] BTRFS info (device xvdb): found 64670 extents
[61180.386694] BTRFS info (device xvdb): relocating block group
3656116076544 flags 4
[62336.225196] BTRFS info (device xvdb): found 64731 extents
[62336.644462] BTRFS info (device xvdb): relocating block group
3655042334720 flags 4
[63334.270235] BTRFS info (device xvdb): found 64693 extents
[63334.391065] BTRFS info (device xvdb): relocating block group
3653968592896 flags 4
[64168.686317] BTRFS info (device xvdb): found 64740 extents
[64168.960531] BTRFS info (device xvdb): relocating block group
3652894851072 flags 4
[65043.714197] BTRFS info (device xvdb): found 64604 extents
[65043.817075] BTRFS info (device xvdb): relocating block group
3651821109248 flags 4
[65976.565765] BTRFS info (device xvdb): found 64621 extents
[65976.923012] BTRFS info (device xvdb): relocating block group
3650747367424 flags 4
[66842.538025] BTRFS info (device xvdb): found 64537 extents
[66842.595277] BTRFS info (device xvdb): relocating block group
3649673625600 flags 4
[67771.532559] BTRFS info (device xvdb): found 64481 extents
[67771.581113] BTRFS info (device xvdb): relocating block group
3648599883776 flags 4
[68332.363733] BTRFS error (device xvdb): incorrect extent count for
3648599883776; counted 1333, expected 1337
[68332.363750] ------------[ cut here ]------------
[68332.363789] WARNING: CPU: 0 PID: 28996 at
/build/linux-Pq1Zex/linux-4.5.4/fs/btrfs/free-space-tree.c:457
convert_free_space_to_extents+0x398/0x4a0 [btrfs]()
[68332.363798] BTRFS: Transaction aborted (error -5)
[68332.363799] Modules linked in: binfmt_misc(E) nf_log_ipv6(E)
ip6t_REJECT(E) nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E)
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E)
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E)
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E)
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) intel_rapl(E)
x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E)
evdev(E) aes_x86_64(E) pcspkr(E) lrw(E) gf128mul(E) glue_helper(E)
ablk_helper(E) cryptd(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E)
ext4(E)
[68332.363874]  crc16(E) mbcache(E) jbd2(E) btrfs(E) xor(E) raid6_pq(E)
xen_netfront(E) xen_blkfront(E) crc32c_intel(E)
[68332.363889] CPU: 0 PID: 28996 Comm: btrfs Tainted: G        W   E
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.4-1~bpo8+1
[68332.363898]  0000000000000200 00000000430b0e0a ffffffff8130a245
ffff8800b57b3568
[68332.363907]  ffffffffc0115350 ffffffff81079ba1 ffff8801ae8252c8
ffff8800b57b35c0
[68332.363916]  0000000000040000 0000000000000001 00000351c1800000
ffffffff81079c2c
[68332.363925] Call Trace:
[68332.363934]  [<ffffffff8130a245>] ? dump_stack+0x5c/0x77
[68332.363941]  [<ffffffff81079ba1>] ? warn_slowpath_common+0x81/0xb0
[68332.363947]  [<ffffffff81079c2c>] ? warn_slowpath_fmt+0x5c/0x80
[68332.363966]  [<ffffffffc01027c8>] ?
convert_free_space_to_extents+0x398/0x4a0 [btrfs]
[68332.363985]  [<ffffffffc0102cd1>] ?
modify_free_space_bitmap+0x251/0x3c0 [btrfs]
[68332.364005]  [<ffffffffc0102f6f>] ?
__add_to_free_space_tree+0x12f/0x360 [btrfs]
[68332.364040]  [<ffffffffc0084a36>] ? btrfs_mark_buffer_dirty+0x86/0xc0
[btrfs]
[68332.364048]  [<ffffffff811cbe40>] ? kmem_cache_alloc+0x360/0x4e0
[68332.364063]  [<ffffffffc0066c0b>] ? btrfs_del_items+0x38b/0x490 [btrfs]
[68332.364079]  [<ffffffffc0103670>] ? add_to_free_space_tree+0x80/0x120
[btrfs]
[68332.364094]  [<ffffffffc006dc8f>] ?
__btrfs_free_extent.isra.68+0x81f/0xdc0 [btrfs]
[68332.364112]  [<ffffffffc007209d>] ?
__btrfs_run_delayed_refs+0x9ad/0x1210 [btrfs]
[68332.364129]  [<ffffffffc0072f1c>] ? btrfs_free_tree_block+0xdc/0x250
[btrfs]
[68332.364146]  [<ffffffffc007564e>] ? btrfs_run_delayed_refs+0x8e/0x2b0
[btrfs]
[68332.364160]  [<ffffffffc0073637>] ? walk_up_tree+0xc7/0x1c0 [btrfs]
[68332.364177]  [<ffffffffc008a32f>] ?
btrfs_should_end_transaction+0x3f/0x60 [btrfs]
[68332.364194]  [<ffffffffc0073e74>] ? btrfs_drop_snapshot+0x464/0x860
[btrfs]
[68332.364211]  [<ffffffffc00ddedf>] ? merge_reloc_roots+0x10f/0x260 [btrfs]
[68332.364227]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68332.364245]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68332.364263]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68332.364283]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68332.364302]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68332.364319]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68332.364336]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68332.364342]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68332.364349]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68332.364355]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68332.364362]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68332.364367]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68332.364372]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68332.364379]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68332.364417] ---[ end trace 01700446ce279603 ]---
[68332.364430] BTRFS: error (device xvdb) in
convert_free_space_to_extents:457: errno=-5 IO failure
[68332.364442] BTRFS info (device xvdb): forced readonly
[68332.364454] BTRFS: error (device xvdb) in
add_to_free_space_tree:1050: errno=-5 IO failure
[68332.364467] BTRFS: error (device xvdb) in __btrfs_free_extent:6720:
errno=-5 IO failure
[68332.364479] BTRFS: error (device xvdb) in
btrfs_run_delayed_refs:2946: errno=-5 IO failure
[68353.364003] INFO: rcu_sched self-detected stall on CPU
[68353.364003] 	0-...: (5249 ticks this GP) idle=b63/140000000000001/0
softirq=2892635/2892635 fqs=5220
[68353.364003] 	 (t=5250 jiffies g=2905245 c=2905244 q=13864)
[68353.364003] Task dump for CPU 0:
[68353.364003] btrfs           R  running task        0 28996  28660
0x00000008
[68353.364003]  0000000000000001 00000000430b0e0a ffffffff810d70d2
ffff8801f5c16b80
[68353.364003]  ffffffff81a58000 0000000000000000 ffff880135820e40
ffffffff810dab55
[68353.364003]  ffffffff810e6481 001dcd6500000000 00003e2abb8b0a00
ffffffff815b9cf6
[68353.364003] Call Trace:
[68353.364003]  <IRQ>  [<ffffffff810d70d2>] ? rcu_dump_cpu_stacks+0x82/0xb0
[68353.364003]  [<ffffffff810dab55>] ? rcu_check_callbacks+0x465/0x720
[68353.364003]  [<ffffffff810e6481>] ? timekeeping_update+0xf1/0x150
[68353.364003]  [<ffffffff815b9cf6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
[68353.364003]  [<ffffffff811217da>] ? __acct_update_integrals+0x6a/0xf0
[68353.364003]  [<ffffffff810ef920>] ? tick_sched_do_timer+0x30/0x30
[68353.364003]  [<ffffffff810e0ab2>] ? update_process_times+0x32/0x60
[68353.364003]  [<ffffffff810ef340>] ? tick_sched_handle.isra.15+0x20/0x50
[68353.364003]  [<ffffffff810ef958>] ? tick_sched_timer+0x38/0x70
[68353.364003]  [<ffffffff810e167a>] ? __hrtimer_run_queues+0xea/0x280
[68353.364003]  [<ffffffff810e1af9>] ? hrtimer_interrupt+0x99/0x190
[68353.364003]  [<ffffffff8100c362>] ? xen_timer_interrupt+0x32/0x120
[68353.364003]  [<ffffffff810cd647>] ? handle_irq_event_percpu+0x77/0x1b0
[68353.364003]  [<ffffffff810d1077>] ? handle_percpu_irq+0x37/0x50
[68353.364003]  [<ffffffff810ccd71>] ? generic_handle_irq+0x21/0x30
[68353.364003]  [<ffffffff813d353b>] ?
__evtchn_fifo_handle_events+0x17b/0x1a0
[68353.364003]  [<ffffffff813d030c>] ? __xen_evtchn_do_upcall+0x3c/0x70
[68353.364003]  [<ffffffff813d230c>] ? xen_evtchn_do_upcall+0x2c/0x40
[68353.364003]  [<ffffffff815bbfee>] ? xen_do_hypervisor_callback+0x1e/0x40
[68353.364003]  <EOI>  [<ffffffff815b9ec0>] ? _raw_spin_lock+0x10/0x20
[68353.364003]  [<ffffffffc00da9ab>] ? __del_reloc_root+0x2b/0xe0 [btrfs]
[68353.364003]  [<ffffffffc00daa80>] ? free_reloc_roots+0x20/0x30 [btrfs]
[68353.364003]  [<ffffffffc00ddf59>] ? merge_reloc_roots+0x189/0x260 [btrfs]
[68353.364003]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68353.364003]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68353.364003]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68353.364003]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68353.364003]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68353.364003]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68353.364003]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68353.364003]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68353.364003]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68353.364003]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68353.364003]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68353.364003]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68353.364003]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68353.364003]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68380.040006] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[btrfs:28996]
[68380.040019] Modules linked in: binfmt_misc(E) nf_log_ipv6(E)
ip6t_REJECT(E) nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E)
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E)
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E)
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E)
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) intel_rapl(E)
x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E)
evdev(E) aes_x86_64(E) pcspkr(E) lrw(E) gf128mul(E) glue_helper(E)
ablk_helper(E) cryptd(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E)
ext4(E)
[68380.040019]  crc16(E) mbcache(E) jbd2(E) btrfs(E) xor(E) raid6_pq(E)
xen_netfront(E) xen_blkfront(E) crc32c_intel(E)
[68380.040019] CPU: 0 PID: 28996 Comm: btrfs Tainted: G        W   E
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.4-1~bpo8+1
[68380.040019] task: ffff880135820e40 ti: ffff8800b57b0000 task.ti:
ffff8800b57b0000
[68380.040019] RIP: e030:[<ffffffff815b9ec0>]  [<ffffffff815b9ec0>]
_raw_spin_lock+0x10/0x20
[68380.040019] RSP: e02b:ffff8800b57b3ad0  EFLAGS: 00000246
[68380.040019] RAX: 0000000000000000 RBX: ffff8800b57b3b18 RCX:
00000000ffffffe2
[68380.040019] RDX: 0000000000000001 RSI: ffffffffc010cda0 RDI:
ffff8800ed5da570
[68380.040019] RBP: ffff880143939000 R08: 0000000000000000 R09:
00000000ffffffe2
[68380.040019] R10: 0000000000005901 R11: 0000000000000000 R12:
ffff8800ed5da570
[68380.040019] R13: ffff8800ed5da000 R14: ffff8800b57b3b18 R15:
ffff8800ed5da578
[68380.040019] FS:  00007fb4a9c918c0(0000) GS:ffff8801f5c00000(0000)
knlGS:0000000000000000
[68380.040019] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[68380.040019] CR2: 00007f296f540000 CR3: 00000001481be000 CR4:
0000000000042660
[68380.040019] Stack:
[68380.040019]  ffffffffc00da9ab ffff8800b57b3b18 ffff880143939000
ffff8800ed5da000
[68380.040019]  ffff8800ef31b800 ffffffffc00daa80 ffff8801439393c0
ffffffffc00ddf59
[68380.040019]  ffffffe2ed5da578 ffff8801439393c0 ffff8801439393c0
00000000430b0e0a
[68380.040019] Call Trace:
[68380.040019]  [<ffffffffc00da9ab>] ? __del_reloc_root+0x2b/0xe0 [btrfs]
[68380.040019]  [<ffffffffc00daa80>] ? free_reloc_roots+0x20/0x30 [btrfs]
[68380.040019]  [<ffffffffc00ddf59>] ? merge_reloc_roots+0x189/0x260 [btrfs]
[68380.040019]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68380.040019]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68380.040019]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68380.040019]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68380.040019]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68380.040019]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68380.040019]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68380.040019]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68380.040019]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68380.040019]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68380.040019]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68380.040019]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68380.040019]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68380.040019]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68380.040019] Code: 8b 07 85 c0 74 03 31 c0 c3 ba 01 00 00 00 f0 0f b1
17 85 c0 75 f0 b0 01 c3 66 90 66 66 66 66 90 31 c0 ba 01 00 00 00 f0 0f
b1 17 <85> c0 75 02 f3 c3 89 c6 e8 63 48 b0 ff 66 90 c3 66 66 66 66 90
[68408.040003] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[btrfs:28996]
[68408.040003] Modules linked in: binfmt_misc(E) nf_log_ipv6(E)
ip6t_REJECT(E) nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E)
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E)
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E)
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E)
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) intel_rapl(E)
x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E)
evdev(E) aes_x86_64(E) pcspkr(E) lrw(E) gf128mul(E) glue_helper(E)
ablk_helper(E) cryptd(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E)
ext4(E)
[68408.040003]  crc16(E) mbcache(E) jbd2(E) btrfs(E) xor(E) raid6_pq(E)
xen_netfront(E) xen_blkfront(E) crc32c_intel(E)
[68408.040003] CPU: 0 PID: 28996 Comm: btrfs Tainted: G        W   EL
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.4-1~bpo8+1
[68408.040003] task: ffff880135820e40 ti: ffff8800b57b0000 task.ti:
ffff8800b57b0000
[68408.040003] RIP: e030:[<ffffffffc00daa71>]  [<ffffffffc00daa71>]
free_reloc_roots+0x11/0x30 [btrfs]
[68408.040003] RSP: e02b:ffff8800b57b3b00  EFLAGS: 00000283
[68408.040003] RAX: ffff8801439393c0 RBX: ffff8800b57b3b18 RCX:
00000000ffffffe2
[68408.040003] RDX: 000003b323000000 RSI: ffffffffc010cda0 RDI:
ffff8800ed5da570
[68408.040003] RBP: ffff880143939000 R08: 0000000000000000 R09:
00000000ffffffe2
[68408.040003] R10: 0000000000005901 R11: 0000000000000000 R12:
ffff8800ed5da000
[68408.040003] R13: ffff8800ef31b800 R14: ffff8800b57b3b18 R15:
ffff8800ed5da578
[68408.040003] FS:  00007fb4a9c918c0(0000) GS:ffff8801f5c00000(0000)
knlGS:0000000000000000
[68408.040003] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[68408.040003] CR2: 00007f296f540000 CR3: 00000001481be000 CR4:
0000000000042660
[68408.040003] Stack:
[68408.040003]  ffff8801439393c0 ffffffffc00ddf59 ffffffe2ed5da578
ffff8801439393c0
[68408.040003]  ffff8801439393c0 00000000430b0e0a ffff8800ed5da0e8
ffff8801ae825b88
[68408.040003]  ffff8800ed5da108 0000000000000000 ffff8800ed5da000
0000000000000000
[68408.040003] Call Trace:
[68408.040003]  [<ffffffffc00ddf59>] ? merge_reloc_roots+0x189/0x260 [btrfs]
[68408.040003]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68408.040003]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68408.040003]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68408.040003]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68408.040003]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68408.040003]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68408.040003]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68408.040003]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68408.040003]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68408.040003]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68408.040003]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68408.040003]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68408.040003]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68408.040003]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68408.040003] Code: 00 48 89 df e8 c1 58 23 c1 e9 79 ff ff ff 5b 5d 41
5c 41 5d c3 0f 0b 0f 1f 00 66 66 66 66 90 53 48 8b 07 48 89 fb 48 39 c7
74 17 <48> 8b 03 48 8d b8 40 fc ff ff e8 00 ff ff ff 48 8b 03 48 39 c3
[68416.376002] INFO: rcu_sched self-detected stall on CPU
[68416.376002] 	0-...: (21002 ticks this GP) idle=b63/140000000000001/0
softirq=2892635/2892635 fqs=20815
[68416.376002] 	 (t=21003 jiffies g=2905245 c=2905244 q=15750)
[68416.376002] Task dump for CPU 0:
[68416.376002] btrfs           R  running task        0 28996  28660
0x00000008
[68416.376002]  0000000000000001 00000000430b0e0a ffffffff810d70d2
ffff8801f5c16b80
[68416.376002]  ffffffff81a58000 0000000000000000 ffff880135820e40
ffffffff810dab55
[68416.376002]  ffffffff810e6481 001dcd6500000000 00003e396759db00
ffffffff815b9cf6
[68416.376002] Call Trace:
[68416.376002]  <IRQ>  [<ffffffff810d70d2>] ? rcu_dump_cpu_stacks+0x82/0xb0
[68416.376002]  [<ffffffff810dab55>] ? rcu_check_callbacks+0x465/0x720
[68416.376002]  [<ffffffff810e6481>] ? timekeeping_update+0xf1/0x150
[68416.376002]  [<ffffffff815b9cf6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
[68416.376002]  [<ffffffff811217da>] ? __acct_update_integrals+0x6a/0xf0
[68416.376002]  [<ffffffff810ef920>] ? tick_sched_do_timer+0x30/0x30
[68416.376002]  [<ffffffff810e0ab2>] ? update_process_times+0x32/0x60
[68416.376002]  [<ffffffff810ef340>] ? tick_sched_handle.isra.15+0x20/0x50
[68416.376002]  [<ffffffff810ef958>] ? tick_sched_timer+0x38/0x70
[68416.376002]  [<ffffffff810e167a>] ? __hrtimer_run_queues+0xea/0x280
[68416.376002]  [<ffffffff810e1af9>] ? hrtimer_interrupt+0x99/0x190
[68416.376002]  [<ffffffff8100c362>] ? xen_timer_interrupt+0x32/0x120
[68416.376002]  [<ffffffff810cd647>] ? handle_irq_event_percpu+0x77/0x1b0
[68416.376002]  [<ffffffff810d1077>] ? handle_percpu_irq+0x37/0x50
[68416.376002]  [<ffffffff810ccd71>] ? generic_handle_irq+0x21/0x30
[68416.376002]  [<ffffffff813d353b>] ?
__evtchn_fifo_handle_events+0x17b/0x1a0
[68416.376002]  [<ffffffff813d030c>] ? __xen_evtchn_do_upcall+0x3c/0x70
[68416.376002]  [<ffffffff813d230c>] ? xen_evtchn_do_upcall+0x2c/0x40
[68416.376002]  [<ffffffff815bbfee>] ? xen_do_hypervisor_callback+0x1e/0x40
[68416.376002]  <EOI>  [<ffffffff810be66c>] ?
__raw_callee_save___pv_queued_spin_unlock+0xc/0x12
[68416.376002]  [<ffffffffc00da9d7>] ? __del_reloc_root+0x57/0xe0 [btrfs]
[68416.376002]  [<ffffffffc00daa80>] ? free_reloc_roots+0x20/0x30 [btrfs]
[68416.376002]  [<ffffffffc00ddf59>] ? merge_reloc_roots+0x189/0x260 [btrfs]
[68416.376002]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68416.376002]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68416.376002]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68416.376002]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68416.376002]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68416.376002]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68416.376002]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68416.376002]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68416.376002]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68416.376002]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68416.376002]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68416.376002]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68416.376002]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68416.376002]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68444.040002] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[btrfs:28996]
[68444.040002] Modules linked in: binfmt_misc(E) nf_log_ipv6(E)
ip6t_REJECT(E) nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E)
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E)
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E)
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E)
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E)
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E)
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) intel_rapl(E)
x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E)
ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E)
evdev(E) aes_x86_64(E) pcspkr(E) lrw(E) gf128mul(E) glue_helper(E)
ablk_helper(E) cryptd(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E)
ext4(E)
[68444.040002]  crc16(E) mbcache(E) jbd2(E) btrfs(E) xor(E) raid6_pq(E)
xen_netfront(E) xen_blkfront(E) crc32c_intel(E)
[68444.040002] CPU: 0 PID: 28996 Comm: btrfs Tainted: G        W   EL
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.4-1~bpo8+1
[68444.040002] task: ffff880135820e40 ti: ffff8800b57b0000 task.ti:
ffff8800b57b0000
[68444.040002] RIP: e030:[<ffffffff815b9ec0>]  [<ffffffff815b9ec0>]
_raw_spin_lock+0x10/0x20
[68444.040002] RSP: e02b:ffff8800b57b3ad0  EFLAGS: 00000246
[68444.040002] RAX: 0000000000000000 RBX: ffff8800b57b3b18 RCX:
00000000ffffffe2
[68444.040002] RDX: 0000000000000001 RSI: ffffffffc010cda0 RDI:
ffff8800ed5da570
[68444.040002] RBP: ffff880143939000 R08: 0000000000000000 R09:
00000000ffffffe2
[68444.040002] R10: 0000000000005901 R11: 0000000000000000 R12:
ffff8800ed5da570
[68444.040002] R13: ffff8800ed5da000 R14: ffff8800b57b3b18 R15:
ffff8800ed5da578
[68444.040002] FS:  00007fb4a9c918c0(0000) GS:ffff8801f5c00000(0000)
knlGS:0000000000000000
[68444.040002] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[68444.040002] CR2: 00007f296f540000 CR3: 00000001481be000 CR4:
0000000000042660
[68444.040002] Stack:
[68444.040002]  ffffffffc00da9ab ffff8800b57b3b18 ffff880143939000
ffff8800ed5da000
[68444.040002]  ffff8800ef31b800 ffffffffc00daa80 ffff8801439393c0
ffffffffc00ddf59
[68444.040002]  ffffffe2ed5da578 ffff8801439393c0 ffff8801439393c0
00000000430b0e0a
[68444.040002] Call Trace:
[68444.040002]  [<ffffffffc00da9ab>] ? __del_reloc_root+0x2b/0xe0 [btrfs]
[68444.040002]  [<ffffffffc00daa80>] ? free_reloc_roots+0x20/0x30 [btrfs]
[68444.040002]  [<ffffffffc00ddf59>] ? merge_reloc_roots+0x189/0x260 [btrfs]
[68444.040002]  [<ffffffffc00de4d1>] ? relocate_block_group+0x4a1/0x710
[btrfs]
[68444.040002]  [<ffffffffc00a68be>] ?
btrfs_wait_ordered_roots+0x1de/0x210 [btrfs]
[68444.040002]  [<ffffffffc00de8e0>] ?
btrfs_relocate_block_group+0x1a0/0x280 [btrfs]
[68444.040002]  [<ffffffffc00b4561>] ?
btrfs_relocate_chunk.isra.38+0x41/0xc0 [btrfs]
[68444.040002]  [<ffffffffc00b5d5c>] ? btrfs_balance+0xa1c/0x11b0 [btrfs]
[68444.040002]  [<ffffffffc00c0511>] ? btrfs_ioctl_balance+0x301/0x370
[btrfs]
[68444.040002]  [<ffffffffc00c5090>] ? btrfs_ioctl+0x1100/0x2190 [btrfs]
[68444.040002]  [<ffffffff811c4091>] ? alloc_pages_vma+0xc1/0x240
[68444.040002]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[68444.040002]  [<ffffffff811a12c8>] ? handle_mm_fault+0x13d8/0x1b90
[68444.040002]  [<ffffffff811feb69>] ? do_vfs_ioctl+0x99/0x5d0
[68444.040002]  [<ffffffff811a771a>] ? do_brk+0x1da/0x2c0
[68444.040002]  [<ffffffff811ff116>] ? SyS_ioctl+0x76/0x90
[68444.040002]  [<ffffffff815ba236>] ? system_call_fast_compare_end+0xc/0x6b
[68444.040002] Code: 8b 07 85 c0 74 03 31 c0 c3 ba 01 00 00 00 f0 0f b1
17 85 c0 75 f0 b0 01 c3 66 90 66 66 66 66 90 31 c0 ba 01 00 00 00 f0 0f
b1 17 <85> c0 75 02 f3 c3 89 c6 e8 63 48 b0 ff 66 90 c3 66 66 66 66 90

The free space tree code keeps crashing the whole thing because it
detects the metadata corruption. Since the problem is not in the free
space tree itself, I think this is fine, but it might be nicer if it
would be a bit more forgiving by just allowing some part of the free
space not being tracked, to allow to be able to fix the real problem
instead.

The real problem here is the lockup and corruption caused by doing
metadata balance and a subvolume delete at the same time, which is
something that btrfs definitely needs to be able to handle.

Doing a btrfs check now on the block device, will fup with the output.

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
