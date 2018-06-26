Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932072AbeFZRUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 13:20:22 -0400
Date: Tue, 26 Jun 2018 19:17:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix regression in btrfs_page_mkwrite() from
 vm_fault_t conversion
Message-ID: <20180626171729.GO27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625170341.101319-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180625170341.101319-1-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 10:03:41AM -0700, Chris Mason wrote:
> The vm_fault_t conversion commit introduced a ret2 variable for tracking
> the integer return values from internal btrfs functions.  It was
> sometimes returning VM_FAULT_LOCKED for pages that were actually invalid
> and had been removed from the radix.  Something like this:
> 
>     ret2 = btrfs_delalloc_reserve_space() // returns zero on success
> 
>     lock_page(page)
>     if (page->mapping != inode->i_mapping)
> 	goto out_unlock;
> 
> ...
> 
> out_unlock:
>     if (!ret2) {
> 	    ...
> 	    return VM_FAULT_LOCKED;
>     }
> 
> This ends up triggering this WARNING in btrfs_destroy_inode()
>     WARN_ON(BTRFS_I(inode)->block_rsv.size);
> 
> xfstests generic/095 was able to reliably reproduce the errors.
> 
> Since out_unlock: is only used for errors, this fix moves it below the
> if (!ret2) check we use to return VM_FAULT_LOCKED for success.
> 
> Fixes: a528a2415087 (btrfs: change return type of btrfs_page_mkwrite to vm_fault_t)
> Signed-off-by: Chris Mason <clm@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

also passed the tests here standalone and with the fixup worker fixes.
