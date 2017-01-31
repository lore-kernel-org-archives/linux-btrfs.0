Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40846 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdAaPjY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 10:39:24 -0500
Date: Tue, 31 Jan 2017 07:38:22 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: bulk delete checksum items in the same leaf
Message-ID: <20170131153822.GA642@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1485583592-25555-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485583592-25555-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 28, 2017 at 06:06:32AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Very often we have the checksums for an extent spread in multiple items
> in the checksums tree, and currently the algorithm to delete them starts
> by looking for them one by one and then deleting them one by one, which
> is not optimal since each deletion involves shifting all the other items
> in the leaf and when the leaf reaches some low threshold, to move items
> off the leaf into its left and right neighbor leafs. Also, after each
> item deletion we release our search path and start a new search for other
> checksums items.
> 
> So optimize this by deleting in bulk all the items in the same leaf that
> contain checksums for the extent being freed.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/file-item.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index e97e322..d7d6d4a 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -643,7 +643,33 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>  
>  		/* delete the entire item, it is inside our range */
>  		if (key.offset >= bytenr && csum_end <= end_byte) {
> -			ret = btrfs_del_item(trans, root, path);
> +			int del_nr = 1;
> +
> +			/*
> +			 * Check how many csum items preceding this one in this
> +			 * leaf correspond to our range and then delete them all
> +			 * at once.
> +			 */
> +			if (key.offset > bytenr && path->slots[0] > 0) {
> +				int slot = path->slots[0] - 1;
> +
> +				while (slot >= 0) {
> +					struct btrfs_key pk;
> +
> +					btrfs_item_key_to_cpu(leaf, &pk, slot);
> +					if (pk.offset < bytenr ||
> +					    pk.type != BTRFS_EXTENT_CSUM_KEY ||
> +					    pk.objectid !=
> +					    BTRFS_EXTENT_CSUM_OBJECTID)
> +						break;
> +					path->slots[0] = slot;
> +					del_nr++;
> +					key.offset = pk.offset;
> +					slot--;
> +				}
> +			}
> +			ret = btrfs_del_items(trans, root, path,
> +					      path->slots[0], del_nr);
>  			if (ret)
>  				goto out;
>  			if (key.offset == bytenr)
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
