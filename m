Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56028 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2INLhG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 07:37:06 -0400
Date: Fri, 14 Sep 2012 13:36:59 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] Btrfs: cleanup for duplicated code in
 find_free_extent
Message-ID: <20120914113659.GH17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347613087-3489-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 04:58:05PM +0800, Liu Bo wrote:
> There is already an 'add free space' phrase in front of this one, we
> needn't to redo it.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Yes, the check is duplicate and the values cannot change inbetween,
moreover this calls the add_free_space twice, to it's likely to fix
things (or not, the whole function is a mess and I'm not sticking my
reviewed-by tag).

Also, the return value of btrfs_add_free_space should be checked, as it
may silently fail in case of ENOMEM, and fail loudly if there's failure
in:

  btrfs_add_free_space
    __btrfs_add_free_space
      - either link_free_space
      - or insert_into_bitmap
        fail with -EEXIST
      BUG_ON

I saw the crash inside insert_into_bitmap in logs from yesterday, I
haven't processed them yet, but it looks that it matches this situation.

> ---
>  fs/btrfs/extent-tree.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ba58024..6575f89 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5806,10 +5806,6 @@ checks:
>  
>  		trace_btrfs_reserve_extent(orig_root, block_group,
>  					   search_start, num_bytes);
> -		if (offset < search_start)
> -			btrfs_add_free_space(used_block_group, offset,
> -					     search_start - offset);
> -		BUG_ON(offset > search_start);
>  		if (used_block_group != block_group)
>  			btrfs_put_block_group(used_block_group);
>  		btrfs_put_block_group(block_group);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
