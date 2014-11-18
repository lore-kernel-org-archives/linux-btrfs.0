Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32848 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKRHNR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 02:13:17 -0500
Date: Tue, 18 Nov 2014 15:13:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not move em to modified list when unpinning
Message-ID: <20141118071308.GB12504@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1415999790-4144-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415999790-4144-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 04:16:30PM -0500, Josef Bacik wrote:
> We use the modified list to keep track of which extents have been modified so we
> know which ones are candidates for logging at fsync() time.  Newly modified
> extents are added to the list at modification time, around the same time the
> ordered extent is created.  We do this so that we don't have to wait for ordered
> extents to complete before we know what we need to log.  The problem is when
> something like this happens
> 
> log extent 0-4k on inode 1
> copy csum for 0-4k from ordered extent into log
> sync log
> commit transaction
> log some other extent on inode 1
> ordered extent for 0-4k completes and adds itself onto modified list again
> log changed extents
> see ordered extent for 0-4k has already been logged
> 	at this point we assume the csum has been copied
> sync log
> crash
> 
> On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
> which is the same one that we are replaying which also drops the csum, and then
> we won't find the csum in the log for that bytenr.  This of course causes us to
> have errors about not having csums for certain ranges of our inode.  So remove
> the modified list manipulation in unpin_extent_cache, any modified extents
> should have been added well before now, and we don't want them re-logged.  This
> fixes my test that I could reliably reproduce this problem with.  Thanks,

This will make em->generation remain -1 in the above case, no?

Csum is copied after ordered extent is set with "IO_DONE", but before
unpin_extent_cache(), "sync log" happens, so if we dont have it 're-logged',
em->generation will not get updated so that the btrfs_file_extent_item's generation will not be
updated.

thanks,
-liubo

> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent_map.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 225302b..6a98bdd 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -287,8 +287,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
>  	if (!em)
>  		goto out;
>  
> -	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
> -		list_move(&em->list, &tree->modified_extents);
>  	em->generation = gen;
>  	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
>  	em->mod_start = em->start;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
