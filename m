From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.38-rc1] btrfs potential false-positive lockdep report...
Date: Thu, 20 Jan 2011 10:53:51 +0700
Message-ID: <AANLkTinTkAtUkZApi-EMpTx-R7sBagLnd4uYnUTL5Lek@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I saw a lockdep report with an instrumented 2.6.38-rc1 kernel [1].

Checking the code, it looks more likely a false-positive due to the
lock manipulation to satisfy lockdep, since CONFIG_DEBUG_LOCK_ALLOC is
defined.

Is this the case?

Thanks,
  Daniel

--- [1]

=============================================
[ INFO: possible recursive locking detected ]
2.6.38-rc1-340cd+ #7
---------------------------------------------
gnome-screensav/4276 is trying to acquire lock:
 (&(&eb->lock)->rlock){+.+...}, at: [<ffffffff81301078>]
btrfs_try_spin_lock+0x58/0x100

but task is already holding lock:
 (&(&eb->lock)->rlock){+.+...}, at: [<ffffffff8130113d>]
btrfs_clear_lock_blocking+0x1d/0x30

other info that might help us debug this:
2 locks held by gnome-screensav/4276:
 #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff81178fb1>]
do_lookup+0x1c1/0x2c0
 #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffff8130113d>]
btrfs_clear_lock_blocking+0x1d/0x30

stack backtrace:
Pid: 4276, comm: gnome-screensav Not tainted 2.6.38-rc1-340cd+ #7
Call Trace:
 [<ffffffff810a7a10>] ? __lock_acquire+0x1040/0x1d10
 [<ffffffff810a42ed>] ? trace_hardirqs_on_caller+0x15d/0x1b0
 [<ffffffff8100bdfc>] ? native_sched_clock+0x2c/0x80
 [<ffffffff8100bc33>] ? sched_clock+0x13/0x20
 [<ffffffff810a87a6>] ? lock_acquire+0xc6/0x280
 [<ffffffff81301078>] ? btrfs_try_spin_lock+0x58/0x100
 [<ffffffff816d31cb>] ? _raw_spin_lock+0x3b/0x70
 [<ffffffff81301078>] ? btrfs_try_spin_lock+0x58/0x100
 [<ffffffff8130113d>] ? btrfs_clear_lock_blocking+0x1d/0x30
 [<ffffffff81301078>] ? btrfs_try_spin_lock+0x58/0x100
 [<ffffffff812b4c27>] ? btrfs_search_slot+0x917/0xa10
 [<ffffffff8100bc33>] ? sched_clock+0x13/0x20
 [<ffffffff812c520a>] ? btrfs_lookup_dir_item+0x7a/0x110
 [<ffffffff810a434d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811563d3>] ? kmem_cache_alloc+0x163/0x2f0
 [<ffffffff812db274>] ? btrfs_lookup_dentry+0xa4/0x480
 [<ffffffff810a2a4e>] ? put_lock_stats+0xe/0x40
 [<ffffffff810a2b2c>] ? lock_release_holdtime+0xac/0x150
 [<ffffffff81055ce1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8105a1fd>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff812db661>] ? btrfs_lookup+0x11/0x30
 [<ffffffff81178b10>] ? d_alloc_and_lookup+0x40/0x80
 [<ffffffff81186420>] ? d_lookup+0x30/0x60
 [<ffffffff81178fd3>] ? do_lookup+0x1e3/0x2c0
 [<ffffffff8117832e>] ? generic_permission+0x1e/0xb0
 [<ffffffff8117b5a1>] ? link_path_walk+0x141/0xbd0
 [<ffffffff8117af68>] ? path_init_rcu+0x1b8/0x280
 [<ffffffff8117c326>] ? do_path_lookup+0x56/0x130
 [<ffffffff8117d022>] ? user_path_at+0x52/0xa0
 [<ffffffff8109375e>] ? up_read+0x1e/0x40
 [<ffffffff810335c8>] ? do_page_fault+0x1f8/0x510
 [<ffffffff8109543d>] ? sched_clock_cpu+0xdd/0x120
 [<ffffffff81171ff1>] ? vfs_fstatat+0x41/0x80
 [<ffffffff810a2a4e>] ? put_lock_stats+0xe/0x40
 [<ffffffff810a2b2c>] ? lock_release_holdtime+0xac/0x150
 [<ffffffff81172066>] ? vfs_stat+0x16/0x20
 [<ffffffff8117223f>] ? sys_newstat+0x1f/0x50
 [<ffffffff810a42ed>] ? trace_hardirqs_on_caller+0x15d/0x1b0
 [<ffffffff816d2f39>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81003192>] ? system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
