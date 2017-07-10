Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44911 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754832AbdGJSIx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 14:08:53 -0400
Date: Mon, 10 Jul 2017 20:07:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170710180739.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170704172815.26449-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170704172815.26449-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 04, 2017 at 08:28:15PM +0300, Timofey Titovets wrote:
> For now that code just return true
> Later more complex heuristic code will be added
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 22 ++++++++++++++++++++++
>  fs/btrfs/compression.h |  2 ++
>  fs/btrfs/inode.c       | 25 ++++++++++++++++---------
>  3 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index a2fad39f79ba..481e56f61461 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1098,3 +1098,25 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
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
> index 680d4265d601..259ea776c9d4 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -93,4 +93,6 @@ struct btrfs_compress_op {
>  extern const struct btrfs_compress_op btrfs_zlib_compress;
>  extern const struct btrfs_compress_op btrfs_lzo_compress;
>  
> +int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
> +
>  #endif
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 556c93060606..285e5b5eed35 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -510,15 +510,6 @@ static noinline void compress_file_range(struct inode *inode,
>  	 */
>  	if (inode_need_compress(inode)) {

Actually, I think we should put the decision logic based on heuristic
into inode_need_compress that's called from here.

So, please update prototype of inode_need_compress to take start/end and
call btrfs_compress_heuristic from there.

>  		WARN_ON(pages);
> -		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> -		if (!pages) {
> -			/* just bail out to the uncompressed code */
> -			goto cont;
> -		}
> -
> -		if (BTRFS_I(inode)->force_compress)
> -			compress_type = BTRFS_I(inode)->force_compress;
> -
>  		/*
>  		 * we need to call clear_page_dirty_for_io on each
>  		 * page in the range.  Otherwise applications with the file
> @@ -530,6 +521,22 @@ static noinline void compress_file_range(struct inode *inode,
>  		 */
>  		extent_range_clear_dirty_for_io(inode, start, end);
>  		redirty = 1;
> +
> +		ret = btrfs_compress_heuristic(inode, start, end);

Here we're too far to skip compression, as the pages have been marked
for redirtying again. The original code proceeds to compression
directly.

Merging the logic into inode_need_compress would also mean that it's
going to be used from run_delalloc_range. This could have other
implications, but I haven't looked closely.

> +
> +		/* Heuristic say: dont try compress that */
> +		if (ret == 0)
> +			goto cont;
> +
> +		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> +		if (!pages) {
> +			/* just bail out to the uncompressed code */
> +			goto cont;
> +		}
> +
> +		if (BTRFS_I(inode)->force_compress)
> +			compress_type = BTRFS_I(inode)->force_compress;
> +
>  		ret = btrfs_compress_pages(compress_type,
>  					   inode->i_mapping, start,
>  					   pages,
> -- 
> 2.13.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
