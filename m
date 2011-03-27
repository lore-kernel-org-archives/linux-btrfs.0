From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V5 2/2] btrfs: implement delayed inode items operation
Date: Sun, 27 Mar 2011 15:00:00 +0800
Message-ID: <4D8EE070.6000700@cn.fujitsu.com>
References: <4D8B2DEB.1000001@cn.fujitsu.com> <20110327143055.ae2d3c68.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110327143055.ae2d3c68.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On sun, 27 Mar 2011 14:30:55 +0900, Itaru Kitayama wrote:
> Chris' stress test, stress.sh -n 50 -c /mnt/linux-2.6 /mnt gave me another lockdep splat
> (see below). I applied your V5 patches on top of the next-rc branch.

I got it. It is because the allocation flag of the metadata's page cache, which is stored in
the btree inode's i_mapping, was set to be GFP_HIGHUSER_MOVABLE. So if we allocate pages for
btree's page cache, this lockdep warning will be triggered.

I think even without my patch, this lockdep warning can also be triggered, btrfs_evict_inode()
do the similar operations like what I do in the btrfs_destroy_inode(). 
  Task1					Kswap0 task
  open()
    ...
    btrfs_search_slot()
      ...
      btrfs_cow_block()
	...
	alloc_page()
	  wait for reclaiming
					shrink_slab()
					  ...
					  shrink_icache_memory()
					    ...
					    btrfs_evict_inode()
					      ...
					      btrfs_search_slot()

If the path is locked by task1, the deadlock happens.

So the btree's page cache is different with the file's page cache, it can not allocate pages
by GFP_HIGHUSER_MOVABLE flag.

I will make a separate patch to fix it.

> I haven't triggered it in my actual testing, but do you think we can iterate a list of block 
> groups in an lockless manner using rcu?

May be we can use it, but AFAIK, the write-side of the sleepable RCU is quite slow. Though the
operations of the block group list are few, I think we should do some test to check the performance
regression.

Thanks
Miao

> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2164296..f40ff4e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -740,6 +740,7 @@ struct btrfs_space_info {
>  	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
>  	spinlock_t lock;
>  	struct rw_semaphore groups_sem;
> +	struct srcu_struct groups_srcu;
>  	atomic_t caching_threads;
>  };
>  
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9e4c9f4..22d6dbb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3003,6 +3003,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
>  		INIT_LIST_HEAD(&found->block_groups[i]);
>  	init_rwsem(&found->groups_sem);
> +	init_srcu_struct(&found->groups_srcu);
>  	spin_lock_init(&found->lock);
>  	found->flags = flags & (BTRFS_BLOCK_GROUP_DATA |
>  				BTRFS_BLOCK_GROUP_SYSTEM |
> @@ -4853,6 +4854,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
>  				     int data)
>  {
>  	int ret = 0;
> +	int idx;
>  	struct btrfs_root *root = orig_root->fs_info->extent_root;
>  	struct btrfs_free_cluster *last_ptr = NULL;
>  	struct btrfs_block_group_cache *block_group = NULL;
> @@ -4929,7 +4931,7 @@ ideal_cache:
>  		if (block_group && block_group_bits(block_group, data) &&
>  		    (block_group->cached != BTRFS_CACHE_NO ||
>  		     search_start == ideal_cache_offset)) {
> -			down_read(&space_info->groups_sem);
> +			idx = srcu_read_lock(&space_info->groups_srcu);
>  			if (list_empty(&block_group->list) ||
>  			    block_group->ro) {
>  				/*
> @@ -4939,7 +4941,7 @@ ideal_cache:
>  				 * valid
>  				 */
>  				btrfs_put_block_group(block_group);
> -				up_read(&space_info->groups_sem);
> +				srcu_read_unlock(&space_info->groups_srcu, idx);
>  			} else {
>  				index = get_block_group_index(block_group);
>  				goto have_block_group;
> @@ -4949,8 +4951,8 @@ ideal_cache:
>  		}
>  	}
>  search:
> -	down_read(&space_info->groups_sem);
> -	list_for_each_entry(block_group, &space_info->block_groups[index],
> +	idx = srcu_read_lock(&space_info->groups_srcu);
> +	list_for_each_entry_rcu(block_group, &space_info->block_groups[index],
>  			    list) {
>  		u64 offset;
>  		int cached;
> @@ -5197,8 +5199,8 @@ loop:
>  		BUG_ON(index != get_block_group_index(block_group));
>  		btrfs_put_block_group(block_group);
>  	}
> -	up_read(&space_info->groups_sem);
> -
> +	srcu_read_unlock(&space_info->groups_srcu, idx);
> +	
>  	if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
>  		goto search;
>  
> 
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.36-v5+ #2
> ---------------------------------------------------------
> kswapd0/49 just changed the state of lock:
>  (&delayed_node->mutex){+.+.-.}, at: [<ffffffff812131f7>] btrfs_remove_delayed_node+0x3e/0xd2
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
>  -> (&found->groups_sem){++++.+} ops: 1334 {
>     HARDIRQ-ON-W at:
>                           [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6a2a>] down_write+0x55/0x9b
>                           [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                           [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                           [<ffffffff811d4921>] open_ctree+0xf78/0x14ab
>                           [<ffffffff811bafdf>] btrfs_get_sb+0x236/0x467
>                           [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                           [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                           [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     HARDIRQ-ON-R at:
>                           [<ffffffff81075e98>] __lock_acquire+0x31e/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6abc>] down_read+0x4c/0x91
>                           [<ffffffff811cb5b2>] find_free_extent+0x3ec/0xa86
>                           [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                           [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                           [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                           [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                           [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                           [<ffffffff811c1495>] btrfs_insert_empty_items+0x6a/0xbc
>                           [<ffffffff811ffb68>] btrfs_insert_orphan_item+0x5d/0x75
>                           [<ffffffff811df1a1>] btrfs_orphan_add+0x139/0x152
>                           [<ffffffff811e0dd3>] btrfs_setattr+0xff/0x253
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
>                           [<ffffffff814c6a2a>] down_write+0x55/0x9b
>                           [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                           [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                           [<ffffffff811d4921>] open_ctree+0xf78/0x14ab
>                           [<ffffffff811bafdf>] btrfs_get_sb+0x236/0x467
>                           [<ffffffff8111f25e>] vfs_kern_mount+0xbd/0x1a7
>                           [<ffffffff8111f3b0>] do_kern_mount+0x4d/0xed
>                           [<ffffffff8113668d>] do_mount+0x74e/0x7c5
>                           [<ffffffff8113678c>] sys_mount+0x88/0xc2
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     SOFTIRQ-ON-R at:
>                           [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                           [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                           [<ffffffff814c6abc>] down_read+0x4c/0x91
>                           [<ffffffff811cb5b2>] find_free_extent+0x3ec/0xa86
>                           [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                           [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                           [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                           [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                           [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                           [<ffffffff811c1495>] btrfs_insert_empty_items+0x6a/0xbc
>                           [<ffffffff811ffb68>] btrfs_insert_orphan_item+0x5d/0x75
>                           [<ffffffff811df1a1>] btrfs_orphan_add+0x139/0x152
>                           [<ffffffff811e0dd3>] btrfs_setattr+0xff/0x253
>                           [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                           [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                           [<ffffffff81127a77>] do_last+0x579/0x57e
>                           [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                           [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                           [<ffffffff8111af8f>] sys_open+0x20/0x22
>                           [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     RECLAIM_FS-ON-R at:
>                              [<ffffffff81074292>] mark_held_locks+0x52/0x70
>                              [<ffffffff81074354>] lockdep_trace_alloc+0xa4/0xc2
>                              [<ffffffff810db873>] __alloc_pages_nodemask+0x96/0x841
>                              [<ffffffff81105bcb>] alloc_pages_current+0xa7/0xca
>                              [<ffffffff810d4d91>] __page_cache_alloc+0x85/0x8c
>                              [<ffffffff810ddef6>] __do_page_cache_readahead+0xb5/0x19d
>                              [<ffffffff810ddfff>] ra_submit+0x21/0x25
>                              [<ffffffff810de3b9>] ondemand_readahead+0x1b6/0x1c9
>                              [<ffffffff810de4b2>] page_cache_sync_readahead+0x3d/0x3f
>                              [<ffffffff8120798d>] load_free_space_cache+0x262/0x671
>                              [<ffffffff811c886f>] cache_block_group+0x97/0x233
>                              [<ffffffff811cb63f>] find_free_extent+0x479/0xa86
>                              [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>                              [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>                              [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                              [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                              [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                              [<ffffffff811c1495>] btrfs_insert_empty_items+0x6a/0xbc
>                              [<ffffffff811ffb68>] btrfs_insert_orphan_item+0x5d/0x75
>                              [<ffffffff811df1a1>] btrfs_orphan_add+0x139/0x152
>                              [<ffffffff811e0dd3>] btrfs_setattr+0xff/0x253
>                              [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                              [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                              [<ffffffff81127a77>] do_last+0x579/0x57e
>                              [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                              [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                              [<ffffffff8111af8f>] sys_open+0x20/0x22
>                              [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>     INITIAL USE at:
>                          [<ffffffff81075f37>] __lock_acquire+0x3bd/0xda6
>                          [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                          [<ffffffff814c6a2a>] down_write+0x55/0x9b
>                          [<ffffffff811c352a>] __link_block_group+0x5a/0x83
>                          [<ffffffff811ca562>] btrfs_read_block_groups+0x2fb/0x56c
>                          [<ffffffff811d4921>] open_ctree+0xf78/0x14ab
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
>    [<ffffffff814c6abc>] down_read+0x4c/0x91
>    [<ffffffff811cb48a>] find_free_extent+0x2c4/0xa86
>    [<ffffffff811cbd00>] btrfs_reserve_extent+0xb4/0x142
>    [<ffffffff811cbef5>] btrfs_alloc_free_block+0x167/0x2b2
>    [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>    [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>    [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>    [<ffffffff811cf58b>] btrfs_lookup_inode+0x2f/0x8f
>    [<ffffffff812123e5>] btrfs_update_delayed_inode+0x75/0x135
>    [<ffffffff8121306e>] btrfs_async_run_delayed_node_done+0xd5/0x194
>    [<ffffffff811fb48e>] worker_loop+0x198/0x4dd
>    [<ffffffff81061a60>] kthread+0x9d/0xa5
>    [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
> 
> -> (&delayed_node->mutex){+.+.-.} ops: 8932 {
>    HARDIRQ-ON-W at:
>                         [<ffffffff81075ec0>] __lock_acquire+0x346/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>                         [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>                         [<ffffffff81211fb4>] btrfs_delayed_update_inode+0x45/0x101
>                         [<ffffffff811dc5a3>] btrfs_update_inode+0x2e/0x129
>                         [<ffffffff811e0c9a>] btrfs_truncate+0x43d/0x477
>                         [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                         [<ffffffff811e0ed6>] btrfs_setattr+0x202/0x253
>                         [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                         [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                         [<ffffffff81127a77>] do_last+0x579/0x57e
>                         [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                         [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                         [<ffffffff8111af8f>] sys_open+0x20/0x22
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    SOFTIRQ-ON-W at:
>                         [<ffffffff81075ee1>] __lock_acquire+0x367/0xda6
>                         [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                         [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>                         [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>                         [<ffffffff81211fb4>] btrfs_delayed_update_inode+0x45/0x101
>                         [<ffffffff811dc5a3>] btrfs_update_inode+0x2e/0x129
>                         [<ffffffff811e0c9a>] btrfs_truncate+0x43d/0x477
>                         [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                         [<ffffffff811e0ed6>] btrfs_setattr+0x202/0x253
>                         [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                         [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                         [<ffffffff81127a77>] do_last+0x579/0x57e
>                         [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                         [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                         [<ffffffff8111af8f>] sys_open+0x20/0x22
>                         [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>    IN-RECLAIM_FS-W at:
>                            [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>                            [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>                            [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>                            [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>                            [<ffffffff812131f7>] btrfs_remove_delayed_node+0x3e/0xd2
>                            [<ffffffff811d77aa>] btrfs_destroy_inode+0x2ae/0x2d4
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
>                        [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>                        [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>                        [<ffffffff81211fb4>] btrfs_delayed_update_inode+0x45/0x101
>                        [<ffffffff811dc5a3>] btrfs_update_inode+0x2e/0x129
>                        [<ffffffff811e0c9a>] btrfs_truncate+0x43d/0x477
>                        [<ffffffff810dfb22>] vmtruncate+0x44/0x52
>                        [<ffffffff811e0ed6>] btrfs_setattr+0x202/0x253
>                        [<ffffffff8113201e>] notify_change+0x1a2/0x29d
>                        [<ffffffff8111bf08>] do_truncate+0x6c/0x89
>                        [<ffffffff81127a77>] do_last+0x579/0x57e
>                        [<ffffffff81129502>] do_filp_open+0x215/0x5ae
>                        [<ffffffff8111aec0>] do_sys_open+0x60/0xfc
>                        [<ffffffff8111af8f>] sys_open+0x20/0x22
>                        [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
>  }
>  ... key      at: [<ffffffff82925450>] __key.31289+0x0/0x8
>  ... acquired at:
>    [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>    [<ffffffff81074162>] mark_lock+0x18c/0x26a
>    [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>    [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>    [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>    [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>    [<ffffffff812131f7>] btrfs_remove_delayed_node+0x3e/0xd2
>    [<ffffffff811d77aa>] btrfs_destroy_inode+0x2ae/0x2d4
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
> Pid: 49, comm: kswapd0 Not tainted 2.6.36-v5+ #2
> Call Trace:
>  [<ffffffff8107493d>] print_irq_inversion_bug+0x124/0x135
>  [<ffffffff810749bf>] check_usage_forwards+0x71/0x7e
>  [<ffffffff8107494e>] ? check_usage_forwards+0x0/0x7e
>  [<ffffffff81074162>] mark_lock+0x18c/0x26a
>  [<ffffffff81075f1f>] __lock_acquire+0x3a5/0xda6
>  [<ffffffff81076911>] ? __lock_acquire+0xd97/0xda6
>  [<ffffffff812131f7>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>  [<ffffffff812131f7>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff812131f7>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff814c6291>] __mutex_lock_common+0x5a/0x444
>  [<ffffffff812131f7>] ? btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff81074604>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff814c6730>] mutex_lock_nested+0x39/0x3e
>  [<ffffffff812131f7>] btrfs_remove_delayed_node+0x3e/0xd2
>  [<ffffffff811d77aa>] btrfs_destroy_inode+0x2ae/0x2d4
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
>  [<ffffffff814c8880>] ? restore_args+0x0/0x30
>  [<ffffffff810619c3>] ? kthread+0x0/0xa5
>  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

