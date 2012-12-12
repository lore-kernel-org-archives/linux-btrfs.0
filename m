Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44463 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2LLPQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 10:16:56 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (jored mo21) (RZmta 31.9 AUTH)
	with ESMTPA id 604e88oBCEFrAk for <linux-btrfs@vger.kernel.org>;
	Wed, 12 Dec 2012 16:16:54 +0100 (CET)
Message-ID: <50C89FE6.4020307@giantdisaster.de>
Date: Wed, 12 Dec 2012 16:16:54 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] btrfs-next issues detected with xfstest, part #2
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the last part.

./check 078-299

[112]
Dec 12 12:51:05 qvarne root: run xfstest 112
device fsid 55bc7fff-2ed3-48c4-94d8-e4ec5157ae21 devid 1 transid 35 /dev/sdg
btrfs: enabling check integrity
btrfs: use lzo compression
btrfs: enabling auto defrag
btrfs: disk space caching is enabled
------------[ cut here ]------------
kernel BUG at fs/btrfs/locking.c:265!
invalid opcode: 0000 [#1] SMP
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class
CPU 2
Pid: 31783, comm: fsx Tainted: G        W    3.7.0+ #106 Supermicro X8SIL/X8SIL
RIP: 0010:[<ffffffffa0112d90>]  [<ffffffffa0112d90>] btrfs_assert_tree_locked+0x10/0x20 [btrfs]
RSP: 0018:ffff88022ef899c8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8801e35aea20 RCX: 0000000000000001
RDX: 00000001dd212000 RSI: ffff880000000000 RDI: ffff880225977700
RBP: ffff88022ef899c8 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000006 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000001 R14: ffff88022b551000 R15: ffff880230aaebe0
FS:  00007f46ad977700(0000) GS:ffff880236a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46ad8e9000 CR3: 0000000231cec000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx (pid: 31783, threadinfo ffff88022ef88000, task ffff88022e1b2270)
Stack:
 ffff88022ef89a68 ffffffffa00bbf1b 0000000000000006 0000000000000006
 0000000000000035 0000000000000005 ffff88022ef89a68 ffffffff00000001
 ffff880200000001 00000f6600000006 ffff880100000001 ffff880225975e40
Call Trace:
 [<ffffffffa00bbf1b>] push_leaf_left+0xab/0x1a0 [btrfs]
 [<ffffffffa00bf75d>] btrfs_del_items+0x37d/0x4f0 [btrfs]
 [<ffffffffa00ff3c4>] ? read_extent_buffer+0xb4/0x110 [btrfs]
 [<ffffffffa0116325>] drop_adjacent_extents.isra.24+0x465/0x480 [btrfs]
 [<ffffffffa0116628>] log_one_extent.isra.25+0x2e8/0x710 [btrfs]
 [<ffffffffa0118cdc>] ? btrfs_log_inode+0x7fc/0x8e0 [btrfs]
 [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
 [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
 [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
 [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
 [<ffffffff811c7526>] vfs_fsync+0x26/0x30
 [<ffffffff81178f9c>] sys_msync+0x13c/0x1c0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
Code: 5d 41 5e 41 5f 5d c3 be e8 00 00 00 48 c7 c7 06 27 15 a0 e8 33 38 f7 e0 eb bb 90 8b 87 cc 00 00 00 55 48 89 e5 85 c0 74 02 5d c3 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
 00 55 48 89 e5 48
RIP  [<ffffffffa0112d90>] btrfs_assert_tree_locked+0x10/0x20 [btrfs]
 RSP <ffff88022ef899c8>
---[ end trace 2f6666e1b1941b46 ]---

A sysrq-b was required to reboot the box.

./check 113-299

[113 shows same issue as already seen with 076]
Dec 12 13:50:54 qvarne root: run xfstest 113
device fsid 55bc7fff-2ed3-48c4-94d8-e4ec5157ae21 devid 1 transid 41 /dev/sdg
btrfs: enabling check integrity
btrfs: use lzo compression
btrfs: enabling auto defrag
btrfs: disk space caching is enabled
======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.7.0+ #106 Not tainted
------------------------------------------------------
aio-stress/4272 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&root->log_extents_lock[0])->rlock){+.+...}, at: [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
and this task is already holding:
 (&(&t->lock)->rlock){..-...}, at: [<ffffffffa00f6714>] btrfs_get_logged_extents+0x24/0xd0 [btrfs]
which would create a new lock dependency:
 (&(&t->lock)->rlock){..-...} -> (&(&root->log_extents_lock[0])->rlock){+.+...}
but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&t->lock)->rlock){..-...}
... which became SOFTIRQ-irq-safe at:
  [<ffffffff810e1d45>] __lock_acquire+0x5f5/0x1c00
  [<ffffffff810e3965>] lock_acquire+0x95/0x150
  [<ffffffff8195ded2>] _raw_spin_lock_irqsave+0x52/0x90
  [<ffffffffa00f656d>] btrfs_dec_test_ordered_pending+0x3d/0x1c0 [btrfs]
  [<ffffffffa00e2e42>] btrfs_writepage_end_io_hook+0x72/0x1a0 [btrfs]
  [<ffffffffa00fc002>] end_extent_writepage+0x42/0x70 [btrfs]
  [<ffffffffa00fc06b>] end_bio_extent_writepage+0x3b/0xa0 [btrfs]
  [<ffffffff811cd4c8>] bio_endio+0x18/0x30
  [<ffffffffa010a61d>] btrfs_end_bio+0xfd/0x190 [btrfs]
  [<ffffffff811cd4c8>] bio_endio+0x18/0x30
  [<ffffffff81417a63>] req_bio_endio.isra.52+0x83/0xc0
  [<ffffffff814193f1>] blk_update_request+0x111/0x540
  [<ffffffff8141984c>] blk_update_bidi_request+0x2c/0x90
  [<ffffffff8141a997>] blk_end_bidi_request+0x27/0x70
  [<ffffffff8141aa1b>] blk_end_request+0xb/0x10
  [<ffffffff8159cb9a>] scsi_io_completion+0xaa/0x680
  [<ffffffff815932dc>] scsi_finish_command+0xbc/0x110
  [<ffffffff8159c9ef>] scsi_softirq_done+0x12f/0x150
  [<ffffffff81420913>] blk_done_softirq+0x73/0x90
  [<ffffffff8108ef0d>] __do_softirq+0xcd/0x290
  [<ffffffff8196788c>] call_softirq+0x1c/0x30
  [<ffffffff810452f5>] do_softirq+0x85/0xc0
  [<ffffffff8108f26e>] irq_exit+0x9e/0xc0
  [<ffffffff81044dee>] do_IRQ+0x5e/0xd0
  [<ffffffff8195ec6f>] ret_from_intr+0x0/0x13
  [<ffffffff816df25a>] cpuidle_enter+0x1a/0x20
  [<ffffffff816df8fe>] cpuidle_idle_call+0xbe/0x320
  [<ffffffff8104c1f5>] cpu_idle+0x85/0xd0
  [<ffffffff8194a6af>] start_secondary+0x220/0x222
to a SOFTIRQ-irq-unsafe lock:
 (&(&root->log_extents_lock[0])->rlock){+.+...}
... which became SOFTIRQ-irq-unsafe at:
...  [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
  [<ffffffff810e3965>] lock_acquire+0x95/0x150
  [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
  [<ffffffffa00f69aa>] btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
  [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
  [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
  [<ffffffff811c75f8>] do_fsync+0x58/0x80
  [<ffffffff811c799b>] sys_fsync+0xb/0x10
  [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
other info that might help us debug this:
 Possible interrupt unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&(&root->log_extents_lock[0])->rlock);
                               local_irq_disable();
                               lock(&(&t->lock)->rlock);
                               lock(&(&root->log_extents_lock[0])->rlock);
  <Interrupt>
    lock(&(&t->lock)->rlock);
 *** DEADLOCK ***
4 locks held by aio-stress/4272:
 #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00ef9bd>] btrfs_sync_file+0xad/0x2c0 [btrfs]
 #1:  (sb_internal){.+.+..}, at: [<ffffffffa00dfba6>] start_transaction+0x2a6/0x470 [btrfs]
 #2:  (&ei->log_mutex){+.+...}, at: [<ffffffffa01185f6>] btrfs_log_inode+0x116/0x8e0 [btrfs]
 #3:  (&(&t->lock)->rlock){..-...}, at: [<ffffffffa00f6714>] btrfs_get_logged_extents+0x24/0xd0 [btrfs]
the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&(&t->lock)->rlock){..-...} ops: 30788 {
   IN-SOFTIRQ-W at:
                    [<ffffffff810e1d45>] __lock_acquire+0x5f5/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195ded2>] _raw_spin_lock_irqsave+0x52/0x90
                    [<ffffffffa00f656d>] btrfs_dec_test_ordered_pending+0x3d/0x1c0 [btrfs]
                    [<ffffffffa00e2e42>] btrfs_writepage_end_io_hook+0x72/0x1a0 [btrfs]
                    [<ffffffffa00fc002>] end_extent_writepage+0x42/0x70 [btrfs]
                    [<ffffffffa00fc06b>] end_bio_extent_writepage+0x3b/0xa0 [btrfs]
                    [<ffffffff811cd4c8>] bio_endio+0x18/0x30
                    [<ffffffffa010a61d>] btrfs_end_bio+0xfd/0x190 [btrfs]
                    [<ffffffff811cd4c8>] bio_endio+0x18/0x30
                    [<ffffffff81417a63>] req_bio_endio.isra.52+0x83/0xc0
                    [<ffffffff814193f1>] blk_update_request+0x111/0x540
                    [<ffffffff8141984c>] blk_update_bidi_request+0x2c/0x90
                    [<ffffffff8141a997>] blk_end_bidi_request+0x27/0x70
                    [<ffffffff8141aa1b>] blk_end_request+0xb/0x10
                    [<ffffffff8159cb9a>] scsi_io_completion+0xaa/0x680
                    [<ffffffff815932dc>] scsi_finish_command+0xbc/0x110
                    [<ffffffff8159c9ef>] scsi_softirq_done+0x12f/0x150
                    [<ffffffff81420913>] blk_done_softirq+0x73/0x90
                    [<ffffffff8108ef0d>] __do_softirq+0xcd/0x290
                    [<ffffffff8196788c>] call_softirq+0x1c/0x30
                    [<ffffffff810452f5>] do_softirq+0x85/0xc0
                    [<ffffffff8108f26e>] irq_exit+0x9e/0xc0
                    [<ffffffff81044dee>] do_IRQ+0x5e/0xd0
                    [<ffffffff8195ec6f>] ret_from_intr+0x0/0x13
                    [<ffffffff816df25a>] cpuidle_enter+0x1a/0x20
                    [<ffffffff816df8fe>] cpuidle_idle_call+0xbe/0x320
                    [<ffffffff8104c1f5>] cpu_idle+0x85/0xd0
                    [<ffffffff8194a6af>] start_secondary+0x220/0x222
   INITIAL USE at:
                   [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                   [<ffffffff810e3965>] lock_acquire+0x95/0x150
                   [<ffffffff8195de46>] _raw_spin_lock_irq+0x46/0x80
                   [<ffffffffa00f731d>] btrfs_lookup_ordered_extent+0x2d/0xe0 [btrfs]
                   [<ffffffffa00fc6bf>] __extent_read_full_page+0xcf/0x660 [btrfs]
                   [<ffffffffa00ff213>] read_extent_buffer_pages+0x263/0x360 [btrfs]
                   [<ffffffffa00d7541>] btree_read_extent_buffer_pages.constprop.119+0xb1/0x110 [btrfs]
                   [<ffffffffa00d8b25>] read_tree_block+0x35/0x50 [btrfs]
                   [<ffffffffa00dc5f2>] open_ctree+0x1292/0x1ee0 [btrfs]
                   [<ffffffffa00b4b36>] btrfs_mount+0x5a6/0x680 [btrfs]
                   [<ffffffff8119c54e>] mount_fs+0x3e/0x1b0
                   [<ffffffff811b6b33>] vfs_kern_mount+0x63/0x100
                   [<ffffffff811b734f>] do_kern_mount+0x4f/0x100
                   [<ffffffff811b8d0c>] do_mount+0x19c/0x880
                   [<ffffffff811b947b>] sys_mount+0x8b/0xe0
                   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa015fe98>] __key.35139+0x0/0xfffffffffffea68e [btrfs]
 ... acquired at:
   [<ffffffff810e12cb>] check_irq_usage+0x5b/0xe0
   [<ffffffff810e27bb>] __lock_acquire+0x106b/0x1c00
   [<ffffffff810e3965>] lock_acquire+0x95/0x150
   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
   [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
   [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
   [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
   [<ffffffff811c75f8>] do_fsync+0x58/0x80
   [<ffffffff811c799b>] sys_fsync+0xb/0x10
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
-> (&(&root->log_extents_lock[0])->rlock){+.+...} ops: 2 {
   HARDIRQ-ON-W at:
                    [<ffffffff810e1d73>] __lock_acquire+0x623/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa00f69aa>] btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                    [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                    [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa00f69aa>] btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                    [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                    [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   INITIAL USE at:
                   [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                   [<ffffffff810e3965>] lock_acquire+0x95/0x150
                   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                   [<ffffffffa00f69aa>] btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                   [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                   [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                   [<ffffffff811c75f8>] do_fsync+0x58/0x80
                   [<ffffffff811c799b>] sys_fsync+0xb/0x10
                   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa015fc88>] __key.37235+0x0/0xfffffffffffea89e [btrfs]
 ... acquired at:
   [<ffffffff810e12cb>] check_irq_usage+0x5b/0xe0
   [<ffffffff810e27bb>] __lock_acquire+0x106b/0x1c00
   [<ffffffff810e3965>] lock_acquire+0x95/0x150
   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
   [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
   [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
   [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
   [<ffffffff811c75f8>] do_fsync+0x58/0x80
   [<ffffffff811c799b>] sys_fsync+0xb/0x10
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
stack backtrace:
Pid: 4272, comm: aio-stress Not tainted 3.7.0+ #106
Call Trace:
 [<ffffffff810e1262>] check_usage+0x4c2/0x4d0
 [<ffffffff810bec15>] ? sched_clock_cpu+0xc5/0x120
 [<ffffffff810e12cb>] check_irq_usage+0x5b/0xe0
 [<ffffffff810e27bb>] __lock_acquire+0x106b/0x1c00
 [<ffffffff810de1bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffa00f6770>] ? btrfs_get_logged_extents+0x80/0xd0 [btrfs]
 [<ffffffff810e3965>] lock_acquire+0x95/0x150
 [<ffffffffa00f6770>] ? btrfs_get_logged_extents+0x80/0xd0 [btrfs]
 [<ffffffffa01185f6>] ? btrfs_log_inode+0x116/0x8e0 [btrfs]
 [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
 [<ffffffffa00f6770>] ? btrfs_get_logged_extents+0x80/0xd0 [btrfs]
 [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
 [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
 [<ffffffff810e423e>] ? mark_held_locks+0x7e/0x140
 [<ffffffff810e449d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
 [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
 [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
 [<ffffffff819666f7>] ? sysret_check+0x1b/0x56
 [<ffffffff811c75f8>] do_fsync+0x58/0x80
 [<ffffffff814427ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811c799b>] sys_fsync+0xb/0x10
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
------------[ cut here ]------------

sysrq-b

./check 114-299

[117 shows same "INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected" issue as already seen with 076 and 113]

[127 skipped -- took too long]

[013, 068, 071, 091, 218...]
WARNING: at fs/btrfs/inode.c:7755 btrfs_destroy_inode+0x236/0x2d0 [btrfs]()
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eeeb6>] btrfs_destroy_inode+0x236/0x2d0 [btrfs]
 [<ffffffff811b24f7>] destroy_inode+0x37/0x60
 [<ffffffff811b263d>] evict+0x11d/0x1b0
 [<ffffffff811b2709>] dispose_list+0x39/0x50
 [<ffffffff811b340c>] evict_inodes+0x10c/0x120
 [<ffffffff8119aa3e>] generic_shutdown_super+0x4e/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
WARNING: at fs/btrfs/inode.c:7756 btrfs_destroy_inode+0x2be/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7758 btrfs_destroy_inode+0x292/0x2d0 [btrfs]()
WARNING: at fs/btrfs/extent-tree.c:4351 btrfs_free_block_groups+0x2b5/0x360 [btrfs]()
WARNING: at fs/btrfs/extent-tree.c:4352 btrfs_free_block_groups+0x34f/0x360 [btrfs]()
WARNING: at fs/btrfs/extent-tree.c:7650 btrfs_free_block_groups+0x246/0x360 [btrfs]()
space_info 1 has 8085504 free, is not full
space_info total=8388608, used=303104, pinned=0, reserved=0, may_use=40960, readonly=0
WARNING: at fs/btrfs/extent-tree.c:7650 btrfs_free_block_groups+0x246/0x360 [btrfs]()
space_info 4 has 1073651712 free, is not full
space_info total=1082130432, used=24576, pinned=0, reserved=0, may_use=1179648, readonly=8454144

[241]
see other mail.

[256 skipped -- took too long]

[263]
WARNING: at fs/btrfs/inode.c:7755 btrfs_destroy_inode+0x236/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7756 btrfs_destroy_inode+0x2be/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7758 btrfs_destroy_inode+0x292/0x2d0 [btrfs]()
kernel BUG at fs/btrfs/locking.c:265!

sysrq-b

mkfs.btrfs /dev/sdg
mkfs.btrfs /dev/sdi
./check 264-299

[274 -- not reproducible]
Dec 12 14:40:34 qvarne root: run xfstest 274
device fsid f2fdb070-1360-4a0e-a22d-f5df8601e2ab devid 1 transid 4 /dev/sdi
btrfs: enabling check integrity
btrfs: use lzo compression
btrfs: enabling auto defrag
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.7.0+ #106 Not tainted
---------------------------------------------------------
dd/17866 just changed the state of lock:
 (&(&root->log_extents_lock[1])->rlock){+.+...}, at: [<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&(&t->lock)->rlock){..-...}
and interrupts could create inverse lock ordering between them.
other info that might help us debug this:
 Possible interrupt unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&(&root->log_extents_lock[1])->rlock);
                               local_irq_disable();
                               lock(&(&t->lock)->rlock);
                               lock(&(&root->log_extents_lock[1])->rlock);
  <Interrupt>
    lock(&(&t->lock)->rlock);
 *** DEADLOCK ***
4 locks held by dd/17866:
 #0:  (sb_writers#9){.+.+.+}, at: [<ffffffffa00f1054>] btrfs_file_aio_write+0x94/0x620 [btrfs]
 #1:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00ef9bd>] btrfs_sync_file+0xad/0x2c0 [btrfs]
 #2:  (sb_internal){.+.+..}, at: [<ffffffffa00dfba6>] start_transaction+0x2a6/0x470 [btrfs]
 #3:  (&ei->log_mutex){+.+...}, at: [<ffffffffa01185f6>] btrfs_log_inode+0x116/0x8e0 [btrfs]
the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&t->lock)->rlock){..-...} ops: 1289693 {
    IN-SOFTIRQ-W at:
                      [<ffffffff810e1d45>] __lock_acquire+0x5f5/0x1c00
                      [<ffffffff810e3965>] lock_acquire+0x95/0x150
                      [<ffffffff8195ded2>] _raw_spin_lock_irqsave+0x52/0x90
                      [<ffffffffa00f656d>] btrfs_dec_test_ordered_pending+0x3d/0x1c0 [btrfs]
                      [<ffffffffa00e2e42>] btrfs_writepage_end_io_hook+0x72/0x1a0 [btrfs]
                      [<ffffffffa00fc002>] end_extent_writepage+0x42/0x70 [btrfs]
                      [<ffffffffa00fc06b>] end_bio_extent_writepage+0x3b/0xa0 [btrfs]
                      [<ffffffff811cd4c8>] bio_endio+0x18/0x30
                      [<ffffffffa010a61d>] btrfs_end_bio+0xfd/0x190 [btrfs]
                      [<ffffffff811cd4c8>] bio_endio+0x18/0x30
                      [<ffffffff81417a63>] req_bio_endio.isra.52+0x83/0xc0
                      [<ffffffff814193f1>] blk_update_request+0x111/0x540
                      [<ffffffff8141984c>] blk_update_bidi_request+0x2c/0x90
                      [<ffffffff8141a997>] blk_end_bidi_request+0x27/0x70
                      [<ffffffff8141aa1b>] blk_end_request+0xb/0x10
                      [<ffffffff8159cb9a>] scsi_io_completion+0xaa/0x680
                      [<ffffffff815932dc>] scsi_finish_command+0xbc/0x110
                      [<ffffffff8159c9ef>] scsi_softirq_done+0x12f/0x150
                      [<ffffffff81420913>] blk_done_softirq+0x73/0x90
                      [<ffffffff8108ef0d>] __do_softirq+0xcd/0x290
                      [<ffffffff8196788c>] call_softirq+0x1c/0x30
                      [<ffffffff810452f5>] do_softirq+0x85/0xc0
                      [<ffffffff8108f26e>] irq_exit+0x9e/0xc0
                      [<ffffffff81044dee>] do_IRQ+0x5e/0xd0
                      [<ffffffff8195ec6f>] ret_from_intr+0x0/0x13
                      [<ffffffff816df25a>] cpuidle_enter+0x1a/0x20
                      [<ffffffff816df8fe>] cpuidle_idle_call+0xbe/0x320
                      [<ffffffff8104c1f5>] cpu_idle+0x85/0xd0
                      [<ffffffff8194a6af>] start_secondary+0x220/0x222
    INITIAL USE at:
                     [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                     [<ffffffff810e3965>] lock_acquire+0x95/0x150
                     [<ffffffff8195de46>] _raw_spin_lock_irq+0x46/0x80
                     [<ffffffffa00f731d>] btrfs_lookup_ordered_extent+0x2d/0xe0 [btrfs]
                     [<ffffffffa00fc6bf>] __extent_read_full_page+0xcf/0x660 [btrfs]
                     [<ffffffffa00ff213>] read_extent_buffer_pages+0x263/0x360 [btrfs]
                     [<ffffffffa00d7541>] btree_read_extent_buffer_pages.constprop.119+0xb1/0x110 [btrfs]
                     [<ffffffffa00d8b25>] read_tree_block+0x35/0x50 [btrfs]
                     [<ffffffffa00dc5f2>] open_ctree+0x1292/0x1ee0 [btrfs]
                     [<ffffffffa00b4b36>] btrfs_mount+0x5a6/0x680 [btrfs]
                     [<ffffffff8119c54e>] mount_fs+0x3e/0x1b0
                     [<ffffffff811b6b33>] vfs_kern_mount+0x63/0x100
                     [<ffffffff811b734f>] do_kern_mount+0x4f/0x100
                     [<ffffffff811b8d0c>] do_mount+0x19c/0x880
                     [<ffffffff811b947b>] sys_mount+0x8b/0xe0
                     [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
  }
  ... key      at: [<ffffffffa015fe98>] __key.35139+0x0/0xfffffffffffea68e [btrfs]
  ... acquired at:
   [<ffffffff810e3965>] lock_acquire+0x95/0x150
   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
   [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
   [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
   [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
   [<ffffffff811c7583>] generic_write_sync+0x53/0x70
   [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
   [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
   [<ffffffff81198ad1>] vfs_write+0xb1/0x180
   [<ffffffff81198e10>] sys_write+0x50/0xa0
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
-> (&(&root->log_extents_lock[1])->rlock){+.+...} ops: 2 {
   HARDIRQ-ON-W at:
                    [<ffffffff810e1d73>] __lock_acquire+0x623/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
                    [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
                    [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                    [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
                    [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                    [<ffffffff811c7583>] generic_write_sync+0x53/0x70
                    [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
                    [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
                    [<ffffffff81198ad1>] vfs_write+0xb1/0x180
                    [<ffffffff81198e10>] sys_write+0x50/0xa0
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
                    [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
                    [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                    [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
                    [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                    [<ffffffff811c7583>] generic_write_sync+0x53/0x70
                    [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
                    [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
                    [<ffffffff81198ad1>] vfs_write+0xb1/0x180
                    [<ffffffff81198e10>] sys_write+0x50/0xa0
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   INITIAL USE at:
                   [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                   [<ffffffff810e3965>] lock_acquire+0x95/0x150
                   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                   [<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
                   [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
                   [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
                   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                   [<ffffffff811c7583>] generic_write_sync+0x53/0x70
                   [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
                   [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
                   [<ffffffff81198ad1>] vfs_write+0xb1/0x180
                   [<ffffffff81198e10>] sys_write+0x50/0xa0
                   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa015fc90>] __key.37236+0x0/0xfffffffffffea896 [btrfs]
 ... acquired at:
   [<ffffffff810e0d60>] check_usage_backwards+0x110/0x150
   [<ffffffff810e15f8>] mark_lock+0x198/0x2f0
   [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
   [<ffffffff810e3965>] lock_acquire+0x95/0x150
   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
   [<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
   [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
   [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
   [<ffffffff811c7583>] generic_write_sync+0x53/0x70
   [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
   [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
   [<ffffffff81198ad1>] vfs_write+0xb1/0x180
   [<ffffffff81198e10>] sys_write+0x50/0xa0
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
stack backtrace:
Pid: 17866, comm: dd Not tainted 3.7.0+ #106
Call Trace:
 [<ffffffff810e0af8>] print_irq_inversion_bug.part.40+0x1e8/0x1f0
 [<ffffffff810e0d60>] check_usage_backwards+0x110/0x150
 [<ffffffff810e15f8>] mark_lock+0x198/0x2f0
 [<ffffffff810e0c50>] ? check_usage_forwards+0x150/0x150
 [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
 [<ffffffff810bec15>] ? sched_clock_cpu+0xc5/0x120
 [<ffffffff810becbb>] ? local_clock+0x4b/0x60
 [<ffffffff810dea95>] ? lock_release_holdtime.part.25+0x15/0x190
 [<ffffffffa00f8ac1>] ? release_extent_buffer.isra.25+0xb1/0xe0 [btrfs]
 [<ffffffffa011668e>] ? log_one_extent.isra.25+0x34e/0x710 [btrfs]
 [<ffffffff810e3965>] lock_acquire+0x95/0x150
 [<ffffffffa011668e>] ? log_one_extent.isra.25+0x34e/0x710 [btrfs]
 [<ffffffff8195e796>] ? _raw_spin_unlock+0x26/0x40
 [<ffffffffa00f8ac1>] ? release_extent_buffer.isra.25+0xb1/0xe0 [btrfs]
 [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
 [<ffffffffa011668e>] ? log_one_extent.isra.25+0x34e/0x710 [btrfs]
 [<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
 [<ffffffff810de1bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810dea95>] ? lock_release_holdtime.part.25+0x15/0x190
 [<ffffffffa0118cb0>] ? btrfs_log_inode+0x7d0/0x8e0 [btrfs]
 [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
 [<ffffffff810e423e>] ? mark_held_locks+0x7e/0x140
 [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
 [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
 [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
 [<ffffffff810e449d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811c7583>] generic_write_sync+0x53/0x70
 [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
 [<ffffffff810bec15>] ? sched_clock_cpu+0xc5/0x120
 [<ffffffff810de1bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810becbb>] ? local_clock+0x4b/0x60
 [<ffffffff810becbb>] ? local_clock+0x4b/0x60
 [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
 [<ffffffff81198ad1>] vfs_write+0xb1/0x180
 [<ffffffff81198e10>] sys_write+0x50/0xa0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
btrfs: attempt to write superblock which references block M @222605312 (sdi/222605312/1) with generation 8 != parent generation 9!
------------[ cut here ]------------
WARNING: at fs/btrfs/check-integrity.c:2533 btrfsic_process_written_superblock+0x256/0x3e0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class
Pid: 17866, comm: dd Not tainted 3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa01468d6>] btrfsic_process_written_superblock+0x256/0x3e0 [btrfs]
 [<ffffffffa0147ce4>] btrfsic_process_written_block+0x634/0xf90 [btrfs]
 [<ffffffffa014866d>] ? btrfsic_submit_bh+0x2d/0x1d0 [btrfs]
 [<ffffffffa014866d>] ? btrfsic_submit_bh+0x2d/0x1d0 [btrfs]
 [<ffffffffa014876d>] btrfsic_submit_bh+0x12d/0x1d0 [btrfs]
 [<ffffffffa00d778e>] write_dev_supers.isra.113+0x1ee/0x280 [btrfs]
 [<ffffffffa00d9530>] write_all_supers+0x650/0x910 [btrfs]
 [<ffffffffa01348e7>] ? btrfs_scrub_pause_super+0x17/0x20 [btrfs]
 [<ffffffffa00d97fe>] write_ctree_super+0xe/0x10 [btrfs]
 [<ffffffffa011a344>] btrfs_sync_log+0x654/0x6c0 [btrfs]
 [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
 [<ffffffff810e449d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811c7583>] generic_write_sync+0x53/0x70
 [<ffffffffa00f1296>] btrfs_file_aio_write+0x2d6/0x620 [btrfs]
 [<ffffffff810bec15>] ? sched_clock_cpu+0xc5/0x120
 [<ffffffff814427ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81120aa0>] ? rcu_irq_exit+0x60/0xb0
 [<ffffffff811d6c94>] ? fsnotify+0x84/0x2f0
 [<ffffffff8119840b>] do_sync_write+0x9b/0xe0
 [<ffffffff81198ad1>] vfs_write+0xb1/0x180
 [<ffffffff81198e10>] sys_write+0x50/0xa0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 757707b80c8ca9bf ]---
S-65536(sdi/65536/1) --> M-222609408(sdi/222609408/0) --> M-222605312(sdi/222605312/1)
                     --> M-131072(sdi/131072/0)
                     --> M-326303744(sdi/326303744/0) --> M-4194304(sdi/4194304/1)
                                                      --> M-294621184(sdi/294621184/1) --> M-294633472(sdi/294633472/0) --> M-325406720(sdi/325406720/0)
                                                                                                                        --> M-321982464(sdi/321982464/0)
                                                                                                                        --> M-318558208(sdi/318558208/0)
                                                                                                                        --> M-315138048(sdi/315138048/0)
...
------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:7755 btrfs_destroy_inode+0x236/0x2d0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class
Pid: 17881, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eeeb6>] btrfs_destroy_inode+0x236/0x2d0 [btrfs]
 [<ffffffff811b24f7>] destroy_inode+0x37/0x60
 [<ffffffff811b263d>] evict+0x11d/0x1b0
 [<ffffffff811b2709>] dispose_list+0x39/0x50
 [<ffffffff811b340c>] evict_inodes+0x10c/0x120
 [<ffffffff8119aa3e>] generic_shutdown_super+0x4e/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 757707b80c8cad54 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:7756 btrfs_destroy_inode+0x2be/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7758 btrfs_destroy_inode+0x292/0x2d0 [btrfs]()
WARNING: at fs/btrfs/extent-tree.c:4351 btrfs_free_block_groups+0x2b5/0x360 [btrfs]()
Call Trace:
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
WARNING: at fs/btrfs/extent-tree.c:4352 btrfs_free_block_groups+0x34f/0x360 [btrfs]()
WARNING: at fs/btrfs/extent-tree.c:7650 btrfs_free_block_groups+0x246/0x360 [btrfs]()
space_info 5 has 824860672 free, is full
space_info total=1069547520, used=244621312, pinned=0, reserved=0, may_use=810991616, readonly=65536
btrfs warning page private not zero on page 221949952
btrfs warning page private not zero on page 221954048
btrfs warning page private not zero on page 221962240
btrfs warning page private not zero on page 222539776
btrfs warning page private not zero on page 222543872
btrfs warning page private not zero on page 222552064
btrfs warning page private not zero on page 222601216
btrfs warning page private not zero on page 222605312
btrfs warning page private not zero on page 222609408

