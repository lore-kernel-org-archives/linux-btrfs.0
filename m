Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56702 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3BGPKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 10:10:05 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 12F929A04E9
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2013 08:10:04 -0700 (MST)
Date: Thu, 7 Feb 2013 10:10:00 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [RFC][PATCH] Btrfs: fix deadlock due to unsubmitted
Message-ID: <20130207151000.GA1933@localhost.localdomain>
References: <51137DF7.7050006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51137DF7.7050006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:12:07AM -0700, Miao Xie wrote:
> The deadlock problem happened when running fsstress(a test program in LTP).
> 
> Steps to reproduce:
>  # mkfs.btrfs -b 100M <partition>
>  # mount <partition> <mnt>
>  # <Path>/fsstress -p 3 -n 10000000 -d <mnt>
> 
> The reason is:
> btrfs_direct_IO()
>  |->do_direct_IO()
>      |->get_page()
>      |->get_blocks()
>      |	 |->btrfs_delalloc_resereve_space()
>      |	 |->btrfs_add_ordered_extent() -------	Add a new ordered extent
>      |->dio_send_cur_page(page0) --------------	We didn't submit bio here
>      |->get_page()
>      |->get_blocks()
> 	 |->btrfs_delalloc_resereve_space()
> 	     |->flush_space()
> 		 |->btrfs_start_ordered_extent()
> 		     |->wait_event() ----------	Wait the completion of
> 						the ordered extent that is
> 						mentioned above
> 
> But because we didn't submit the bio that is mentioned above, the ordered
> extent can not complete, we would wait for its completion forever.
> 
> There are two methods which can fix this deadlock problem:
> 1. submit the bio before we invoke get_blocks()
> 2. reserve the space before we do dio
> 
> Though the 1st is the simplest way, we need modify the code of VFS, and it
> is likely to break contiguous requests, and introduce performance regression
> for the other filesystems.
> 
> So we have to choose the 2nd way.

I ran into this a few weeks ago and as Chris said I opted for option 4, just
do all the direct io stuff ourselves and ditch the generic stuff.  This approach
works for now though so I'm good with it.

> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |    3 +-
>  fs/btrfs/inode.c       |   81 ++++++++++++++++++++++++-----------------------
>  2 files changed, 43 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 85b8454..ca9afc4 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4670,7 +4670,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
>  	spin_lock(&BTRFS_I(inode)->lock);
>  	dropped = drop_outstanding_extent(inode);
>  
> -	to_free = calc_csum_metadata_size(inode, num_bytes, 0);
> +	if (num_bytes)
> +		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
>  	spin_unlock(&BTRFS_I(inode)->lock);
>  	if (dropped > 0)
>  		to_free += btrfs_calc_trans_metadata_size(root, dropped);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ca7ace7..c5d829d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6004,16 +6004,15 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	u64 len = bh_result->b_size;
>  	struct btrfs_trans_handle *trans;
>  	int unlock_bits = EXTENT_LOCKED;
> -	int ret;
> +	int ret = 0;
>  
>  	if (create) {
> -		ret = btrfs_delalloc_reserve_space(inode, len);
> -		if (ret)
> -			return ret;
> +		spin_lock(&BTRFS_I(inode)->lock);
> +		BTRFS_I(inode)->outstanding_extents++;
> +		spin_unlock(&BTRFS_I(inode)->lock);
>  		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
> -	} else {
> +	} else
>  		len = min_t(u64, len, root->sectorsize);
> -	}
>  
>  	lockstart = start;
>  	lockend = start + len - 1;
> @@ -6025,14 +6024,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	if (lock_extent_direct(inode, lockstart, lockend, &cached_state, create))
>  		return -ENOTBLK;
>  
> -	if (create) {
> -		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> -				     lockend, EXTENT_DELALLOC, NULL,
> -				     &cached_state, GFP_NOFS);
> -		if (ret)
> -			goto unlock_err;
> -	}
> -
>  	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
>  	if (IS_ERR(em)) {
>  		ret = PTR_ERR(em);
> @@ -6064,7 +6055,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
>  			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
>  		free_extent_map(em);
> -		ret = 0;

This doesn't look right, this should be left here.

>  		goto unlock_err;
>  	}
>  
> @@ -6162,6 +6152,11 @@ unlock:
>  		 */
>  		if (start + len > i_size_read(inode))
>  			i_size_write(inode, start + len);
> +
> +		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> +				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
> +				     &cached_state, GFP_NOFS);
> +		BUG_ON(ret);

Return the error if there is one, there's no reason to add new BUG_ON()'s.
Thanks,

Josef
