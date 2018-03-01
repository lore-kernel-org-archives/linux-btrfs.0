Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36936 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966291AbeCAGPO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 01:15:14 -0500
Subject: Re: [PATCH] btrfs: rename btrfs_close_extra_device to
 btrfs_free_extra_devids
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
References: <20180227043242.26367-1-anand.jain@oracle.com>
 <201803011216.UCOGFQ7a%fengguang.wu@intel.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <db1fb0e5-1bf4-84c9-6b97-cc6fbd9dab14@oracle.com>
Date: Thu, 1 Mar 2018 14:16:47 +0800
MIME-Version: 1.0
In-Reply-To: <201803011216.UCOGFQ7a%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/01/2018 12:42 PM, kbuild test robot wrote:
> Hi Anand,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on btrfs/next]
> [also build test ERROR on v4.16-rc3 next-20180228]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Anand-Jain/btrfs-rename-btrfs_close_extra_device-to-btrfs_free_extra_devids/20180301-120850
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next
> config: x86_64-randconfig-x016-201808 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
> 
> All errors (new ones prefixed by >>):


  there is v2 which already fixed this.

Thanks,
Anand

>     fs/btrfs/disk-io.c: In function 'open_ctree':
>>> fs/btrfs/disk-io.c:2783:2: error: implicit declaration of function 'btrfs_free_extra_devids'; did you mean 'btrfs_free_extra_devid'? [-Werror=implicit-function-declaration]
>       btrfs_free_extra_devids(fs_devices, 0);
>       ^~~~~~~~~~~~~~~~~~~~~~~
>       btrfs_free_extra_devid
>     cc1: some warnings being treated as errors
> 
> vim +2783 fs/btrfs/disk-io.c
> 
>    2396	
>    2397	int open_ctree(struct super_block *sb,
>    2398		       struct btrfs_fs_devices *fs_devices,
>    2399		       char *options)
>    2400	{
>    2401		u32 sectorsize;
>    2402		u32 nodesize;
>    2403		u32 stripesize;
>    2404		u64 generation;
>    2405		u64 features;
>    2406		struct btrfs_key location;
>    2407		struct buffer_head *bh;
>    2408		struct btrfs_super_block *disk_super;
>    2409		struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>    2410		struct btrfs_root *tree_root;
>    2411		struct btrfs_root *chunk_root;
>    2412		int ret;
>    2413		int err = -EINVAL;
>    2414		int num_backups_tried = 0;
>    2415		int backup_index = 0;
>    2416		int max_active;
>    2417		int clear_free_space_tree = 0;
>    2418	
>    2419		tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
>    2420		chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
>    2421		if (!tree_root || !chunk_root) {
>    2422			err = -ENOMEM;
>    2423			goto fail;
>    2424		}
>    2425	
>    2426		ret = init_srcu_struct(&fs_info->subvol_srcu);
>    2427		if (ret) {
>    2428			err = ret;
>    2429			goto fail;
>    2430		}
>    2431	
>    2432		ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
>    2433		if (ret) {
>    2434			err = ret;
>    2435			goto fail_srcu;
>    2436		}
>    2437		fs_info->dirty_metadata_batch = PAGE_SIZE *
>    2438						(1 + ilog2(nr_cpu_ids));
>    2439	
>    2440		ret = percpu_counter_init(&fs_info->delalloc_bytes, 0, GFP_KERNEL);
>    2441		if (ret) {
>    2442			err = ret;
>    2443			goto fail_dirty_metadata_bytes;
>    2444		}
>    2445	
>    2446		ret = percpu_counter_init(&fs_info->bio_counter, 0, GFP_KERNEL);
>    2447		if (ret) {
>    2448			err = ret;
>    2449			goto fail_delalloc_bytes;
>    2450		}
>    2451	
>    2452		INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
>    2453		INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
>    2454		INIT_LIST_HEAD(&fs_info->trans_list);
>    2455		INIT_LIST_HEAD(&fs_info->dead_roots);
>    2456		INIT_LIST_HEAD(&fs_info->delayed_iputs);
>    2457		INIT_LIST_HEAD(&fs_info->delalloc_roots);
>    2458		INIT_LIST_HEAD(&fs_info->caching_block_groups);
>    2459		spin_lock_init(&fs_info->delalloc_root_lock);
>    2460		spin_lock_init(&fs_info->trans_lock);
>    2461		spin_lock_init(&fs_info->fs_roots_radix_lock);
>    2462		spin_lock_init(&fs_info->delayed_iput_lock);
>    2463		spin_lock_init(&fs_info->defrag_inodes_lock);
>    2464		spin_lock_init(&fs_info->tree_mod_seq_lock);
>    2465		spin_lock_init(&fs_info->super_lock);
>    2466		spin_lock_init(&fs_info->qgroup_op_lock);
>    2467		spin_lock_init(&fs_info->buffer_lock);
>    2468		spin_lock_init(&fs_info->unused_bgs_lock);
>    2469		rwlock_init(&fs_info->tree_mod_log_lock);
>    2470		mutex_init(&fs_info->unused_bg_unpin_mutex);
>    2471		mutex_init(&fs_info->delete_unused_bgs_mutex);
>    2472		mutex_init(&fs_info->reloc_mutex);
>    2473		mutex_init(&fs_info->delalloc_root_mutex);
>    2474		mutex_init(&fs_info->cleaner_delayed_iput_mutex);
>    2475		seqlock_init(&fs_info->profiles_lock);
>    2476	
>    2477		INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
>    2478		INIT_LIST_HEAD(&fs_info->space_info);
>    2479		INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
>    2480		INIT_LIST_HEAD(&fs_info->unused_bgs);
>    2481		btrfs_mapping_init(&fs_info->mapping_tree);
>    2482		btrfs_init_block_rsv(&fs_info->global_block_rsv,
>    2483				     BTRFS_BLOCK_RSV_GLOBAL);
>    2484		btrfs_init_block_rsv(&fs_info->trans_block_rsv, BTRFS_BLOCK_RSV_TRANS);
>    2485		btrfs_init_block_rsv(&fs_info->chunk_block_rsv, BTRFS_BLOCK_RSV_CHUNK);
>    2486		btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
>    2487		btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
>    2488				     BTRFS_BLOCK_RSV_DELOPS);
>    2489		atomic_set(&fs_info->async_delalloc_pages, 0);
>    2490		atomic_set(&fs_info->defrag_running, 0);
>    2491		atomic_set(&fs_info->qgroup_op_seq, 0);
>    2492		atomic_set(&fs_info->reada_works_cnt, 0);
>    2493		atomic64_set(&fs_info->tree_mod_seq, 0);
>    2494		fs_info->sb = sb;
>    2495		fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
>    2496		fs_info->metadata_ratio = 0;
>    2497		fs_info->defrag_inodes = RB_ROOT;
>    2498		atomic64_set(&fs_info->free_chunk_space, 0);
>    2499		fs_info->tree_mod_log = RB_ROOT;
>    2500		fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
>    2501		fs_info->avg_delayed_ref_runtime = NSEC_PER_SEC >> 6; /* div by 64 */
>    2502		/* readahead state */
>    2503		INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
>    2504		spin_lock_init(&fs_info->reada_lock);
>    2505		btrfs_init_ref_verify(fs_info);
>    2506	
>    2507		fs_info->thread_pool_size = min_t(unsigned long,
>    2508						  num_online_cpus() + 2, 8);
>    2509	
>    2510		INIT_LIST_HEAD(&fs_info->ordered_roots);
>    2511		spin_lock_init(&fs_info->ordered_root_lock);
>    2512	
>    2513		fs_info->btree_inode = new_inode(sb);
>    2514		if (!fs_info->btree_inode) {
>    2515			err = -ENOMEM;
>    2516			goto fail_bio_counter;
>    2517		}
>    2518		mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
>    2519	
>    2520		fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
>    2521						GFP_KERNEL);
>    2522		if (!fs_info->delayed_root) {
>    2523			err = -ENOMEM;
>    2524			goto fail_iput;
>    2525		}
>    2526		btrfs_init_delayed_root(fs_info->delayed_root);
>    2527	
>    2528		btrfs_init_scrub(fs_info);
>    2529	#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>    2530		fs_info->check_integrity_print_mask = 0;
>    2531	#endif
>    2532		btrfs_init_balance(fs_info);
>    2533		btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
>    2534	
>    2535		sb->s_blocksize = BTRFS_BDEV_BLOCKSIZE;
>    2536		sb->s_blocksize_bits = blksize_bits(BTRFS_BDEV_BLOCKSIZE);
>    2537	
>    2538		btrfs_init_btree_inode(fs_info);
>    2539	
>    2540		spin_lock_init(&fs_info->block_group_cache_lock);
>    2541		fs_info->block_group_cache_tree = RB_ROOT;
>    2542		fs_info->first_logical_byte = (u64)-1;
>    2543	
>    2544		extent_io_tree_init(&fs_info->freed_extents[0], NULL);
>    2545		extent_io_tree_init(&fs_info->freed_extents[1], NULL);
>    2546		fs_info->pinned_extents = &fs_info->freed_extents[0];
>    2547		set_bit(BTRFS_FS_BARRIER, &fs_info->flags);
>    2548	
>    2549		mutex_init(&fs_info->ordered_operations_mutex);
>    2550		mutex_init(&fs_info->tree_log_mutex);
>    2551		mutex_init(&fs_info->chunk_mutex);
>    2552		mutex_init(&fs_info->transaction_kthread_mutex);
>    2553		mutex_init(&fs_info->cleaner_mutex);
>    2554		mutex_init(&fs_info->volume_mutex);
>    2555		mutex_init(&fs_info->ro_block_group_mutex);
>    2556		init_rwsem(&fs_info->commit_root_sem);
>    2557		init_rwsem(&fs_info->cleanup_work_sem);
>    2558		init_rwsem(&fs_info->subvol_sem);
>    2559		sema_init(&fs_info->uuid_tree_rescan_sem, 1);
>    2560	
>    2561		btrfs_init_dev_replace_locks(fs_info);
>    2562		btrfs_init_qgroup(fs_info);
>    2563	
>    2564		btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
>    2565		btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
>    2566	
>    2567		init_waitqueue_head(&fs_info->transaction_throttle);
>    2568		init_waitqueue_head(&fs_info->transaction_wait);
>    2569		init_waitqueue_head(&fs_info->transaction_blocked_wait);
>    2570		init_waitqueue_head(&fs_info->async_submit_wait);
>    2571	
>    2572		INIT_LIST_HEAD(&fs_info->pinned_chunks);
>    2573	
>    2574		/* Usable values until the real ones are cached from the superblock */
>    2575		fs_info->nodesize = 4096;
>    2576		fs_info->sectorsize = 4096;
>    2577		fs_info->stripesize = 4096;
>    2578	
>    2579		ret = btrfs_alloc_stripe_hash_table(fs_info);
>    2580		if (ret) {
>    2581			err = ret;
>    2582			goto fail_alloc;
>    2583		}
>    2584	
>    2585		__setup_root(tree_root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
>    2586	
>    2587		invalidate_bdev(fs_devices->latest_bdev);
>    2588	
>    2589		/*
>    2590		 * Read super block and check the signature bytes only
>    2591		 */
>    2592		bh = btrfs_read_dev_super(fs_devices->latest_bdev);
>    2593		if (IS_ERR(bh)) {
>    2594			err = PTR_ERR(bh);
>    2595			goto fail_alloc;
>    2596		}
>    2597	
>    2598		/*
>    2599		 * We want to check superblock checksum, the type is stored inside.
>    2600		 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>    2601		 */
>    2602		if (btrfs_check_super_csum(fs_info, bh->b_data)) {
>    2603			btrfs_err(fs_info, "superblock checksum mismatch");
>    2604			err = -EINVAL;
>    2605			brelse(bh);
>    2606			goto fail_alloc;
>    2607		}
>    2608	
>    2609		/*
>    2610		 * super_copy is zeroed at allocation time and we never touch the
>    2611		 * following bytes up to INFO_SIZE, the checksum is calculated from
>    2612		 * the whole block of INFO_SIZE
>    2613		 */
>    2614		memcpy(fs_info->super_copy, bh->b_data, sizeof(*fs_info->super_copy));
>    2615		memcpy(fs_info->super_for_commit, fs_info->super_copy,
>    2616		       sizeof(*fs_info->super_for_commit));
>    2617		brelse(bh);
>    2618	
>    2619		memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>    2620	
>    2621		ret = btrfs_check_super_valid(fs_info);
>    2622		if (ret) {
>    2623			btrfs_err(fs_info, "superblock contains fatal errors");
>    2624			err = -EINVAL;
>    2625			goto fail_alloc;
>    2626		}
>    2627	
>    2628		disk_super = fs_info->super_copy;
>    2629		if (!btrfs_super_root(disk_super))
>    2630			goto fail_alloc;
>    2631	
>    2632		/* check FS state, whether FS is broken. */
>    2633		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
>    2634			set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
>    2635	
>    2636		/*
>    2637		 * run through our array of backup supers and setup
>    2638		 * our ring pointer to the oldest one
>    2639		 */
>    2640		generation = btrfs_super_generation(disk_super);
>    2641		find_oldest_super_backup(fs_info, generation);
>    2642	
>    2643		/*
>    2644		 * In the long term, we'll store the compression type in the super
>    2645		 * block, and it'll be used for per file compression control.
>    2646		 */
>    2647		fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
>    2648	
>    2649		ret = btrfs_parse_options(fs_info, options, sb->s_flags);
>    2650		if (ret) {
>    2651			err = ret;
>    2652			goto fail_alloc;
>    2653		}
>    2654	
>    2655		features = btrfs_super_incompat_flags(disk_super) &
>    2656			~BTRFS_FEATURE_INCOMPAT_SUPP;
>    2657		if (features) {
>    2658			btrfs_err(fs_info,
>    2659			    "cannot mount because of unsupported optional features (%llx)",
>    2660			    features);
>    2661			err = -EINVAL;
>    2662			goto fail_alloc;
>    2663		}
>    2664	
>    2665		features = btrfs_super_incompat_flags(disk_super);
>    2666		features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
>    2667		if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
>    2668			features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
>    2669		else if (fs_info->compress_type == BTRFS_COMPRESS_ZSTD)
>    2670			features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD;
>    2671	
>    2672		if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
>    2673			btrfs_info(fs_info, "has skinny extents");
>    2674	
>    2675		/*
>    2676		 * flag our filesystem as having big metadata blocks if
>    2677		 * they are bigger than the page size
>    2678		 */
>    2679		if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
>    2680			if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
>    2681				btrfs_info(fs_info,
>    2682					"flagging fs with big metadata feature");
>    2683			features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
>    2684		}
>    2685	
>    2686		nodesize = btrfs_super_nodesize(disk_super);
>    2687		sectorsize = btrfs_super_sectorsize(disk_super);
>    2688		stripesize = sectorsize;
>    2689		fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
>    2690		fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
>    2691	
>    2692		/* Cache block sizes */
>    2693		fs_info->nodesize = nodesize;
>    2694		fs_info->sectorsize = sectorsize;
>    2695		fs_info->stripesize = stripesize;
>    2696	
>    2697		/*
>    2698		 * mixed block groups end up with duplicate but slightly offset
>    2699		 * extent buffers for the same range.  It leads to corruptions
>    2700		 */
>    2701		if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
>    2702		    (sectorsize != nodesize)) {
>    2703			btrfs_err(fs_info,
>    2704	"unequal nodesize/sectorsize (%u != %u) are not allowed for mixed block groups",
>    2705				nodesize, sectorsize);
>    2706			goto fail_alloc;
>    2707		}
>    2708	
>    2709		/*
>    2710		 * Needn't use the lock because there is no other task which will
>    2711		 * update the flag.
>    2712		 */
>    2713		btrfs_set_super_incompat_flags(disk_super, features);
>    2714	
>    2715		features = btrfs_super_compat_ro_flags(disk_super) &
>    2716			~BTRFS_FEATURE_COMPAT_RO_SUPP;
>    2717		if (!sb_rdonly(sb) && features) {
>    2718			btrfs_err(fs_info,
>    2719		"cannot mount read-write because of unsupported optional features (%llx)",
>    2720			       features);
>    2721			err = -EINVAL;
>    2722			goto fail_alloc;
>    2723		}
>    2724	
>    2725		max_active = fs_info->thread_pool_size;
>    2726	
>    2727		ret = btrfs_init_workqueues(fs_info, fs_devices);
>    2728		if (ret) {
>    2729			err = ret;
>    2730			goto fail_sb_buffer;
>    2731		}
>    2732	
>    2733		sb->s_bdi->congested_fn = btrfs_congested_fn;
>    2734		sb->s_bdi->congested_data = fs_info;
>    2735		sb->s_bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
>    2736		sb->s_bdi->ra_pages = VM_MAX_READAHEAD * SZ_1K / PAGE_SIZE;
>    2737		sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
>    2738		sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
>    2739	
>    2740		sb->s_blocksize = sectorsize;
>    2741		sb->s_blocksize_bits = blksize_bits(sectorsize);
>    2742		memcpy(&sb->s_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
>    2743	
>    2744		mutex_lock(&fs_info->chunk_mutex);
>    2745		ret = btrfs_read_sys_array(fs_info);
>    2746		mutex_unlock(&fs_info->chunk_mutex);
>    2747		if (ret) {
>    2748			btrfs_err(fs_info, "failed to read the system array: %d", ret);
>    2749			goto fail_sb_buffer;
>    2750		}
>    2751	
>    2752		generation = btrfs_super_chunk_root_generation(disk_super);
>    2753	
>    2754		__setup_root(chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
>    2755	
>    2756		chunk_root->node = read_tree_block(fs_info,
>    2757						   btrfs_super_chunk_root(disk_super),
>    2758						   generation);
>    2759		if (IS_ERR(chunk_root->node) ||
>    2760		    !extent_buffer_uptodate(chunk_root->node)) {
>    2761			btrfs_err(fs_info, "failed to read chunk root");
>    2762			if (!IS_ERR(chunk_root->node))
>    2763				free_extent_buffer(chunk_root->node);
>    2764			chunk_root->node = NULL;
>    2765			goto fail_tree_roots;
>    2766		}
>    2767		btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
>    2768		chunk_root->commit_root = btrfs_root_node(chunk_root);
>    2769	
>    2770		read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
>    2771		   btrfs_header_chunk_tree_uuid(chunk_root->node), BTRFS_UUID_SIZE);
>    2772	
>    2773		ret = btrfs_read_chunk_tree(fs_info);
>    2774		if (ret) {
>    2775			btrfs_err(fs_info, "failed to read chunk tree: %d", ret);
>    2776			goto fail_tree_roots;
>    2777		}
>    2778	
>    2779		/*
>    2780		 * keep the devid that is marked to be the target device for the
>    2781		 * dev_replace procedure
>    2782		 */
>> 2783		btrfs_free_extra_devids(fs_devices, 0);
>    2784	
>    2785		if (!fs_devices->latest_bdev) {
>    2786			btrfs_err(fs_info, "failed to read devices");
>    2787			goto fail_tree_roots;
>    2788		}
>    2789	
>    2790	retry_root_backup:
>    2791		generation = btrfs_super_generation(disk_super);
>    2792	
>    2793		tree_root->node = read_tree_block(fs_info,
>    2794						  btrfs_super_root(disk_super),
>    2795						  generation);
>    2796		if (IS_ERR(tree_root->node) ||
>    2797		    !extent_buffer_uptodate(tree_root->node)) {
>    2798			btrfs_warn(fs_info, "failed to read tree root");
>    2799			if (!IS_ERR(tree_root->node))
>    2800				free_extent_buffer(tree_root->node);
>    2801			tree_root->node = NULL;
>    2802			goto recovery_tree_root;
>    2803		}
>    2804	
>    2805		btrfs_set_root_node(&tree_root->root_item, tree_root->node);
>    2806		tree_root->commit_root = btrfs_root_node(tree_root);
>    2807		btrfs_set_root_refs(&tree_root->root_item, 1);
>    2808	
>    2809		mutex_lock(&tree_root->objectid_mutex);
>    2810		ret = btrfs_find_highest_objectid(tree_root,
>    2811						&tree_root->highest_objectid);
>    2812		if (ret) {
>    2813			mutex_unlock(&tree_root->objectid_mutex);
>    2814			goto recovery_tree_root;
>    2815		}
>    2816	
>    2817		ASSERT(tree_root->highest_objectid <= BTRFS_LAST_FREE_OBJECTID);
>    2818	
>    2819		mutex_unlock(&tree_root->objectid_mutex);
>    2820	
>    2821		ret = btrfs_read_roots(fs_info);
>    2822		if (ret)
>    2823			goto recovery_tree_root;
>    2824	
>    2825		fs_info->generation = generation;
>    2826		fs_info->last_trans_committed = generation;
>    2827	
>    2828		ret = btrfs_recover_balance(fs_info);
>    2829		if (ret) {
>    2830			btrfs_err(fs_info, "failed to recover balance: %d", ret);
>    2831			goto fail_block_groups;
>    2832		}
>    2833	
>    2834		ret = btrfs_init_dev_stats(fs_info);
>    2835		if (ret) {
>    2836			btrfs_err(fs_info, "failed to init dev_stats: %d", ret);
>    2837			goto fail_block_groups;
>    2838		}
>    2839	
>    2840		ret = btrfs_init_dev_replace(fs_info);
>    2841		if (ret) {
>    2842			btrfs_err(fs_info, "failed to init dev_replace: %d", ret);
>    2843			goto fail_block_groups;
>    2844		}
>    2845	
>    2846		btrfs_free_extra_devids(fs_devices, 1);
>    2847	
>    2848		ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
>    2849		if (ret) {
>    2850			btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
>    2851					ret);
>    2852			goto fail_block_groups;
>    2853		}
>    2854	
>    2855		ret = btrfs_sysfs_add_device(fs_devices);
>    2856		if (ret) {
>    2857			btrfs_err(fs_info, "failed to init sysfs device interface: %d",
>    2858					ret);
>    2859			goto fail_fsdev_sysfs;
>    2860		}
>    2861	
>    2862		ret = btrfs_sysfs_add_mounted(fs_info);
>    2863		if (ret) {
>    2864			btrfs_err(fs_info, "failed to init sysfs interface: %d", ret);
>    2865			goto fail_fsdev_sysfs;
>    2866		}
>    2867	
>    2868		ret = btrfs_init_space_info(fs_info);
>    2869		if (ret) {
>    2870			btrfs_err(fs_info, "failed to initialize space info: %d", ret);
>    2871			goto fail_sysfs;
>    2872		}
>    2873	
>    2874		ret = btrfs_read_block_groups(fs_info);
>    2875		if (ret) {
>    2876			btrfs_err(fs_info, "failed to read block groups: %d", ret);
>    2877			goto fail_sysfs;
>    2878		}
>    2879	
>    2880		if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info)) {
>    2881			btrfs_warn(fs_info,
>    2882			"writeable mount is not allowed due to too many missing devices");
>    2883			goto fail_sysfs;
>    2884		}
>    2885	
>    2886		fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>    2887						       "btrfs-cleaner");
>    2888		if (IS_ERR(fs_info->cleaner_kthread))
>    2889			goto fail_sysfs;
>    2890	
>    2891		fs_info->transaction_kthread = kthread_run(transaction_kthread,
>    2892							   tree_root,
>    2893							   "btrfs-transaction");
>    2894		if (IS_ERR(fs_info->transaction_kthread))
>    2895			goto fail_cleaner;
>    2896	
>    2897		if (!btrfs_test_opt(fs_info, NOSSD) &&
>    2898		    !fs_info->fs_devices->rotating) {
>    2899			btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
>    2900		}
>    2901	
>    2902		/*
>    2903		 * Mount does not set all options immediately, we can do it now and do
>    2904		 * not have to wait for transaction commit
>    2905		 */
>    2906		btrfs_apply_pending_changes(fs_info);
>    2907	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
