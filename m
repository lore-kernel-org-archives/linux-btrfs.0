Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43545 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdBOVTc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:19:32 -0500
Date: Wed, 15 Feb 2017 13:18:37 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/29] btrfs: remove unused parameter from
 __push_leaf_left
Message-ID: <20170215211837.GB19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <5ddf638130041869bf426c8abe6aac0f2651f464.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5ddf638130041869bf426c8abe6aac0f2651f464.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:45AM +0100, David Sterba wrote:
> Unused since long ago.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 2283f92b5484..b98e90a3eee7 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3825,8 +3825,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>   * item at 'max_slot' won't be touched.  Use (u32)-1 to make us do all the
>   * items
>   */
> -static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
> -				     struct btrfs_fs_info *fs_info,
> +static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
>  				     struct btrfs_path *path, int data_size,
>  				     int empty, struct extent_buffer *left,
>  				     int free_space, u32 right_nritems,
> @@ -4035,7 +4034,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>  		goto out;
>  	}
>  
> -	return __push_leaf_left(trans, fs_info, path, min_data_size,
> +	return __push_leaf_left(fs_info, path, min_data_size,
>  			       empty, left, free_space, right_nritems,
>  			       max_slot);
>  out:
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
