Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751490AbeDJHps (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 03:45:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E37DAEB9
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 07:45:40 +0000 (UTC)
Subject: Re: [PATCH 7/7] btrfs: use fs_info for btrfs_handle_em_exist
 tracepoint
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1523275048.git.dsterba@suse.com>
 <03827d85f2986d6c4dd1d72b477c74464559ebd3.1523275048.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5080f406-2d72-59c1-3c63-b441186d1c89@suse.com>
Date: Tue, 10 Apr 2018 10:45:39 +0300
MIME-Version: 1.0
In-Reply-To: <03827d85f2986d6c4dd1d72b477c74464559ebd3.1523275048.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.04.2018 14:58, David Sterba wrote:
> We really want to know to which filesystem the extent map events belong,
> but as it cannot be reached from the extent_map pointers, we need to
> pass it down the callchain.

I really dislike propagating arguments solely for tracepoints purposes,
but if we don't have any other choice then I guess we should go with it.
However...

> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_map.c             |  6 ++++--
>  fs/btrfs/extent_map.h             |  3 ++-
>  fs/btrfs/inode.c                  |  2 +-
>  fs/btrfs/tests/extent-map-tests.c |  8 ++++----
>  include/trace/events/btrfs.h      | 12 +++++++-----
>  5 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 53a0633c6ef7..581b42d23e0d 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -517,6 +517,7 @@ static noinline int merge_extent_mapping(struct extent_map_tree *em_tree,
>  
>  /**
>   * btrfs_add_extent_mapping - add extent mapping into em_tree
> + * @fs_info - used for tracepoint
>   * @em_tree - the extent tree into which we want to insert the extent mapping
>   * @em_in   - extent we are inserting
>   * @start   - start of the logical range btrfs_get_extent() is requesting
> @@ -534,7 +535,8 @@ static noinline int merge_extent_mapping(struct extent_map_tree *em_tree,
>   * Return 0 on success, otherwise -EEXIST.
>   *
>   */
> -int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
> +int btrfs_add_extent_mapping(struct btrfs_fs_info *fs_info,
> +			     struct extent_map_tree *em_tree,
>  			     struct extent_map **em_in, u64 start, u64 len)
>  {
>  	int ret;
> @@ -552,7 +554,7 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
>  
>  		existing = search_extent_mapping(em_tree, start, len);
>  
> -		trace_btrfs_handle_em_exist(existing, em, start, len);
> +		trace_btrfs_handle_em_exist(fs_info, existing, em, start, len);
>  
>  		/*
>  		 * existing will always be non-NULL, since there must be
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index f6f8ba114977..f55c8b4ef120 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -91,6 +91,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen
>  void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
>  struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
>  					 u64 start, u64 len);
> -int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
> +int btrfs_add_extent_mapping(struct btrfs_fs_info *fs_info,
> +			     struct extent_map_tree *em_tree,
>  			     struct extent_map **em_in, u64 start, u64 len);
>  #endif
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1f091c2358a4..18c31006865f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7092,7 +7092,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  
>  	err = 0;
>  	write_lock(&em_tree->lock);
> -	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
> +	err = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);

This function is called only here, and we know that em_tree passed
points to a struct, stored in btrfs_inode. So can't we use container_of
to get the btrfs_inode in this function, from where we can reference the
fs_info? I guess it could be a problem for tests.


Admittedly  this feels somewhat hacky and I guess is not very
future-proof, but it's still a viable alternative.

