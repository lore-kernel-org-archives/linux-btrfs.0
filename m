Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62179 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbaFWKOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 06:14:44 -0400
Message-ID: <53A7FE82.3070303@cn.fujitsu.com>
Date: Mon, 23 Jun 2014 18:16:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Refactor btrfs_lock_cluster() to kill compiler
 warning
References: <1403440209-13370-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1403440209-13370-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 22 Jun 2014 14:30:09 +0200, Geert Uytterhoeven wrote:
> fs/btrfs/extent-tree.c: In function ‘btrfs_lock_cluster’:
> fs/btrfs/extent-tree.c:6399: warning: ‘used_bg’ may be used uninitialized in this function
> 
>   - Replace "again: ... goto again;" by standard C "while (1) { ... }",
>   - Move block not processed during the first iteration of the loop to the
>     end of the loop, which allows to kill the "locked" variable,
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Looks good to me.

Reviewed-and-Tested-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
> Please review, compile tested only.
> ---
>  fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++----------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 99c253918208..e151c4a73d7b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6397,36 +6397,34 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
>  		   int delalloc)
>  {
>  	struct btrfs_block_group_cache *used_bg;
> -	bool locked = false;
> -again:
> +
>  	spin_lock(&cluster->refill_lock);
> -	if (locked) {
> -		if (used_bg == cluster->block_group)
> -			return used_bg;
> +	while (1) {
> +		used_bg = cluster->block_group;
> +		if (!used_bg)
> +			return NULL;
>  
> -		up_read(&used_bg->data_rwsem);
> -		btrfs_put_block_group(used_bg);
> -	}
> +		if (used_bg == block_group)
> +			return used_bg;
>  
> -	used_bg = cluster->block_group;
> -	if (!used_bg)
> -		return NULL;
> +		btrfs_get_block_group(used_bg);
>  
> -	if (used_bg == block_group)
> -		return used_bg;
> +		if (!delalloc)
> +			return used_bg;
>  
> -	btrfs_get_block_group(used_bg);
> +		if (down_read_trylock(&used_bg->data_rwsem))
> +			return used_bg;
>  
> -	if (!delalloc)
> -		return used_bg;
> +		spin_unlock(&cluster->refill_lock);
> +		down_read(&used_bg->data_rwsem);
>  
> -	if (down_read_trylock(&used_bg->data_rwsem))
> -		return used_bg;
> +		spin_lock(&cluster->refill_lock);
> +		if (used_bg == cluster->block_group)
> +			return used_bg;
>  
> -	spin_unlock(&cluster->refill_lock);
> -	down_read(&used_bg->data_rwsem);
> -	locked = true;
> -	goto again;
> +		up_read(&used_bg->data_rwsem);
> +		btrfs_put_block_group(used_bg);
> +	}
>  }
>  
>  static inline void
> 

