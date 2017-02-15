Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42765 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdBOUoS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:44:18 -0500
Date: Wed, 15 Feb 2017 12:43:24 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/29] btrfs: remove unused parameter from split_item
Message-ID: <20170215204324.GD11220@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <131f5894701d44f5e855de99f5c8334b316bc1de.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <131f5894701d44f5e855de99f5c8334b316bc1de.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:33AM +0100, David Sterba wrote:
> Never used.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index d509dafdb20c..4c5d7c40c8bf 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4413,8 +4413,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static noinline int split_item(struct btrfs_trans_handle *trans,
> -			       struct btrfs_fs_info *fs_info,
> +static noinline int split_item(struct btrfs_fs_info *fs_info,
>  			       struct btrfs_path *path,
>  			       const struct btrfs_key *new_key,
>  			       unsigned long split_offset)
> @@ -4511,7 +4510,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		return ret;
>  
> -	ret = split_item(trans, root->fs_info, path, new_key, split_offset);
> +	ret = split_item(root->fs_info, path, new_key, split_offset);
>  	return ret;
>  }
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,

-liubo
