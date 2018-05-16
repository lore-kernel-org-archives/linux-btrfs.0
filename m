Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbeEPHJ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 03:09:27 -0400
Subject: Re: [PATCH 5/6] Btrfs: grab write lock directly if write_lock_level
 is the max level
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-6-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0f3bb28d-b80a-4dbc-7ee2-61e7b67c86d6@suse.com>
Date: Wed, 16 May 2018 10:09:25 +0300
MIME-Version: 1.0
In-Reply-To: <1526406728-109055-6-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 20:52, Liu Bo wrote:
> In case of (cow && (p->keep_locks || p->lowest_level)), write_lock_level
> is the max level, and we should grab write lock of root node from the very
> beginning.

THis needs to be expanded to explain what are the adverse effects (if
any) without this commit. And then explain how this commit actually
improve things.

> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/ctree.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index cf34eca41d4e..f7c3f581f647 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2633,20 +2633,23 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>  		goto out;
>  	}
>  
> -	/*
> -	 * we don't know the level of the root node until we actually
> -	 * have it read locked
> -	 */
> -	b = btrfs_read_lock_root_node(root);
> -	level = btrfs_header_level(b);
> -	if (level > write_lock_level)
> -		goto out;
> +	if (write_lock_level < BTRFS_MAX_LEVEL) {
> +		/*
> +		 * we don't know the level of the root node until we actually
> +		 * have it read locked
> +		 */
> +		b = btrfs_read_lock_root_node(root);
> +		level = btrfs_header_level(b);
> +		if (level > write_lock_level)
> +			goto out;
> +
> +		/*
> +		 * whoops, must trade for write lock
> +		 */
> +		btrfs_tree_read_unlock(b);
> +		free_extent_buffer(b);
> +	}

Here just seems you are adding 1 extra branch so more context please.

>  
> -	/*
> -	 * whoops, must trade for write lock
> -	 */
> -	btrfs_tree_read_unlock(b);
> -	free_extent_buffer(b);
>  	b = btrfs_lock_root_node(root);
>  	root_lock = BTRFS_WRITE_LOCK;
>  	/*
> 
