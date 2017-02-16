Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40774 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbdBPAO2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 19:14:28 -0500
Date: Wed, 15 Feb 2017 16:12:28 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 29/29] btrfs: remove unused parameter from
 adjust_slots_upwards
Message-ID: <20170216001228.GP19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <3b7ce86c208631f625555daf477c7d18604db297.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3b7ce86c208631f625555daf477c7d18604db297.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:50AM +0100, David Sterba wrote:
> Never used.
> 
Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/qgroup.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 6d106e623604..4ef513a392a7 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1589,8 +1589,7 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
>   * If we increment the root nodes slot counter past the number of
>   * elements, 1 is returned to signal completion of the search.
>   */
> -static int adjust_slots_upwards(struct btrfs_root *root,
> -				struct btrfs_path *path, int root_level)
> +static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
>  {
>  	int level = 0;
>  	int nr, slot;
> @@ -1731,7 +1730,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>  				goto out;
>  
>  			/* Nonzero return here means we completed our search */
> -			ret = adjust_slots_upwards(root, path, root_level);
> +			ret = adjust_slots_upwards(path, root_level);
>  			if (ret)
>  				break;
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
