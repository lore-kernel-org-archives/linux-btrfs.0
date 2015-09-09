Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:10180 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbIIByG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 21:54:06 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 51122AC0279
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2015 10:54:04 +0900 (JST)
Subject: Re: [PATCH 15/19] btrfs: fallocate: Add support to accurate qgroup
 reserve
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441704164-353-4-git-send-email-quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55EF912B.3050905@jp.fujitsu.com>
Date: Wed, 9 Sep 2015 10:53:47 +0900
MIME-Version: 1.0
In-Reply-To: <1441704164-353-4-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu,

On 2015/09/08 18:22, Qu Wenruo wrote:
> Now fallocate will do accurate qgroup reserve space check, unlike old
> method, which will always reserve the whole length of the range.
> 
> With this patch, fallocate will:
> 1) Iterate the desired range and mark in data rsv map
>     Only range which is going to be allocated will be recorded in data
>     rsv map and reserve the space.
>     For already allocated range (normal/prealloc extent) they will be
>     skipped.
>     Also, record the marked range into a new list for later use.
> 
> 2) If 1) succeeded, do real file extent allocate.
>     And at file extent allocation time, corresponding range will be
>     removed from the range in data rsv map.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/file.c | 147 +++++++++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 107 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index c1eec4f..26e59bc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2545,17 +2545,61 @@ out_only_mutex:
>   	return err;
>   }
>   
> +/* Helper structure to record which range is already reserved */
> +struct falloc_range {
> +	struct list_head list;
> +	u64 start;
> +	u64 len;
> +};
> +
> +/*
> + * Helper function to add falloc range
> + *
> + * Caller should have locked the larger range of extent containing
> + * [start, len)
> + */
> +static int add_falloc_range(struct list_head *head, u64 start, u64 len)
> +{
> +	struct falloc_range *prev = NULL;
> +	struct falloc_range *range = NULL;
> +
> +	if (list_empty(head))
> +		goto insert;
> +
> +	/*
> +	 * As fallocate iterate by bytenr order, we only need to check
> +	 * the last range.
> +	 */
> +	prev = list_entry(head->prev, struct falloc_range, list);
> +	if (prev->start + prev->len == start) {
> +		prev->len += len;
> +		return 0;
> +	}
> +insert:
> +	range = kmalloc(sizeof(*range), GFP_NOFS);
> +	if (!range)
> +		return -ENOMEM;
> +	range->start = start;
> +	range->len = len;
> +	list_add_tail(&range->list, head);
> +	return 0;
> +}
> +
>   static long btrfs_fallocate(struct file *file, int mode,
>   			    loff_t offset, loff_t len)
>   {
>   	struct inode *inode = file_inode(file);
>   	struct extent_state *cached_state = NULL;
> +	struct falloc_range *range;
> +	struct falloc_range *tmp;
> +	struct list_head reserve_list;
>   	u64 cur_offset;
>   	u64 last_byte;
>   	u64 alloc_start;
>   	u64 alloc_end;
>   	u64 alloc_hint = 0;
>   	u64 locked_end;
> +	u64 actual_end = 0;
>   	struct extent_map *em;
>   	int blocksize = BTRFS_I(inode)->root->sectorsize;
>   	int ret;
> @@ -2571,10 +2615,11 @@ static long btrfs_fallocate(struct file *file, int mode,
>   		return btrfs_punch_hole(inode, offset, len);
>   
>   	/*
> -	 * Make sure we have enough space before we do the
> -	 * allocation.
> +	 * Only trigger disk allocation, don't trigger qgroup reserve
> +	 *
> +	 * For qgroup space, it will be checked later.
>   	 */
> -	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start, alloc_end - alloc_start);
> +	ret = btrfs_alloc_data_chunk_ondemand(inode, alloc_end - alloc_start);
>   	if (ret)
>   		return ret;
>   
> @@ -2583,6 +2628,13 @@ static long btrfs_fallocate(struct file *file, int mode,
>   	if (ret)
>   		goto out;
>   
> +	/*
> +	 * TODO: Move these two operations after we have checked
> +	 * accurate reserved space, or fallocate can still fail but
> +	 * with page truncated or size expanded.
> +	 *
> +	 * But that's a minor problem and won't do much harm BTW.
> +	 */
>   	if (alloc_start > inode->i_size) {
>   		ret = btrfs_cont_expand(inode, i_size_read(inode),
>   					alloc_start);
> @@ -2641,10 +2693,10 @@ static long btrfs_fallocate(struct file *file, int mode,
>   		}
>   	}
>   
> +	/* First, check if we exceed the qgroup limit */
> +	INIT_LIST_HEAD(&reserve_list);
>   	cur_offset = alloc_start;
>   	while (1) {
> -		u64 actual_end;
> -
>   		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
>   				      alloc_end - cur_offset, 0);
>   		if (IS_ERR_OR_NULL(em)) {
> @@ -2657,54 +2709,69 @@ static long btrfs_fallocate(struct file *file, int mode,
>   		last_byte = min(extent_map_end(em), alloc_end);
>   		actual_end = min_t(u64, extent_map_end(em), offset + len);
>   		last_byte = ALIGN(last_byte, blocksize);
> -
>   		if (em->block_start == EXTENT_MAP_HOLE ||
>   		    (cur_offset >= inode->i_size &&
>   		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
> -			ret = btrfs_prealloc_file_range(inode, mode, cur_offset,
> -							last_byte - cur_offset,
> -							1 << inode->i_blkbits,
> -							offset + len,
> -							&alloc_hint);
> -		} else if (actual_end > inode->i_size &&
> -			   !(mode & FALLOC_FL_KEEP_SIZE)) {
> -			struct btrfs_trans_handle *trans;
> -			struct btrfs_root *root = BTRFS_I(inode)->root;
> -
> -			/*
> -			 * We didn't need to allocate any more space, but we
> -			 * still extended the size of the file so we need to
> -			 * update i_size and the inode item.
> -			 */
> -			trans = btrfs_start_transaction(root, 1);
> -			if (IS_ERR(trans)) {
> -				ret = PTR_ERR(trans);
> -			} else {
> -				inode->i_ctime = CURRENT_TIME;
> -				i_size_write(inode, actual_end);
> -				btrfs_ordered_update_i_size(inode, actual_end,
> -							    NULL);
> -				ret = btrfs_update_inode(trans, root, inode);
> -				if (ret)
> -					btrfs_end_transaction(trans, root);
> -				else
> -					ret = btrfs_end_transaction(trans,
> -								    root);
> +			ret = add_falloc_range(&reserve_list, cur_offset,
> +					       last_byte - cur_offset);
> +			if (ret < 0) {
> +				free_extent_map(em);
> +				goto out;
>   			}
> +			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
> +					last_byte - cur_offset);
>   		}
>   		free_extent_map(em);
> -		if (ret < 0)
> -			break;
> -
>   		cur_offset = last_byte;
> -		if (cur_offset >= alloc_end) {
> -			ret = 0;
> +		if (cur_offset >= alloc_end)
>   			break;
> +	}
> +	if (ret < 0)
> +		goto out;
> +
> +	/* Now we are sure qgroup reserved enough space now */
> +	list_for_each_entry_safe(range, tmp, &reserve_list, list) {
> +		ret = btrfs_prealloc_file_range(inode, mode, range->start,
> +				range->len, 1 << inode->i_blkbits,
> +				offset + len, &alloc_hint);
> +		if (ret < 0)
> +			goto out;
> +	}
> +	if (actual_end > inode->i_size &&
> +	    !(mode & FALLOC_FL_KEEP_SIZE)) {
> +		struct btrfs_trans_handle *trans;
> +		struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +		/*
> +		 * We didn't need to allocate any more space, but we
> +		 * still extended the size of the file so we need to
> +		 * update i_size and the inode item.
> +		 */
> +		trans = btrfs_start_transaction(root, 1);
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +		} else {
> +			inode->i_ctime = CURRENT_TIME;
> +			i_size_write(inode, actual_end);
> +			btrfs_ordered_update_i_size(inode, actual_end, NULL);
> +			ret = btrfs_update_inode(trans, root, inode);
> +			if (ret)
> +				btrfs_end_transaction(trans, root);
> +			else
> +				ret = btrfs_end_transaction(trans, root);
>   		}
>   	}
>   	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
>   			     &cached_state, GFP_NOFS);
>   out:
> +	/*
> +	 * As we waited the extent range, the data_rsv_map must be empty
> +	 * in the range, as written data range will be released from it.

> +	 * And for prelloacted extent, it will also be released when

                   preallocated

Thanks,
Tsutomu

> +	 * its metadata is written.
> +	 * So this is completely used as cleanup.
> +	 */
> +	btrfs_qgroup_free_data(inode, alloc_start, alloc_end - alloc_start);
>   	mutex_unlock(&inode->i_mutex);
>   	/* Let go of our reservation. */
>   	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
> 


