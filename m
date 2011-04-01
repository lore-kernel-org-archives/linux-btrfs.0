From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix free space cache when there are pinned extents
 and clusters
Date: Fri, 01 Apr 2011 15:56:33 +0800
Message-ID: <4D958531.90500@cn.fujitsu.com>
References: <1301601548-14612-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301601548-14612-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

> +	spin_lock(&block_group->tree_lock);
> +	if (btrfs_block_group_free_space(block_group) !=

This function call can be replaced by block_group->free_space, so
we don't have to iterate the tree.

(This function gets removed in my patchset for inode number caching)

> +	    (block_group->key.offset - used - block_group->bytes_super)) {
> +		spin_unlock(&block_group->tree_lock);
> +		printk(KERN_ERR "block group %llu has an wrong amount of free "
> +		       "space\n", block_group->key.objectid);
> +		ret = 0;
> +		goto free_cache;
> +	}
> +	spin_unlock(&block_group->tree_lock);
