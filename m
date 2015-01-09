Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:27667 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbAIBCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 20:02:13 -0500
Message-ID: <54AF2885.40708@huawei.com>
Date: Fri, 9 Jan 2015 09:01:57 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Shaohua Li <shli@fb.com>, <linux-btrfs@vger.kernel.org>
CC: <Kernel-team@fb.com>
Subject: Re: [PATCH] btrfs: delete chunk allocation attemp when setting block
 group ro
References: <ad987515563f59adfc028f23693d4a151a333846.1420752193.git.shli@fb.com>
In-Reply-To: <ad987515563f59adfc028f23693d4a151a333846.1420752193.git.shli@fb.com>
Content-Type: text/plain; charset="gbk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 08 Jan 2015 13:23:13 -0800, Shaohua Li wrote:
> Below test will fail currently:
>   mkfs.ext4 -F /dev/sda
>   btrfs-convert /dev/sda
>   mount /dev/sda /mnt
>   btrfs device add -f /dev/sdb /mnt
>   btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt
> 
> The reason is there are some block groups with usage 0, but the whole
> disk hasn't free space to allocate new chunk, so we even can't set such
> block group readonly. This patch deletes the chunk allocation when
> setting block group ro. For META, we already have reserve. But for
> SYSTEM, we don't have, so the check_system_chunk is still required.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 31 +++++++------------------------
>  1 file changed, 7 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a80b971..430101b6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8493,22 +8493,8 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
>  {
>  	struct btrfs_space_info *sinfo = cache->space_info;
>  	u64 num_bytes;
> -	u64 min_allocable_bytes;
>  	int ret = -ENOSPC;
>  
> -
> -	/*
> -	 * We need some metadata space and system metadata space for
> -	 * allocating chunks in some corner cases until we force to set
> -	 * it to be readonly.
> -	 */
> -	if ((sinfo->flags &
> -	     (BTRFS_BLOCK_GROUP_SYSTEM | BTRFS_BLOCK_GROUP_METADATA)) &&
> -	    !force)
> -		min_allocable_bytes = 1 * 1024 * 1024;
> -	else
> -		min_allocable_bytes = 0;
> -
>  	spin_lock(&sinfo->lock);
>  	spin_lock(&cache->lock);
>  
> @@ -8521,8 +8507,8 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
>  		    cache->bytes_super - btrfs_block_group_used(&cache->item);
>  
>  	if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned +
> -	    sinfo->bytes_may_use + sinfo->bytes_readonly + num_bytes +
> -	    min_allocable_bytes <= sinfo->total_bytes) {
> +	    sinfo->bytes_may_use + sinfo->bytes_readonly + num_bytes
> +	    <= sinfo->total_bytes) {
>  		sinfo->bytes_readonly += num_bytes;
>  		cache->ro = 1;
>  		list_add_tail(&cache->ro_list, &sinfo->ro_bgs);
> @@ -8548,14 +8534,6 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> -	alloc_flags = update_block_group_flags(root, cache->flags);
> -	if (alloc_flags != cache->flags) {
> -		ret = do_chunk_alloc(trans, root, alloc_flags,
> -				     CHUNK_ALLOC_FORCE);
> -		if (ret < 0)
> -			goto out;
> -	}
> -
>  	ret = set_block_group_ro(cache, 0);
>  	if (!ret)
>  		goto out;
> @@ -8566,6 +8544,11 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
>  		goto out;
>  	ret = set_block_group_ro(cache, 0);
>  out:
> +	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> +		alloc_flags = update_block_group_flags(root, cache->flags);
> +		check_system_chunk(trans, root, alloc_flags);

Please consider the case that the following patch fixed
  199c36eaa95077a47ae1bc55532fc0fbeb80cc95

If there is no free device space, check_system_chunk can not allocate
new system metadata chunk, so when we run final step of the chunk
allocation to update the device item and insert the new chunk item, we
would fail.

Thanks
Miao

> +	}
> +
>  	btrfs_end_transaction(trans, root);
>  	return ret;
>  }
> 

