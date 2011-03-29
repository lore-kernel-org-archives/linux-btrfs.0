From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2] btrfs: fix possible deadlock by clearing __GFP_FS
 flag
Date: Tue, 29 Mar 2011 14:16:53 +0800
Message-ID: <4D917955.2060500@cn.fujitsu.com>
References: <4D8EF048.5050203@cn.fujitsu.com>	<4D8F2D32.3000601@cn.fujitsu.com> <20110329144805.507dfe30.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110329144805.507dfe30.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 29 Mar 2011 14:48:05 +0900, Itaru Kitayama wrote:
> Hi Miao,
> 
> On Sun, 27 Mar 2011 20:27:30 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> Changelog V1 -> V2:
>> - modify the explanation of the deadlock.
>> - clear __GFP_FS flag in the free space's page cache.
> 
> I think this is also needed on top of your V5 patch to avoid a recursion. Could you
> review it and give your Signed-off-by?

It is good to me.

> 
> Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8862dda..03e5ab3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2641,7 +2641,7 @@ int extent_readpages(struct extent_io_tree *tree,
>                 prefetchw(&page->flags);
>                 list_del(&page->lru);
>                 if (!add_to_page_cache_lru(page, mapping,
> -                                       page->index, GFP_KERNEL)) {
> +                                       page->index, GFP_NOFS)) {
>                         __extent_read_full_page(tree, page, get_extent,
>                                                 &bio, 0, &bio_flags);
>                 }
> 
> After applying the patch above, I don't see the warning below during Chris' stress test. 
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.36-v5+ #10
> ---------------------------------------------------------
> kswapd0/49 just changed the state of lock:
>  (&delayed_node->mutex){+.+.-.}, at: [<ffffffff81213283>] btrfs_remove_delayed_node+0x3e/0xd2
> but this lock took another, RECLAIM_FS-READ-unsafe lock in the past:
>  (&found->groups_sem){++++.+}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> 2 locks held by kswapd0/49:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810e242a>] shrink_slab+0x3d/0x164
>  #1:  (iprune_sem){++++.-}, at: [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
> 
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&found->groups_sem){++++.+} ops: 3649 {
>     HARDIRQ-ON-W at:
>                           [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6aba>] down_write+0x55/0x9b
>                           [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                           [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                           [<ffffffff811d4974>] open_ctree+0xf8f/0x14c3
>                           [<ffffffff811bafdf>] btrfs_get_sb+0x236/0x467
>                           [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                           [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                           [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     HARDIRQ-ON-R at:
>                           [<ffffffff81075e98>] __lock_acquire+0x31e/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6b4c>] down_read+0x4c/0x91
>                           [<ffffffff811cb5b2>] find_free_extent+0x3ec/0xa86
>                           [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                           [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                           [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                           [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                           [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                           [<ffffffff811dc0d9>] btrfs_truncate_inode_items+0x12a/0x61a
>                           [<ffffffff811defa7>] btrfs_evict_inode+0x154/0x1be
>                           [<ffffffff811311b0>] evict+0x27/0x97
>                           [<ffffffff81131615>] iput+0x1d0/0x23e
>                           [<ffffffff811e1143>] btrfs_orphan_cleanup+0x1c8/0x269
>                           [<ffffffff811d05e1>] btrfs_cleanup_fs_roots+0x6d/0x8c
>                           [<ffffffff811bac48>] btrfs_remount+0x9e/0xe9
>                           [<ffffffff8111e9b2>] do_remount_sb+0xbb/0x106
>                           [<ffffffff81136194>] do_mount+0x255/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     SOFTIRQ-ON-W at:
>                           [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6aba>] down_write+0x55/0x9b
>                           [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                           [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                           [<ffffffff811d4974>] open_ctree+0xf8f/0x14c3
>                           [<ffffffff811bafdf>] btrfs_get_sb+0x236/0x467
>                           [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                           [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                           [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     SOFTIRQ-ON-R at:
>                           [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6b4c>] down_read+0x4c/0x91
>                           [<ffffffff811cb5b2>] find_free_extent+0x3ec/0xa86
>                           [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                           [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                           [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                           [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                           [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                           [<ffffffff811dc0d9>] btrfs_truncate_inode_items+0x12a/0x61a
>                           [<ffffffff811defa7>] btrfs_evict_inode+0x154/0x1be
>                           [<ffffffff811311b0>] evict+0x27/0x97
>                           [<ffffffff81131615>] iput+0x1d0/0x23e
>                           [<ffffffff811e1143>] btrfs_orphan_cleanup+0x1c8/0x269
>                           [<ffffffff811d05e1>] btrfs_cleanup_fs_roots+0x6d/0x8c
>                           [<ffffffff811bac48>] btrfs_remount+0x9e/0xe9
>                           [<ffffffff8111e9b2>] do_remount_sb+0xbb/0x106
>                           [<ffffffff81136194>] do_mount+0x255/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     RECLAIM_FS-ON-R at:
>                              [<ffffffff81074292>] mark_held_locks+0x52/0x70
>                              [<ffffffff81074354>] lockdep_trace_alloc+0xa4/0xc2
>                              [<ffffffff8110fcc9>] kmem_cache_alloc+0x32/0x186
>                              [<ffffffff81265caa>] radix_tree_preload+0x6f/0xd5
>                              [<ffffffff810d4df8>] add_to_page_cache_locked+0x60/0x147
>                              [<ffffffff810d4f0c>] add_to_page_cache_lru+0x2d/0x5b
>                              [<ffffffff811f348a>] extent_readpages+0x6c/0xcb
>                              [<ffffffff811da3b6>] btrfs_readpages+0x1f/0x21
>                              [<ffffffff810ddf68>] __do_page_cache_readahead+0x127/0x19d
>                              [<ffffffff810ddfff>] ra_submit+0x21/0x25
>                              [<ffffffff810de3b9>] ondemand_readahead+0x1b6/0x1c9
>                              [<ffffffff810de4b2>] page_cache_sync_readahead+0x3d/0x3f
>                              [<ffffffff81207a24>] load_free_space_cache+0x27e/0x682
>                              [<ffffffff811c886f>] cache_block_group+0x97/0x233
>                              [<ffffffff811cb63f>] find_free_extent+0x479/0xa86
>                              [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                              [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                              [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                              [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                              [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                              [<ffffffff811dc0d9>] btrfs_truncate_inode_items+0x12a/0x61a
>                              [<ffffffff811defa7>] btrfs_evict_inode+0x154/0x1be
>                              [<ffffffff811311b0>] evict+0x27/0x97
>                              [<ffffffff81131615>] iput+0x1d0/0x23e
>                              [<ffffffff811e1143>] btrfs_orphan_cleanup+0x1c8/0x269
>                              [<ffffffff811d05e1>] btrfs_cleanup_fs_roots+0x6d/0x8c
>                              [<ffffffff811bac48>] btrfs_remount+0x9e/0xe9
>                              [<ffffffff8111e9b2>] do_remount_sb+0xbb/0x106
>                              [<ffffffff81136194>] do_mount+0x255/0x7c5
>                              [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                              [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     INITIAL USE at:
>                          [<ffffffff81075f37>] __lock_acquire+0x3bd/0xda6
>                          [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                          [<ffffffff814c6aba>] down_write+0x55/0x9b
>                          [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                          [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                          [<ffffffff811d4974>] open_ctree+0xf8f/0x14c3
>                          [<ffffffff811bafdf>] btrfs_get_sb+0x236/0x467
>                          [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                          [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                          [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                          [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                          [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>   }
>   ... key      at: [<ffffffff82924fb8>] __key.40112+0x0/0x8
>   ... acquired at:
>    [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>    [<ffffffff814c6b4c>] down_read+0x4c/0x91
>    [<ffffffff811cb48a>] find_free_extent+0x2c4/0xa86
>    [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>    [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>    [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>    [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>    [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>    [<ffffffff811cf58b>] btrfs_lookup_inode+0x2f/0x8f
>    [<ffffffff81212471>] btrfs_update_delayed_inode+0x75/0x135
>    [<ffffffff812130fa>] btrfs_async_run_delayed_node_done+0xd5/0x194
>    [<ffffffff811fb4f6>] worker_loop+0x198/0x4dd
>    [<ffffffff81061a60>] kthread+0x9d/0xa5
>    [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
> 
> -> (&delayed_node->mutex){+.+.-.} ops: 32488 {
>    HARDIRQ-ON-W at:
>                         [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>                         [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>                         [<ffffffff81212040>] btrfs_delayed_update_inode+0x45/0x101
>                         [<ffffffff811dc5f7>] btrfs_update_inode+0x2e/0x129
>                         [<ffffffff811de8b0>] btrfs_dirty_inode+0x57/0x113
>                         [<ffffffff8113c2a5>] __mark_inode_dirty+0x33/0x1aa
>                         [<ffffffff81130939>] touch_atime+0x107/0x12a
>                         [<ffffffff810d63ea>] generic_file_aio_read+0x567/0x5bc
>                         [<ffffffff8111c717>] do_sync_read+0xcb/0x108
>                         [<ffffffff8111cd89>] vfs_read+0xab/0x107
>                         [<ffffffff8111cea8>] sys_read+0x4d/0x74
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    SOFTIRQ-ON-W at:
>                         [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>                         [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>                         [<ffffffff81212040>] btrfs_delayed_update_inode+0x45/0x101
>                         [<ffffffff811dc5f7>] btrfs_update_inode+0x2e/0x129
>                         [<ffffffff811de8b0>] btrfs_dirty_inode+0x57/0x113
>                         [<ffffffff8113c2a5>] __mark_inode_dirty+0x33/0x1aa
>                         [<ffffffff81130939>] touch_atime+0x107/0x12a
>                         [<ffffffff810d63ea>] generic_file_aio_read+0x567/0x5bc
>                         [<ffffffff8111c717>] do_sync_read+0xcb/0x108
>                         [<ffffffff8111cd89>] vfs_read+0xab/0x107
>                         [<ffffffff8111cea8>] sys_read+0x4d/0x74
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    IN-RECLAIM_FS-W at:
>                            [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>                            [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                            [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>                            [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>                            [<ffffffff81213283>] btrfs_remove_delayed_node+0x3e/0xd2
>                            [<ffffffff811d77fe>] btrfs_destroy_inode+0x2ae/0x2d4
>                            [<ffffffff81130dc1>] destroy_inode+0x2f/0x45
>                            [<ffffffff811312ca>] dispose_list+0xaa/0xdf
>                            [<ffffffff81131866>] shrink_icache_memory+0x1e3/0x213
>                            [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>                            [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>                            [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>                            [<ffffffff81061a60>] kthread+0x9d/0xa5
>                            [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>    INITIAL USE at:
>                        [<ffffffff81075f37>] __lock_acquire+0x3bd/0xda6
>                        [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                        [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>                        [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>                        [<ffffffff81212040>] btrfs_delayed_update_inode+0x45/0x101
>                        [<ffffffff811dc5f7>] btrfs_update_inode+0x2e/0x129
>                        [<ffffffff811de8b0>] btrfs_dirty_inode+0x57/0x113
>                        [<ffffffff8113c2a5>] __mark_inode_dirty+0x33/0x1aa
>                        [<ffffffff81130939>] touch_atime+0x107/0x12a
>                        [<ffffffff810d63ea>] generic_file_aio_read+0x567/0x5bc
>                        [<ffffffff8111c717>] do_sync_read+0xcb/0x108
>                        [<ffffffff8111cd89>] vfs_read+0xab/0x107
>                        [<ffffffff8111cea8>] sys_read+0x4d/0x74
>                        [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>  }
>  ... key      at: [<ffffffff82925450>] __key.31289+0x0/0x8
>  ... acquired at:
>    [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>    [<ffffffff81074162>] mark_lock+0x18c/0x26a
>    [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>    [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>    [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>    [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>    [<ffffffff81213283>] btrfs_remove_delayed_node+0x3e/0xd2
>    [<ffffffff811d77fe>] btrfs_destroy_inode+0x2ae/0x2d4
>    [<ffffffff81130dc1>] destroy_inode+0x2f/0x45
>    [<ffffffff811312ca>] dispose_list+0xaa/0xdf
>    [<ffffffff81131866>] shrink_icache_memory+0x1e3/0x213
>    [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>    [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>    [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>    [<ffffffff81061a60>] kthread+0x9d/0xa5
>    [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
> 
> 
> stack backtrace:
> Pid: 49, comm: kswapd0 Not tainted 2.6.36-v5+ #10
> Call Trace:
>  [<ffffffff8107493d>] print_irq_inversion_bug+0x124/0x135
>  [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>  [<ffffffff8107494e>] ? check_usage_forwards+0x0/0x7e
>  [<ffffffff81074162>] mark_lock+0x18c/0x26a
>  [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>  [<ffffffff81076911>] ? __lock_acquire+0xd97/0xda6
>  [<ffffffff81213283>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>  [<ffffffff81213283>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff81213283>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff814c6321>] __mutex_lock_common+0x5a/0x444
>  [<ffffffff81213283>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff81074604>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff814c67c0>] mutex_lock_nested+0x39/0x3e
>  [<ffffffff81213283>] btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff811d77fe>] btrfs_destroy_inode+0x2ae/0x2d4
>  [<ffffffff81130dc1>] destroy_inode+0x2f/0x45
>  [<ffffffff811312ca>] dispose_list+0xaa/0xdf
>  [<ffffffff81131866>] shrink_icache_memory+0x1e3/0x213
>  [<ffffffff810e24cd>] shrink_slab+0xe0/0x164
>  [<ffffffff810e4619>] balance_pgdat+0x2e8/0x50b
>  [<ffffffff810e4bbc>] kswapd+0x380/0x3c0
>  [<ffffffff81062032>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff810e483c>] ? kswapd+0x0/0x3c0
>  [<ffffffff81061a60>] kthread+0x9d/0xa5
>  [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81038cd9>] ? finish_task_switch+0x70/0xb9
>  [<ffffffff814c8940>] ? restore_args+0x0/0x30
>  [<ffffffff810619c3>] ? kthread+0x0/0xa5
>  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

