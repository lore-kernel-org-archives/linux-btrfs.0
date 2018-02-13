Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37281 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933426AbeBMHUg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 02:20:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52F19ADF5
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 07:20:35 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180213011332.13287-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9fe4ab5f-d066-55e2-23f8-4037e63a5343@suse.com>
Date: Tue, 13 Feb 2018 09:20:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180213011332.13287-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 03:13, Qu Wenruo wrote:
> There are reports in mail list, even with latest mainline kernel, btrfs
> can't survive a power loss.
> 
> Unlike journal based filesystem, btrfs doesn't use journal for such
> work. (log tree is an optimization for fsync, not to keep fs healthy)
> In btrfs we use metadata CoW to ensure all tree blocks are as atomic as
> superblock.
> 
> This leads to an obvious assumption, some code breaks such metadata CoW
> makes btrfs no longer bullet-proof against power loss.
> 
> This patch adds extra runtime selftest to find_free_extent(), which
> will check the range in commit root of extent tree to ensure there is no
> overlap at all.
> 
> And hopes this could help us to catch the cause of the problem.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Unfortunately, no new problem exposed yet.
> ---
>  fs/btrfs/extent-tree.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2f4328511ac8..3b3cd82bce3a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7458,6 +7458,114 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
>  	btrfs_put_block_group(cache);
>  }
>  
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +/*
> + * Verify if the given extent range [@start, @start + @len) conflicts any
> + * existing extent in commit root.
> + *
> + * Btrfs doesn't use journal, but depends on metadata (and data) CoW to keep
> + * the whole filesystem consistent against powerloss.
> + * If we have overwritten any extent used by previous trans (commit root),
> + * and powerloss happen we will corrupt our filesystem.

Currently do we know if the corruption is caused due to extent overlap
or some other subtle bug? I.e is there a guarnteee that this self-check
should trigger?

> + *
> + * Return 0 if nothing wrong.
> + * Return <0 (including ENOMEM) means we have something wrong.
> + * Except NOEMEM, this normally means we have extent conflicts with previous
> + * transaction.
> + */
> +static int check_extent_conflicts(struct btrfs_fs_info *fs_info,
> +				  u64 start, u64 len)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	struct btrfs_root *extent_root = fs_info->extent_root;
> +	u64 extent_start;
> +	u64 extent_len;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +
> +	key.objectid = start + len;
> +	key.type = 0;
> +	key.offset = 0;
> +
> +	/*
> +	 * Here we use extent commit root to search for any conflicts.
> +	 * If extent commit tree is already overwritten, we will get transid
> +	 * error and error out any way.
> +	 * If extent commit tree is OK, but other extent conflicts, we will
> +	 * find it.
> +	 * So anyway, such search should be OK to find the conflicts.
> +	 */
> +	path->search_commit_root = true;
> +	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
> +
> +	if (ret < 0)
> +		goto out;
> +	/* Impossible as no type/offset should be (u64)-1 */
> +	if (ret == 0) {
> +		ret = -EUCLEAN;
> +		goto out;
> +	}
> +	ret = btrfs_previous_extent_item(extent_root, path, start);
> +	if (ret < 0)
> +		goto out;
> +	if (ret == 0) {
> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		extent_start = key.objectid;
> +		if (key.type == BTRFS_EXTENT_ITEM_KEY)
> +			extent_len = key.offset;
> +		else
> +			extent_len = fs_info->nodesize;
> +		goto report;
> +	}
> +	/*
> +	 * Even we didn't found extent starts after @start, we still need to
> +	 * ensure previous extent doesn't overlap with [@start, @start + @len)
> +	 */
> +	while (1) {
> +		extent_len = 0;
> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		if (key.type == BTRFS_EXTENT_ITEM_KEY)
> +			extent_len = key.offset;
> +		else if (key.type == BTRFS_METADATA_ITEM_KEY)
> +			extent_len = fs_info->nodesize;
> +
> +		if (extent_len) {
> +			if (extent_len + key.objectid <= start) {
> +				ret = 0;
> +				goto out;
> +			}
> +			extent_start = key.objectid;
> +			goto report;
> +		}
> +		if (path->slots[0] == 0) {
> +			ret = btrfs_prev_leaf(extent_root, path);
> +			if (ret > 0) {
> +				ret = 0;
> +				goto out;
> +			}
> +			if (ret < 0)
> +				goto out;
> +		} else {
> +			path->slots[0]--;
> +		}
> +	}
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +report:
> +	WARN(1,
> +"broken CoW detected: old extent [%llu, %llu) new extent [%llu, %llu)\n",
> +	     extent_start, extent_start + extent_len, start, start + len);
> +	btrfs_free_path(path);
> +	return -EEXIST;
> +}
> +#endif
> +
>  /*
>   * walks the btree of allocated extents and find a hole of a given size.
>   * The key ins is changed to record the hole:
> @@ -7949,6 +8057,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  		spin_unlock(&space_info->lock);
>  		ins->offset = max_extent_size;
>  	}
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +	if (!ret) {
> +		/*
> +		 * Any extent allocated must not conflict with any extent in
> +		 * commit root
> +		 */
> +		ret = check_extent_conflicts(fs_info, ins->objectid,
> +					     ins->offset);
> +	}
> +#endif
>  	return ret;
>  }
>  
> 
