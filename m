Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33973 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdBRAe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 19:34:59 -0500
Date: Fri, 17 Feb 2017 16:34:46 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary constraint when splitting a
 leaf
Message-ID: <20170218003445.GB9399@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1487358964-9758-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487358964-9758-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 17, 2017 at 07:16:04PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we want to append an item to a leaf we were trying to move off from the
> leaf into its neighbors an amount of space corresponding to the item's
> size. That amount of space is too much and can be reduced to the item's
> size minus the amount of free space in the leaf, like we do for all the
> other cases (item inserted at the beginning or somewhere in the middle of
> the leaf).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index a426dc8..86be619 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4130,11 +4130,11 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
>  	int progress = 0;
>  	int slot;
>  	u32 nritems;
> -	int space_needed = data_size;
> +	int space_needed;
>  
>  	slot = path->slots[0];
> -	if (slot < btrfs_header_nritems(path->nodes[0]))
> -		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
> +	space_needed = data_size -
> +		btrfs_leaf_free_space(fs_info, path->nodes[0]);
>  
>  	/*
>  	 * try to push all the items after our slot into the
> @@ -4205,11 +4205,9 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>  
>  	/* first try to make some room by pushing left and right */
>  	if (data_size && path->nodes[1]) {
> -		int space_needed = data_size;
> -
> -		if (slot < btrfs_header_nritems(l))
> -			space_needed -= btrfs_leaf_free_space(fs_info, l);
> +		int space_needed;

One doubt, if (slot == nritems(l)), and push_leaf_right() is with @emtpy == 0,
so it is possible to use the right sibling as the node for the new item, so if
we minus l's free space from space_needed, then it's possible that

(the original space_needed) > (free space of right node) > (the subtracted space_needed)

in that case, we're going to use right node as path->nodes[0] while right node
doesn't have enough space.

Thanks,

-liubo
>  
> +		space_needed = data_size - btrfs_leaf_free_space(fs_info, l);
>  		wret = push_leaf_right(trans, root, path, space_needed,
>  				       space_needed, 0, 0);
>  		if (wret < 0)
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
