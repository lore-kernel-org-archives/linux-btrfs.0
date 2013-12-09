Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3LICkE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Dec 2013 21:40:04 -0500
Date: Mon, 9 Dec 2013 10:39:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't miss skinny extent items on delayed ref
 head contention
Message-ID: <20131209023955.GB32246@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1386462389-25218-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386462389-25218-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 08, 2013 at 12:26:29AM +0000, Filipe David Borba Manana wrote:
> Currently extent-tree.c:btrfs_lookup_extent_info() can miss the lookup
> of skinny extent items. This can happen when the execution flow is the
> following:
> 
> * We do an extent tree lookup and fail to find a skinny extent item;
> 
> * As a result, we attempt to see if a non-skinny extent item exists,
>   either by looking at previous item in the leaf or by doing another
>   full extent tree search;
> 
> * We have a transaction and then we check for a matching delayed ref
>   head in the transaction's delayed refs rbtree;
> 
> * We find such delayed ref head and then we try to lock it with a
>   call to mutex_trylock();
> 
> * The lock was contended so we jump to the label "again", which repeats
>   the extent tree search but for a non-skinny extent item, because we set
>   previously metadata variable to 0 and the search key to look for a
>   non-skinny extent-item;
> 
> * After the jump (and after releasing the transaction's delayed refs
>   lock), a skinny extent item might have been added to the extent tree
>   but we will miss it because metadata is set to 0 and the search key
>   is set for a non-skinny extent-item.
> 
> The fix here is to not reset metadata to 0 and to jump to the initial search
> key setup if the delayed ref head is contended, instead of jumping directly
> to the extent tree search label ("again").
> 
> This issue was found while investigating the issue reported at Bugzilla 64961.
> 
> David Sterba suspected this function was missing extent items, and that
> this could be caused by the last change to this function, which was made
> in the following patch:
> 
>     [PATCH] Btrfs: optimize btrfs_lookup_extent_info()
>     (commit 74be9510876a66ad9826613ac8a526d26f9e7f01)
> 
> But in fact this issue already existed before, because after failing to find
> a skinny extent item, the code set the search key for a non-skinny extent
> item, and on contention of a matching delayed ref head it would not search
> the extent tree for a skinny extent item anymore.

Make sense.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/extent-tree.c |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 62d433f..c9f020e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -769,20 +769,19 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>  	if (!path)
>  		return -ENOMEM;
>  
> -	if (metadata) {
> -		key.objectid = bytenr;
> -		key.type = BTRFS_METADATA_ITEM_KEY;
> -		key.offset = offset;
> -	} else {
> -		key.objectid = bytenr;
> -		key.type = BTRFS_EXTENT_ITEM_KEY;
> -		key.offset = offset;
> -	}
> -
>  	if (!trans) {
>  		path->skip_locking = 1;
>  		path->search_commit_root = 1;
>  	}
> +
> +search_again:
> +	key.objectid = bytenr;
> +	key.offset = offset;
> +	if (metadata)
> +		key.type = BTRFS_METADATA_ITEM_KEY;
> +	else
> +		key.type = BTRFS_EXTENT_ITEM_KEY;
> +
>  again:
>  	ret = btrfs_search_slot(trans, root->fs_info->extent_root,
>  				&key, path, 0, 0);
> @@ -790,7 +789,6 @@ again:
>  		goto out_free;
>  
>  	if (ret > 0 && metadata && key.type == BTRFS_METADATA_ITEM_KEY) {
> -		metadata = 0;
>  		if (path->slots[0]) {
>  			path->slots[0]--;
>  			btrfs_item_key_to_cpu(path->nodes[0], &key,
> @@ -857,7 +855,7 @@ again:
>  			mutex_lock(&head->mutex);
>  			mutex_unlock(&head->mutex);
>  			btrfs_put_delayed_ref(&head->node);
> -			goto again;
> +			goto search_again;
>  		}
>  		if (head->extent_op && head->extent_op->update_flags)
>  			extent_flags |= head->extent_op->flags_to_set;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
