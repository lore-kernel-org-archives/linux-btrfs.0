From: Stephen Hemminger <shemminger@vyatta.com>
Subject: lockdep warnings
Date: Mon, 15 Nov 2010 12:51:29 -0800
Message-ID: <20101115125129.07f3882d@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Running with lockdep I see these warnings (running 2.6.37-rc1)

It occurred during the time when rsync is running backup.


Nov 14 12:03:31 nehalam kernel: [ 5527.284541] =============================================
Nov 14 12:03:31 nehalam kernel: [ 5527.284544] [ INFO: possible recursive locking detected ]
Nov 14 12:03:31 nehalam kernel: [ 5527.284546] 2.6.37-rc1+ #67
Nov 14 12:03:31 nehalam kernel: [ 5527.284547] ---------------------------------------------
Nov 14 12:03:31 nehalam kernel: [ 5527.284549] rsync/2782 is trying to acquire lock:
Nov 14 12:03:31 nehalam kernel: [ 5527.284551]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa005f026>] btrfs_try_spin_lock+0x53/0xd1 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284567] 
Nov 14 12:03:31 nehalam kernel: [ 5527.284567] but task is already holding lock:
Nov 14 12:03:31 nehalam kernel: [ 5527.284569]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa005f0c6>] btrfs_clear_lock_blocking+0x22/0x2c [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284581] 
Nov 14 12:03:31 nehalam kernel: [ 5527.284581] other info that might help us debug this:
Nov 14 12:03:31 nehalam kernel: [ 5527.284583] 2 locks held by rsync/2782:
Nov 14 12:03:31 nehalam kernel: [ 5527.284585]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f98be>] do_lookup+0x9d/0x10d
Nov 14 12:03:31 nehalam kernel: [ 5527.284592]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa005f0c6>] btrfs_clear_lock_blocking+0x22/0x2c [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284605] 
Nov 14 12:03:31 nehalam kernel: [ 5527.284605] stack backtrace:
Nov 14 12:03:31 nehalam kernel: [ 5527.284607] Pid: 2782, comm: rsync Not tainted 2.6.37-rc1+ #67
Nov 14 12:03:31 nehalam kernel: [ 5527.284609] Call Trace:
Nov 14 12:03:31 nehalam kernel: [ 5527.284615]  [<ffffffff8106b651>] __lock_acquire+0xc7a/0xcf1
Nov 14 12:03:31 nehalam kernel: [ 5527.284619]  [<ffffffff810ba186>] ? activate_page+0x130/0x13f
Nov 14 12:03:31 nehalam kernel: [ 5527.284622]  [<ffffffff8106b799>] lock_acquire+0xd1/0xf7
Nov 14 12:03:31 nehalam kernel: [ 5527.284633]  [<ffffffffa005f026>] ? btrfs_try_spin_lock+0x53/0xd1 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284638]  [<ffffffff813b31c7>] _raw_spin_lock+0x31/0x40
Nov 14 12:03:31 nehalam kernel: [ 5527.284648]  [<ffffffffa005f026>] ? btrfs_try_spin_lock+0x53/0xd1 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284659]  [<ffffffffa005f0c6>] ? btrfs_clear_lock_blocking+0x22/0x2c [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284669]  [<ffffffffa005f026>] btrfs_try_spin_lock+0x53/0xd1 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284677]  [<ffffffffa0022714>] btrfs_search_slot+0x3e6/0x513 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284687]  [<ffffffffa003121f>] btrfs_lookup_inode+0x2f/0x8f [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284698]  [<ffffffffa003ac58>] ? btrfs_init_locked_inode+0x0/0x2e [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284709]  [<ffffffffa003e2a7>] btrfs_iget+0xc3/0x415 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284721]  [<ffffffffa00419b9>] btrfs_lookup_dentry+0x105/0x3c4 [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284724]  [<ffffffff81069db5>] ? trace_hardirqs_on+0xd/0xf
Nov 14 12:03:31 nehalam kernel: [ 5527.284735]  [<ffffffffa0041c8e>] btrfs_lookup+0x16/0x2e [btrfs]
Nov 14 12:03:31 nehalam kernel: [ 5527.284738]  [<ffffffff810f97b5>] d_alloc_and_lookup+0x55/0x74
Nov 14 12:03:31 nehalam kernel: [ 5527.284741]  [<ffffffff810f98dc>] do_lookup+0xbb/0x10d
Nov 14 12:03:31 nehalam kernel: [ 5527.284744]  [<ffffffff810fb6a1>] link_path_walk+0x2a6/0x3fc
Nov 14 12:03:31 nehalam kernel: [ 5527.284746]  [<ffffffff810fb8f3>] path_walk+0x69/0xd9
Nov 14 12:03:31 nehalam kernel: [ 5527.284750]  [<ffffffff811e23c2>] ? strncpy_from_user+0x48/0x76
Nov 14 12:03:31 nehalam kernel: [ 5527.284753]  [<ffffffff810fba35>] do_path_lookup+0x2a/0x4f
Nov 14 12:03:31 nehalam kernel: [ 5527.284756]  [<ffffffff810fc52f>] user_path_at+0x56/0x9a
Nov 14 12:03:31 nehalam kernel: [ 5527.284760]  [<ffffffff810caa14>] ? might_fault+0x5c/0xac
Nov 14 12:03:31 nehalam kernel: [ 5527.284764]  [<ffffffff810f4701>] ? cp_new_stat+0xf7/0x10d
Nov 14 12:03:31 nehalam kernel: [ 5527.284767]  [<ffffffff810f45a2>] vfs_fstatat+0x37/0x62
Nov 14 12:03:31 nehalam kernel: [ 5527.284770]  [<ffffffff810f45eb>] vfs_lstat+0x1e/0x20
Nov 14 12:03:31 nehalam kernel: [ 5527.284772]  [<ffffffff810f4773>] sys_newlstat+0x1f/0x3d
Nov 14 12:03:31 nehalam kernel: [ 5527.284776]  [<ffffffff81069d84>] ? trace_hardirqs_on_caller+0x118/0x13c
Nov 14 12:03:31 nehalam kernel: [ 5527.284779]  [<ffffffff813b2fe0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov 14 12:03:31 nehalam kernel: [ 5527.284783]  [<ffffffff8100245b>] system_call_fastpath+0x16/0x1b
