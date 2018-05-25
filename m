Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754393AbeEYJVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 05:21:44 -0400
Subject: Re: [RFC PATCH v4 5/6] Btrfs: rename get_chunk_map() and make it
 non-static
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <cover.1527197312.git.osandov@fb.com>
 <ad156ee9fa4c91c2760a60745f42773d0032824b.1527197312.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <37cbe6e1-9ad5-3fb2-e6dd-2d696d78d582@suse.com>
Date: Fri, 25 May 2018 12:21:41 +0300
MIME-Version: 1.0
In-Reply-To: <ad156ee9fa4c91c2760a60745f42773d0032824b.1527197312.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.05.2018 00:41, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
> make it non-static.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

nit: How about introducing proper kernel doc for this function, now that
it becomes public just as good practice so that eventually we will have
proper kernel doc for all public interfaces. You could also mention that
it needs a paired free_extent_map
> ---
>  fs/btrfs/volumes.c | 22 +++++++++++-----------
>  fs/btrfs/volumes.h |  2 ++
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 33b3d329ebb9..6e1a89c6b362 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2789,8 +2789,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>  	return ret;
>  }
>  
> -static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> -					u64 logical, u64 length)
> +struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
> +				       u64 logical, u64 length)
>  {
>  	struct extent_map_tree *em_tree;
>  	struct extent_map *em;
> @@ -2827,7 +2827,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>  	int i, ret = 0;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>  
> -	em = get_chunk_map(fs_info, chunk_offset, 1);
> +	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
>  	if (IS_ERR(em)) {
>  		/*
>  		 * This is a logic error, but we don't want to just rely on the
> @@ -4962,7 +4962,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>  	int i = 0;
>  	int ret = 0;
>  
> -	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
> +	em = btrfs_get_chunk_map(fs_info, chunk_offset, chunk_size);
>  	if (IS_ERR(em))
>  		return PTR_ERR(em);
>  
> @@ -5105,7 +5105,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>  	int miss_ndevs = 0;
>  	int i;
>  
> -	em = get_chunk_map(fs_info, chunk_offset, 1);
> +	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
>  	if (IS_ERR(em))
>  		return 1;
>  
> @@ -5165,7 +5165,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  	struct map_lookup *map;
>  	int ret;
>  
> -	em = get_chunk_map(fs_info, logical, len);
> +	em = btrfs_get_chunk_map(fs_info, logical, len);
>  	if (IS_ERR(em))
>  		/*
>  		 * We could return errors for these cases, but that could get
> @@ -5211,7 +5211,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>  	struct map_lookup *map;
>  	unsigned long len = fs_info->sectorsize;
>  
> -	em = get_chunk_map(fs_info, logical, len);
> +	em = btrfs_get_chunk_map(fs_info, logical, len);
>  
>  	if (!WARN_ON(IS_ERR(em))) {
>  		map = em->map_lookup;
> @@ -5228,7 +5228,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>  	struct map_lookup *map;
>  	int ret = 0;
>  
> -	em = get_chunk_map(fs_info, logical, len);
> +	em = btrfs_get_chunk_map(fs_info, logical, len);
>  
>  	if(!WARN_ON(IS_ERR(em))) {
>  		map = em->map_lookup;
> @@ -5387,7 +5387,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
>  	/* discard always return a bbio */
>  	ASSERT(bbio_ret);
>  
> -	em = get_chunk_map(fs_info, logical, length);
> +	em = btrfs_get_chunk_map(fs_info, logical, length);
>  	if (IS_ERR(em))
>  		return PTR_ERR(em);
>  
> @@ -5713,7 +5713,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>  		return __btrfs_map_block_for_discard(fs_info, logical,
>  						     *length, bbio_ret);
>  
> -	em = get_chunk_map(fs_info, logical, *length);
> +	em = btrfs_get_chunk_map(fs_info, logical, *length);
>  	if (IS_ERR(em))
>  		return PTR_ERR(em);
>  
> @@ -6012,7 +6012,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
>  	u64 rmap_len;
>  	int i, j, nr = 0;
>  
> -	em = get_chunk_map(fs_info, chunk_start, 1);
> +	em = btrfs_get_chunk_map(fs_info, chunk_start, 1);
>  	if (IS_ERR(em))
>  		return -EIO;
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 5139ec8daf4c..d3dedfd1324b 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -467,6 +467,8 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>  int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>  				struct btrfs_fs_info *fs_info,
>  				u64 chunk_offset, u64 chunk_size);
> +struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
> +				       u64 logical, u64 length);
>  int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>  		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
>  
> 
