Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab3HECUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 22:20:45 -0400
Message-ID: <51FF0C38.7060907@cn.fujitsu.com>
Date: Mon, 05 Aug 2013 10:21:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't ignore errors from btrfs_run_delayed_items
References: <1375662326-23444-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375662326-23444-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 5 Aug 2013 01:25:26 +0100, Filipe David Borba Manana wrote:
> tree-log.c was ignoring the return value from btrfs_run_delayed_items()
> in several places.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/tree-log.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index ff60d89..f919f26 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -747,7 +747,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
>  	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
>  	if (ret)
>  		goto out;
> -	btrfs_run_delayed_items(trans, root);
> +	else
> +		ret = btrfs_run_delayed_items(trans, root);
>  out:
>  	kfree(name);
>  	iput(inode);
> @@ -923,7 +924,9 @@ again:
>  				kfree(victim_name);
>  				if (ret)
>  					return ret;
> -				btrfs_run_delayed_items(trans, root);
> +				ret = btrfs_run_delayed_items(trans, root);
> +				if (ret)
> +					return ret;
>  				*search_done = 1;
>  				goto again;
>  			}
> @@ -990,7 +993,8 @@ again:
>  								 inode,
>  								 victim_name,
>  								 victim_name_len);
> -					btrfs_run_delayed_items(trans, root);
> +					if (!ret)
> +						ret = btrfs_run_delayed_items(trans, root);

checkpatch.pl reported:

WARNING: line over 80 characters
#141: FILE: fs/btrfs/tree-log.c:997:
+						ret = btrfs_run_delayed_items(trans, root);

The other code is OK.

Thanks
Miao

>  				}
>  				iput(victim_parent);
>  				kfree(victim_name);
> @@ -1810,7 +1814,7 @@ again:
>  			ret = btrfs_unlink_inode(trans, root, dir, inode,
>  						 name, name_len);
>  			if (!ret)
> -				btrfs_run_delayed_items(trans, root);
> +				ret = btrfs_run_delayed_items(trans, root);
>  			kfree(name);
>  			iput(inode);
>  			if (ret)
> 

