Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32499 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdBVAIO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 19:08:14 -0500
Date: Tue, 21 Feb 2017 16:07:56 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: try harder to migrate items to left sibling
 before splitting a leaf
Message-ID: <20170222000756.GD32725@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1487537799-17570-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487537799-17570-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 19, 2017 at 08:56:39PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Before attempting to split a leaf we try to migrate items from the leaf to
> its right and left siblings. We start by trying to move items into the
> rigth sibling and, if the new item is meant to be inserted at the end of
> our leaf, we try to free from our leaf an amount of bytes equal to the
> number of bytes used by the new item, by setting the variable space_needed
> to the byte size of that new item. However if we fail to move enough items
> to the right sibling due to lack of space in that sibling, we then try
> to move items into the left sibling, and in that case we try to free
> an amount equal to the size of the new item from our leaf, when we need
> only to free an amount corresponding to the size of the new item minus
> the current free space of our leaf. So make sure that before we try to
> move items to the left sibling we do set the variable space_needed with
> a value corresponding to the new item's size minus the leaf's current
> free space.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index a426dc8..1d66761 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4160,6 +4160,9 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
>  
>  	/* try to push all the items before our slot into the next leaf */
>  	slot = path->slots[0];
> +	space_needed = data_size;
> +	if (slot > 0)
> +		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);

Good point.

>  	ret = push_leaf_left(trans, root, path, 1, space_needed, 0, slot);
>  	if (ret < 0)
>  		return ret;
> @@ -4215,6 +4218,10 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>  		if (wret < 0)
>  			return wret;
>  		if (wret) {
> +			space_needed = data_size;
> +			if (slot > 0)
> +				space_needed -= btrfs_leaf_free_space(fs_info,
> +								      l);

Not sure if we need this, the above push_leaf_right() was called with
@min_data_size == space_needed, thus if @wret == 1, no items have been moved in
push_leaf_right() so that leaf 'l' remains unchanged.

Thanks,

-liubo
>  			wret = push_leaf_left(trans, root, path, space_needed,
>  					      space_needed, 0, (u32)-1);
>  			if (wret < 0)
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
