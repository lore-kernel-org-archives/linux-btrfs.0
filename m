From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [patch 1/2] Balance progress monitoring (updated)
Date: Mon, 01 Nov 2010 16:06:53 +0800
Message-ID: <4CCE751D.6030204@cn.fujitsu.com>
References: <20101030000726.286517546@carfax.org.uk> <20101030000741.689283553@carfax.org.uk> <20101030133934.GD9369@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030133934.GD9369@selene>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2010 09:39 PM, Hugo Mills wrote:
> This patch introduces a basic form of progress monitoring for balance
> operations, by counting the number of block groups remaining. The
> information is exposed to userspace by an ioctl.
> 

IMO, tracking the information of blocks which are balancing also makes sense. 
For example, the block information's blocknr. 
It can help us monitor better.

> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> 
> ---
> This patch replaces the one previously posted, correcting a minor error.
> 
>  fs/btrfs/ctree.h   |    9 ++++++++
>  fs/btrfs/disk-io.c |    2 +
>  fs/btrfs/ioctl.c   |   34 ++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h   |    7 ++++++
>  fs/btrfs/volumes.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 105 insertions(+), 2 deletions(-)
> 
> Index: linux-mainline/fs/btrfs/ctree.h
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/ctree.h	2010-10-26 18:03:38.000000000 +0100
> +++ linux-mainline/fs/btrfs/ctree.h	2010-10-30 14:35:25.306450922 +0100
> @@ -803,6 +803,11 @@
>  	struct list_head cluster_list;
>  };
>  
> +struct btrfs_balance_info {
> +	u64 expected;
> +	u64 completed;
> +};
> +
>  struct reloc_control;
>  struct btrfs_device;
>  struct btrfs_fs_devices;
> @@ -1010,6 +1015,10 @@
>  	unsigned metadata_ratio;
>  
>  	void *bdev_holder;
> +
> +	/* Keep track of any rebalance operations on this FS */
> +	spinlock_t balance_info_lock;
> +	struct btrfs_balance_info *balance_info;
>  };
>  
>  /*
> Index: linux-mainline/fs/btrfs/ioctl.c
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/ioctl.c	2010-10-26 18:03:38.000000000 +0100
> +++ linux-mainline/fs/btrfs/ioctl.c	2010-10-30 14:35:25.396447198 +0100
> @@ -1984,6 +1984,38 @@
>  	return 0;
>  }
>  
> +/*
> + * Return the current status of any balance operation
> + */
> +long btrfs_ioctl_balance_progress(
> +	struct btrfs_fs_info *fs_info,
> +	struct btrfs_ioctl_balance_progress __user *user_dest)
> +{
> +	int ret = 0;
> +	struct btrfs_ioctl_balance_progress dest;
> +
> +	spin_lock(&fs_info->balance_info_lock);
> +	if (!fs_info->balance_info) {
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	dest.expected = fs_info->balance_info->expected;
> +	dest.completed = fs_info->balance_info->completed;
> +
> +	spin_unlock(&fs_info->balance_info_lock);
> +
> +	if (copy_to_user(user_dest, &dest,
> +			 sizeof(struct btrfs_ioctl_balance_progress)))
> +		return -EFAULT;
> +
> +	return 0;
> +
> +error:
> +	spin_unlock(&fs_info->balance_info_lock);
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -2017,6 +2049,8 @@
>  		return btrfs_ioctl_rm_dev(root, argp);
>  	case BTRFS_IOC_BALANCE:
>  		return btrfs_balance(root->fs_info->dev_root);
> +	case BTRFS_IOC_BALANCE_PROGRESS:
> +		return btrfs_ioctl_balance_progress(root->fs_info, argp);
>  	case BTRFS_IOC_CLONE:
>  		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
>  	case BTRFS_IOC_CLONE_RANGE:
> Index: linux-mainline/fs/btrfs/ioctl.h
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/ioctl.h	2010-10-26 18:03:38.000000000 +0100
> +++ linux-mainline/fs/btrfs/ioctl.h	2010-10-30 14:35:25.316450509 +0100
> @@ -138,6 +138,11 @@
>  	struct btrfs_ioctl_space_info spaces[0];
>  };
>  
> +struct btrfs_ioctl_balance_progress {
> +	__u64 expected;
> +	__u64 completed;
> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -178,4 +183,6 @@
>  #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
>  #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>  				    struct btrfs_ioctl_space_args)
> +#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 21, \
> +					struct btrfs_ioctl_balance_progress)
>  #endif
> Index: linux-mainline/fs/btrfs/volumes.c
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/volumes.c	2010-10-26 18:03:38.000000000 +0100
> +++ linux-mainline/fs/btrfs/volumes.c	2010-10-30 14:35:25.326450096 +0100
> @@ -1902,6 +1902,7 @@
>  	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_key found_key;
> +	struct btrfs_balance_info *bal_info;
>  
>  	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
>  		return -EROFS;
> @@ -1909,6 +1910,18 @@
>  	mutex_lock(&dev_root->fs_info->volume_mutex);
>  	dev_root = dev_root->fs_info->dev_root;
>  
> +	dev_root->fs_info->balance_info = kmalloc(
> +		sizeof(struct btrfs_balance_info),
> +		GFP_NOFS);
> +	if (!dev_root->fs_info->balance_info) {
> +		ret = -ENOSPC;

-ENOMEM is better, for it comes from a kmalloc().

> +		goto error_no_status;
> +	}
> +	bal_info = dev_root->fs_info->balance_info;
> +	bal_info->expected = -1; /* One less than actually counted,
> +				    because chunk 0 is special */
> +	bal_info->completed = 0;
> +
>  	/* step one make some room on all the devices */
>  	list_for_each_entry(device, devices, dev_list) {
>  		old_size = device->total_bytes;
> @@ -1932,10 +1945,40 @@
>  		btrfs_end_transaction(trans, dev_root);
>  	}
>  
> -	/* step two, relocate all the chunks */
> +	/* step two, count the chunks */
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path) {
> +		ret = -ENOSPC;

ditto

> +		goto error;
> +	}
> +
> +	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> +	key.offset = (u64)-1;
> +	key.type = BTRFS_CHUNK_ITEM_KEY;
> +
> +	ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
> +	if (ret <= 0) {
> +		printk(KERN_ERR "btrfs: Failed to find the last chunk.\n");
> +		BUG();
> +	}
> +
> +	while (1) {
> +		ret = btrfs_previous_item(chunk_root, path, 0,
> +					  BTRFS_CHUNK_ITEM_KEY);
> +		if (ret)
> +			break;
> +
> +		bal_info->expected++;
> +	}
> +
> +	btrfs_free_path(path);
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOSPC;

ditto

> +		goto error;
> +	}
>  
> +	/* step three, relocate all the chunks */
>  	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
>  	key.offset = (u64)-1;
>  	key.type = BTRFS_CHUNK_ITEM_KEY;
> @@ -1976,10 +2019,18 @@
>  					   found_key.offset);
>  		BUG_ON(ret && ret != -ENOSPC);
>  		key.offset = found_key.offset - 1;
> +		bal_info->completed++;
> +		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> +		       bal_info->completed, bal_info->expected);

Would you please printk found_key.offset which balance code is processing?
That would be helpful.


thanks,
liubo

>  	}
>  	ret = 0;
>  error:
>  	btrfs_free_path(path);
> +	spin_lock(&dev_root->fs_info->balance_info_lock);
> +	kfree(dev_root->fs_info->balance_info);
> +	dev_root->fs_info->balance_info = NULL;
> +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> +error_no_status:
>  	mutex_unlock(&dev_root->fs_info->volume_mutex);
>  	return ret;
>  }
> Index: linux-mainline/fs/btrfs/disk-io.c
> ===================================================================
> --- linux-mainline.orig/fs/btrfs/disk-io.c	2010-10-29 17:19:12.000000000 +0100
> +++ linux-mainline/fs/btrfs/disk-io.c	2010-10-29 17:20:02.022161666 +0100
> @@ -1591,6 +1591,7 @@
>  	spin_lock_init(&fs_info->ref_cache_lock);
>  	spin_lock_init(&fs_info->fs_roots_radix_lock);
>  	spin_lock_init(&fs_info->delayed_iput_lock);
> +	spin_lock_init(&fs_info->balance_info_lock);
>  
>  	init_completion(&fs_info->kobj_unregister);
>  	fs_info->tree_root = tree_root;
> @@ -1616,6 +1617,7 @@
>  	fs_info->sb = sb;
>  	fs_info->max_inline = 8192 * 1024;
>  	fs_info->metadata_ratio = 0;
> +	fs_info->balance_info = NULL;
>  
>  	fs_info->thread_pool_size = min_t(unsigned long,
>  					  num_online_cpus() + 2, 8);
> 

