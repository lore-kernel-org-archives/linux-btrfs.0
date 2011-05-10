From: David Sterba <dave@jikos.cz>
Subject: Lockdep warning in btrfs_clear_lock_blocking
Date: Tue, 10 May 2011 14:44:47 +0200
Message-ID: <20110510124447.GP12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've hit this lockdep warning, 2.6.39rc6. Single btrfs partition, 30GB,
filled with 2GB, "compress-force=lzo", warning trigered after normal copy+du.
Happened only once.

[Might be a false positive.]

david

[14547.128565] =============================================
[14547.132010] [ INFO: possible recursive locking detected ]
[14547.132010] 2.6.39-rc6-default+ #4
[14547.132010] ---------------------------------------------
[14547.132010] du/22878 is trying to acquire lock:
[14547.132010]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0401e8c>]
btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[14547.132010]
[14547.132010] but task is already holding lock:
[14547.132010]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0401e02>]
btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[14547.132010]
[14547.132010] other info that might help us debug this:
[14547.132010] 2 locks held by du/22878:
[14547.132010]  #0:  (&sb->s_type->i_mutex_key#18){+.+.+.}, at: [<ffffffff81175df5>] vfs_readdir+0x75/0xd0
[14547.132010]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0401e02>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[14547.132010]
[14547.132010] stack backtrace:
[14547.132010] Pid: 22878, comm: du Not tainted 2.6.39-rc6-default+ #4
[14547.132010] Call Trace:
[14547.132010]  [<ffffffff810be08b>] __lock_acquire+0x159b/0x1de0
[14547.132010]  [<ffffffff810ac8d8>] ? sched_clock_cpu+0xa8/0x110
[14547.132010]  [<ffffffff810ac745>] ? sched_clock_local+0x25/0x90
[14547.132010]  [<ffffffff810bef4f>] lock_acquire+0x9f/0x130
[14547.132010]  [<ffffffffa0401e8c>] ? btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[14547.132010]  [<ffffffff814e1586>] _raw_spin_lock+0x36/0x70
[14547.132010]  [<ffffffffa0401e8c>] ? btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[14547.132010]  [<ffffffffa0401e02>] ?  btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[14547.132010]  [<ffffffffa0401e8c>] btrfs_try_spin_lock+0x7c/0xa0 [btrfs]
[14547.132010]  [<ffffffffa03b312d>] btrfs_search_slot+0x80d/0x880 [btrfs]
[14547.132010]  [<ffffffffa03d1d8f>] btrfs_real_readdir+0xcf/0x4f0 [btrfs]
[14547.132010]  [<ffffffff814df901>] ?  mutex_lock_killable_nested+0x281/0x3c0
[14547.132010]  [<ffffffff81175ad0>] ? sys_ioctl+0x80/0x80
[14547.132010]  [<ffffffff81175df5>] ? vfs_readdir+0x75/0xd0
[14547.132010]  [<ffffffff810b984d>] ? trace_hardirqs_off+0xd/0x10
[14547.132010]  [<ffffffff810ac9af>] ? local_clock+0x6f/0x80
[14547.132010]  [<ffffffff81175df5>] ? vfs_readdir+0x75/0xd0
[14547.132010]  [<ffffffff81175ad0>] ? sys_ioctl+0x80/0x80
[14547.132010]  [<ffffffff81175e28>] vfs_readdir+0xa8/0xd0
[14547.132010]  [<ffffffff8116419c>] ? fget+0x8c/0x260
[14547.132010]  [<ffffffff81164110>] ? fget_raw+0x250/0x250
[14547.132010]  [<ffffffff81176045>] sys_getdents64+0x85/0xf0
[14547.132010]  [<ffffffff814ea482>] system_call_fastpath+0x16/0x1b
