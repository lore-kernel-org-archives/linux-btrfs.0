Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43035 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbaIJTy7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 15:54:59 -0400
Date: Wed, 10 Sep 2014 21:54:56 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: oops in wait_block_group_cache_progress() while accessing removed
 media
Message-ID: <20140910195456.GA26976@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I manage to crash now and then by removing the mounted mmc card. This
happens randomly. This log is from -rc3 but it also triggered on -rc4:

| BTRFS: bdev /dev/root errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
| BTRFS error (device mmcblk0p2): error reading free space cache
| BTRFS warning (device mmcblk0p2): failed to load free space cache for block group 29360128, rebuild it now
| Alignment trap: not handling instruction e1932f9f at [<c015bd64>]
| Unhandled fault: alignment exception (0x001) at 0x00000059
| Internal error: : 1 [#1] ARM
| Modules linked in:
| CPU: 0 PID: 676 Comm: btrfs-transacti Not tainted 3.17.0-rc3-00023-g1b1867b-dirty #268
| task: de472000 ti: de4c0000 task.ti: de4c0000
| PC is at wait_block_group_cache_progress+0x48/0xe4
| LR is at find_free_extent+0x514/0xe18
| pc : [<c015bd68>]    lr : [<c0168298>]    psr: 20000013
| sp : de4c1ac8  ip : de4313b8  fp : 00000000
| r10: 00000001  r9 : 00000001  r8 : de474700
| r7 : 00000000  r6 : 00204000  r5 : 00000000  r4 : 00200000
| r3 : 00000059  r2 : 00204000  r1 : de4a1d80  r0 : de474700
| Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
| Control: 10c5387d  Table: 9e4e0019  DAC: 00000015
| Process btrfs-transacti (pid: 676, stack limit = 0xde4c0240)
| Stack: (0xde4c1ac8 to 0xde4c2000)
| [<c015bd68>] (wait_block_group_cache_progress) from [<c0168298>] (find_free_extent+0x514/0xe18)
| [<c0168298>] (find_free_extent) from [<c0168cbc>] (btrfs_reserve_extent+0x120/0x1ac)
| [<c0168cbc>] (btrfs_reserve_extent) from [<c016a7a0>] (btrfs_alloc_free_block+0x148/0x684)
| [<c016a7a0>] (btrfs_alloc_free_block) from [<c01509b4>] (__btrfs_cow_block+0x130/0x778)
| [<c01509b4>] (__btrfs_cow_block) from [<c01511a4>] (btrfs_cow_block+0x140/0x2c4)
| [<c01511a4>] (btrfs_cow_block) from [<c0155ac4>] (btrfs_search_slot+0x208/0xa14)
| [<c0155ac4>] (btrfs_search_slot) from [<c0175330>] (btrfs_lookup_inode+0x44/0x1a8)
| [<c0175330>] (btrfs_lookup_inode) from [<c01df4e8>] (__btrfs_update_delayed_inode+0x80/0x320)
| [<c01df4e8>] (__btrfs_update_delayed_inode) from [<c01e083c>] (__btrfs_run_delayed_items+0x15c/0x1e0)
| [<c01e083c>] (__btrfs_run_delayed_items) from [<c017f890>] (btrfs_commit_transaction+0x1ac/0xbc0)
| [<c017f890>] (btrfs_commit_transaction) from [<c017d9e0>] (transaction_kthread+0x140/0x1a8)
| [<c017d9e0>] (transaction_kthread) from [<c005352c>] (kthread+0xc8/0xe4)
| [<c005352c>] (kthread) from [<c000e898>] (ret_from_fork+0x14/0x20)

Don't get confused by the "Alignment trap". This is generated before
"NULL" pointer excpetion (it tried to access 0x59).

addr2line for c015bd68 gives:
  arch/arm/include/asm/atomic.h:46
  fs/btrfs/extent-tree.c:330
  fs/btrfs/extent-tree.c:6294

Sebastian
