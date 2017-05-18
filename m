Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47768 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933245AbdERPDv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 11:03:51 -0400
Date: Thu, 18 May 2017 08:01:35 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org, #@suse.cz,
        3.16+@suse.cz
Subject: Re: [PATCH] btrfs: use correct types for page indices in
 btrfs_page_exists_in_range
Message-ID: <20170518150133.GB28854@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170517140035.1854-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517140035.1854-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 04:00:35PM +0200, David Sterba wrote:
> Variables start_idx and end_idx are supposed to hold a page index
> derived from the file offsets. The int type is not the right one though,
> offsets larger than 1 << 44 will get silently trimmed off the high bits.
> (1 << 44 is 16TiB)
> 
> What can go wrong, if start is below the boundary and end gets trimmed:
> - if there's a page after start, we'll find it (radix_tree_gang_lookup_slot)
> - the final check "if (page->index <= end_idx)" will unexpectedly fail
> 
> The function will return false, ie. "there's no page in the range",
> although there is at least one.
> 
> btrfs_page_exists_in_range is used to prevent races in:
> 
> * in hole punching, where we make sure there are not pages in the
>   truncated range, otherwise we'll wait for them to finish and redo
>   truncation, but we're going to replace the pages with holes anyway so
>   the only problem is the intermediate state
>

(Not related to the patch, my concern about the race between page fault and
punch hole is that we just retry if one page or more get faulted, which could be
endless in theory.  To avoid that, a lock should be taken before
truncate_pagecache_range.)

> * lock_extent_direct: we want to make sure there are no pages before we
>   lock and start DIO, to prevent stale data reads
> 
> For practical occurence of the bug, there are several constaints.  The
> file must be quite large, the affected range must cross the 16TiB
> boundary and the internal state of the file pages and pending operations
> must match.  Also, we must not have started any ordered data in the
> range, otherwise we don't even reach the buggy function check.
> 
> DIO locking tries hard in several places to avoid deadlocks with
> buffered IO and avoids waiting for ranges. The worst consequence seems
> to be stale data read.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> CC: Liu Bo <bo.li.liu@oracle.com>
> CC: stable@vger.kernel.org	# 3.16+
> Fixes: fc4adbff823f7 ("btrfs: Drop EXTENT_UPTODATE check in hole punching and direct locking")
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 85591d3f3ad9..7237421b4e30 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7359,8 +7359,8 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
>  	bool found = false;
>  	void **pagep = NULL;
>  	struct page *page = NULL;
> -	int start_idx;
> -	int end_idx;
> +	unsigned long start_idx;
> +	unsigned long end_idx;
>  
>  	start_idx = start >> PAGE_SHIFT;
>  
> -- 
> 2.12.0
> 
