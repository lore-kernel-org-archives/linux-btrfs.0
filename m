From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: 2.6.38 fs balance lock ordering...
Date: Thu, 24 Mar 2011 18:11:20 +0800
Message-ID: <AANLkTim6B0aWKs0KWmZvMeymeVP6j81RQY9Mfwm4GpTU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While doing a filesystem balance, lockdep detecting a potential lock
ordering issue [1].

Thanks,
  Daniel

--- [1]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38.1-341cd+ #10
-------------------------------------------------------
btrfs/1101 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff812cddb9>]
prealloc_file_extent_cluster+0x59/0x180

but task is already holding lock:
 (&fs_info->cleaner_mutex){+.+.+.}, at: [<ffffffff812cfcb7>]
btrfs_relocate_block_group+0x197/0x2d0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&fs_info->cleaner_mutex){+.+.+.}:
       [<ffffffff8109628a>] lock_acquire+0x5a/0x70
       [<ffffffff816c9cde>] mutex_lock_nested+0x5e/0x390
       [<ffffffff812828e1>] btrfs_commit_super+0x21/0xe0
       [<ffffffff812857a2>] close_ctree+0x332/0x3a0
       [<ffffffff8125fd08>] btrfs_put_super+0x18/0x30
       [<ffffffff8113ae7d>] generic_shutdown_super+0x6d/0xf0
       [<ffffffff8113af91>] kill_anon_super+0x11/0x60
       [<ffffffff8113b6b5>] deactivate_locked_super+0x45/0x60
       [<ffffffff8113c2b5>] deactivate_super+0x45/0x60
       [<ffffffff81158729>] mntput_no_expire+0x99/0xf0
       [<ffffffff8115996c>] sys_umount+0x7c/0x3c0
       [<ffffffff81002dfb>] system_call_fastpath+0x16/0x1b

-> #1 (&type->s_umount_key#24){++++++}:
       [<ffffffff8109628a>] lock_acquire+0x5a/0x70
       [<ffffffff816ca372>] down_read+0x42/0x60
       [<ffffffff8115e935>] writeback_inodes_sb_nr_if_idle+0x35/0x60
       [<ffffffff812723ae>] shrink_delalloc+0xee/0x180
       [<ffffffff81273253>] btrfs_delalloc_reserve_metadata+0x163/0x180
       [<ffffffff812732ab>] btrfs_delalloc_reserve_space+0x3b/0x60
       [<ffffffff8129563d>] btrfs_file_aio_write+0x61d/0x9c0
       [<ffffffff81137f12>] do_sync_write+0xd2/0x110
       [<ffffffff81138a88>] vfs_write+0xc8/0x190
       [<ffffffff81138c3c>] sys_write+0x4c/0x90
       [<ffffffff81002dfb>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
       [<ffffffff810961a8>] __lock_acquire+0x1ba8/0x1c30
       [<ffffffff8109628a>] lock_acquire+0x5a/0x70
       [<ffffffff816c9cde>] mutex_lock_nested+0x5e/0x390
       [<ffffffff812cddb9>] prealloc_file_extent_cluster+0x59/0x180
       [<ffffffff812ce0a1>] relocate_file_extent_cluster+0x91/0x380
       [<ffffffff812ce44b>] relocate_data_extent+0xbb/0xd0
       [<ffffffff812cf843>] relocate_block_group+0x323/0x600
       [<ffffffff812cfcc8>] btrfs_relocate_block_group+0x1a8/0x2d0
       [<ffffffff812b09c3>] btrfs_relocate_chunk+0x83/0x600
       [<ffffffff812b160d>] btrfs_balance+0x20d/0x280
       [<ffffffff812b8b86>] btrfs_ioctl+0x1b6/0xa80
       [<ffffffff8114a43d>] do_vfs_ioctl+0x9d/0x590
       [<ffffffff8114a97a>] sys_ioctl+0x4a/0x80
       [<ffffffff81002dfb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

2 locks held by btrfs/1101:
 #0:  (&fs_info->volume_mutex){+.+.+.}, at: [<ffffffff812b148b>]
btrfs_balance+0x8b/0x280
 #1:  (&fs_info->cleaner_mutex){+.+.+.}, at: [<ffffffff812cfcb7>]
btrfs_relocate_block_group+0x197/0x2d0

stack backtrace:
Pid: 1101, comm: btrfs Tainted: G        W   2.6.38.1-341cd+ #10
Call Trace:
 [<ffffffff810937fb>] ? print_circular_bug+0xeb/0xf0
 [<ffffffff810961a8>] ? __lock_acquire+0x1ba8/0x1c30
 [<ffffffff812a5fd1>] ? map_private_extent_buffer+0xe1/0x210
 [<ffffffff812cddb9>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff8109628a>] ? lock_acquire+0x5a/0x70
 [<ffffffff812cddb9>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff810565f5>] ? add_preempt_count+0x75/0xd0
 [<ffffffff816c9cde>] ? mutex_lock_nested+0x5e/0x390
 [<ffffffff812cddb9>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff81125fa3>] ? init_object+0x43/0x80
 [<ffffffff81051121>] ? get_parent_ip+0x11/0x50
 [<ffffffff812cddb9>] ? prealloc_file_extent_cluster+0x59/0x180
 [<ffffffff812ce0a1>] ? relocate_file_extent_cluster+0x91/0x380
 [<ffffffff812ce44b>] ? relocate_data_extent+0xbb/0xd0
 [<ffffffff812cf843>] ? relocate_block_group+0x323/0x600
 [<ffffffff812cfcc8>] ? btrfs_relocate_block_group+0x1a8/0x2d0
 [<ffffffff812b09c3>] ? btrfs_relocate_chunk+0x83/0x600
 [<ffffffff812a62d2>] ? read_extent_buffer+0xf2/0x230
 [<ffffffff8126c286>] ? btrfs_search_slot+0x886/0xa90
 [<ffffffff8105654d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff812a62d2>] ? read_extent_buffer+0xf2/0x230
 [<ffffffff812b160d>] ? btrfs_balance+0x20d/0x280
 [<ffffffff812b8b86>] ? btrfs_ioctl+0x1b6/0xa80
 [<ffffffff8103146c>] ? do_page_fault+0x1cc/0x440
 [<ffffffff8114a43d>] ? do_vfs_ioctl+0x9d/0x590
 [<ffffffff8113943f>] ? fget_light+0x1df/0x3c0
 [<ffffffff8114a97a>] ? sys_ioctl+0x4a/0x80
 [<ffffffff81002dfb>] ? system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
