From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Fri, 08 Jul 2011 08:51:09 +0900
Message-ID: <4E16466D.5020508@jp.fujitsu.com>
References: <1308345034-sup-1969@shiny> <4DFD7C63.6040902@jp.fujitsu.com> <4DFE8933.7040101@jp.fujitsu.com> <20110621002435.GK12709@twin.jikos.cz> <1308616798-sup-2605@shiny> <4DFFF0B2.1070403@jp.fujitsu.com> <4E0C186C.8060101@cn.fujitsu.com> <4E0D8130.8040101@jp.fujitsu.com> <1310070350-sup-5716@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: miaox <miaox@cn.fujitsu.com>, David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310070350-sup-5716@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris,

(2011/07/08 5:26), Chris Mason wrote:
> Excerpts from Tsutomu Itoh's message of 2011-07-01 04:11:28 -0400:
>> Hi, Miao,
>>
>> (2011/06/30 15:32), Miao Xie wrote:
>>> Hi, Itoh-san
>>>
>>> Could you test the following patch to check whether it can fix the bug or not?
>>> I have tested it on my x86_64 machine by your test script for two days, it worked well.
>>
>> I ran my test script about a day, I was not able to reproduce this BUG.
> 
> Can you please try this patch with the inode_cache option (in addition
> to Miao's code).

In my clarification.

I do only have to apply this patch to 'btrfs-unstable + (current)for-linus'?
or, other patches also necessary?

Thanks,
Tsutomu

> 
> commit d0243d46f7a1e4cd57c74fa14556be65b454687d
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Thu Jul 7 15:53:12 2011 -0400
> 
>     Btrfs: write out free inode cache before taking snapshots
>     
>     The btrfs snapshotting code requires that once a root has been
>     snapshotted, we don't change it during a commit
>     
>     But the free inode cache was changing the roots when it root the cache,
>     which lead to corruptions.
>     
>     This fixes things by making sure we write the cache while we are taking
>     the snapshot, and that we don't write it again later.
>     
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index bf0d615..d594cf7 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1651,6 +1651,7 @@ int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
>  	info->bytes = bytes;
>  
>  	spin_lock(&ctl->tree_lock);
> +	ctl->dirty = 1;
>  
>  	if (try_merge_free_space(ctl, info, true))
>  		goto link;
> @@ -1691,6 +1692,7 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
>  	int ret = 0;
>  
>  	spin_lock(&ctl->tree_lock);
> +	ctl->dirty = 1;
>  
>  again:
>  	info = tree_search_offset(ctl, offset, 0, 0);
> @@ -2589,6 +2591,7 @@ u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root)
>  		if (entry->bytes == 0)
>  			free_bitmap(ctl, entry);
>  	}
> +	ctl->dirty = 1;
>  out:
>  	spin_unlock(&ctl->tree_lock);
>  
> @@ -2688,6 +2691,10 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>  		printk(KERN_ERR "btrfs: failed to write free ino cache "
>  		       "for root %llu\n", root->root_key.objectid);
>  
> +	/* we write out at transaction commit time, there's no racing. */
> +	if (ret == 0)
> +		ctl->dirty = 0;
> +
>  	iput(inode);
>  	return ret;
>  }
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index 8f2613f..1e92c93 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -35,6 +35,11 @@ struct btrfs_free_space_ctl {
>  	int free_extents;
>  	int total_bitmaps;
>  	int unit;
> +	/*
> +	 * record if we've changed since written.  This can turn
> +	 * into a bit field if we need more flags
> +	 */
> +	unsigned long dirty;
>  	u64 start;
>  	struct btrfs_free_space_op *op;
>  	void *private;
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index b4087e0..e7c1493 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -376,6 +376,7 @@ void btrfs_init_free_ino_ctl(struct btrfs_root *root)
>  	ctl->start = 0;
>  	ctl->private = NULL;
>  	ctl->op = &free_ino_op;
> +	ctl->dirty = 1;
>  
>  	/*
>  	 * Initially we allow to use 16K of ram to cache chunks of
> @@ -417,6 +418,9 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
>  	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>  		return 0;
>  
> +	if (!ctl->dirty)
> +		return 0;
> +
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> @@ -485,6 +489,24 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * this tries to save the cache, but if it fails for any reason we clear
> + * the dirty flag so that it won't be saved again during this commit.
> + *
> + * This is used by the snapshotting code to make sure we don't corrupt the
> + * FS by saving the inode cache after the snapshot is taken.
> + */
> +int btrfs_force_save_ino_cache(struct btrfs_root *root,
> +			       struct btrfs_trans_handle *trans)
> +{
> +	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
> +	int ret;
> +	ret = btrfs_save_ino_cache(root, trans);
> +
> +	ctl->dirty = 0;
> +	return ret;
> +}
> +
>  static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
>  {
>  	struct btrfs_path *path;
> diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
> index ddb347b..2be060e 100644
> --- a/fs/btrfs/inode-map.h
> +++ b/fs/btrfs/inode-map.h
> @@ -7,7 +7,8 @@ void btrfs_return_ino(struct btrfs_root *root, u64 objectid);
>  int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid);
>  int btrfs_save_ino_cache(struct btrfs_root *root,
>  			 struct btrfs_trans_handle *trans);
> -
> +int btrfs_force_save_ino_cache(struct btrfs_root *root,
> +			       struct btrfs_trans_handle *trans);
>  int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid);
>  
>  #endif
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 51dcec8..e34827c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -966,6 +966,15 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	ret = btrfs_run_delayed_items(trans, root);
>  	BUG_ON(ret);
>  
> +	/*
> +	 * there are a few transient reasons the free inode cache writeback can fail.
> +	 * and if it does, we'll try again later in the commit.  This forces the
> +	 * clean bit, tossing the cache.  Tossing the cache isn't really good, but
> +	 * if we try to write it again later in the commit we'll corrupt things.
> +	 */
> +	btrfs_force_save_ino_cache(parent_root, trans);
> +
> +
>  	record_root_in_trans(trans, root);
>  	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>  	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
> 
> 

