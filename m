Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaCOAMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 20:12:24 -0400
Message-ID: <53239AE0.8030306@oracle.com>
Date: Fri, 14 Mar 2014 20:12:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: clm@fb.com, jbacik@fb.com
CC: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: btrfs: lock inversion between delayed_node->mutex and found->groups_sem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:

[  788.451695] =========================================================
[  788.452455] [ INFO: possible irq lock inversion dependency detected ]
[  788.453020] 3.14.0-rc6-next-20140313-sasha-00010-gb8c1db1-dirty #217 Tainted: G        W
[  788.453827] ---------------------------------------------------------
[  788.454371] kswapd3/4199 just changed the state of lock:
[  788.454902]  (&delayed_node->mutex){+.+.-.}, at: __btrfs_release_delayed_node+0x4f/0x140 (fs/btrfs/delayed-inode.c:263)
[  788.455890] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[  788.456543]  (&found->groups_sem){+++++.}

and interrupts could create inverse lock ordering between them.

[  788.457491]
[  788.457491] other info that might help us debug this:
[  788.458115]  Possible interrupt unsafe locking scenario:
[  788.458115]
[  788.458756]        CPU0                    CPU1
[  788.459188]        ----                    ----
[  788.459625]   lock(&found->groups_sem);
[  788.460041]                                local_irq_disable();
[  788.460041]                                lock(&delayed_node->mutex);
[  788.460041]                                lock(&found->groups_sem);
[  788.460041]   <Interrupt>
[  788.460041]     lock(&delayed_node->mutex);
[  788.460041]
[  788.460041]  *** DEADLOCK ***
[  788.460041]
[  788.460041] 2 locks held by kswapd3/4199:
[  788.460041]  #0:  (shrinker_rwsem){++++..}, at: shrink_slab+0x3f/0x160 (mm/vmscan.c:360)
[  788.460041]  #1:  (&type->s_umount_key#108){.+.+..}, at: grab_super_passive+0x56/0x90 (fs/super.c:361)
[  788.460041]
[  788.460041] the shortest dependencies between 2nd lock and 1st lock:
[  788.460041]  -> (&found->groups_sem){+++++.} ops: 46 {
[  788.460041]     HARDIRQ-ON-W at:
[  788.460041]                       mark_irqflags+0xf0/0x170 (kernel/locking/lockdep.c:2800)
[  788.460041]                       __lock_acquire+0x2de/0x5a0 (kernel/locking/lockdep.c:3138)
[  788.460041]                       lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]                       down_write+0x5c/0xc0 (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[  788.460041]                       __link_block_group+0x45/0x110 (fs/btrfs/extent-tree.c:8348)
[  788.460041]                       btrfs_read_block_groups+0x3ae/0x700 (fs/btrfs/extent-tree.c:8533)
[  788.460041]                       open_ctree+0x1abf/0x2210 (fs/btrfs/disk-io.c:2749)
[  788.460041]                       btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                       btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                       mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                       vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                       do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)[  788.460041]                       do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                       SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                       tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]     HARDIRQ-ON-R at:
[  788.460041]                       mark_irqflags+0xbc/0x170 (kernel/locking/lockdep.c:2792)
[  788.460041]                       __lock_acquire+0x2de/0x5a0 (kernel/locking/lockdep.c:3138)
[  788.460041]                       lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]                       down_read+0x4c/0xa0 (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:23)
[  788.460041]                       btrfs_calc_num_tolerated_disk_barrier_failures+0x2a7/0x3a0 (fs/btrfs/disk-io.c:3309)
[  788.460041]                       open_ctree+0x1af7/0x2210 (fs/btrfs/disk-io.c:2755)
[  788.460041]                       btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                       btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                       mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                       vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                       do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)
[  788.460041]                       do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                       SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                       tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]     SOFTIRQ-ON-W at:
[  788.460041]                       mark_irqflags+0x110/0x170 (kernel/locking/lockdep.c:2804)
[  788.460041]                       __lock_acquire+0x2de/0x5a0 (kernel/locking/lockdep.c:3138)
[  788.460041]                       lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]                       down_write+0x5c/0xc0 (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[  788.460041]                       __link_block_group+0x45/0x110 (fs/btrfs/extent-tree.c:8348)
[  788.460041]                       btrfs_read_block_groups+0x3ae/0x700 (fs/btrfs/extent-tree.c:8533)
[  788.460041]                       open_ctree+0x1abf/0x2210 (fs/btrfs/disk-io.c:2749)
[  788.460041]                       btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                       btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                       mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                       vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                       do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)
[  788.460041]                       do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                       SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                       tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]     SOFTIRQ-ON-R at:
[  788.460041]                       mark_irqflags+0x110/0x170 (kernel/locking/lockdep.c:2804)
[  788.460041]                       __lock_acquire+0x2de/0x5a0 (kernel/locking/lockdep.c:3138)
[  788.460041]                       lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]                       down_read+0x4c/0xa0 (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:23)
[  788.460041]                       btrfs_calc_num_tolerated_disk_barrier_failures+0x2a7/0x3a0 (fs/btrfs/disk-io.c:3309)
[  788.460041]                       open_ctree+0x1af7/0x2210 (fs/btrfs/disk-io.c:2755)
[  788.460041]                       btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                       btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                       mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                       vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                       do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)
[  788.460041]                       do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                       SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                       tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]     RECLAIM_FS-ON-W at:
[  788.460041]                          mark_held_locks+0x6c/0x90 (kernel/locking/lockdep.c:2523)
[  788.460041]                          lockdep_trace_alloc+0xfd/0x140 (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[  788.460041]                          __kmalloc_track_caller+0x80/0x350 (mm/slub.c:965 mm/slub.c:2402 mm/slub.c:2475 mm/slub.c:3851)
[  788.460041]                          kvasprintf+0x5b/0x90 (lib/kasprintf.c:24)
[  788.460041]                          kobject_set_name_vargs+0x23/0x70 (lib/kobject.c:266)
[  788.460041]                          kobject_add_varg+0x25/0x60 (lib/kobject.c:348)
[  788.460041]                          kobject_add+0x70/0x80 (lib/kobject.c:403)
[  788.460041]                          __link_block_group+0xad/0x110 (fs/btrfs/extent-tree.c:8355)
[  788.460041]                          btrfs_read_block_groups+0x3ae/0x700 (fs/btrfs/extent-tree.c:8533)
[  788.460041]                          open_ctree+0x1abf/0x2210 (fs/btrfs/disk-io.c:2749)
[  788.460041]                          btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                          btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                          mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                          vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                          do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)
[  788.460041]                          do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                          SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                          tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]     INITIAL USE at:
[  788.460041]                      __lock_acquire+0x301/0x5a0 (kernel/locking/lockdep.c:3142)
[  788.460041]                      lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]                      down_write+0x5c/0xc0 (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[  788.460041]                      __link_block_group+0x45/0x110 (fs/btrfs/extent-tree.c:8348)
[  788.460041]                      btrfs_read_block_groups+0x3ae/0x700 (fs/btrfs/extent-tree.c:8533)
[  788.460041]                      open_ctree+0x1abf/0x2210 (fs/btrfs/disk-io.c:2749)
[  788.460041]                      btrfs_fill_super+0x81/0x140 (fs/btrfs/super.c:958)
[  788.460041]                      btrfs_mount+0x26a/0x300 (fs/btrfs/super.c:1295)
[  788.460041]                      mount_fs+0x8d/0x1a0 (fs/super.c:1091)
[  788.460041]                      vfs_kern_mount+0x79/0x150 (fs/namespace.c:813)
[  788.460041]                      do_new_mount+0xcd/0x1c0 (fs/namespace.c:2068)
[  788.460041]                      do_mount+0x15d/0x210 (fs/namespace.c:2392)
[  788.460041]                      SyS_mount+0x9d/0xe0 (fs/namespace.c:2589 fs/namespace.c:2560)
[  788.460041]                      tracesys+0xdd/0xe2 (arch/x86/kernel/entry_64.S:749)
[  788.460041]   }
[  788.460041]   ... key      at: __key.59054+0x0/0x8 (??:0)
[  788.460041]   ... acquired at:
[  788.460041]    validate_chain+0x6c5/0x7b0 (kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131)
[  788.460041]    __lock_acquire+0x4cd/0x5a0 (kernel/locking/lockdep.c:3182)
[  788.460041]    lock_acquire+0x182/0x1d0 (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  788.460041]    down_read+0x4c/0xa0 (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:23)
[  788.460041]    find_free_extent+0x391/0xbf0 (fs/btrfs/extent-tree.c:6235)
[  788.460041]    btrfs_reserve_extent+0x7a/0x130 (fs/btrfs/extent-tree.c:6609)
[  788.460041]    btrfs_alloc_free_block+0x94/0x260 (fs/btrfs/extent-tree.c:7003)
[  788.460041]    __btrfs_cow_block+0x14a/0x4c0 (fs/btrfs/ctree.c:1168)
[  788.460041]    btrfs_cow_block+0x159/0x2b0 (fs/btrfs/ctree.c:1600)
[  788.460041]    btrfs_search_slot+0x33c/0x740 (fs/btrfs/ctree.c:2837)
[  788.460041]    btrfs_lookup_inode+0x2f/0xa0 (fs/btrfs/inode-item.c:423)
[  788.460041]    __btrfs_update_delayed_inode+0x61/0x240 (fs/btrfs/delayed-inode.c:1051)
[  788.460041]    __btrfs_run_delayed_items+0x123/0x1f0 (fs/btrfs/delayed-inode.c:1126 fs/btrfs/delayed-inode.c:1145 fs/btrfs/delayed-inode.c:1180)
[  788.460041]    btrfs_run_delayed_items+0x13/0x20 (fs/btrfs/delayed-inode.c:1206)
[  788.460041]    btrfs_flush_all_pending_stuffs+0x24/0x80 (fs/btrfs/transaction.c:1594)
[  788.460041]    btrfs_commit_transaction+0x25b/0x9f0 (fs/btrfs/transaction.c:1728)
[  788.460041]    transaction_kthread+0x133/0x250 (fs/btrfs/disk-io.c:1768)


Thanks,
Sasha
