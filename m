Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOVPK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:15:10 -0500
Date: Wed, 15 Feb 2017 13:14:16 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/29] btrfs: remove unused parameter from
 __push_leaf_right
Message-ID: <20170215211415.GC12445@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <18a2895c6859246d061ada47912e18283d19bbb6.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18a2895c6859246d061ada47912e18283d19bbb6.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:42AM +0100, David Sterba wrote:
> Unused since long ago.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 4c5d7c40c8bf..2283f92b5484 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3595,8 +3595,7 @@ noinline int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
>   * min slot controls the lowest index we're willing to push to the
>   * right.  We'll push up to and including min_slot, but no lower
>   */
> -static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
> -				      struct btrfs_fs_info *fs_info,
> +static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
>  				      struct btrfs_path *path,
>  				      int data_size, int empty,
>  				      struct extent_buffer *right,
> @@ -3810,7 +3809,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>  		return 0;
>  	}
>  
> -	return __push_leaf_right(trans, fs_info, path, min_data_size, empty,
> +	return __push_leaf_right(fs_info, path, min_data_size, empty,
>  				right, free_space, left_nritems, min_slot);
>  out_unlock:
>  	btrfs_tree_unlock(right);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
