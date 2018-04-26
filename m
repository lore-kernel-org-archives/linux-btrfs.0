Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753228AbeDZG1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 02:27:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7725DAD53
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 06:27:13 +0000 (UTC)
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180426062425.8574-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <606c532d-c641-ac55-8d17-4b8c8beacfdb@suse.com>
Date: Thu, 26 Apr 2018 09:27:11 +0300
MIME-Version: 1.0
In-Reply-To: <20180426062425.8574-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.04.2018 09:24, Qu Wenruo wrote:
> fs_info can be extracted from btrfs_block_group_cache, and all
> btrfs_block_group_cache is created by btrfs_create_block_group_cache()
> with fs_info initialized, no need to worry about NULL pointer
> dereference.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I very  much hate function which take parameters solely for the purpose
of trace points!

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c       |  8 ++++----
>  include/trace/events/btrfs.h | 18 ++++++++----------
>  2 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 09d6e4544d6e..bf30be868f7a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7664,7 +7664,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  			if (offset) {
>  				/* we have a block, we're done */
>  				spin_unlock(&last_ptr->refill_lock);
> -				trace_btrfs_reserve_extent_cluster(fs_info,
> +				trace_btrfs_reserve_extent_cluster(
>  						used_block_group,
>  						search_start, num_bytes);
>  				if (used_block_group != block_group) {
> @@ -7737,7 +7737,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  				if (offset) {
>  					/* we found one, proceed */
>  					spin_unlock(&last_ptr->refill_lock);
> -					trace_btrfs_reserve_extent_cluster(fs_info,
> +					trace_btrfs_reserve_extent_cluster(
>  						block_group, search_start,
>  						num_bytes);
>  					goto checks;
> @@ -7837,8 +7837,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  		ins->objectid = search_start;
>  		ins->offset = num_bytes;
>  
> -		trace_btrfs_reserve_extent(fs_info, block_group,
> -					   search_start, num_bytes);
> +		trace_btrfs_reserve_extent(block_group, search_start,
> +					   num_bytes);
>  		btrfs_release_block_group(block_group, delalloc);
>  		break;
>  loop:
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index d78d8ab4bc86..5af2479e9b16 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -1146,11 +1146,10 @@ TRACE_EVENT(find_free_extent,
>  
>  DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  
> -	TP_PROTO(const struct btrfs_fs_info *fs_info,
> -		 const struct btrfs_block_group_cache *block_group, u64 start,
> +	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
>  		 u64 len),
>  
> -	TP_ARGS(fs_info, block_group, start, len),
> +	TP_ARGS(block_group, start, len),
>  
>  	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	bg_objectid		)
> @@ -1159,7 +1158,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  		__field(	u64,	len			)
>  	),
>  
> -	TP_fast_assign_btrfs(fs_info,
> +	TP_fast_assign_btrfs(block_group->fs_info,
>  		__entry->bg_objectid	= block_group->key.objectid;
>  		__entry->flags		= block_group->flags;
>  		__entry->start		= start;
> @@ -1177,20 +1176,18 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  
>  DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent,
>  
> -	TP_PROTO(const struct btrfs_fs_info *fs_info,
> -		 const struct btrfs_block_group_cache *block_group, u64 start,
> +	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
>  		 u64 len),
>  
> -	TP_ARGS(fs_info, block_group, start, len)
> +	TP_ARGS(block_group, start, len)
>  );
>  
>  DEFINE_EVENT(btrfs__reserve_extent, btrfs_reserve_extent_cluster,
>  
> -	TP_PROTO(const struct btrfs_fs_info *fs_info,
> -		 const struct btrfs_block_group_cache *block_group, u64 start,
> +	TP_PROTO(const struct btrfs_block_group_cache *block_group, u64 start,
>  		 u64 len),
>  
> -	TP_ARGS(fs_info, block_group, start, len)
> +	TP_ARGS(block_group, start, len)
>  );
>  
>  TRACE_EVENT(btrfs_find_cluster,
> @@ -1807,6 +1804,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
>  			show_root_type(__entry->root_objectid),
>  			__entry->ino, __entry->mod)
>  );
> +
>  #endif /* _TRACE_BTRFS_H */
>  
>  /* This part must be outside protection */
> 
