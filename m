From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: btrfs panic
Date: Thu, 14 Jul 2011 18:01:45 +0800
Message-ID: <4E1EBE89.4040302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When xfstests 224 was running, the box was panic, and i got this message:

[ 1998.327235] =============================================
[ 1998.329940] [ INFO: possible recursive locking detected ]
[ 1998.329940] 2.6.39+ #3
[ 1998.329940] ---------------------------------------------
[ 1998.329940] dd/25718 is trying to acquire lock:
[ 1998.329940]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa025dbe1>] btrfs_try_spin_lock+0x2a/0x89 [btrfs]
[ 1998.329940] 
[ 1998.329940] but task is already holding lock:
[ 1998.329940]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa025dbae>] btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
[ 1998.478275] 
[ 1998.478275] other info that might help us debug this:
[ 1998.478275] 2 locks held by dd/25718:
[ 1998.478275]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa0240d97>] btrfs_file_aio_write+0xdc/0x49a [btrfs]
[ 1998.478275]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa025dbae>] btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
[ 1998.478275] 
[ 1998.478275] stack backtrace:
[ 1998.478275] Pid: 25718, comm: dd Not tainted 2.6.39+ #3
[ 1998.478275] Call Trace:
[ 1998.478275]  [<ffffffff8107ff48>] __lock_acquire+0xd47/0xdcf
[ 1998.478275]  [<ffffffff8100fec9>] ? sched_clock+0x9/0xd
[ 1998.478275]  [<ffffffff81071d71>] ? sched_clock_local+0x12/0x75
[ 1998.478275]  [<ffffffffa025dbae>] ? btrfs_clear_lock_blocking+0x22/0x2b [btrfs]
[ 1998.478275]  [<ffffffffa025dbe1>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
[ 1998.478275]  [<ffffffff810804f9>] lock_acquire+0xd1/0xfb
[ 1998.478275]  [<ffffffffa025dbe1>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
[ 1998.478275]  [<ffffffff81468ad3>] _raw_spin_lock+0x36/0x69
[ 1998.478275]  [<ffffffffa025dbe1>] ? btrfs_try_spin_lock+0x2a/0x89 [btrfs]
[ 1998.478275]  [<ffffffffa025dbe1>] btrfs_try_spin_lock+0x2a/0x89 [btrfs]
[ 1998.478275]  [<ffffffffa021d025>] btrfs_search_slot+0x39c/0x4c0 [btrfs]
[ 1998.478275]  [<ffffffffa022a7c9>] btrfs_lookup_xattr+0x76/0xd7 [btrfs]
[ 1998.478275]  [<ffffffffa0219290>] ? btrfs_alloc_path+0x1a/0x1c [btrfs]
[ 1998.478275]  [<ffffffff81114a76>] ? kmem_cache_alloc+0x57/0xfc
[ 1998.478275]  [<ffffffffa0240d00>] ? btrfs_file_aio_write+0x45/0x49a [btrfs]
[ 1998.478275]  [<ffffffffa024c066>] __btrfs_getxattr+0x86/0x11c [btrfs]
[ 1998.478275]  [<ffffffffa024c466>] btrfs_getxattr+0x77/0x82 [btrfs]
[ 1998.478275]  [<ffffffff811f3044>] cap_inode_need_killpriv+0x2d/0x37
[ 1998.478275]  [<ffffffff810d8309>] file_remove_suid+0x27/0x64
[ 1998.478275]  [<ffffffffa0240e14>] btrfs_file_aio_write+0x159/0x49a [btrfs]
[ 1998.478275]  [<ffffffff8107bfd2>] ? trace_hardirqs_off+0xd/0xf
[ 1998.478275]  [<ffffffff81071f42>] ? local_clock+0x36/0x4d
[ 1998.478275]  [<ffffffff810800ab>] ? lock_release_non_nested+0xdb/0x263
[ 1998.478275]  [<ffffffff81121996>] do_sync_write+0xcb/0x108
[ 1998.478275]  [<ffffffff810f33a4>] ? might_fault+0x5c/0xac
[ 1998.478275]  [<ffffffff8107ed01>] ? lock_is_held+0x8d/0x98
[ 1998.478275]  [<ffffffff8112200f>] vfs_write+0xaf/0x102
[ 1998.478275]  [<ffffffff8112347e>] ? fget_light+0x3a/0xa1
[ 1998.478275]  [<ffffffff81122222>] sys_write+0x4d/0x74
[ 1998.478275]  [<ffffffff8146fec2>] system_call_fastpath+0x16/0x1b

[ 2160.937580] INFO: task xfs_io:22734 blocked for more than 120 seconds.
[ 2160.953899] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2160.978494] xfs_io          D 0000000000000000     0 22734  21963 0x00000000
[ 2160.996597]  ffff88000ac8dc68 0000000000000046 ffff88000ac8dc08 ffffffff00000000
[ 2161.107976]  00000000001d3ec0 00000000001d3ec0 00000000001d3ec0 ffff8800002423a0
[ 2161.117511]  00000000001d3ec0 ffff88000ac8dfd8 00000000001d3ec0 00000000001d3ec0
[ 2161.127543] Call Trace:
[ 2161.131247]  [<ffffffff8112cb40>] ? do_last+0x1d2/0x59d
[ 2161.136678]  [<ffffffff8112cb40>] ? do_last+0x1d2/0x59d
[ 2161.142181]  [<ffffffff81467a75>] __mutex_lock_common+0x22b/0x35b
[ 2161.148104]  [<ffffffff8112cb40>] ? do_last+0x1d2/0x59d
[ 2161.153578]  [<ffffffff81467c69>] mutex_lock_nested+0x3e/0x43
[ 2161.159300]  [<ffffffff8112cb40>] do_last+0x1d2/0x59d
[ 2161.164589]  [<ffffffff8112e264>] path_openat+0xcb/0x33a
[ 2161.170358]  [<ffffffff8100fec9>] ? sched_clock+0x9/0xd
[ 2161.175941]  [<ffffffff81071d71>] ? sched_clock_local+0x12/0x75
[ 2161.182033]  [<ffffffff8112e510>] do_filp_open+0x3d/0x89
[ 2161.187301]  [<ffffffff8146945f>] ? _raw_spin_unlock+0x2b/0x2f
[ 2161.192937]  [<ffffffff81139104>] ? alloc_fd+0x181/0x193
[ 2161.198541]  [<ffffffff81121548>] do_sys_open+0x74/0x106
[ 2161.204058]  [<ffffffff811215fa>] sys_open+0x20/0x22
[ 2161.209488]  [<ffffffff8146fec2>] system_call_fastpath+0x16/0x1b
[ 2161.215279] INFO: lockdep is turned off.
[ 2161.219841] Kernel panic - not syncing: hung_task: blocked tasks
[ 2161.225647] Pid: 42, comm: khungtaskd Not tainted 2.6.39+ #3
[ 2161.231535] Call Trace:
[ 2161.235146]  [<ffffffff8146653b>] panic+0x91/0x1a9
[ 2161.240266]  [<ffffffff810a8c81>] watchdog+0x1ae/0x219
[ 2161.244863]  [<ffffffff810a8ad3>] ? rcu_read_unlock+0x23/0x23
[ 2161.250816]  [<ffffffff8106c0e4>] kthread+0xa0/0xa8
[ 2161.255995]  [<ffffffff8107de2a>] ? trace_hardirqs_on_caller+0x13f/0x172
[ 2161.262333]  [<ffffffff81471064>] kernel_thread_helper+0x4/0x10
[ 2161.268211]  [<ffffffff814696d4>] ? retint_restore_args+0x13/0x13
[ 2161.274113]  [<ffffffff8106c044>] ? __init_kthread_worker+0x5b/0x5b
[ 2161.280135]  [<ffffffff81471060>] ? gs_change+0x13/0x13


I am happy to answer any questions.
