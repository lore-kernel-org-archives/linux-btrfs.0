Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65224 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbdJKEvM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 00:51:12 -0400
Subject: Re: [PATCH] Remove unused dedupe argument btrfs_set_extent_delalloc()
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20171011022900.21486-1-rgoldwyn@suse.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fcc7193b-6a59-4140-b847-7a6e8e382245@gmx.com>
Date: Wed, 11 Oct 2017 12:50:58 +0800
MIME-Version: 1.0
In-Reply-To: <20171011022900.21486-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月11日 10:29, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>   fs/btrfs/ctree.h             |  2 +-
>   fs/btrfs/file.c              |  2 +-
>   fs/btrfs/inode.c             |  9 ++++-----
>   fs/btrfs/relocation.c        |  2 +-
>   fs/btrfs/tests/inode-tests.c | 12 ++++++------
>   5 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8fc690384c58..ac7e2b02a4df 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3174,7 +3174,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
>   int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
>   			       int nr);
>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> -			      struct extent_state **cached_state, int dedupe);
> +			      struct extent_state **cached_state);

Just as the variable name indicated, it's preparation for in-band dedupe.
Same for @delalloc_end.

If Fujitsu is not pushing inband dedupe anymore, it would be possible to 
remove it, but AFAIK it's not the case.

Thanks,
Qu

>   int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
>   			     struct btrfs_root *new_root,
>   			     struct btrfs_root *parent_root,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a3d006d14683..46fa02e109f3 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -504,7 +504,7 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
>   
>   	end_of_last_block = start_pos + num_bytes - 1;
>   	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
> -					cached, 0);
> +					cached);
>   	if (err)
>   		return err;
>   
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d94e3f68b9b1..9a3953fc3b45 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2036,7 +2036,7 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
>   }
>   
>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> -			      struct extent_state **cached_state, int dedupe)
> +			      struct extent_state **cached_state)
>   {
>   	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
>   	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
> @@ -2101,8 +2101,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
>   		goto out;
>   	 }
>   
> -	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state,
> -				  0);
> +	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
>   	ClearPageChecked(page);
>   	set_page_dirty(page);
>   out:
> @@ -4854,7 +4853,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
>   			  0, 0, &cached_state, GFP_NOFS);
>   
>   	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
> -					&cached_state, 0);
> +					&cached_state);
>   	if (ret) {
>   		unlock_extent_cached(io_tree, block_start, block_end,
>   				     &cached_state, GFP_NOFS);
> @@ -9253,7 +9252,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
>   			  0, 0, &cached_state, GFP_NOFS);
>   
>   	ret = btrfs_set_extent_delalloc(inode, page_start, end,
> -					&cached_state, 0);
> +					&cached_state);
>   	if (ret) {
>   		unlock_extent_cached(io_tree, page_start, page_end,
>   				     &cached_state, GFP_NOFS);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 9841faef08ea..ff19edb84d0e 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3266,7 +3266,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
>   			nr++;
>   		}
>   
> -		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL, 0);
> +		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
>   		set_page_dirty(page);
>   
>   		unlock_extent(&BTRFS_I(inode)->io_tree,
> diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
> index 8c91d03cc82d..1a7d8b65d500 100644
> --- a/fs/btrfs/tests/inode-tests.c
> +++ b/fs/btrfs/tests/inode-tests.c
> @@ -970,7 +970,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	/* [BTRFS_MAX_EXTENT_SIZE] */
>   	BTRFS_I(inode)->outstanding_extents++;
>   	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
> -					NULL, 0);
> +					NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> @@ -986,7 +986,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	BTRFS_I(inode)->outstanding_extents++;
>   	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
>   					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
> -					NULL, 0);
> +					NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> @@ -1021,7 +1021,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
>   					(BTRFS_MAX_EXTENT_SIZE >> 1)
>   					+ sectorsize - 1,
> -					NULL, 0);
> +					NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> @@ -1044,7 +1044,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	ret = btrfs_set_extent_delalloc(inode,
>   			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
>   			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
> -			NULL, 0);
> +			NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> @@ -1062,7 +1062,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	BTRFS_I(inode)->outstanding_extents++;
>   	ret = btrfs_set_extent_delalloc(inode,
>   			BTRFS_MAX_EXTENT_SIZE + sectorsize,
> -			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
> +			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> @@ -1099,7 +1099,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
>   	BTRFS_I(inode)->outstanding_extents++;
>   	ret = btrfs_set_extent_delalloc(inode,
>   			BTRFS_MAX_EXTENT_SIZE + sectorsize,
> -			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
> +			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
>   	if (ret) {
>   		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
>   		goto out;
> 
