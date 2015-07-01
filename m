Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20167 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbbGAOr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 10:47:26 -0400
Date: Wed, 1 Jul 2015 22:47:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 12/21] Btrfs: subpagesize-blocksize: Search for
 all ordered extents that could span across a page.
Message-ID: <20150701144709.GE7847@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-13-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-13-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:47PM +0530, Chandan Rajendra wrote:
> In subpagesize-blocksize scenario it is not sufficient to search using the
> first byte of the page to make sure that there are no ordered extents
> present across the page. Fix this.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/extent_io.c | 3 ++-
>  fs/btrfs/inode.c     | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 14b4e05..0b017e1 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3244,7 +3244,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>  
>  	while (1) {
>  		lock_extent(tree, start, end);
> -		ordered = btrfs_lookup_ordered_extent(inode, start);
> +		ordered = btrfs_lookup_ordered_range(inode, start,
> +						PAGE_CACHE_SIZE);

A minor suggestion, it'd be better to include the new prototype in the
same patch, which will be benefit to later cherry-picking or reverting.

Thanks,

-liubo
>  		if (!ordered)
>  			break;
>  		unlock_extent(tree, start, end);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e9bab73..8b4aaed 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1976,7 +1976,7 @@ again:
>  	if (PagePrivate2(page))
>  		goto out;
>  
> -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
>  	if (ordered) {
>  		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
>  				     page_end, &cached_state, GFP_NOFS);
> @@ -8513,7 +8513,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
>  
>  	if (!inode_evicting)
>  		lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
> -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_CACHE_SIZE);
>  	if (ordered) {
>  		/*
>  		 * IO on this page will never be started, so we need
> -- 
> 2.1.0
> 
