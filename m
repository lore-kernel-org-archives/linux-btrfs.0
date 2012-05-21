Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46319 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2EUEBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 00:01:25 -0400
Message-ID: <4FB9BDBA.2030806@cn.fujitsu.com>
Date: Mon, 21 May 2012 11:59:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Martin Mailand <martin@tuxadero.com>,
        Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
References: <20120514142048.GA3260@localhost.localdomain> <20120516192035.GA1910@localhost.localdomain> <4FB4D30C.7030301@tuxadero.com> <20120517144306.GA3011@dhcp231-144.rdu.redhat.com> <4FB51577.5090100@tuxadero.com> <20120517194358.GA9846@dhcp231-144.rdu.redhat.com> <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com> <4FB56B21.7070800@tuxadero.com> <20120518144759.GA1892@localhost.localdomain> <4FB685C9.2050607@tuxadero.com> <20120518190105.GB1892@localhost.localdomain>
In-Reply-To: <20120518190105.GB1892@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On fri, 18 May 2012 15:01:05 -0400, Josef Bacik wrote:
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 9b9b15f..492c74f 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -57,9 +57,6 @@ struct btrfs_inode {
>  	/* used to order data wrt metadata */
>  	struct btrfs_ordered_inode_tree ordered_tree;
>  
> -	/* for keeping track of orphaned inodes */
> -	struct list_head i_orphan;
> -
>  	/* list of all the delalloc inodes in the FS.  There are times we need
>  	 * to write all the delalloc pages to disk, and this list is used
>  	 * to walk them all.
> @@ -156,6 +153,8 @@ struct btrfs_inode {
>  	unsigned dummy_inode:1;
>  	unsigned in_defrag:1;
>  	unsigned delalloc_meta_reserved:1;
> +	unsigned has_orphan_item:1;
> +	unsigned doing_truncate:1;

I think the problem is we should not use the different lock to protect the bit fields which
are stored in the same machine word. Or some bit fields may be covered by the others when
someone change those fields. Could you try to declare ->delalloc_meta_reserved and ->has_orphan_item
as a integer?

Thanks
Miao

>  
>  	/*
>  	 * always compress this one file
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8fd7233..aad2600 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1375,7 +1375,7 @@ struct btrfs_root {
>  	struct list_head root_list;
>  
>  	spinlock_t orphan_lock;
> -	struct list_head orphan_list;
> +	atomic_t orphan_inodes;
>  	struct btrfs_block_rsv *orphan_block_rsv;
>  	int orphan_item_inserted;
>  	int orphan_cleanup_state;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a7ffc88..ff3bf4b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1153,7 +1153,6 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
>  	root->orphan_block_rsv = NULL;
>  
>  	INIT_LIST_HEAD(&root->dirty_list);
> -	INIT_LIST_HEAD(&root->orphan_list);
>  	INIT_LIST_HEAD(&root->root_list);
>  	spin_lock_init(&root->orphan_lock);
>  	spin_lock_init(&root->inode_lock);
> @@ -1166,6 +1165,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
>  	atomic_set(&root->log_commit[0], 0);
>  	atomic_set(&root->log_commit[1], 0);
>  	atomic_set(&root->log_writers, 0);
> +	atomic_set(&root->orphan_inodes, 0);
>  	root->log_batch = 0;
>  	root->log_transid = 0;
>  	root->last_log_commit = 0;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 61b16c6..572da13 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2072,12 +2072,12 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
>  	struct btrfs_block_rsv *block_rsv;
>  	int ret;
>  
> -	if (!list_empty(&root->orphan_list) ||
> +	if (atomic_read(&root->orphan_inodes) ||
>  	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
>  		return;
>  
>  	spin_lock(&root->orphan_lock);
> -	if (!list_empty(&root->orphan_list)) {
> +	if (atomic_read(&root->orphan_inodes)) {
>  		spin_unlock(&root->orphan_lock);
>  		return;
>  	}
> @@ -2134,8 +2134,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
>  		block_rsv = NULL;
>  	}
>  
> -	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
> -		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
> +	if (!BTRFS_I(inode)->has_orphan_item) {
> +		BTRFS_I(inode)->has_orphan_item = 1;
>  #if 0
>  		/*
>  		 * For proper ENOSPC handling, we should do orphan
> @@ -2148,6 +2148,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
>  			insert = 1;
>  #endif
>  		insert = 1;
> +		atomic_inc(&root->orphan_inodes);
>  	}
>  
>  	if (!BTRFS_I(inode)->orphan_meta_reserved) {
> @@ -2166,6 +2167,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
>  	if (insert >= 1) {
>  		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
>  		if (ret && ret != -EEXIST) {
> +			spin_lock(&root->orphan_lock);
> +			BTRFS_I(inode)->has_orphan_item = 0;
> +			spin_unlock(&root->orphan_lock);
>  			btrfs_abort_transaction(trans, root, ret);
>  			return ret;
>  		}
> @@ -2195,13 +2199,21 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
>  	int release_rsv = 0;
>  	int ret = 0;
>  
> +	/*
> +	 * evict_inode gets called without holding the i_mutex so we need to
> +	 * take the orphan lock to make sure we are safe in messing with these.
> +	 */
>  	spin_lock(&root->orphan_lock);
> -	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
> -		list_del_init(&BTRFS_I(inode)->i_orphan);
> -		delete_item = 1;
> +	if (BTRFS_I(inode)->has_orphan_item) {
> +		if (trans) {
> +			BTRFS_I(inode)->has_orphan_item = 0;
> +			delete_item = 1;
> +		} else {
> +			WARN_ON(1);
> +		}
>  	}
>  
> -	if (BTRFS_I(inode)->orphan_meta_reserved) {
> +	if (trans && BTRFS_I(inode)->orphan_meta_reserved) {
>  		BTRFS_I(inode)->orphan_meta_reserved = 0;
>  		release_rsv = 1;
>  	}
> @@ -2209,12 +2221,19 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
>  
>  	if (trans && delete_item) {
>  		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
> +		if (ret)
> +			printk(KERN_ERR "couldn't find orphan item for %Lu, nlink %d, root %Lu, root being deleted %s\n",
> +			       btrfs_ino(inode), inode->i_nlink, root->objectid,
> +			       root->orphan_item_inserted ? "yes" : "no");
>  		BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
>  	}
>  
>  	if (release_rsv)
>  		btrfs_orphan_release_metadata(inode);
>  
> +	if (trans && delete_item)
> +		atomic_dec(&root->orphan_inodes);
> +
>  	return 0;
>  }
>  
> @@ -2341,6 +2360,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  				ret = PTR_ERR(trans);
>  				goto out;
>  			}
> +			printk(KERN_ERR "auto deleting %Lu\n",
> +			       found_key.objectid);
>  			ret = btrfs_del_orphan_item(trans, root,
>  						    found_key.objectid);
>  			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
> @@ -2353,7 +2374,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  		 * the proper thing when we hit it
>  		 */
>  		spin_lock(&root->orphan_lock);
> -		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
> +		atomic_inc(&root->orphan_inodes);
> +		WARN_ON(BTRFS_I(inode)->has_orphan_item);
> +		BTRFS_I(inode)->has_orphan_item = 1;
>  		spin_unlock(&root->orphan_lock);
>  
>  		/* if we have links, this was a truncate, lets do that */
> @@ -3671,7 +3694,7 @@ void btrfs_evict_inode(struct inode *inode)
>  	btrfs_wait_ordered_range(inode, 0, (u64)-1);
>  
>  	if (root->fs_info->log_root_recovering) {
> -		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
> +		BUG_ON(!BTRFS_I(inode)->has_orphan_item);
>  		goto no_delete;
>  	}
>  
> @@ -6683,9 +6706,13 @@ static int btrfs_truncate(struct inode *inode)
>  	u64 mask = root->sectorsize - 1;
>  	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
>  
> +	spin_lock(&BTRFS_I(inode)->lock);
> +	BUG_ON(BTRFS_I(inode)->doing_truncate);
> +	BTRFS_I(inode)->doing_truncate = 0;
> +	spin_unlock(&BTRFS_I(inode)->lock);
>  	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
>  	if (ret)
> -		return ret;
> +		goto real_out;
>  
>  	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
>  	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
> @@ -6727,8 +6754,10 @@ static int btrfs_truncate(struct inode *inode)
>  	 * updating the inode.
>  	 */
>  	rsv = btrfs_alloc_block_rsv(root);
> -	if (!rsv)
> -		return -ENOMEM;
> +	if (!rsv) {
> +		ret = -ENOMEM;
> +		goto real_out;
> +	}
>  	rsv->size = min_size;
>  
>  	/*
> @@ -6847,7 +6876,10 @@ end_trans:
>  
>  out:
>  	btrfs_free_block_rsv(root, rsv);
> -
> +real_out:
> +	spin_lock(&BTRFS_I(inode)->lock);
> +	BTRFS_I(inode)->doing_truncate = 0;
> +	spin_unlock(&BTRFS_I(inode)->lock);
>  	if (ret && !err)
>  		err = ret;
>  
> @@ -6914,6 +6946,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>  	ei->dummy_inode = 0;
>  	ei->in_defrag = 0;
>  	ei->delalloc_meta_reserved = 0;
> +	ei->has_orphan_item = 0;
> +	ei->doing_truncate = 0;
>  	ei->force_compress = BTRFS_COMPRESS_NONE;
>  
>  	ei->delayed_node = NULL;
> @@ -6927,7 +6961,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>  	mutex_init(&ei->log_mutex);
>  	mutex_init(&ei->delalloc_mutex);
>  	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
> -	INIT_LIST_HEAD(&ei->i_orphan);
>  	INIT_LIST_HEAD(&ei->delalloc_inodes);
>  	INIT_LIST_HEAD(&ei->ordered_operations);
>  	RB_CLEAR_NODE(&ei->rb_node);
> @@ -6972,13 +7005,11 @@ void btrfs_destroy_inode(struct inode *inode)
>  		spin_unlock(&root->fs_info->ordered_extent_lock);
>  	}
>  
> -	spin_lock(&root->orphan_lock);
> -	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
> +	if (BTRFS_I(inode)->has_orphan_item) {
>  		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
>  		       (unsigned long long)btrfs_ino(inode));
> -		list_del_init(&BTRFS_I(inode)->i_orphan);
> +		atomic_dec(&root->orphan_inodes);
>  	}
> -	spin_unlock(&root->orphan_lock);
>  
>  	while (1) {
>  		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

