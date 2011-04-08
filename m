From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v4 1/8] btrfs: Balance progress monitoring
Date: Fri, 8 Apr 2011 15:37:15 +0200
Message-ID: <20110408133715.GM31675@twin.jikos.cz>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
 <1302195975-3088-2-git-send-email-hugo@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302195975-3088-2-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

sorry for separate mail, just noticed a kfree inside a spinlock below

On Thu, Apr 07, 2011 at 06:06:08PM +0100, Hugo Mills wrote:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> @@ -2115,10 +2162,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
        ^^^^^
move it out of the spinlocked section

> +	dev_root->fs_info->balance_info = NULL;
> +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> +error_no_status:
>  	mutex_unlock(&dev_root->fs_info->volume_mutex);
>  	return ret;
>  }
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
