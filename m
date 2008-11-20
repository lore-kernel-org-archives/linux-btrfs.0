From: Diego Calleja <diegocg@gmail.com>
Subject: "possible circular locking dependency detected"
Date: Thu, 20 Nov 2008 17:00:15 +0100
Message-ID: <20081120170015.1a5177a0@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got this lockdep warning while running tiobench on a clean btrfs filesystem
with the latest code available (commit 2c41b36dd2f9fb5dee150f20c84895496e0642f2)
But it was a purely read-only workload: only root could write to the
filesystem and I was running tiobench as an user, which was spitting
"denied permission" errors.



[ 5177.201587] =======================================================
[ 5177.201594] [ INFO: possible circular locking dependency detected ]
[ 5177.201601] 2.6.28-rc5-dirty #7
[ 5177.201604] -------------------------------------------------------
[ 5177.201610] btrfs-transacti/9012 is trying to acquire lock:
[ 5177.201615]  (&cache->alloc_mutex){--..}, at: [<ffffffffa03d9e57>] btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.201648]
[ 5177.201650] but task is already holding lock:
[ 5177.201654]  (&fs_info->pinned_mutex){--..}, at: [<ffffffffa039eb53>] btrfs_finish_extent_commit+0x33/0x100 [btrfs]
[ 5177.201692]
[ 5177.201693] which lock already depends on the new lock.
[ 5177.201695]
[ 5177.201698]
[ 5177.201699] the existing dependency chain (in reverse order) is:
[ 5177.201704]
[ 5177.201705] -> #1 (&fs_info->pinned_mutex){--..}:
[ 5177.201712]        [<ffffffff8026cb99>] __lock_acquire+0x13c9/0x1970
[ 5177.201722]        [<ffffffff8026d196>] lock_acquire+0x56/0x80
[ 5177.201728]        [<ffffffff804f7fe6>] mutex_lock_nested+0xb6/0x320
[ 5177.201736]        [<ffffffffa0396c07>] add_new_free_space+0x37/0xe0 [btrfs]
[ 5177.201755]        [<ffffffffa0396f62>] cache_block_group+0x2b2/0x320 [btrfs]
[ 5177.201774]        [<ffffffffa0397294>] find_free_extent+0x2c4/0x640 [btrfs]
[ 5177.201792]        [<ffffffffa0397704>] __btrfs_reserve_extent+0xf4/0x310 [btrfs]
[ 5177.201811]        [<ffffffffa03995bc>] btrfs_alloc_extent+0x4c/0xc0 [btrfs]
[ 5177.201829]        [<ffffffffa0399691>] btrfs_alloc_free_block+0x61/0xa0 [btrfs]
[ 5177.201848]        [<ffffffffa0388fd6>] __btrfs_cow_block+0x966/0xe00 [btrfs]
[ 5177.201865]        [<ffffffffa0389ca6>] btrfs_cow_block+0x136/0x330 [btrfs]
[ 5177.201883]        [<ffffffffa038fdc4>] btrfs_search_slot+0x294/0xb70 [btrfs]
[ 5177.201901]        [<ffffffffa03a2838>] btrfs_lookup_inode+0x38/0xb0 [btrfs]
[ 5177.201920]        [<ffffffffa03ad86b>] btrfs_update_inode+0x4b/0xd0 [btrfs]
[ 5177.201940]        [<ffffffffa03b07cd>] btrfs_dirty_inode+0x4d/0x70 [btrfs]
[ 5177.201961]        [<ffffffff802edc1a>] __mark_inode_dirty+0x3a/0x1d0
[ 5177.201968]        [<ffffffff802e2438>] touch_atime+0xd8/0x140
[ 5177.201975]        [<ffffffff802dccc6>] vfs_readdir+0xc6/0xd0
[ 5177.201983]        [<ffffffff802dce38>] sys_getdents+0x88/0xe0
[ 5177.201989]        [<ffffffff8020bb7b>] system_call_fastpath+0x16/0x1b
[ 5177.201997]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 5177.202024]
[ 5177.202025] -> #0 (&cache->alloc_mutex){--..}:
[ 5177.202033]        [<ffffffff8026cce2>] __lock_acquire+0x1512/0x1970
[ 5177.202039]        [<ffffffff8026d196>] lock_acquire+0x56/0x80
[ 5177.202046]        [<ffffffff804f7fe6>] mutex_lock_nested+0xb6/0x320
[ 5177.202053]        [<ffffffffa03d9e57>] btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.202072]        [<ffffffffa0397cd2>] btrfs_update_pinned_extents+0x172/0x1d0 [btrfs]
[ 5177.202091]        [<ffffffffa039eb92>] btrfs_finish_extent_commit+0x72/0x100 [btrfs]
[ 5177.202110]        [<ffffffffa03a9fc5>] btrfs_commit_transaction+0x6f5/0x8b0 [btrfs]
[ 5177.202130]        [<ffffffffa03a44c1>] transaction_kthread+0x231/0x270 [btrfs]
[ 5177.202149]        [<ffffffff80259cde>] kthread+0x4e/0x90
[ 5177.202157]        [<ffffffff8020ccc9>] child_rip+0xa/0x11
[ 5177.202163]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 5177.202170]
[ 5177.202171] other info that might help us debug this:
[ 5177.202173]
[ 5177.202177] 3 locks held by btrfs-transacti/9012:
[ 5177.202181]  #0:  (&fs_info->transaction_kthread_mutex){--..}, at: [<ffffffffa03a4383>] transaction_kthread+0xf3/0x270 [btrfs]
[ 5177.202206]  #1:  (&fs_info->tree_reloc_mutex){--..}, at: [<ffffffffa03a9c16>] btrfs_commit_transaction+0x346/0x8b0 [btrfs]
[ 5177.202231]  #2:  (&fs_info->pinned_mutex){--..}, at: [<ffffffffa039eb53>] btrfs_finish_extent_commit+0x33/0x100 [btrfs]
[ 5177.202254]
[ 5177.202255] stack backtrace:
[ 5177.202260] Pid: 9012, comm: btrfs-transacti Not tainted 2.6.28-rc5-dirty #7
[ 5177.202265] Call Trace:
[ 5177.202271]  [<ffffffff8026b3a8>] print_circular_bug_tail+0xd8/0xe0
[ 5177.202278]  [<ffffffff8026cce2>] __lock_acquire+0x1512/0x1970
[ 5177.202285]  [<ffffffff8026899c>] ? find_usage_backwards+0xdc/0x120
[ 5177.202306]  [<ffffffffa03d9e57>] ? btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.202312]  [<ffffffff8026d196>] lock_acquire+0x56/0x80
[ 5177.202329]  [<ffffffffa03d9e57>] ? btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.202337]  [<ffffffff804f7fe6>] mutex_lock_nested+0xb6/0x320
[ 5177.202354]  [<ffffffffa03d9e57>] ? btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.202372]  [<ffffffffa03d9e57>] btrfs_add_free_space+0x27/0x70 [btrfs]
[ 5177.202391]  [<ffffffffa0397cd2>] btrfs_update_pinned_extents+0x172/0x1d0 [btrfs]
[ 5177.202410]  [<ffffffffa039eb92>] btrfs_finish_extent_commit+0x72/0x100 [btrfs]
[ 5177.202429]  [<ffffffffa03a9fc5>] btrfs_commit_transaction+0x6f5/0x8b0 [btrfs]
[ 5177.202437]  [<ffffffff8025a1d0>] ? autoremove_wake_function+0x0/0x40
[ 5177.202438]  [<ffffffff804f87de>] ? mutex_unlock+0xe/0x10
[ 5177.202438]  [<ffffffffa03a44c1>] transaction_kthread+0x231/0x270 [btrfs]
[ 5177.202438]  [<ffffffff8026adcd>] ? trace_hardirqs_on+0xd/0x10
[ 5177.202438]  [<ffffffff804fa397>] ? _spin_unlock_irqrestore+0x47/0x80
[ 5177.202438]  [<ffffffffa03a4290>] ? transaction_kthread+0x0/0x270 [btrfs]
[ 5177.202438]  [<ffffffff80259cde>] kthread+0x4e/0x90
[ 5177.202438]  [<ffffffff8020ccc9>] child_rip+0xa/0x11
[ 5177.202438]  [<ffffffff8020c1b8>] ? restore_args+0x0/0x30
[ 5177.202438]  [<ffffffff80259c90>] ? kthread+0x0/0x90
[ 5177.202438]  [<ffffffff8020ccbf>] ? child_rip+0x0/0x11
