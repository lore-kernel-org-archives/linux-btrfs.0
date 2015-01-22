Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAVXqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 18:46:43 -0500
Date: Fri, 23 Jan 2015 07:46:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix setup_leaf_for_split() to avoid leaf
 corruption
Message-ID: <20150122234632.GA30838@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1421757653-14370-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421757653-14370-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 12:40:53PM +0000, Filipe Manana wrote:
> We were incorrectly detecting when the target key didn't exist anymore
> after releasing the path and re-searching the tree. This could make
> us split or duplicate (btrfs_split_item() and btrfs_duplicate_item()
> are its only callers at the moment) an item when we should not.
> 
> For the case of duplicating an item, we currently only duplicate
> checksum items (csum tree) and file extent items (fs/subvol trees).
> For the checksum items we end up overriding the item completely,
> but for file extent items we update only some of their fields in
> the copy (done in __btrfs_drop_extents), which means we can end up
> having a logical corruption for some values.
> 
> Also for the case where we duplicate a file extent item it will make
> us produce a leaf with a wrong key order, as btrfs_duplicate_item()
> advances us to the next slot and then its caller sets a smaller key
> on the new item at that slot (like in __btrfs_drop_extents() e.g.).
> Alternatively if the tree search in setup_leaf_for_split() leaves
> with path->slots[0] == btrfs_header_nritems(path->nodes[0]), we end
> up accessing beyond the leaf's end (when we check if the item's size
> has changed) and make our caller insert an item at the invalid slot
> btrfs_header_nritems(path->nodes[0]) + 1, causing an invalid memory
> access if the leaf is full or nearly full.

Good catch, it's just the similar case as what commit 0b43e04f
("Btrfs: fix leaf corruption after __btrfs_drop_extents") fixes.
    
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> This issue has been present since the introduction of this function
> in 2009:
> 
>     Btrfs: Add btrfs_duplicate_item
>     commit ad48fd754676bfae4139be1a897b1ea58f9aaf21
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 14a72ed..78e8993c1 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4356,13 +4356,15 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
>  	path->search_for_split = 1;
>  	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
>  	path->search_for_split = 0;
> +	if (ret > 0)
> +		ret = -EAGAIN;
>  	if (ret < 0)
>  		goto err;
>  
>  	ret = -EAGAIN;
>  	leaf = path->nodes[0];
> -	/* if our item isn't there or got smaller, return now */
> -	if (ret > 0 || item_size != btrfs_item_size_nr(leaf, path->slots[0]))
> +	/* if our item isn't there, return now */
> +	if (item_size != btrfs_item_size_nr(leaf, path->slots[0]))
>  		goto err;
>  
>  	/* the leaf has  changed, it now has room.  return now */
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
