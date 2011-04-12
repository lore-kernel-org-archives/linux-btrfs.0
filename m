From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v5 1/8] btrfs: Balance progress monitoring
Date: Tue, 12 Apr 2011 19:12:32 +0200
Message-ID: <20110412171232.GJ31675@twin.jikos.cz>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
 <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com,
	linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed that Arne's scrub patches add scrub variables directly
into the fs_info structure, while you have a separate struct.

I was wondering whether it would be better to put items of
btrfs_balance_info to fs_info too, balance state is a global info.

Although fs_info is a huge structure now, 9402 bytes on 86_64, there is
no space saving in this case.

On Sun, Apr 10, 2011 at 10:06:04PM +0100, Hugo Mills wrote:
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7f78cc7..17c7ecc 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -865,6 +865,11 @@ struct btrfs_block_group_cache {
>  	struct list_head cluster_list;
>  };
>  
> +struct btrfs_balance_info {
> +	u32 expected;
> +	u32 completed;

two u32 make one u64

> +};
> +
>  struct reloc_control;
>  struct btrfs_device;
>  struct btrfs_fs_devices;
> @@ -1078,6 +1083,10 @@ struct btrfs_fs_info {
>  
>  	/* filesystem state */
>  	u64 fs_state;
> +
> +	/* Keep track of any rebalance operations on this FS */
> +	spinlock_t balance_info_lock;
> +	struct btrfs_balance_info *balance_info;

a pointer is a u64 too

>  };
>  
>  /*
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dd13eb8..bb2ffed 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2051,6 +2052,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
>  	mutex_lock(&dev_root->fs_info->volume_mutex);
>  	dev_root = dev_root->fs_info->dev_root;
>  
> +	bal_info = kmalloc(
> +		sizeof(struct btrfs_balance_info),
> +		GFP_NOFS);

... drop

> +	if (!bal_info) {
> +		ret = -ENOMEM;
> +		goto error_no_status;
> +	}
> +	spin_lock(&dev_root->fs_info->balance_info_lock);
> +	dev_root->fs_info->balance_info = bal_info;
> +	bal_info->expected = -1; /* One less than actually counted,
> +				    because chunk 0 is special */
> +	bal_info->completed = 0;
> +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> +
>  	/* step one make some room on all the devices */
>  	list_for_each_entry(device, devices, dev_list) {
>  		old_size = device->total_bytes;
> @@ -2115,10 +2157,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
>  					   found_key.offset);
>  		BUG_ON(ret && ret != -ENOSPC);
>  		key.offset = found_key.offset - 1;
> +		spin_lock(&dev_root->fs_info->balance_info_lock);
> +		bal_info->completed++;
> +		spin_unlock(&dev_root->fs_info->balance_info_lock);
> +		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> +		       bal_info->completed, bal_info->expected);
>  	}
>  	ret = 0;
>  error:
>  	btrfs_free_path(path);
> +	spin_lock(&dev_root->fs_info->balance_info_lock);
> +	kfree(dev_root->fs_info->balance_info);

... drop

> +	dev_root->fs_info->balance_info = NULL;
> +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> +error_no_status:
>  	mutex_unlock(&dev_root->fs_info->volume_mutex);
>  	return ret;
>  }
> -- 
