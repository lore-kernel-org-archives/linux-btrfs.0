Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52343 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933144AbeFYN5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 09:57:04 -0400
Date: Mon, 25 Jun 2018 15:54:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix regression in btrfs_page_mkwrite() from
 vm_fault_t conversion
Message-ID: <20180625135411.GD27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625134532.3889459-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180625134532.3889459-1-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 06:45:32AM -0700, Chris Mason wrote:
> The vm_fault_t conversion commit introduced a ret2 variable for
> tracking the integer return values from internal btrfs functions.  It
> was sometimes returning VM_FAULT_LOCKED for pages that were actually
> invalid and had been removed from the radix.  Something like this:
> 
> 	ret2 = btrfs_delalloc_reserve_space() // returns zero on success
> 
> 	lock_page(page)
> 	if (page->mapping != inode->i_mapping)
> 	    goto out_unlock;
> 
> ...
> 
> out_unlock:
> 	if (!ret2) {
> 		...
> 		return VM_FAULT_LOCKED;
> 	}
> 
> This ends up triggering this WARNING in btrfs_destroy_inode()
> 	WARN_ON(BTRFS_I(inode)->block_rsv.size);
> 
> The fix used here is to use ret instead of ret2 in our check for success.
> 
> Fixes: a528a2415087 (btrfs: change return type of btrfs_page_mkwrite to vm_fault_t)
> Signed-off-by: Chris Mason <clm@fb.com>
> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 193f933..38403aa 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9013,6 +9013,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>  		goto out_unlock;
>  	}
>  	ret2 = 0;
> +	ret = 0;

That's something I'd rather avoid, now there are two error values that
need to be tracked. Shouldn't the 'ret2 = 0' be removed completely?

>  
>  	/* page is wholly or partially inside EOF */
>  	if (page_start + PAGE_SIZE > size)
> @@ -9037,7 +9038,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>  	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
>  
>  out_unlock:
> -	if (!ret2) {
> +	if (!ret) {

I'm not sure is safe, the new ret is one of the VM_FAULT_ values and
it's not 0 by default and in fact I don't see anything that would set it
to 0 directly or indirectly. Which means that the code in the out: label
also needs to be revisited:

9016 out:
9017         btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
9018         btrfs_delalloc_release_space(inode, data_reserved, page_start,
9019                                      reserved_space, (ret != 0));

>  		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
>  		sb_end_pagefault(inode->i_sb);
>  		extent_changeset_free(data_reserved);
