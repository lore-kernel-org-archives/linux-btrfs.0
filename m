Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34785 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbeDJPvg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 11:51:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A10CBAF2A
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 15:51:34 +0000 (UTC)
Date: Tue, 10 Apr 2018 17:49:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Factor out read portion of
 btrfs_get_blocks_direct
Message-ID: <20180410154905.GE2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519315934-13611-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519315934-13611-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 06:12:13PM +0200, Nikolay Borisov wrote:
> Currently this function handles both the READ and WRITE dio cases. This
> is facilitated by a bunch of 'if' statements, a goto short-circuit
> statement and a very perverse aliasing of "!created"(READ) case
> by setting lockstart = lockend and checking for lockstart < lockend for
> detecting the write. Let's simplify this mess by extracting the
> READ-only code into a separate __btrfs_get_block_direct_read function.
> This is only the first step, the next one will be to factor out the
> write side as well. The end goal will be to have the common locking/
> unlocking code in btrfs_get_blocks_direct and then it will call either
> the read|write subvariants. No functional changes.

Reviewed-by: David Sterba <dsterba@suse.com>

uh what a convoluted code to untangle. A few style notes below.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 49 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 491a7397f6fa..fd99347d0c91 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7677,6 +7677,27 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
>  	return em;
>  }
>  
> +
> +static int __btrfs_get_blocks_direct_read(struct extent_map *em,

Please drop the "__" the function is static and there's no
underscore-less version.

> +					 struct buffer_head *bh_result,
> +					 struct inode *inode,
> +					 u64 start, u64 len)
> +{
> +	if (em->block_start == EXTENT_MAP_HOLE ||
> +			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
> +		return -ENOENT;
> +
> +	len = min(len, em->len - (start - em->start));
> +
> +	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
> +		inode->i_blkbits;
> +	bh_result->b_size = len;
> +	bh_result->b_bdev = em->bdev;
> +	set_buffer_mapped(bh_result);
> +
> +	return 0;
> +}
> +
>  static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  				   struct buffer_head *bh_result, int create)
>  {
> @@ -7745,11 +7766,22 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  		goto unlock_err;
>  	}
>  
> -	/* Just a good old fashioned hole, return */
> -	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
> -			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
> +	if (!create) {
> +		ret = __btrfs_get_blocks_direct_read(em, bh_result, inode,
> +						   start, len);
> +		/* Can be negative only if we read from a hole */
> +		if (ret < 0) {
> +			ret = 0;
> +			free_extent_map(em);
> +			goto unlock_err;
> +		}
> +		/*
> +		 * We need to unlock only the end area that we aren't using
> +		 * if there is any leftover space
> +		 */
> +		free_extent_state(cached_state);
>  		free_extent_map(em);
> -		goto unlock_err;
> +		return 0;

Please add a separate label for that, the funcion uses the single exit
block style (labels and one-or-two returns).

>  	}
>  
>  	/*
> @@ -7761,12 +7793,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	 * just use the extent.
>  	 *
>  	 */
> -	if (!create) {
> -		len = min(len, em->len - (start - em->start));
> -		lockstart = start + len;
> -		goto unlock;
> -	}
> -
>  	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
>  	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
>  	     em->block_start != EXTENT_MAP_HOLE)) {
> @@ -7853,10 +7879,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
>  				 lockend, unlock_bits, 1, 0,
>  				 &cached_state);
> -	} else {
> -		free_extent_state(cached_state);
>  	}
> -
>  	free_extent_map(em);
>  
>  	return 0;
