Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41734 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756784AbaFZCAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:00:10 -0400
Message-ID: <53AB7EE5.9070706@cn.fujitsu.com>
Date: Thu, 26 Jun 2014 10:01:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs: refactor open_ctree()
References: <53AB6185.9060109@redhat.com>
In-Reply-To: <53AB6185.9060109@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH, RFC] btrfs: refactor open_ctree()
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年06月26日 07:55
> First off: total RFC, don't merge this; it builds, but
> is totally untested.
>
> open_ctree() is almost 1000 lines long.  I've started trying
> to refactor it, primarily into helper functions, and also
> simplifying (?) things a bit at the beginning by removing the
> ret = func(); if (ret) { err = ret; goto ... } dance where it's not
> needed.
Totally agree with such work, great!
Such long open_ctree() really makes things hard to read.
>
> Does this look like a reasonable thing to do?  Have I cut
> things into the right chunks?  Would you rather see it as
> as series of patches, moving one hunk of code at a time?
Personally, I perfer patchsets and each patch just only move one hunk of 
codes.
This will make review things much more easier.

Thanks,
Qu
>
> Thanks,
> -Eric
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8bb4aa1..92c1ede 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2133,6 +2133,208 @@ void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
>   	}
>   }
>   
> +static void btrfs_qgroup_init(struct btrfs_fs_info *fs_info)
> +{
> +	spin_lock_init(&fs_info->qgroup_lock);
> +	mutex_init(&fs_info->qgroup_ioctl_lock);
> +	fs_info->qgroup_tree = RB_ROOT;
> +	fs_info->qgroup_op_tree = RB_ROOT;
> +	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
> +	fs_info->qgroup_seq = 1;
> +	fs_info->quota_enabled = 0;
> +	fs_info->pending_quota_state = 0;
> +	fs_info->qgroup_ulist = NULL;
> +	mutex_init(&fs_info->qgroup_rescan_lock);
> +}
> +
> +static void btrfs_dev_replace_init(struct btrfs_fs_info *fs_info)
> +{
> +	fs_info->dev_replace.lock_owner = 0;
> +	atomic_set(&fs_info->dev_replace.nesting_level, 0);
> +	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> +	mutex_init(&fs_info->dev_replace.lock_management_lock);
> +	mutex_init(&fs_info->dev_replace.lock);
> +}
> +
> +static void btrfs_scrub_init(struct btrfs_fs_info *fs_info)
> +{
> +	mutex_init(&fs_info->scrub_lock);
> +	atomic_set(&fs_info->scrubs_running, 0);
> +	atomic_set(&fs_info->scrub_pause_req, 0);
> +	atomic_set(&fs_info->scrubs_paused, 0);
> +	atomic_set(&fs_info->scrub_cancel_req, 0);
> +	init_waitqueue_head(&fs_info->replace_wait);
> +	init_waitqueue_head(&fs_info->scrub_pause_wait);
> +	fs_info->scrub_workers_refcnt = 0;
> +}
> +
> +static void btrfs_balance_init(struct btrfs_fs_info *fs_info)
> +{
> +	spin_lock_init(&fs_info->balance_lock);
> +	mutex_init(&fs_info->balance_mutex);
> +	atomic_set(&fs_info->balance_running, 0);
> +	atomic_set(&fs_info->balance_pause_req, 0);
> +	atomic_set(&fs_info->balance_cancel_req, 0);
> +	fs_info->balance_ctl = NULL;
> +	init_waitqueue_head(&fs_info->balance_wait_q);
> +}
> +
> +static void btrfs_btree_inode_init(struct btrfs_fs_info *fs_info)
> +{
> +	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
> +	set_nlink(fs_info->btree_inode, 1);
> +	/*
> +	 * we set the i_size on the btree inode to the max possible int.
> +	 * the real end of the address space is determined by all of
> +	 * the devices in the system
> +	 */
> +	fs_info->btree_inode->i_size = OFFSET_MAX;
> +	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
> +	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
> +
> +	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
> +	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
> +			     fs_info->btree_inode->i_mapping);
> +	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
> +	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
> +
> +	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
> +
> +	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
> +	       sizeof(struct btrfs_key));
> +	set_bit(BTRFS_INODE_DUMMY,
> +		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
> +	btrfs_insert_inode_hash(fs_info->btree_inode);
> +}
> +
> +static int btrfs_alloc_workqueues(struct btrfs_fs_info *fs_info,
> +				  struct btrfs_fs_devices *fs_devices,
> +				  int flags)
> +{
> +	int max_active = fs_info->thread_pool_size;
> +
> +	fs_info->workers =
> +		btrfs_alloc_workqueue("worker", flags | WQ_HIGHPRI,
> +				      max_active, 16);
> +	fs_info->delalloc_workers =
> +		btrfs_alloc_workqueue("delalloc", flags, max_active, 2);
> +
> +	fs_info->flush_workers =
> +		btrfs_alloc_workqueue("flush_delalloc", flags, max_active, 0);
> +
> +	fs_info->caching_workers =
> +		btrfs_alloc_workqueue("cache", flags, max_active, 0);
> +
> +	/*
> +	 * a higher idle thresh on the submit workers makes it much more
> +	 * likely that bios will be send down in a sane order to the
> +	 * devices
> +	 */
> +	fs_info->submit_workers =
> +		btrfs_alloc_workqueue("submit", flags,
> +				      min_t(u64, fs_devices->num_devices,
> +					    max_active), 64);
> +	fs_info->fixup_workers =
> +		btrfs_alloc_workqueue("fixup", flags, 1, 0);
> +	/*
> +	 * endios are largely parallel and should have a very
> +	 * low idle thresh
> +	 */
> +	fs_info->endio_workers =
> +		btrfs_alloc_workqueue("endio", flags, max_active, 4);
> +	fs_info->endio_meta_workers =
> +		btrfs_alloc_workqueue("endio-meta", flags, max_active, 4);
> +	fs_info->endio_meta_write_workers =
> +		btrfs_alloc_workqueue("endio-meta-write", flags, max_active, 2);
> +	fs_info->endio_raid56_workers =
> +		btrfs_alloc_workqueue("endio-raid56", flags, max_active, 4);
> +	fs_info->rmw_workers =
> +		btrfs_alloc_workqueue("rmw", flags, max_active, 2);
> +	fs_info->endio_write_workers =
> +		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
> +	fs_info->endio_freespace_worker =
> +		btrfs_alloc_workqueue("freespace-write", flags, max_active, 0);
> +	fs_info->delayed_workers =
> +		btrfs_alloc_workqueue("delayed-meta", flags, max_active, 0);
> +	fs_info->readahead_workers =
> +		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
> +	fs_info->qgroup_rescan_workers =
> +		btrfs_alloc_workqueue("qgroup-rescan", flags, 1, 0);
> +	fs_info->extent_workers =
> +		btrfs_alloc_workqueue("extent-refs", flags,
> +				      min_t(u64, fs_devices->num_devices,
> +					    max_active), 8);
> +
> +	if (!(fs_info->workers && fs_info->delalloc_workers &&
> +	      fs_info->submit_workers && fs_info->flush_workers &&
> +	      fs_info->endio_workers && fs_info->endio_meta_workers &&
> +	      fs_info->endio_meta_write_workers &&
> +	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
> +	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
> +	      fs_info->caching_workers && fs_info->readahead_workers &&
> +	      fs_info->fixup_workers && fs_info->delayed_workers &&
> +	      fs_info->fixup_workers && fs_info->extent_workers &&
> +	      fs_info->qgroup_rescan_workers)) {
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int btrfs_replay_log(struct btrfs_fs_info *fs_info)
> +{
> +	int ret;
> +	u32 blocksize;
> +	struct btrfs_root *tree_root = fs_info->tree_root;
> +	struct btrfs_root *log_tree_root;
> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	struct btrfs_super_block *disk_super = fs_info->super_copy;
> +	u64 bytenr = btrfs_super_log_root(disk_super);
> +
> +	if (fs_devices->rw_devices == 0) {
> +		printk(KERN_WARNING "BTRFS: log replay required "
> +		       "on RO media\n");
> +		return -EIO;
> +	}
> +	blocksize = btrfs_level_size(tree_root,
> +			      btrfs_super_log_root_level(disk_super));
> +
> +	log_tree_root = btrfs_alloc_root(fs_info);
> +	if (!log_tree_root)
> +		return -ENOMEM;
> +
> +	__setup_root(tree_root->nodesize, tree_root->leafsize,
> +		     tree_root->sectorsize, tree_root->stripesize,
> +		     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
> +
> +	log_tree_root->node = read_tree_block(tree_root, bytenr,
> +					      blocksize,
> +					      fs_info->generation + 1);
> +	if (!log_tree_root->node ||
> +	    !extent_buffer_uptodate(log_tree_root->node)) {
> +		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> +		free_extent_buffer(log_tree_root->node);
> +		kfree(log_tree_root);
> +		return -EIO;
> +	}
> +	/* returns with log_tree_root freed on success */
> +	ret = btrfs_recover_log_trees(log_tree_root);
> +	if (ret) {
> +		btrfs_error(tree_root->fs_info, ret,
> +			    "Failed to recover log tree");
> +		free_extent_buffer(log_tree_root->node);
> +		kfree(log_tree_root);
> +		return ret;
> +	}
> +
> +	if (fs_info->sb->s_flags & MS_RDONLY) {
> +		ret = btrfs_commit_super(tree_root);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>   int open_ctree(struct super_block *sb,
>   	       struct btrfs_fs_devices *fs_devices,
>   	       char *options)
> @@ -2155,12 +2357,10 @@ int open_ctree(struct super_block *sb,
>   	struct btrfs_root *dev_root;
>   	struct btrfs_root *quota_root;
>   	struct btrfs_root *uuid_root;
> -	struct btrfs_root *log_tree_root;
>   	int ret;
> -	int err = -EINVAL;
> +	int err;
>   	int num_backups_tried = 0;
>   	int backup_index = 0;
> -	int max_active;
>   	int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
>   	bool create_uuid_tree;
>   	bool check_uuid_tree;
> @@ -2172,37 +2372,28 @@ int open_ctree(struct super_block *sb,
>   		goto fail;
>   	}
>   
> -	ret = init_srcu_struct(&fs_info->subvol_srcu);
> -	if (ret) {
> -		err = ret;
> +	err = init_srcu_struct(&fs_info->subvol_srcu);
> +	if (err)
>   		goto fail;
> -	}
>   
> -	ret = setup_bdi(fs_info, &fs_info->bdi);
> -	if (ret) {
> -		err = ret;
> +	err = setup_bdi(fs_info, &fs_info->bdi);
> +	if (err)
>   		goto fail_srcu;
> -	}
>   
> -	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0);
> -	if (ret) {
> -		err = ret;
> +	err = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0);
> +	if (err)
>   		goto fail_bdi;
> -	}
> +
>   	fs_info->dirty_metadata_batch = PAGE_CACHE_SIZE *
>   					(1 + ilog2(nr_cpu_ids));
>   
> -	ret = percpu_counter_init(&fs_info->delalloc_bytes, 0);
> -	if (ret) {
> -		err = ret;
> +	err = percpu_counter_init(&fs_info->delalloc_bytes, 0);
> +	if (err)
>   		goto fail_dirty_metadata_bytes;
> -	}
>   
> -	ret = percpu_counter_init(&fs_info->bio_counter, 0);
> -	if (ret) {
> -		err = ret;
> +	err = percpu_counter_init(&fs_info->bio_counter, 0);
> +	if (err)
>   		goto fail_delalloc_bytes;
> -	}
>   
>   	fs_info->btree_inode = new_inode(sb);
>   	if (!fs_info->btree_inode) {
> @@ -2263,9 +2454,11 @@ int open_ctree(struct super_block *sb,
>   	fs_info->tree_mod_log = RB_ROOT;
>   	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
>   	fs_info->avg_delayed_ref_runtime = div64_u64(NSEC_PER_SEC, 64);
> +{
>   	/* readahead state */
>   	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
>   	spin_lock_init(&fs_info->reada_lock);
> +}
>   
>   	fs_info->thread_pool_size = min_t(unsigned long,
>   					  num_online_cpus() + 2, 8);
> @@ -2280,56 +2473,22 @@ int open_ctree(struct super_block *sb,
>   	}
>   	btrfs_init_delayed_root(fs_info->delayed_root);
>   
> -	mutex_init(&fs_info->scrub_lock);
> -	atomic_set(&fs_info->scrubs_running, 0);
> -	atomic_set(&fs_info->scrub_pause_req, 0);
> -	atomic_set(&fs_info->scrubs_paused, 0);
> -	atomic_set(&fs_info->scrub_cancel_req, 0);
> -	init_waitqueue_head(&fs_info->replace_wait);
> -	init_waitqueue_head(&fs_info->scrub_pause_wait);
> -	fs_info->scrub_workers_refcnt = 0;
> +	btrfs_scrub_init(fs_info);
> +
>   #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>   	fs_info->check_integrity_print_mask = 0;
>   #endif
> +	btrfs_balance_init(fs_info);
>   
> -	spin_lock_init(&fs_info->balance_lock);
> -	mutex_init(&fs_info->balance_mutex);
> -	atomic_set(&fs_info->balance_running, 0);
> -	atomic_set(&fs_info->balance_pause_req, 0);
> -	atomic_set(&fs_info->balance_cancel_req, 0);
> -	fs_info->balance_ctl = NULL;
> -	init_waitqueue_head(&fs_info->balance_wait_q);
>   	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
>   
>   	sb->s_blocksize = 4096;
>   	sb->s_blocksize_bits = blksize_bits(4096);
>   	sb->s_bdi = &fs_info->bdi;
>   
> -	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
> -	set_nlink(fs_info->btree_inode, 1);
> -	/*
> -	 * we set the i_size on the btree inode to the max possible int.
> -	 * the real end of the address space is determined by all of
> -	 * the devices in the system
> -	 */
> -	fs_info->btree_inode->i_size = OFFSET_MAX;
> -	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
> -	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
> -
> -	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
> -	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
> -			     fs_info->btree_inode->i_mapping);
> -	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
> -	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
> -
> -	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
> -
> +	/* XXX move up? */
> +	btrfs_btree_inode_init(fs_info);
>   	BTRFS_I(fs_info->btree_inode)->root = tree_root;
> -	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
> -	       sizeof(struct btrfs_key));
> -	set_bit(BTRFS_INODE_DUMMY,
> -		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
> -	btrfs_insert_inode_hash(fs_info->btree_inode);
>   
>   	spin_lock_init(&fs_info->block_group_cache_lock);
>   	fs_info->block_group_cache_tree = RB_ROOT;
> @@ -2342,7 +2501,6 @@ int open_ctree(struct super_block *sb,
>   	fs_info->pinned_extents = &fs_info->freed_extents[0];
>   	fs_info->do_barriers = 1;
>   
> -
>   	mutex_init(&fs_info->ordered_operations_mutex);
>   	mutex_init(&fs_info->ordered_extent_flush_mutex);
>   	mutex_init(&fs_info->tree_log_mutex);
> @@ -2354,22 +2512,9 @@ int open_ctree(struct super_block *sb,
>   	init_rwsem(&fs_info->cleanup_work_sem);
>   	init_rwsem(&fs_info->subvol_sem);
>   	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
> -	fs_info->dev_replace.lock_owner = 0;
> -	atomic_set(&fs_info->dev_replace.nesting_level, 0);
> -	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> -	mutex_init(&fs_info->dev_replace.lock_management_lock);
> -	mutex_init(&fs_info->dev_replace.lock);
>   
> -	spin_lock_init(&fs_info->qgroup_lock);
> -	mutex_init(&fs_info->qgroup_ioctl_lock);
> -	fs_info->qgroup_tree = RB_ROOT;
> -	fs_info->qgroup_op_tree = RB_ROOT;
> -	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
> -	fs_info->qgroup_seq = 1;
> -	fs_info->quota_enabled = 0;
> -	fs_info->pending_quota_state = 0;
> -	fs_info->qgroup_ulist = NULL;
> -	mutex_init(&fs_info->qgroup_rescan_lock);
> +	btrfs_dev_replace_init(fs_info);
> +	btrfs_qgroup_init(fs_info);
>   
>   	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
>   	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
> @@ -2379,11 +2524,9 @@ int open_ctree(struct super_block *sb,
>   	init_waitqueue_head(&fs_info->transaction_blocked_wait);
>   	init_waitqueue_head(&fs_info->async_submit_wait);
>   
> -	ret = btrfs_alloc_stripe_hash_table(fs_info);
> -	if (ret) {
> -		err = ret;
> +	err = btrfs_alloc_stripe_hash_table(fs_info);
> +	if (err)
>   		goto fail_alloc;
> -	}
>   
>   	__setup_root(4096, 4096, 4096, 4096, tree_root,
>   		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
> @@ -2421,10 +2564,9 @@ int open_ctree(struct super_block *sb,
>   
>   	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>   
> -	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
> -	if (ret) {
> +	err = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
> +	if (err) {
>   		printk(KERN_ERR "BTRFS: superblock contains fatal errors\n");
> -		err = -EINVAL;
>   		goto fail_alloc;
>   	}
>   
> @@ -2449,11 +2591,9 @@ int open_ctree(struct super_block *sb,
>   	 */
>   	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
>   
> -	ret = btrfs_parse_options(tree_root, options);
> -	if (ret) {
> -		err = ret;
> +	err = btrfs_parse_options(tree_root, options);
> +	if (err)
>   		goto fail_alloc;
> -	}
>   
>   	features = btrfs_super_incompat_flags(disk_super) &
>   		~BTRFS_FEATURE_INCOMPAT_SUPP;
> @@ -2535,76 +2675,9 @@ int open_ctree(struct super_block *sb,
>   		goto fail_alloc;
>   	}
>   
> -	max_active = fs_info->thread_pool_size;
> -
> -	fs_info->workers =
> -		btrfs_alloc_workqueue("worker", flags | WQ_HIGHPRI,
> -				      max_active, 16);
> -
> -	fs_info->delalloc_workers =
> -		btrfs_alloc_workqueue("delalloc", flags, max_active, 2);
> -
> -	fs_info->flush_workers =
> -		btrfs_alloc_workqueue("flush_delalloc", flags, max_active, 0);
> -
> -	fs_info->caching_workers =
> -		btrfs_alloc_workqueue("cache", flags, max_active, 0);
> -
> -	/*
> -	 * a higher idle thresh on the submit workers makes it much more
> -	 * likely that bios will be send down in a sane order to the
> -	 * devices
> -	 */
> -	fs_info->submit_workers =
> -		btrfs_alloc_workqueue("submit", flags,
> -				      min_t(u64, fs_devices->num_devices,
> -					    max_active), 64);
> -
> -	fs_info->fixup_workers =
> -		btrfs_alloc_workqueue("fixup", flags, 1, 0);
> -
> -	/*
> -	 * endios are largely parallel and should have a very
> -	 * low idle thresh
> -	 */
> -	fs_info->endio_workers =
> -		btrfs_alloc_workqueue("endio", flags, max_active, 4);
> -	fs_info->endio_meta_workers =
> -		btrfs_alloc_workqueue("endio-meta", flags, max_active, 4);
> -	fs_info->endio_meta_write_workers =
> -		btrfs_alloc_workqueue("endio-meta-write", flags, max_active, 2);
> -	fs_info->endio_raid56_workers =
> -		btrfs_alloc_workqueue("endio-raid56", flags, max_active, 4);
> -	fs_info->rmw_workers =
> -		btrfs_alloc_workqueue("rmw", flags, max_active, 2);
> -	fs_info->endio_write_workers =
> -		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
> -	fs_info->endio_freespace_worker =
> -		btrfs_alloc_workqueue("freespace-write", flags, max_active, 0);
> -	fs_info->delayed_workers =
> -		btrfs_alloc_workqueue("delayed-meta", flags, max_active, 0);
> -	fs_info->readahead_workers =
> -		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
> -	fs_info->qgroup_rescan_workers =
> -		btrfs_alloc_workqueue("qgroup-rescan", flags, 1, 0);
> -	fs_info->extent_workers =
> -		btrfs_alloc_workqueue("extent-refs", flags,
> -				      min_t(u64, fs_devices->num_devices,
> -					    max_active), 8);
> -
> -	if (!(fs_info->workers && fs_info->delalloc_workers &&
> -	      fs_info->submit_workers && fs_info->flush_workers &&
> -	      fs_info->endio_workers && fs_info->endio_meta_workers &&
> -	      fs_info->endio_meta_write_workers &&
> -	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
> -	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
> -	      fs_info->caching_workers && fs_info->readahead_workers &&
> -	      fs_info->fixup_workers && fs_info->delayed_workers &&
> -	      fs_info->fixup_workers && fs_info->extent_workers &&
> -	      fs_info->qgroup_rescan_workers)) {
> -		err = -ENOMEM;
> +	err = btrfs_alloc_workqueues(fs_info, fs_devices, flags);
> +	if (err)
>   		goto fail_sb_buffer;
> -	}
>   
>   	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
>   	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> @@ -2630,14 +2703,17 @@ int open_ctree(struct super_block *sb,
>   	}
>   
>   	mutex_lock(&fs_info->chunk_mutex);
> -	ret = btrfs_read_sys_array(tree_root);
> +	err = btrfs_read_sys_array(tree_root);
>   	mutex_unlock(&fs_info->chunk_mutex);
> -	if (ret) {
> +	if (err) {
>   		printk(KERN_WARNING "BTRFS: failed to read the system "
>   		       "array on %s\n", sb->s_id);
>   		goto fail_sb_buffer;
>   	}
>   
> +	/* From here on we don't trust function returns to be errnos... */
> + 	err = -EINVAL;
> +
>   	blocksize = btrfs_level_size(tree_root,
>   				     btrfs_super_chunk_root_level(disk_super));
>   	generation = btrfs_super_chunk_root_generation(disk_super);
> @@ -2847,52 +2923,11 @@ retry_root_backup:
>   
>   	/* do not make disk changes in broken FS */
>   	if (btrfs_super_log_root(disk_super) != 0) {
> -		u64 bytenr = btrfs_super_log_root(disk_super);
> -
> -		if (fs_devices->rw_devices == 0) {
> -			printk(KERN_WARNING "BTRFS: log replay required "
> -			       "on RO media\n");
> -			err = -EIO;
> -			goto fail_qgroup;
> -		}
> -		blocksize =
> -		     btrfs_level_size(tree_root,
> -				      btrfs_super_log_root_level(disk_super));
> -
> -		log_tree_root = btrfs_alloc_root(fs_info);
> -		if (!log_tree_root) {
> -			err = -ENOMEM;
> -			goto fail_qgroup;
> -		}
> -
> -		__setup_root(nodesize, leafsize, sectorsize, stripesize,
> -			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
> -
> -		log_tree_root->node = read_tree_block(tree_root, bytenr,
> -						      blocksize,
> -						      generation + 1);
> -		if (!log_tree_root->node ||
> -		    !extent_buffer_uptodate(log_tree_root->node)) {
> -			printk(KERN_ERR "BTRFS: failed to read log tree\n");
> -			free_extent_buffer(log_tree_root->node);
> -			kfree(log_tree_root);
> -			goto fail_qgroup;
> -		}
> -		/* returns with log_tree_root freed on success */
> -		ret = btrfs_recover_log_trees(log_tree_root);
> +		ret = btrfs_replay_log(fs_info);
>   		if (ret) {
> -			btrfs_error(tree_root->fs_info, ret,
> -				    "Failed to recover log tree");
> -			free_extent_buffer(log_tree_root->node);
> -			kfree(log_tree_root);
> +			err = ret;
>   			goto fail_qgroup;
>   		}
> -
> -		if (sb->s_flags & MS_RDONLY) {
> -			ret = btrfs_commit_super(tree_root);
> -			if (ret)
> -				goto fail_qgroup;
> -		}
>   	}
>   
>   	ret = btrfs_find_orphan_roots(tree_root);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

