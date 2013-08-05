Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3HEIpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 04:45:00 -0400
Message-ID: <51FF6646.502@cn.fujitsu.com>
Date: Mon, 05 Aug 2013 16:45:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: don't ignore errors from btrfs_run_delayed_items
References: <1375662326-23444-1-git-send-email-fdmanana@gmail.com> <1375691147-10428-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375691147-10428-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 5 Aug 2013 09:25:47 +0100, Filipe David Borba Manana wrote:
> tree-log.c was ignoring the return value from btrfs_run_delayed_items()
> in several places.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Ensure no line exceeds 80 characters.

Looks good to me.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> 
>  fs/btrfs/tree-log.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index ff60d89..f90ae35 100644
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
> @@ -990,7 +993,9 @@ again:
>  								 inode,
>  								 victim_name,
>  								 victim_name_len);
> -					btrfs_run_delayed_items(trans, root);
> +					if (!ret)
> +						ret = btrfs_run_delayed_items(
> +								  trans, root);
>  				}
>  				iput(victim_parent);
>  				kfree(victim_name);
> @@ -1810,7 +1815,7 @@ again:
>  			ret = btrfs_unlink_inode(trans, root, dir, inode,
>  						 name, name_len);
>  			if (!ret)
> -				btrfs_run_delayed_items(trans, root);
> +				ret = btrfs_run_delayed_items(trans, root);
>  			kfree(name);
>  			iput(inode);
>  			if (ret)
> 

