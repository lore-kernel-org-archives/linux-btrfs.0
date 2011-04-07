From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: 2.6.39-rc2 filesystem balance lock ordering...
Date: Thu, 7 Apr 2011 12:37:05 +0800
Message-ID: <BANLkTim0LnrEhjN9TwTr59EU2OE8uqOmmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While trying to reproduce an earlier problem on 2.6.39-rc2, we see a
possible deadlock from locks being taken in an inconsistent order:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.39-rc2-350cd #2
-------------------------------------------------------
btrfs/27867 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff812df249>]
prealloc_file_extent_cluster+0x59/0x180

but task is already holding lock:
 (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffff812e0dd7>]
btrfs_relocate_block_group+0x197/0x2d0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&fs_info->cleaner_mutex){+.+...}:
       [<ffffffff81098857>] validate_chain+0x5a7/0x6c0
       [<ffffffff81098e05>] __lock_acquire+0x495/0x920
       [<ffffffff810992ea>] lock_acquire+0x5a/0x70
       [<ffffffff817076de>] mutex_lock_nested+0x5e/0x390
       [<ffffffff81293161>] btrfs_commit_super+0x21/0xe0
       [<ffffffff81294468>] close_ctree+0x258/0x2d0
       [<ffffffff8126f418>] btrfs_put_super+0x18/0x30
       [<ffffffff811430bd>] generic_shutdown_super+0x6d/0xf0
       [<ffffffff811431d1>] kill_anon_super+0x11/0x60
       [<ffffffff811438f5>] deactivate_locked_super+0x45/0x60
       [<ffffffff811441c5>] deactivate_super+0x45/0x60
       [<ffffffff811611a9>] mntput_no_expire+0x99/0xf0
       [<ffffffff81161da7>] sys_umount+0x67/0xd0
       [<ffffffff81709ffb>] system_call_fastpath+0x16/0x1b

-> #1 (&type->s_umount_key#32){+++++.}:
       [<ffffffff81098857>] validate_chain+0x5a7/0x6c0
       [<ffffffff81098e05>] __lock_acquire+0x495/0x920
       [<ffffffff810992ea>] lock_acquire+0x5a/0x70
       [<ffffffff81707d72>] down_read+0x42/0x60
       [<ffffffff81167805>] writeback_inodes_sb_nr_if_idle+0x35/0x60
       [<ffffffff812824fe>] shrink_delalloc+0xee/0x180
       [<ffffffff81282653>] reserve_metadata_bytes+0xc3/0x200
       [<ffffffff81282bf4>] btrfs_delalloc_reserve_metadata+0xc4/0x150
       [<ffffffff81282cbb>] btrfs_delalloc_reserve_space+0x3b/0x60
       [<ffffffff812a5843>] __btrfs_buffered_write+0x153/0x320
       [<ffffffff812a5da0>] btrfs_file_aio_write+0x230/0x310
       [<ffffffff81182904>] aio_rw_vect_retry+0x74/0x1d0
       [<ffffffff81184501>] aio_run_iocb+0x61/0x180
       [<ffffffff81184ddf>] io_submit_one+0x15f/0x210
       [<ffffffff81184fa8>] do_io_submit+0x118/0x1d0
       [<ffffffff8118506b>] sys_io_submit+0xb/0x10
       [<ffffffff81709ffb>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
       [<ffffffff81097d15>] check_prev_add+0x705/0x720
       [<ffffffff81098857>] validate_chain+0x5a7/0x6c0
       [<ffffffff81098e05>] __lock_acquire+0x495/0x920
       [<ffffffff810992ea>] lock_acquire+0x5a/0x70
       [<ffffffff817076de>] mutex_lock_nested+0x5e/0x390
       [<ffffffff812df249>] prealloc_file_extent_cluster+0x59/0x180
       [<ffffffff812df531>] relocate_file_extent_cluster+0x91/0x380
       [<ffffffff812df85f>] relocate_data_extent+0x3f/0xd0
       [<ffffffff812e0963>] relocate_block_group+0x323/0x600
       [<ffffffff812e0de8>] btrfs_relocate_block_group+0x1a8/0x2d0
       [<ffffffff812c14ed>] btrfs_relocate_chunk+0x6d/0x3b0
       [<ffffffff812c1a4a>] btrfs_shrink_device+0x21a/0x3d0
       [<ffffffff812c1fdb>] btrfs_balance+0x10b/0x280
       [<ffffffff812c9ec0>] btrfs_ioctl+0x450/0x590
       [<ffffffff81152e8d>] do_vfs_ioctl+0x8d/0x330
       [<ffffffff8115317a>] sys_ioctl+0x4a/0x80
       [<ffffffff81709ffb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

2 locks held by btrfs/27867:
 #0:  (&fs_info->volume_mutex){+.+...}, at: [<ffffffff812c1f5b>]
btrfs_balance+0x8b/0x280
 #1:  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffff812e0dd7>]
btrfs_relocate_block_group+0x197/0x2d0

stack backtrace:
Pid: 27867, comm: btrfs Tainted: G        W   2.6.39-rc2-350cd #2
Call Trace:
 [<ffffffff81096d7b>] print_circular_bug+0xeb/0xf0
 [<ffffffff81097d15>] check_prev_add+0x705/0x720
 [<ffffffff81098857>] validate_chain+0x5a7/0x6c0
 [<ffffffff81098e05>] __lock_acquire+0x495/0x920
 [<ffffffff812b5b2e>] ? unmap_extent_buffer+0xe/0x40
 [<ffffffff81271d5c>] ? generic_bin_search+0x19c/0x210
 [<ffffffff812df249>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff810992ea>] lock_acquire+0x5a/0x70
 [<ffffffff812df249>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff810558fd>] ? add_preempt_count+0x7d/0xd0
 [<ffffffff817076de>] mutex_lock_nested+0x5e/0x390
 [<ffffffff812df249>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff81095f9c>] ? mark_held_locks+0x6c/0xa0
 [<ffffffff8112eb7d>] ? __slab_alloc+0x18d/0x480
 [<ffffffff8109629d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff812df249>] prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff812df516>] ? relocate_file_extent_cluster+0x76/0x380
 [<ffffffff812df531>] relocate_file_extent_cluster+0x91/0x380
 [<ffffffff8129737f>] ? __btrfs_end_transaction+0x15f/0x240
 [<ffffffff812df85f>] relocate_data_extent+0x3f/0xd0
 [<ffffffff812e0963>] relocate_block_group+0x323/0x600
 [<ffffffff812e0de8>] btrfs_relocate_block_group+0x1a8/0x2d0
 [<ffffffff812c14ed>] btrfs_relocate_chunk+0x6d/0x3b0
 [<ffffffff8105584d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff812b5b2e>] ? unmap_extent_buffer+0xe/0x40
 [<ffffffff812ab4a5>] ? btrfs_dev_extent_chunk_offset+0xe5/0xf0
 [<ffffffff812c1a4a>] btrfs_shrink_device+0x21a/0x3d0
 [<ffffffff812c1fdb>] btrfs_balance+0x10b/0x280
 [<ffffffff81085b9e>] ? up_read+0x1e/0x40
 [<ffffffff81031d5c>] ? do_page_fault+0x1cc/0x440
 [<ffffffff812c9ec0>] btrfs_ioctl+0x450/0x590
 [<ffffffff81152e8d>] do_vfs_ioctl+0x8d/0x330
 [<ffffffff8114148f>] ? fget_light+0x2bf/0x3c0
 [<ffffffff8109629d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8115317a>] sys_ioctl+0x4a/0x80
 [<ffffffff81709ffb>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
