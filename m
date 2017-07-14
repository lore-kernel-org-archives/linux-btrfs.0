Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753124AbdGNMZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 08:25:34 -0400
Date: Fri, 14 Jul 2017 14:24:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170714122414.GF2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170714120046.3451-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170714120046.3451-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 03:00:46PM +0300, Timofey Titovets wrote:
> For now that code just return true
> Later more complex heuristic code will be added
> 
> Changes v1 -> v2:
>  - Heuristic call moved into inode_need_compress() function
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 22 ++++++++++++++++++++++
>  fs/btrfs/compression.h |  2 ++
>  fs/btrfs/inode.c       | 18 ++++++++++++------
>  3 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 2c0b7b57fcd5..d0cf2024def7 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1046,3 +1046,25 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
>  
>  	return 1;
>  }
> +
> +/*
> + * Heuristic skeleton
> + * For now just would be a naive and very optimistic 'return true'.
> + */
> +int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
> +{
> +	u64 index = start >> PAGE_SHIFT;
> +	u64 end_index = end >> PAGE_SHIFT;
> +	struct page *page;
> +	int ret = 1;
> +
> +	while (index <= end_index) {
> +		page = find_get_page(inode->i_mapping, index);
> +		kmap(page);
> +		kunmap(page);
> +		put_page(page);
> +		index++;
> +	}
> +
> +	return ret;
> +}
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 87f6d3332163..8508ba6b9aef 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -129,4 +129,6 @@ struct btrfs_compress_op {
>  extern const struct btrfs_compress_op btrfs_zlib_compress;
>  extern const struct btrfs_compress_op btrfs_lzo_compress;
>  
> +int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
> +
>  #endif
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 06dea7c89bbd..27922b29fa4e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -392,20 +392,26 @@ static noinline int add_async_extent(struct async_cow *cow,
>  	return 0;
>  }
>  
> -static inline int inode_need_compress(struct inode *inode)
> +static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>  {
> +	int ret = 0;
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  
>  	/* force compress */
>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
> -		return 1;
> +		goto try_compress;
>  	/* bad compression ratios */
>  	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
> -		return 0;
> +		goto skip_compress;
>  	if (btrfs_test_opt(fs_info, COMPRESS) ||
>  	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
>  	    BTRFS_I(inode)->force_compress)
> -		return 1;
> +		goto try_compress;
> +	goto skip_compress;
> +try_compress:
> +	ret = btrfs_compress_heuristic(inode, start, end);
> +	return ret;
> +skip_compress:
>  	return 0;

That's a bit wilde goto skip_compress can be simple return 0. Also you
can drop ret and return btrfs_compress_heuristic(...);

Otherwise it looks ok, just the documentation side could be improved,
like describe the purpose and expected furure enhancements.

>  }
>  
> @@ -503,7 +509,7 @@ static noinline void compress_file_range(struct inode *inode,
>  	 * inode has not been flagged as nocompress.  This flag can
>  	 * change at any time if we discover bad compression ratios.
>  	 */
> -	if (inode_need_compress(inode)) {
> +	if (inode_need_compress(inode, start, end)) {
>  		WARN_ON(pages);
>  		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
>  		if (!pages) {
> @@ -1576,7 +1582,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
>  	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
>  		ret = run_delalloc_nocow(inode, locked_page, start, end,
>  					 page_started, 0, nr_written);
> -	} else if (!inode_need_compress(inode)) {
> +	} else if (!inode_need_compress(inode, start, end)) {
>  		ret = cow_file_range(inode, locked_page, start, end, end,
>  				      page_started, nr_written, 1, NULL);
>  	} else {
> -- 
> 2.13.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
