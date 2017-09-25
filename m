Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932656AbdIYMSd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 08:18:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB032AC82
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 12:18:31 +0000 (UTC)
Subject: Re: [PATCH 08/10] btrfs: remove unused parameter in cow_file_range
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-9-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <13b784de-e906-7334-8aae-39cb7ce8c85e@suse.com>
Date: Mon, 25 Sep 2017 15:18:31 +0300
MIME-Version: 1.0
In-Reply-To: <1503308630-6652-9-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.08.2017 12:43, Nikolay Borisov wrote:
> The delalloc_end parameter was only passed to extent_clear_unlock_delalloc, but
> since its usage was removed form that function let's also remove it from the
> caller's parameter list.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

ping, since most of the series has been merged but this one has been
left out I assume it could have been missed.

> ---
>  fs/btrfs/inode.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 98b56aca0a6f..156be9face5b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -105,9 +105,9 @@ static int btrfs_truncate(struct inode *inode);
>  static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
>  static noinline int cow_file_range(struct inode *inode,
>  				   struct page *locked_page,
> -				   u64 start, u64 end, u64 delalloc_end,
> -				   int *page_started, unsigned long *nr_written,
> -				   int unlock, struct btrfs_dedupe_hash *hash);
> +				   u64 start, u64 end, int *page_started,
> +				   unsigned long *nr_written, int unlock,
> +				   struct btrfs_dedupe_hash *hash);
>  static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
>  				       u64 orig_start, u64 block_start,
>  				       u64 block_len, u64 orig_block_len,
> @@ -739,8 +739,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
>  					     async_extent->start,
>  					     async_extent->start +
>  					     async_extent->ram_size - 1,
> -					     async_extent->start +
> -					     async_extent->ram_size - 1,
>  					     &page_started, &nr_written, 0,
>  					     NULL);
>  
> @@ -930,9 +928,9 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
>   */
>  static noinline int cow_file_range(struct inode *inode,
>  				   struct page *locked_page,
> -				   u64 start, u64 end, u64 delalloc_end,
> -				   int *page_started, unsigned long *nr_written,
> -				   int unlock, struct btrfs_dedupe_hash *hash)
> +				   u64 start, u64 end, int *page_started,
> +				   unsigned long *nr_written, int unlock,
> +				   struct btrfs_dedupe_hash *hash)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -1431,7 +1429,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  		if (cow_start != (u64)-1) {
>  			ret = cow_file_range(inode, locked_page,
>  					     cow_start, found_key.offset - 1,
> -					     end, page_started, nr_written, 1,
> +					     page_started, nr_written, 1,
>  					     NULL);
>  			if (ret) {
>  				if (!nolock && nocow)
> @@ -1517,7 +1515,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  	}
>  
>  	if (cow_start != (u64)-1) {
> -		ret = cow_file_range(inode, locked_page, cow_start, end, end,
> +		ret = cow_file_range(inode, locked_page, cow_start, end,
>  				     page_started, nr_written, 1, NULL);
>  		if (ret)
>  			goto error;
> @@ -1574,7 +1572,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
>  		ret = run_delalloc_nocow(inode, locked_page, start, end,
>  					 page_started, 0, nr_written);
>  	} else if (!inode_need_compress(inode, start, end)) {
> -		ret = cow_file_range(inode, locked_page, start, end, end,
> +		ret = cow_file_range(inode, locked_page, start, end,
>  				      page_started, nr_written, 1, NULL);
>  	} else {
>  		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
> 
