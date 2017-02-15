Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32071 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdBOVXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:23:01 -0500
Date: Wed, 15 Feb 2017 13:22:06 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/29] btrfs: remove unused parameter from
 tree_move_next_or_upnext
Message-ID: <20170215212206.GE19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <760c406686a36b6bedcb07ee3a600d460c37cc13.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <760c406686a36b6bedcb07ee3a600d460c37cc13.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:01AM +0100, David Sterba wrote:
> Not needed.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index a981c2acd6fa..1192bc7d2ee7 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -5256,8 +5256,7 @@ static int tree_move_down(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> -static int tree_move_next_or_upnext(struct btrfs_fs_info *fs_info,
> -				    struct btrfs_path *path,
> +static int tree_move_next_or_upnext(struct btrfs_path *path,
>  				    int *level, int root_level)
>  {
>  	int ret = 0;
> @@ -5296,8 +5295,7 @@ static int tree_advance(struct btrfs_fs_info *fs_info,
>  	int ret;
>  
>  	if (*level == 0 || !allow_down) {
> -		ret = tree_move_next_or_upnext(fs_info, path, level,
> -					       root_level);
> +		ret = tree_move_next_or_upnext(path, level, root_level);
>  	} else {
>  		ret = tree_move_down(fs_info, path, level);
>  	}
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
