Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbdLSV2h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 16:28:37 -0500
Date: Tue, 19 Dec 2017 13:23:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB
 restriction
Message-ID: <20171219212333.GA11950@magnolia>
References: <20171219100247.13880-1-nefelim4ag@gmail.com>
 <20171219100247.13880-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171219100247.13880-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 01:02:44PM +0300, Timofey Titovets wrote:
> At now btrfs_dedupe_file_range() restricted to 16MiB range for
> limit locking time and memory requirement for dedup ioctl()
> 
> For too big input range code silently set range to 16MiB
> 
> Let's remove that restriction by do iterating over dedup range.
> That's backward compatible and will not change anything for request
> less then 16MiB.
> 
> Changes:
>   v1 -> v2:
>     - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
>     - Store memory of pages array between iterations
>     - Lock inodes once, not on each iteration
>     - Small inplace cleanups

/me wonders if you could take advantage of vfs_clone_file_prep_inodes,
which takes care of the content comparison (and flushing files, and inode
checks, etc.) ?

(ISTR Qu Wenruo(??) or someone remarking that this might not work well
with btrfs locking model, but I could be mistaken about all that...)

--D

> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 160 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 94 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index be5bd81b3669..45a47d0891fc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2965,8 +2965,8 @@ static void btrfs_cmp_data_free(struct cmp_pages *cmp)
>  			put_page(pg);
>  		}
>  	}
> -	kfree(cmp->src_pages);
> -	kfree(cmp->dst_pages);
> +
> +	cmp->num_pages = 0;
>  }
>  
>  static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
> @@ -2974,41 +2974,22 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
>  				  u64 len, struct cmp_pages *cmp)
>  {
>  	int ret;
> -	int num_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> -	struct page **src_pgarr, **dst_pgarr;
> -
> -	/*
> -	 * We must gather up all the pages before we initiate our
> -	 * extent locking. We use an array for the page pointers. Size
> -	 * of the array is bounded by len, which is in turn bounded by
> -	 * BTRFS_MAX_DEDUPE_LEN.
> -	 */
> -	src_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> -	dst_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> -	if (!src_pgarr || !dst_pgarr) {
> -		kfree(src_pgarr);
> -		kfree(dst_pgarr);
> -		return -ENOMEM;
> -	}
> -	cmp->num_pages = num_pages;
> -	cmp->src_pages = src_pgarr;
> -	cmp->dst_pages = dst_pgarr;
>  
>  	/*
>  	 * If deduping ranges in the same inode, locking rules make it mandatory
>  	 * to always lock pages in ascending order to avoid deadlocks with
>  	 * concurrent tasks (such as starting writeback/delalloc).
>  	 */
> -	if (src == dst && dst_loff < loff) {
> -		swap(src_pgarr, dst_pgarr);
> +	if (src == dst && dst_loff < loff)
>  		swap(loff, dst_loff);
> -	}
>  
> -	ret = gather_extent_pages(src, src_pgarr, cmp->num_pages, loff);
> +	cmp->num_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +
> +	ret = gather_extent_pages(src, cmp->src_pages, cmp->num_pages, loff);
>  	if (ret)
>  		goto out;
>  
> -	ret = gather_extent_pages(dst, dst_pgarr, cmp->num_pages, dst_loff);
> +	ret = gather_extent_pages(dst, cmp->dst_pages, cmp->num_pages, dst_loff);
>  
>  out:
>  	if (ret)
> @@ -3078,31 +3059,23 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
>  	return 0;
>  }
>  
> -static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> -			     struct inode *dst, u64 dst_loff)
> +static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> +			       struct inode *dst, u64 dst_loff,
> +			       struct cmp_pages *cmp)
>  {
>  	int ret;
>  	u64 len = olen;
> -	struct cmp_pages cmp;
>  	bool same_inode = (src == dst);
>  	u64 same_lock_start = 0;
>  	u64 same_lock_len = 0;
>  
> -	if (len == 0)
> -		return 0;
> -
> -	if (same_inode)
> -		inode_lock(src);
> -	else
> -		btrfs_double_inode_lock(src, dst);
> -
>  	ret = extent_same_check_offsets(src, loff, &len, olen);
>  	if (ret)
> -		goto out_unlock;
> +		return ret;
>  
>  	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
>  	if (ret)
> -		goto out_unlock;
> +		return ret;
>  
>  	if (same_inode) {
>  		/*
> @@ -3119,32 +3092,21 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  		 * allow an unaligned length so long as it ends at
>  		 * i_size.
>  		 */
> -		if (len != olen) {
> -			ret = -EINVAL;
> -			goto out_unlock;
> -		}
> +		if (len != olen)
> +			return -EINVAL;
>  
>  		/* Check for overlapping ranges */
> -		if (dst_loff + len > loff && dst_loff < loff + len) {
> -			ret = -EINVAL;
> -			goto out_unlock;
> -		}
> +		if (dst_loff + len > loff && dst_loff < loff + len)
> +			return -EINVAL;
>  
>  		same_lock_start = min_t(u64, loff, dst_loff);
>  		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
>  	}
>  
> -	/* don't make the dst file partly checksummed */
> -	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> -	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
> -		ret = -EINVAL;
> -		goto out_unlock;
> -	}
> -
>  again:
> -	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, &cmp);
> +	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, cmp);
>  	if (ret)
> -		goto out_unlock;
> +		return ret;
>  
>  	if (same_inode)
>  		ret = lock_extent_range(src, same_lock_start, same_lock_len,
> @@ -3165,7 +3127,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  		 * Ranges in the io trees already unlocked. Now unlock all
>  		 * pages before waiting for all IO to complete.
>  		 */
> -		btrfs_cmp_data_free(&cmp);
> +		btrfs_cmp_data_free(cmp);
>  		if (same_inode) {
>  			btrfs_wait_ordered_range(src, same_lock_start,
>  						 same_lock_len);
> @@ -3178,12 +3140,12 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	ASSERT(ret == 0);
>  	if (WARN_ON(ret)) {
>  		/* ranges in the io trees already unlocked */
> -		btrfs_cmp_data_free(&cmp);
> +		btrfs_cmp_data_free(cmp);
>  		return ret;
>  	}
>  
>  	/* pass original length for comparison so we stay within i_size */
> -	ret = btrfs_cmp_data(olen, &cmp);
> +	ret = btrfs_cmp_data(olen, cmp);
>  	if (ret == 0)
>  		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>  
> @@ -3193,8 +3155,79 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	else
>  		btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
>  
> -	btrfs_cmp_data_free(&cmp);
> -out_unlock:
> +	btrfs_cmp_data_free(cmp);
> +
> +	return ret;
> +}
> +
> +#define BTRFS_MAX_DEDUPE_LEN	SZ_16M
> +
> +static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> +				 struct inode *dst, u64 dst_loff)
> +{
> +	int ret;
> +	int num_pages;
> +	bool same_inode = (src == dst);
> +	u64 i, tail_len, chunk_count;
> +	struct cmp_pages cmp;
> +
> +	if (olen == 0)
> +		return 0;
> +
> +	/* don't make the dst file partly checksummed */
> +	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> +	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
> +		return -EINVAL;
> +	}
> +
> +	if (same_inode)
> +		inode_lock(src);
> +	else
> +		btrfs_double_inode_lock(src, dst);
> +
> +	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
> +	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
> +
> +	if (chunk_count > 0) {
> +		num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
> +	} else {
> +		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
> +	}
> +	/*
> +	 * We must gather up all the pages before we initiate our
> +	 * extent locking. We use an array for the page pointers. Size
> +	 * of the array is bounded by len, which is in turn bounded by
> +	 * BTRFS_MAX_DEDUPE_LEN.
> +	 */
> +	ret = -ENOMEM;
> +	cmp.src_pages = kcalloc(num_pages, sizeof(struct page *),
> +				GFP_KERNEL);
> +	if (!cmp.src_pages)
> +		goto out;
> +	cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *),
> +				GFP_KERNEL);
> +	if (!cmp.dst_pages)
> +		goto out;
> +
> +
> +	for (i = 0; i < chunk_count; i++) {
> +		ret = __btrfs_extent_same(src, loff, BTRFS_MAX_DEDUPE_LEN,
> +					  dst, dst_loff, &cmp);
> +		if (ret)
> +			goto out;
> +
> +		loff += BTRFS_MAX_DEDUPE_LEN;
> +		dst_loff += BTRFS_MAX_DEDUPE_LEN;
> +	}
> +
> +	if (tail_len > 0)
> +		ret = __btrfs_extent_same(src, loff, tail_len,
> +					  dst, dst_loff, &cmp);
> +
> +out:
> +	kfree(cmp.src_pages);
> +	kfree(cmp.dst_pages);
> +
>  	if (same_inode)
>  		inode_unlock(src);
>  	else
> @@ -3203,8 +3236,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	return ret;
>  }
>  
> -#define BTRFS_MAX_DEDUPE_LEN	SZ_16M
> -
>  ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
>  				struct file *dst_file, u64 dst_loff)
>  {
> @@ -3213,9 +3244,6 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
>  	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
>  	ssize_t res;
>  
> -	if (olen > BTRFS_MAX_DEDUPE_LEN)
> -		olen = BTRFS_MAX_DEDUPE_LEN;
> -
>  	if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
>  		/*
>  		 * Btrfs does not support blocksize < page_size. As a
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
