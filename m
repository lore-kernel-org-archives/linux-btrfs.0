From: Daniel J Blueman <daniel@quora.org>
Subject: umount vs delayed allocation potential deadlock...
Date: Mon, 9 Apr 2012 23:15:21 +0800
Message-ID: <CAMVG2stauVZZPPUS0J0UvUj_eSy0ip3YmU5pRtm1sN09dX632A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When testing btrfs on 3.4-rc2 with unmount directly after a test
workload, I see potential deadlock:

[ INFO: possible circular locking dependency detected ]
3.4.0-rc2-debug+ #2 Not tainted
-------------------------------------------------------
fio/2365 is trying to acquire lock:
 (&type->s_umount_key#19){+++++.}, at: [<ffffffff8113d1d8>]
writeback_inodes_sb_nr_if_idle+0x38/0x60

but task is already holding lock:
 (&ei->delalloc_mutex){+.+...}, at: [<ffffffffa00a864b>]
btrfs_delalloc_reserve_metadata+0x7b/0x240 [btrfs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ei->delalloc_mutex){+.+...}:
       [<ffffffff8108cf1a>] check_prevs_add+0xda/0x140
       [<ffffffff8108d359>] validate_chain.isra.33+0x3d9/0x510
       [<ffffffff8108deb8>] __lock_acquire+0x388/0x900
       [<ffffffff8108e955>] lock_acquire+0x55/0x70
       [<ffffffff815a9b0b>] mutex_lock_nested+0x6b/0x340
       [<ffffffffa00a864b>] btrfs_delalloc_reserve_metadata+0x7b/0x240 [btrfs]
       [<ffffffffa00a890b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
       [<ffffffffa00b11cf>] btrfs_save_ino_cache+0x23f/0x310 [btrfs]
       [<ffffffffa00b9370>] commit_fs_roots.isra.22+0xc0/0x190 [btrfs]
       [<ffffffffa00ba56c>] btrfs_commit_transaction+0x4cc/0x8e0 [btrfs]
       [<ffffffffa00c8f86>] btrfs_sync_file+0x116/0x1a0 [btrfs]
       [<ffffffff81140db1>] do_fsync+0x51/0x80
       [<ffffffff811410cb>] sys_fsync+0xb/0x10
       [<ffffffff815ad122>] system_call_fastpath+0x16/0x1b

-> #1 (&fs_info->tree_log_mutex){+.+...}:
       [<ffffffff8108cf1a>] check_prevs_add+0xda/0x140
       [<ffffffff8108d359>] validate_chain.isra.33+0x3d9/0x510
       [<ffffffff8108deb8>] __lock_acquire+0x388/0x900
       [<ffffffff8108e53d>] lock_release_non_nested+0x10d/0x310
       [<ffffffff8108e76a>] lock_release_nested+0x2a/0xa0
       [<ffffffff8108e88d>] __lock_release+0xad/0xd0
       [<ffffffff8108e8e6>] lock_release+0x36/0x50
       [<ffffffff815a9e66>] __mutex_unlock_slowpath+0x86/0x150
       [<ffffffff815a9f39>] mutex_unlock+0x9/0x10
       [<ffffffffa00ba7b7>] btrfs_commit_transaction+0x717/0x8e0 [btrfs]
       [<ffffffffa00953ab>] btrfs_sync_fs+0x4b/0x80 [btrfs]
       [<ffffffff81140e9e>] __sync_filesystem+0x5e/0x90
       [<ffffffff81140ee7>] sync_one_sb+0x17/0x20
       [<ffffffff811189e9>] iterate_supers+0xe9/0xf0
       [<ffffffff81140f92>] sys_sync+0x42/0x60
       [<ffffffff815ad122>] system_call_fastpath+0x16/0x1b

-> #0 (&type->s_umount_key#19){+++++.}:
       [<ffffffff8108ce29>] check_prev_add+0x719/0x730
       [<ffffffff8108cf1a>] check_prevs_add+0xda/0x140
       [<ffffffff8108d359>] validate_chain.isra.33+0x3d9/0x510
       [<ffffffff8108deb8>] __lock_acquire+0x388/0x900
       [<ffffffff8108e955>] lock_acquire+0x55/0x70
       [<ffffffff815aa2a7>] down_read+0x47/0x5c
       [<ffffffff8113d1d8>] writeback_inodes_sb_nr_if_idle+0x38/0x60
       [<ffffffffa00a0b2a>] shrink_delalloc+0x13a/0x200 [btrfs]
       [<ffffffffa00a7672>] reserve_metadata_bytes.isra.70+0x1c2/0x430 [btrfs]
       [<ffffffffa00a86ff>] btrfs_delalloc_reserve_metadata+0x12f/0x240 [btrfs]
       [<ffffffffa00a890b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
       [<ffffffffa00bceea>] btrfs_direct_IO+0x14a/0x410 [btrfs]
       [<ffffffff810c641c>] generic_file_direct_write+0xcc/0x190
       [<ffffffffa0112391>] __btrfs_direct_write+0x40/0x146 [btrfs]
       [<ffffffffa00ca3af>] btrfs_file_aio_write+0x33f/0x350 [btrfs]
       [<ffffffff8115b1a9>] aio_rw_vect_retry+0xb9/0x160
       [<ffffffff8115caee>] aio_run_iocb+0x5e/0x150
       [<ffffffff8115d265>] io_submit_one+0x175/0x220
       [<ffffffff8115d6d9>] do_io_submit+0x129/0x1c0
       [<ffffffff8115d77b>] sys_io_submit+0xb/0x10
       [<ffffffff815ad122>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

Chain exists of:
  &type->s_umount_key#19 --> &fs_info->tree_log_mutex --> &ei->delalloc_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ei->delalloc_mutex);
                               lock(&fs_info->tree_log_mutex);
                               lock(&ei->delalloc_mutex);
  lock(&type->s_umount_key#19);

 *** DEADLOCK ***

2 locks held by fio/2365:
 #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffffa00ca13f>]
btrfs_file_aio_write+0xcf/0x350 [btrfs]
 #1:  (&ei->delalloc_mutex){+.+...}, at: [<ffffffffa00a864b>]
btrfs_delalloc_reserve_metadata+0x7b/0x240 [btrfs]

stack backtrace:
Pid: 2365, comm: fio Not tainted 3.4.0-rc2-debug+ #2
Call Trace:
 [<ffffffff81598195>] print_circular_bug+0xda/0xeb
 [<ffffffff8108ce29>] check_prev_add+0x719/0x730
 [<ffffffff8108deb8>] ? __lock_acquire+0x388/0x900
 [<ffffffff8108cf1a>] check_prevs_add+0xda/0x140
 [<ffffffff8108d359>] validate_chain.isra.33+0x3d9/0x510
 [<ffffffff8108deb8>] __lock_acquire+0x388/0x900
 [<ffffffff8108e955>] lock_acquire+0x55/0x70
 [<ffffffff8113d1d8>] ? writeback_inodes_sb_nr_if_idle+0x38/0x60
 [<ffffffff815aa2a7>] down_read+0x47/0x5c
 [<ffffffff8113d1d8>] ? writeback_inodes_sb_nr_if_idle+0x38/0x60
 [<ffffffff8108e88d>] ? __lock_release+0xad/0xd0
 [<ffffffff8113d1d8>] writeback_inodes_sb_nr_if_idle+0x38/0x60
 [<ffffffffa00a0b2a>] shrink_delalloc+0x13a/0x200 [btrfs]
 [<ffffffffa00a7672>] reserve_metadata_bytes.isra.70+0x1c2/0x430 [btrfs]
 [<ffffffff8108e801>] ? __lock_release+0x21/0xd0
 [<ffffffffa00a86ff>] btrfs_delalloc_reserve_metadata+0x12f/0x240 [btrfs]
 [<ffffffffa00a890b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
 [<ffffffffa00bceea>] btrfs_direct_IO+0x14a/0x410 [btrfs]
 [<ffffffff810cffbf>] ? do_writepages+0x1f/0x40
 [<ffffffff810c641c>] generic_file_direct_write+0xcc/0x190
 [<ffffffffa0112391>] __btrfs_direct_write+0x40/0x146 [btrfs]
 [<ffffffffa00c602f>] ? btrfs_update_time+0x5f/0x160 [btrfs]
 [<ffffffffa00ca3af>] btrfs_file_aio_write+0x33f/0x350 [btrfs]
 [<ffffffff815ac54b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff815ac54b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffffa00ca070>] ? __btrfs_buffered_write+0x340/0x340 [btrfs]
 [<ffffffff8115b1a9>] aio_rw_vect_retry+0xb9/0x160
 [<ffffffff8115b0f0>] ? aio_advance_iovec+0x90/0x90
 [<ffffffff8115caee>] aio_run_iocb+0x5e/0x150
 [<ffffffff8115d265>] io_submit_one+0x175/0x220
 [<ffffffff8115d6d9>] do_io_submit+0x129/0x1c0
 [<ffffffff8115d77b>] sys_io_submit+0xb/0x10
 [<ffffffff815ad122>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
