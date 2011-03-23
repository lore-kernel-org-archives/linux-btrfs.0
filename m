From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Wed, 23 Mar 2011 12:00:38 +0800
Message-ID: <4D897066.7090409@cn.fujitsu.com>
References: <4D8324DE.4010400@cn.fujitsu.com>	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>	<4D8813A5.1040604@cn.fujitsu.com>	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>	<4D8873EC.1040702@cn.fujitsu.com>	<20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>	<4D894C91.5040302@cn.fujitsu.com> <20110323122409.6bc79eaf.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110323122409.6bc79eaf.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 23 Mar 2011 12:24:09 +0900, Itaru Kitayama wrote:
> Hi Miao,
> 
> The possible circular locking dependency message doesn't show up in the updated V5. However,
> I see a new possible irq lock inversion dependency message while running xfstests.

I is testing the new version, in which I fixed the slab shrinker problem reported by
Chris. In the new version, the delayed node is removed before the relative inode is
moved into the unused_inode list(the slab shrinker will reclaim inodes in this list).
Maybe this method can also fix this bug. So could you tell me the reproduce step
or the options of mkfs and mount? I will check if the new patch can fix this bug or not.

Thanks
Miao

> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.36-xie+ #122
> ---------------------------------------------------------
> kswapd0/49 just changed the state of lock:
>  (iprune_sem){++++.-}, at: [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&delayed_node->mutex){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> 1 lock held by kswapd0/49:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810e242a>] shrink_slab+0x3d/0x164
> 
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&delayed_node->mutex){+.+.+.} ops: 1703807 {
>     HARDIRQ-ON-W at:
>                           [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
>                           [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
>                           [<ffffffff81211fd4>] btrfs_delayed_update_inode+0x45/0x101
>                           [<ffffffff811dc5c3>] btrfs_update_inode+0x2e/0x129
>                           [<ffffffff811e0cba>] btrfs_truncate+0x43d/0x477
>                           [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                           [<ffffffff811e0ef6>] btrfs_setattr+0x202/0x253
>                           [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                           [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                           [<ffffffff81127a77>] do_last+0x579/0x57e
>                           [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                           [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                           [<ffffffff8111af8f>] sys_open+0x20/0x22
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     SOFTIRQ-ON-W at:
>                           [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
>                           [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
>                           [<ffffffff81211fd4>] btrfs_delayed_update_inode+0x45/0x101
>                           [<ffffffff811dc5c3>] btrfs_update_inode+0x2e/0x129
>                           [<ffffffff811e0cba>] btrfs_truncate+0x43d/0x477
>                           [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                           [<ffffffff811e0ef6>] btrfs_setattr+0x202/0x253
>                           [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                           [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                           [<ffffffff81127a77>] do_last+0x579/0x57e
>                           [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                           [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                           [<ffffffff8111af8f>] sys_open+0x20/0x22
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     RECLAIM_FS-ON-W at:
>                              [<ffffffff81074292>] mark_held_locks+0x52/0x70
>                              [<ffffffff81074354>] lockdep_trace_alloc+0xa4/0xc2
>                              [<ffffffff8110f206>] __kmalloc+0x7f/0x154
>                              [<ffffffff811c2c21>] kzalloc+0x14/0x16
>                              [<ffffffff811c5e83>] cache_block_group+0x106/0x238
>                              [<ffffffff811c7069>] find_free_extent+0x4e2/0xa86
>                              [<ffffffff811c76c1>] btrfs_reserve_extent+0xb4/0x142
>                              [<ffffffff811c78b6>] btrfs_alloc_free_block+0x167/0x2af
>                              [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                              [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                              [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                              [<ffffffff811cf5ab>] btrfs_lookup_inode+0x2f/0x8f
>                              [<ffffffff81212405>] btrfs_update_delayed_inode+0x75/0x135
>                              [<ffffffff8121340d>] btrfs_run_delayed_items+0xd6/0x131
>                              [<ffffffff811d64d7>] btrfs_commit_transaction+0x28b/0x668
>                              [<ffffffff811ba786>] btrfs_sync_fs+0x6b/0x70
>                              [<ffffffff81140265>] __sync_filesystem+0x6b/0x83
>                              [<ffffffff81140347>] sync_filesystem+0x4c/0x50
>                              [<ffffffff8111fc56>] generic_shutdown_super+0x27/0xd7
>                              [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>                              [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>                              [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>                              [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>                              [<ffffffff81136a87>] sys_umount+0x2c1/0x2ec
>                              [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     INITIAL USE at:
>                          [<ffffffff81075f37>] __lock_acquire+0x3bd/0xda6
>                          [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                          [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
>                          [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
>                          [<ffffffff81211fd4>] btrfs_delayed_update_inode+0x45/0x101
>                          [<ffffffff811dc5c3>] btrfs_update_inode+0x2e/0x129
>                          [<ffffffff811e0cba>] btrfs_truncate+0x43d/0x477
>                          [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                          [<ffffffff811e0ef6>] btrfs_setattr+0x202/0x253
>                          [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                          [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                          [<ffffffff81127a77>] do_last+0x579/0x57e
>                          [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                          [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                          [<ffffffff8111af8f>] sys_open+0x20/0x22
>                          [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>   }
>   ... key      at: [<ffffffff82925450>] __key.31289+0x0/0x8
>   ... acquired at:
>    [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>    [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
>    [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
>    [<ffffffff81213217>] btrfs_remove_delayed_node+0x3e/0xd2
>    [<ffffffff811d77ca>] btrfs_destroy_inode+0x2ae/0x2d4
>    [<ffffffff81130dc1>] destroy_inode+0x2f/0x45
>    [<ffffffff811312ca>] dispose_list+0xaa/0xdf
>    [<ffffffff81131427>] invalidate_inodes+0x128/0x146
>    [<ffffffff8111fc76>] generic_shutdown_super+0x47/0xd7
>    [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>    [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>    [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>    [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>    [<ffffffff81136a87>] sys_umount+0x2c1/0x2ec
>    [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> 
> -> (iprune_sem){++++.-} ops: 69 {
>    HARDIRQ-ON-W at:
>                         [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6a4a>] down_write+0x55/0x9b
>                         [<ffffffff8113133d>] invalidate_inodes+0x3e/0x146
>                         [<ffffffff8111fc76>] generic_shutdown_super+0x47/0xd7
>                         [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>                         [<ffffffffa034d679>] nfs4_kill_super+0x44/0x77 [nfs]
>                         [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>                         [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>                         [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>                         [<ffffffff81135b40>] release_mounts+0x8e/0xa4
>                         [<ffffffff81135bb7>] put_mnt_ns+0x61/0x72
>                         [<ffffffffa034d3da>] nfs_follow_remote_path+0x207/0x302 [nfs]
>                         [<ffffffffa034d5fb>] nfs4_try_mount+0x7a/0xb4 [nfs]
>                         [<ffffffffa034e8a3>] nfs_get_sb+0x4cf/0x750 [nfs]
>                         [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                         [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                         [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                         [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    HARDIRQ-ON-R at:
>                         [<ffffffff81075e98>] __lock_acquire+0x31e/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6adc>] down_read+0x4c/0x91
>                         [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
>                         [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>                         [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>                         [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>                         [<ffffffff81061a60>] kthread+0x9d/0xa5
>                         [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>    SOFTIRQ-ON-W at:
>                         [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6a4a>] down_write+0x55/0x9b
>                         [<ffffffff8113133d>] invalidate_inodes+0x3e/0x146
>                         [<ffffffff8111fc76>] generic_shutdown_super+0x47/0xd7
>                         [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>                         [<ffffffffa034d679>] nfs4_kill_super+0x44/0x77 [nfs]
>                         [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>                         [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>                         [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>                         [<ffffffff81135b40>] release_mounts+0x8e/0xa4
>                         [<ffffffff81135bb7>] put_mnt_ns+0x61/0x72
>                         [<ffffffffa034d3da>] nfs_follow_remote_path+0x207/0x302 [nfs]
>                         [<ffffffffa034d5fb>] nfs4_try_mount+0x7a/0xb4 [nfs]
>                         [<ffffffffa034e8a3>] nfs_get_sb+0x4cf/0x750 [nfs]
>                         [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                         [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                         [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                         [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    SOFTIRQ-ON-R at:
>                         [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6adc>] down_read+0x4c/0x91
>                         [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
>                         [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>                         [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>                         [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>                         [<ffffffff81061a60>] kthread+0x9d/0xa5
>                         [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>    IN-RECLAIM_FS-R at:
>                            [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>                            [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                            [<ffffffff814c6adc>] down_read+0x4c/0x91
>                            [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
>                            [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>                            [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>                            [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>                            [<ffffffff81061a60>] kthread+0x9d/0xa5
>                            [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>    INITIAL USE at:
>                        [<ffffffff81075f37>] __lock_acquire+0x3bd/0xda6
>                        [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                        [<ffffffff814c6a4a>] down_write+0x55/0x9b
>                        [<ffffffff8113133d>] invalidate_inodes+0x3e/0x146
>                        [<ffffffff8111fc76>] generic_shutdown_super+0x47/0xd7
>                        [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>                        [<ffffffffa034d679>] nfs4_kill_super+0x44/0x77 [nfs]
>                        [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>                        [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>                        [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>                        [<ffffffff81135b40>] release_mounts+0x8e/0xa4
>                        [<ffffffff81135bb7>] put_mnt_ns+0x61/0x72
>                        [<ffffffffa034d3da>] nfs_follow_remote_path+0x207/0x302 [nfs]
>                        [<ffffffffa034d5fb>] nfs4_try_mount+0x7a/0xb4 [nfs]
>                        [<ffffffffa034e8a3>] nfs_get_sb+0x4cf/0x750 [nfs]
>                        [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                        [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                        [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                        [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                        [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>  }
>  ... key      at: [<ffffffff81a4d268>] iprune_sem+0x58/0xb0
>  ... acquired at:
>    [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>    [<ffffffff81074113>] mark_lock+0x13d/0x26a
>    [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>    [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>    [<ffffffff814c6adc>] down_read+0x4c/0x91
>    [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
>    [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>    [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>    [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>    [<ffffffff81061a60>] kthread+0x9d/0xa5
>    [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
> 
> 
> stack backtrace:
> Pid: 49, comm: kswapd0 Not tainted 2.6.36-xie+ #122
> Call Trace:
>  [<ffffffff8107493d>] print_irq_inversion_bug+0x124/0x135
>  [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>  [<ffffffff8107494e>] ? check_usage_forwards+0x0/0x7e
>  [<ffffffff81074113>] mark_lock+0x13d/0x26a
>  [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>  [<ffffffff81074003>] ? mark_lock+0x2d/0x26a
>  [<ffffffff81076911>] ? __lock_acquire+0xd97/0xda6
>  [<ffffffff811316d0>] ? shrink_icache_memory+0x4d/0x213
>  [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>  [<ffffffff811316d0>] ? shrink_icache_memory+0x4d/0x213
>  [<ffffffff810dcdfb>] ? global_dirty_limits+0x17/0xca
>  [<ffffffff814c6adc>] down_read+0x4c/0x91
>  [<ffffffff811316d0>] ? shrink_icache_memory+0x4d/0x213
>  [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
>  [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>  [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>  [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>  [<ffffffff81062032>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff810e483c>] ? kswapd+0x0/0x3c0
>  [<ffffffff81061a60>] kthread+0x9d/0xa5
>  [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81038cd9>] ? finish_task_switch+0x70/0xb9
>  [<ffffffff814c88c0>] ? restore_args+0x0/0x30
>  [<ffffffff810619c3>] ? kthread+0x0/0xa5
>  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

