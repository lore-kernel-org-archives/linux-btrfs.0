Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46868 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdBOVXJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:23:09 -0500
Date: Wed, 15 Feb 2017 13:21:25 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/29] btrfs: remove unused parameter from tree_move_down
Message-ID: <20170215212125.GD19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <522e0e7934478160a6dd06f87e65fcef486b582d.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <522e0e7934478160a6dd06f87e65fcef486b582d.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:58AM +0100, David Sterba wrote:
> Never needed.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b98e90a3eee7..a981c2acd6fa 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -5241,7 +5241,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>  
>  static int tree_move_down(struct btrfs_fs_info *fs_info,
>  			   struct btrfs_path *path,
> -			   int *level, int root_level)
> +			   int *level)
>  {
>  	struct extent_buffer *eb;
>  
> @@ -5299,7 +5299,7 @@ static int tree_advance(struct btrfs_fs_info *fs_info,
>  		ret = tree_move_next_or_upnext(fs_info, path, level,
>  					       root_level);
>  	} else {
> -		ret = tree_move_down(fs_info, path, level, root_level);
> +		ret = tree_move_down(fs_info, path, level);
>  	}
>  	if (ret >= 0) {
>  		if (*level == 0)
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
