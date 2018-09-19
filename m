Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38047 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeISFzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 01:55:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id t84-v6so1825782pgb.5
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 17:20:39 -0700 (PDT)
Date: Tue, 18 Sep 2018 17:20:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 33/36] btrfs: only free reserved extent if we didn't
 insert it
Message-ID: <20180919002037.GG479@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-34-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-34-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:58:04PM -0400, Josef Bacik wrote:
> When we insert the file extent once the ordered extent completes we free
> the reserved extent reservation as it'll have been migrated to the
> bytes_used counter.  However if we error out after this step we'll still
> clear the reserved extent reservation, resulting in a negative
> accounting of the reserved bytes for the block group and space info.
> Fix this by only doing the free if we didn't successfully insert a file
> extent for this extent.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 60bcad901857..fd6ade4680b5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2992,6 +2992,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  	bool truncated = false;
>  	bool range_locked = false;
>  	bool clear_new_delalloc_bytes = false;
> +	bool clear_reserved_extent = true;
>  
>  	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
>  	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
> @@ -3095,10 +3096,12 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  						logical_len, logical_len,
>  						compress_type, 0, 0,
>  						BTRFS_FILE_EXTENT_REG);
> -		if (!ret)
> +		if (!ret) {
> +			clear_reserved_extent = false;
>  			btrfs_release_delalloc_bytes(fs_info,
>  						     ordered_extent->start,
>  						     ordered_extent->disk_len);
> +		}
>  	}
>  	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
>  			   ordered_extent->file_offset, ordered_extent->len,
> @@ -3159,8 +3162,13 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  		 * wrong we need to return the space for this ordered extent
>  		 * back to the allocator.  We only free the extent in the
>  		 * truncated case if we didn't write out the extent at all.
> +		 *
> +		 * If we made it past insert_reserved_file_extent before we
> +		 * errored out then we don't need to do this as the accounting
> +		 * has already been done.
>  		 */
>  		if ((ret || !logical_len) &&
> +		    clear_reserved_extent &&
>  		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
>  		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
>  			btrfs_free_reserved_extent(fs_info,
> -- 
> 2.14.3
> 
