From: Ed Tomlinson <edt@aei.ca>
Subject: Re: Linux 3.0 release - btrfs possible locking deadlock
Date: Fri, 22 Jul 2011 19:21:00 -0400
Message-ID: <201107221921.00798.edt@aei.ca>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 21 July 2011 22:59:53 Linus Torvalds wrote:
> So there it is. Gone are the 2.6.<bignum> days, and 3.0 is out.
> 

Hi,

Managed to get this with btrfs rsync(ing) from ext4 to a btrfs fs with three partitions using raid1.

[16018.211493] device fsid f7186eeb-60df-4b1a-890a-4a1eb42f81fe devid 1 transid 10 /dev/sdd4
[16018.230643] btrfs: use lzo compression
[16018.234619] btrfs: enabling disk space caching
[25949.414011] 
[25949.414011] =======================================================
[25949.416549] [ INFO: possible circular locking dependency detected ]
[25949.423187] 3.0.0-crc+ #348
[25949.423187] -------------------------------------------------------
[25949.423187] rsync/20237 is trying to acquire lock:
[25949.423187]  (btrfs-extent-01){+.+...}, at: [<ffffffffa047ce88>] btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187] 
[25949.423187] but task is already holding lock:
[25949.423187]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa047cee2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[25949.423187] 
[25949.423187] which lock already depends on the new lock.
[25949.423187] 
[25949.423187] 
[25949.423187] the existing dependency chain (in reverse order) is:
[25949.423187] 
[25949.423187] -> #1 (&(&eb->lock)->rlock){+.+...}:
[25949.423187]        [<ffffffff8108bb75>] lock_acquire+0x95/0x140
[25949.423187]        [<ffffffff815792eb>] _raw_spin_lock+0x3b/0x50
[25949.423187]        [<ffffffffa047ce88>] btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]        [<ffffffffa0427959>] btrfs_search_slot+0x2e9/0x800 [btrfs]
[25949.423187]        [<ffffffffa0433bee>] lookup_inline_extent_backref+0xbe/0x490 [btrfs]
[25949.423187]        [<ffffffffa0434cbb>] __btrfs_free_extent+0x13b/0x900 [btrfs]
[25949.423187]        [<ffffffffa0435ca3>] run_clustered_refs+0x823/0xaf0 [btrfs]
[25949.423187]        [<ffffffffa043603d>] btrfs_run_delayed_refs+0xcd/0x290 [btrfs]
[25949.423187]        [<ffffffffa0445ecb>] btrfs_commit_transaction+0x8b/0x9d0 [btrfs]
[25949.423187]        [<ffffffffa0440c06>] transaction_kthread+0x2b6/0x2e0 [btrfs]
[25949.423187]        [<ffffffff81071536>] kthread+0xb6/0xc0
[25949.423187]        [<ffffffff81582314>] kernel_thread_helper+0x4/0x10
[25949.423187] 
[25949.423187] -> #0 (btrfs-extent-01){+.+...}:
[25949.423187]        [<ffffffff8108b468>] __lock_acquire+0x1588/0x16a0
[25949.423187]        [<ffffffff8108bb75>] lock_acquire+0x95/0x140
[25949.423187]        [<ffffffff815792eb>] _raw_spin_lock+0x3b/0x50
[25949.423187]        [<ffffffffa047ce88>] btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]        [<ffffffffa0427959>] btrfs_search_slot+0x2e9/0x800 [btrfs]
[25949.423187]        [<ffffffffa0439dd2>] btrfs_lookup_dir_item+0x82/0x120 [btrfs]
[25949.423187]        [<ffffffffa04532a5>] btrfs_lookup_dentry+0xc5/0x4c0 [btrfs]
[25949.423187]        [<ffffffffa04536c4>] btrfs_lookup+0x24/0x70 [btrfs]
[25949.423187]        [<ffffffff8115a863>] d_alloc_and_lookup+0xc3/0x100
[25949.423187]        [<ffffffff8115cfa0>] do_lookup+0x260/0x480
[25949.423187]        [<ffffffff8115d540>] walk_component+0x60/0x1f0
[25949.423187]        [<ffffffff8115e7aa>] path_lookupat+0xea/0x620
[25949.423187]        [<ffffffff8115ed15>] do_path_lookup+0x35/0x1c0
[25949.423187]        [<ffffffff8115fc38>] user_path_at+0x98/0xe0
[25949.423187]        [<ffffffff81153fac>] vfs_fstatat+0x4c/0x90
[25949.423187]        [<ffffffff8115405e>] vfs_lstat+0x1e/0x20
[25949.423187]        [<ffffffff81154084>] sys_newlstat+0x24/0x50
[25949.423187]        [<ffffffff815814eb>] system_call_fastpath+0x16/0x1b
[25949.423187] 
[25949.423187] other info that might help us debug this:
[25949.423187] 
[25949.423187]  Possible unsafe locking scenario:
[25949.423187] 
[25949.423187]        CPU0                    CPU1
[25949.423187]        ----                    ----
[25949.423187]   lock(&(&eb->lock)->rlock);
[25949.423187]                                lock(btrfs-extent-01);
[25949.423187]                                lock(&(&eb->lock)->rlock);
[25949.423187]   lock(btrfs-extent-01);
[25949.423187] 
[25949.423187]  *** DEADLOCK ***
[25949.423187] 
[25949.423187] 2 locks held by rsync/20237:
[25949.423187]  #0:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff8115cf5a>] do_lookup+0x21a/0x480
[25949.423187]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa047cee2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[25949.423187] 
[25949.423187] stack backtrace:
[25949.423187] Pid: 20237, comm: rsync Not tainted 3.0.0-crc+ #348
[25949.423187] Call Trace:
[25949.423187]  [<ffffffff810887de>] print_circular_bug+0x20e/0x2f0
[25949.423187]  [<ffffffff8108b468>] __lock_acquire+0x1588/0x16a0
[25949.423187]  [<ffffffffa0441ebb>] ? verify_parent_transid+0xcb/0x290 [btrfs]
[25949.423187]  [<ffffffffa047ce88>] ? btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]  [<ffffffff8108bb75>] lock_acquire+0x95/0x140
[25949.423187]  [<ffffffffa047ce88>] ? btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]  [<ffffffff815792eb>] _raw_spin_lock+0x3b/0x50
[25949.423187]  [<ffffffffa047ce88>] ? btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]  [<ffffffffa047ce88>] btrfs_try_spin_lock+0x78/0xb0 [btrfs]
[25949.423187]  [<ffffffffa0427959>] btrfs_search_slot+0x2e9/0x800 [btrfs]
[25949.423187]  [<ffffffff8108a0ca>] ? __lock_acquire+0x1ea/0x16a0
[25949.423187]  [<ffffffffa0439dd2>] btrfs_lookup_dir_item+0x82/0x120 [btrfs]
[25949.423187]  [<ffffffff8114186e>] ? kmem_cache_alloc+0xde/0x1e0
[25949.423187]  [<ffffffffa04532a5>] btrfs_lookup_dentry+0xc5/0x4c0 [btrfs]
[25949.423187]  [<ffffffff812924fe>] ? do_raw_spin_lock+0xde/0x1c0
[25949.423187]  [<ffffffff8157d541>] ? sub_preempt_count+0x51/0x60
[25949.423187]  [<ffffffffa04536c4>] btrfs_lookup+0x24/0x70 [btrfs]
[25949.423187]  [<ffffffff8115a863>] d_alloc_and_lookup+0xc3/0x100
[25949.423187]  [<ffffffff8115cfa0>] do_lookup+0x260/0x480
[25949.423187]  [<ffffffff8115d540>] walk_component+0x60/0x1f0
[25949.423187]  [<ffffffff8115e7aa>] path_lookupat+0xea/0x620
[25949.423187]  [<ffffffff8111a3a3>] ? might_fault+0x53/0xb0
[25949.423187]  [<ffffffff8115ed15>] do_path_lookup+0x35/0x1c0
[25949.423187]  [<ffffffff8115fc38>] user_path_at+0x98/0xe0
[25949.423187]  [<ffffffff8111a3ec>] ? might_fault+0x9c/0xb0
[25949.423187]  [<ffffffff8111a3a3>] ? might_fault+0x53/0xb0
[25949.423187]  [<ffffffff81153d78>] ? cp_new_stat+0xf8/0x110
[25949.423187]  [<ffffffff81153fac>] vfs_fstatat+0x4c/0x90
[25949.423187]  [<ffffffff8115405e>] vfs_lstat+0x1e/0x20
[25949.423187]  [<ffffffff81154084>] sys_newlstat+0x24/0x50
[25949.423187]  [<ffffffff81089c3d>] ? trace_hardirqs_on_caller+0x14d/0x190
[25949.423187]  [<ffffffff8128c23e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[25949.423187]  [<ffffffff815814eb>] system_call_fastpath+0x16/0x1b

Kernel is 3.0.0 without any extras.

Ideas?
Ed 
