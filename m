Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:35117 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2JWQAx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 12:00:53 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9NFU6LH003574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 15:30:06 GMT
Message-ID: <5086B7A5.106@oracle.com>
Date: Tue, 23 Oct 2012 23:28:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: fix a tree mod logging issue for root replacement
 operations
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-3-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> Avoid the implicit free by tree_mod_log_set_root_pointer, which is wrong in
> two places. Where needed, we call tree_mod_log_free_eb explicitly now.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 44a7e25..e6b75cc 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -647,8 +647,6 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  	if (tree_mod_dont_log(fs_info, NULL))
>  		return 0;
>  
> -	__tree_mod_log_free_eb(fs_info, old_root);
> -
>  	ret = tree_mod_alloc(fs_info, flags, &tm);
>  	if (ret < 0)
>  		goto out;
> @@ -926,12 +924,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
>  			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
>  			BUG_ON(ret); /* -ENOMEM */
>  		}
> -		/*
> -		 * don't log freeing in case we're freeing the root node, this
> -		 * is done by tree_mod_log_set_root_pointer later
> -		 */
> -		if (buf != root->node && btrfs_header_level(buf) != 0)
> -			tree_mod_log_free_eb(root->fs_info, buf);
> +		tree_mod_log_free_eb(root->fs_info, buf);

Since we've owned a check for if eb's level is 0 in tree_mod_dont_log(),
we can also get rid of these level checks in other places, can't we?

>  		clean_tree_block(trans, root, buf);
>  		*last_ref = 1;
>  	}
> @@ -1728,6 +1721,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  			goto enospc;
>  		}
>  
> +		tree_mod_log_free_eb(root->fs_info, root->node);
>  		tree_mod_log_set_root_pointer(root, child);
>  		rcu_assign_pointer(root->node, child);
>  
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Tested-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo
