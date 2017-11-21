Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbdKUHdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 02:33:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C0FA2AD57
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 07:33:11 +0000 (UTC)
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171121055445.13972-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>
Date: Tue, 21 Nov 2017 09:33:09 +0200
MIME-Version: 1.0
In-Reply-To: <20171121055445.13972-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.11.2017 07:54, Qu Wenruo wrote:
> To save reader seconds before checking if it's rounding up or down.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 309a109069f1..8ab18e25cb91 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2054,7 +2054,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
>  {
>  	int j, ret = 0;
>  	u64 bytes_left, end;
> -	u64 aligned_start = ALIGN(start, 1 << 9);
> +	u64 aligned_start = round_up(start, 1 << 9);

nit: 1 << 9 == SZ_512 or essentially sector size however looking at the
defines there is SECTOR_SIZE defined in ide.h which we do not include.
Or just use 512 no need to obscure it behind a shift.

>  
>  	if (WARN_ON(start != aligned_start)) {
>  		len -= aligned_start - start;
> @@ -4266,7 +4266,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
>  	int have_pinned_space;
>  
>  	/* make sure bytes are sectorsize aligned */
> -	bytes = ALIGN(bytes, fs_info->sectorsize);
> +	bytes = round_up(bytes, fs_info->sectorsize);
>  
>  	if (btrfs_is_free_space_inode(inode)) {
>  		need_commit = 0;
> @@ -6080,7 +6080,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  	if (delalloc_lock)
>  		mutex_lock(&inode->delalloc_mutex);
>  
> -	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
> +	num_bytes = round_up(num_bytes, fs_info->sectorsize);
>  
>  	/* Add our new extents and calculate the new rsv size. */
>  	spin_lock(&inode->lock);
> @@ -6135,7 +6135,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
>  
> -	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
> +	num_bytes = round_up(num_bytes, fs_info->sectorsize);
>  	spin_lock(&inode->lock);
>  	inode->csum_bytes -= num_bytes;
>  	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
> @@ -7818,7 +7818,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  			goto loop;
>  		}
>  checks:
> -		search_start = ALIGN(offset, fs_info->stripesize);
> +		search_start = round_up(offset, fs_info->stripesize);
>  
>  		/* move on to the next group */
>  		if (search_start + num_bytes >
> 
