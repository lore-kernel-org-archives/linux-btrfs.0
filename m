Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:21614 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2LLPMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 10:12:21 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (josoe mo15) (RZmta 31.9 AUTH)
	with ESMTPA id U05d7eoBCF7qEf for <linux-btrfs@vger.kernel.org>;
	Wed, 12 Dec 2012 16:12:18 +0100 (CET)
Message-ID: <50C89ED2.1020101@giantdisaster.de>
Date: Wed, 12 Dec 2012 16:12:18 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] btrfs-next issues detected with xfstest, part #1
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make sure you have a wide terminal to read the following logs. The
current btrfs-next was taken to run the xfstest suite.

export TEST_DEV=/dev/sdg
export TEST_DIR=/mnt3
export SCRATCH_DEV=/dev/sdi
export SCRATCH_MNT=/mnt2
cd ~/git/xfs/cmds/xfstests
grep check_int common.rc
  gives this result:        export MOUNT_OPTIONS="-o
check_int,compress=lzo,autodefrag,space_cache"

./check 001-299

[010]
Dec 12 11:41:04 qvarne root: run xfstest 010
=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.7.0+ #106 Not tainted
---------------------------------------------------------
dbtest/8502 just changed the state of lock:
 (&(&root->log_extents_lock[1])->rlock){+.+...}, at:
[<ffffffffa011668e>] log_one_extent.isra.25+0x34e/0x710 [btrfs]
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
3 locks held by dbtest/8502:
 #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00ef9bd>]
btrfs_sync_file+0xad/0x2c0 [btrfs]
 #1:  (sb_internal){.+.+..}, at: [<ffffffffa00dfba6>]
start_transaction+0x2a6/0x470 [btrfs]
 #2:  (&ei->log_mutex){+.+...}, at: [<ffffffffa01185f6>]
btrfs_log_inode+0x116/0x8e0 [btrfs]
the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&t->lock)->rlock){..-...} ops: 90123 {
    IN-SOFTIRQ-W at:
                      [<ffffffff810e1d45>] __lock_acquire+0x5f5/0x1c00
                      [<ffffffff810e3965>] lock_acquire+0x95/0x150
                      [<ffffffff8195ded2>] _raw_spin_lock_irqsave+0x52/0x90
                      [<ffffffffa00f656d>]
btrfs_dec_test_ordered_pending+0x3d/0x1c0 [btrfs]
                      [<ffffffffa00e2e42>]
btrfs_writepage_end_io_hook+0x72/0x1a0 [btrfs]
                      [<ffffffffa00fc002>]
end_extent_writepage+0x42/0x70 [btrfs]
                      [<ffffffffa00fc06b>]
end_bio_extent_writepage+0x3b/0xa0 [btrfs]
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
                     [<ffffffffa00f731d>]
btrfs_lookup_ordered_extent+0x2d/0xe0 [btrfs]
                     [<ffffffffa00fc6bf>]
__extent_read_full_page+0xcf/0x660 [btrfs]
                     [<ffffffffa00ff213>]
read_extent_buffer_pages+0x263/0x360 [btrfs]
                     [<ffffffffa00d7541>]
btree_read_extent_buffer_pages.constprop.119+0xb1/0x110 [btrfs]
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
  ... key      at: [<ffffffffa015fe98>]
__key.35139+0x0/0xfffffffffffea68e [btrfs]
  ... acquired at:
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
-> (&(&root->log_extents_lock[1])->rlock){+.+...} ops: 6 {
   HARDIRQ-ON-W at:
                    [<ffffffff810e1d73>] __lock_acquire+0x623/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa011668e>]
log_one_extent.isra.25+0x34e/0x710 [btrfs]
                    [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
                    [<ffffffffa011a9ca>]
btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                    [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60
[btrfs]
                    [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa011668e>]
log_one_extent.isra.25+0x34e/0x710 [btrfs]
                    [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
                    [<ffffffffa011a9ca>]
btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                    [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60
[btrfs]
                    [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   INITIAL USE at:
                   [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                   [<ffffffff810e3965>] lock_acquire+0x95/0x150
                   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                   [<ffffffffa00f6770>]
btrfs_get_logged_extents+0x80/0xd0 [btrfs]
                   [<ffffffffa0118605>] btrfs_log_inode+0x125/0x8e0 [btrfs]
                   [<ffffffffa011a9ca>]
btrfs_log_inode_parent+0x18a/0x450 [btrfs]
                   [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60
[btrfs]
                   [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
                   [<ffffffff811c75f8>] do_fsync+0x58/0x80
                   [<ffffffff811c799b>] sys_fsync+0xb/0x10
                   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa015fc90>]
__key.37236+0x0/0xfffffffffffea896 [btrfs]
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
   [<ffffffff811c75f8>] do_fsync+0x58/0x80
   [<ffffffff811c799b>] sys_fsync+0xb/0x10
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
stack backtrace:
Pid: 8502, comm: dbtest Not tainted 3.7.0+ #106
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
 [<ffffffff819666f7>] ? sysret_check+0x1b/0x56
 [<ffffffff811c75f8>] do_fsync+0x58/0x80
 [<ffffffff814427ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811c799b>] sys_fsync+0xb/0x10
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b

[013, 068, 071, 091, 218...]
WARNING: at fs/btrfs/inode.c:7755 btrfs_destroy_inode+0x236/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7756 btrfs_destroy_inode+0x2be/0x2d0 [btrfs]()
WARNING: at fs/btrfs/inode.c:7758 btrfs_destroy_inode+0x292/0x2d0 [btrfs]()

[071]
Dec 12 11:56:55 qvarne root: run xfstest 071
------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:7755 btrfs_destroy_inode+0x236/0x2d0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eeeb6>] btrfs_destroy_inode+0x236/0x2d0 [btrfs]
 [<ffffffff811b24f7>] destroy_inode+0x37/0x60
 [<ffffffff811b263d>] evict+0x11d/0x1b0
 [<ffffffff811b2f35>] iput+0x105/0x190
 [<ffffffffa00e54f2>] btrfs_run_delayed_iputs+0xd2/0x100 [btrfs]
 [<ffffffffa00d9a67>] btrfs_commit_super+0x27/0x100 [btrfs]
 [<ffffffffa00db320>] close_ctree+0x2f0/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7af ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:7756 btrfs_destroy_inode+0x2be/0x2d0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eef3e>] btrfs_destroy_inode+0x2be/0x2d0 [btrfs]
 [<ffffffff811b24f7>] destroy_inode+0x37/0x60
 [<ffffffff811b263d>] evict+0x11d/0x1b0
 [<ffffffff811b2f35>] iput+0x105/0x190
 [<ffffffffa00e54f2>] btrfs_run_delayed_iputs+0xd2/0x100 [btrfs]
 [<ffffffffa00d9a67>] btrfs_commit_super+0x27/0x100 [btrfs]
 [<ffffffffa00db320>] close_ctree+0x2f0/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b0 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:7758 btrfs_destroy_inode+0x292/0x2d0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00eef12>] btrfs_destroy_inode+0x292/0x2d0 [btrfs]
 [<ffffffff811b24f7>] destroy_inode+0x37/0x60
 [<ffffffff811b263d>] evict+0x11d/0x1b0
 [<ffffffff811b2f35>] iput+0x105/0x190
 [<ffffffffa00e54f2>] btrfs_run_delayed_iputs+0xd2/0x100 [btrfs]
 [<ffffffffa00d9a67>] btrfs_commit_super+0x27/0x100 [btrfs]
 [<ffffffffa00db320>] close_ctree+0x2f0/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b1 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4351
btrfs_free_block_groups+0x2b5/0x360 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00ce1a5>] btrfs_free_block_groups+0x2b5/0x360 [btrfs]
 [<ffffffffa00db1ef>] close_ctree+0x1bf/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b2 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4352
btrfs_free_block_groups+0x34f/0x360 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00ce23f>] btrfs_free_block_groups+0x34f/0x360 [btrfs]
 [<ffffffffa00db1ef>] close_ctree+0x1bf/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b3 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:7650
btrfs_free_block_groups+0x246/0x360 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00ce136>] btrfs_free_block_groups+0x246/0x360 [btrfs]
 [<ffffffffa00db1ef>] close_ctree+0x1bf/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b4 ]---
space_info 1 has 1071878144 free, is not full
space_info total=1082130432, used=10252288, pinned=0, reserved=0,
may_use=524288, readonly=0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:7650
btrfs_free_block_groups+0x246/0x360 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
Pid: 20909, comm: umount Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa00ce136>] btrfs_free_block_groups+0x246/0x360 [btrfs]
 [<ffffffffa00db1ef>] close_ctree+0x1bf/0x330 [btrfs]
 [<ffffffff811b340c>] ? evict_inodes+0x10c/0x120
 [<ffffffffa00b04b4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119aa4d>] generic_shutdown_super+0x5d/0xf0
 [<ffffffff8119ab71>] kill_anon_super+0x11/0x20
 [<ffffffffa00b4515>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119b9f1>] ? deactivate_super+0x41/0x70
 [<ffffffff8119adbd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119b9f9>] deactivate_super+0x49/0x70
 [<ffffffff811b7221>] mntput_no_expire+0x101/0x160
 [<ffffffff811b81e9>] sys_umount+0x69/0x3a0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 49e8450e20d1e7b5 ]---
space_info 4 has 1073610752 free, is not full
space_info total=1082130432, used=65536, pinned=0, reserved=0,
may_use=393216, readonly=8454144

[075]
Dec 12 11:59:50 qvarne root: run xfstest 075
device fsid 791bdd4f-0db8-43ee-af10-29e62fc1b27c devid 1 transid 1772
/dev/sdg
btrfs: enabling check integrity
btrfs: use lzo compression
btrfs: enabling auto defrag
btrfs: disk space caching is enabled
BUG: soft lockup - CPU#3 stuck for 23s! [fsx:21976]
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas
scsi_transport_sas raid_class
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff810846be>]
copy_process+0x5ce/0x16b0
softirqs last  enabled at (0): [<ffffffff810846be>]
copy_process+0x5ce/0x16b0
softirqs last disabled at (0): [<          (null)>]           (null)
CPU 3
Pid: 21976, comm: fsx Tainted: G        W    3.7.0+ #106 Supermicro
X8SIL/X8SIL
RIP: 0010:[<ffffffffa00f7ce0>]  [<ffffffffa00f7ce0>] eb_cmp+0x10/0x30
[btrfs]
RSP: 0018:ffff88023483dc80  EFLAGS: 00000246
RAX: 0000000001c96000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff880230fd9128 RSI: ffff880230fd9128 RDI: 0000000000000000
RBP: ffff88023483dda8 R08: ffff880212b931f0 R09: ffff88023483de58
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8195ed1c
R13: ffffffff81120aa0 R14: ffff88023483dbe8 R15: 0000000000000000
FS:  00007fa32e3a3700(0000) GS:ffff880236c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fa32e31f000 CR3: 0000000233dd1000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx (pid: 21976, threadinfo ffff88023483c000, task ffff88020ea5c4e0)
Stack:
 ffffffff81445f7d ffff88023483dcc8 ffff88023483de58 0000000100000282
 0000000000000000 ffff88023483dcc8 ffff88023483dcc0 0000000000000000
 0000000000000000 ffff880230fd9128 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81445f7d>] ? list_sort+0x1bd/0x370
 [<ffffffff8195af39>] ? mutex_lock_nested+0x299/0x360
 [<ffffffffa00fea1b>] btrfs_sync_eb_list+0x5b/0x120 [btrfs]
 [<ffffffffa011a10c>] btrfs_sync_log+0x41c/0x6c0 [btrfs]
 [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
 [<ffffffff811c7526>] vfs_fsync+0x26/0x30
 [<ffffffff81178f9c>] sys_msync+0x13c/0x1c0
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
Code: 89 9c 24 90 00 00 00 48 8b 5d e8 4c 8b 65 f0 c9 c3 66 2e 0f 1f 84
00 00 00 00 00 48 8b 82 58 ff ff ff 31 c9 48 39 86 58 ff ff ff <55> b8
ff ff ff ff 48 89 e5 0f 97 c1 0f 43 c1
 5d c3 66 66 66 66
BUG: soft lockup - CPU#3 stuck for 23s! [fsx:21976]

At this point the box needed an 'impitool power reset' from remote to go on.

./check 076-299

[076]
device fsid 8f255b0b-d145-4a20-8fb0-812ee4b31e87 devid 1 transid 4 /dev/sdi
btrfs: enabling check integrity
btrfs: use lzo compression
btrfs: enabling auto defrag
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.7.0+ #106 Not tainted
------------------------------------------------------
fsstress/4820 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&root->log_extents_lock[0])->rlock){+.+...}, at:
[<ffffffffa00f6770>] btrfs_get_logged_extents+0x80/0xd0 [btrfs]
and this task is already holding:
 (&(&t->lock)->rlock){..-...}, at: [<ffffffffa00f6714>]
btrfs_get_logged_extents+0x24/0xd0 [btrfs]
which would create a new lock dependency:
 (&(&t->lock)->rlock){..-...} ->
(&(&root->log_extents_lock[0])->rlock){+.+...}
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
4 locks held by fsstress/4820:
 #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa00ef9bd>]
btrfs_sync_file+0xad/0x2c0 [btrfs]
 #1:  (sb_internal){.+.+..}, at: [<ffffffffa00dfba6>]
start_transaction+0x2a6/0x470 [btrfs]
 #2:  (&ei->log_mutex){+.+...}, at: [<ffffffffa01185f6>]
btrfs_log_inode+0x116/0x8e0 [btrfs]
 #3:  (&(&t->lock)->rlock){..-...}, at: [<ffffffffa00f6714>]
btrfs_get_logged_extents+0x24/0xd0 [btrfs]
the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&(&t->lock)->rlock){..-...} ops: 3800 {
   IN-SOFTIRQ-W at:
                    [<ffffffff810e1d45>] __lock_acquire+0x5f5/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195ded2>] _raw_spin_lock_irqsave+0x52/0x90
                    [<ffffffffa00f656d>]
btrfs_dec_test_ordered_pending+0x3d/0x1c0 [btrfs]
                    [<ffffffffa00e2e42>]
btrfs_writepage_end_io_hook+0x72/0x1a0 [btrfs]
                    [<ffffffffa00fc002>] end_extent_writepage+0x42/0x70
[btrfs]
                    [<ffffffffa00fc06b>]
end_bio_extent_writepage+0x3b/0xa0 [btrfs]
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
                   [<ffffffffa00f731d>]
btrfs_lookup_ordered_extent+0x2d/0xe0 [btrfs]
                   [<ffffffffa00fc6bf>]
__extent_read_full_page+0xcf/0x660 [btrfs]
                   [<ffffffffa00ff213>]
read_extent_buffer_pages+0x263/0x360 [btrfs]
                   [<ffffffffa00d7541>]
btree_read_extent_buffer_pages.constprop.119+0xb1/0x110 [btrfs]
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
 ... key      at: [<ffffffffa015fe98>]
__key.35139+0x0/0xfffffffffffea68e [btrfs]
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
   [<ffffffff811c79ae>] sys_fdatasync+0xe/0x20
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe
lock:
-> (&(&root->log_extents_lock[0])->rlock){+.+...} ops: 3 {
   HARDIRQ-ON-W at:
                    [<ffffffff810e1d73>] __lock_acquire+0x623/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa00f69aa>]
btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                    [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                    [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810e1da2>] __lock_acquire+0x652/0x1c00
                    [<ffffffff810e3965>] lock_acquire+0x95/0x150
                    [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                    [<ffffffffa00f69aa>]
btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                    [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                    [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                    [<ffffffff811c75f8>] do_fsync+0x58/0x80
                    [<ffffffff811c799b>] sys_fsync+0xb/0x10
                    [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
   INITIAL USE at:
                   [<ffffffff810e1a6a>] __lock_acquire+0x31a/0x1c00
                   [<ffffffff810e3965>] lock_acquire+0x95/0x150
                   [<ffffffff8195dd20>] _raw_spin_lock+0x40/0x80
                   [<ffffffffa00f69aa>]
btrfs_wait_logged_extents+0x4a/0x130 [btrfs]
                   [<ffffffffa011a2b4>] btrfs_sync_log+0x5c4/0x6c0 [btrfs]
                   [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
                   [<ffffffff811c75f8>] do_fsync+0x58/0x80
                   [<ffffffff811c799b>] sys_fsync+0xb/0x10
                   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa015fc88>]
__key.37235+0x0/0xfffffffffffea89e [btrfs]
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
   [<ffffffff811c79ae>] sys_fdatasync+0xe/0x20
   [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
stack backtrace:
Pid: 4820, comm: fsstress Not tainted 3.7.0+ #106
Call Trace:
 [<ffffffff810e1262>] check_usage+0x4c2/0x4d0
 [<ffffffff810de1bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810bec15>] ? sched_clock_cpu+0xc5/0x120
 [<ffffffff810e12cb>] check_irq_usage+0x5b/0xe0
 [<ffffffff810e27bb>] __lock_acquire+0x106b/0x1c00
 [<ffffffff810de1bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810e423e>] ? mark_held_locks+0x7e/0x140
 [<ffffffff8195e02a>] ? _raw_write_unlock_irqrestore+0x3a/0x70
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
 [<ffffffff811c79ae>] sys_fdatasync+0xe/0x20
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b


[tty output of 076 and 077]
076 50s ... [failed, exit status 1] - output mismatch (see 076.out.bad)
--- 076.out     2011-12-05 16:26:15.000000000 +0100
+++ 076.out.bad 2012-12-12 12:47:54.000000000 +0100
@@ -1,5 +1,5 @@
 QA output created by 076
 *** init fs
 *** test concurrent block/fs access
-*** done
+_check_btrfs_filesystem: filesystem on /dev/sdi is inconsistent (see
076.full)
 *** unmount
077 15s ... [failed, exit status 1] - output mismatch (see 077.out.bad)
--- 077.out     2011-12-05 16:26:15.000000000 +0100
+++ 077.out.bad 2012-12-12 12:48:00.000000000 +0100
@@ -3,5 +3,5 @@
 *** set default ACL
 *** populate filesystem, pass #1
 *** populate filesystem, pass #2
-*** all done
+_check_btrfs_filesystem: filesystem on /dev/sdi is inconsistent (see
077.full)
 *** unmount

root@qvarne:~/git/xfs/cmds/xfstests# less 076.full
*** MKFS ***

seed = 1355780049
_check_btrfs_filesystem: filesystem on /dev/sdi is inconsistent
*** fsck.btrfs output ***
Check tree block failed, want=20975616, have=8947527917593559565
Check tree block failed, want=20975616, have=8947527917593559565
Check tree block failed, want=20975616, have=8947527917593559565
read block failed check_tree_block
Couldn't read chunk root
*** end fsck.btrfs output
root@qvarne:~/git/xfs/cmds/xfstests# less 077.full
cp: cannot create regular file
`/mnt2/subdir/modules/3.6.5+/modules.alias.bin': No space left on device
cp: cannot create regular file
`/mnt2/subdir/modules/3.6.5+/modules.builtin.bin': No space left on device
cp: cannot create symbolic link `/mnt2/subdir/modules/3.6.5+/source': No
space left on device
...
_check_btrfs_filesystem: filesystem on /dev/sdi is inconsistent
*** fsck.btrfs output ***
parent transid verify failed on 131072 wanted 5 found 2
parent transid verify failed on 131072 wanted 5 found 2
Ignoring transid failure
Couldn't map the block 39190528
Couldn't read tree root
Critical roots corrupted, unable to fsck the FS
*** end fsck.btrfs output

