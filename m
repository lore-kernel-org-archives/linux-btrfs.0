Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934051Ab3FSBz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 21:55:58 -0400
Message-ID: <51C10FFA.3010307@cn.fujitsu.com>
Date: Wed, 19 Jun 2013 09:57:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Djalal Harouni <tixxdz@opendz.org>
CC: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not ignore errors when truncating the free
 space cache inode
References: <1371592661-11167-1-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1371592661-11167-1-git-send-email-tixxdz@opendz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was fixed by Wei Yongjun

http://marc.info/?l=linux-btrfs&m=136910396606489&w=2

Thanks
Miao

On tue, 18 Jun 2013 22:57:41 +0100, Djalal Harouni wrote:
> btrfs_check_trunc_cache_free_space() tries to check if there is enough
> space for cache inode truncation but it fails.
> 
> Currently this function always returns success even if there is no
> enough space. Fix this by returning the -ENOSPC error code.
> 
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
> Totally untested code.
> 
>  fs/btrfs/free-space-cache.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 2750b50..9629830 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -201,7 +201,7 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
>  				       struct btrfs_block_rsv *rsv)
>  {
>  	u64 needed_bytes;
> -	int ret;
> +	int ret = 0;
>  
>  	/* 1 for slack space, 1 for updating the inode */
>  	needed_bytes = btrfs_calc_trunc_metadata_size(root, 1) +
> @@ -210,10 +210,10 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
>  	spin_lock(&rsv->lock);
>  	if (rsv->reserved < needed_bytes)
>  		ret = -ENOSPC;
> -	else
> -		ret = 0;
> +
>  	spin_unlock(&rsv->lock);
> -	return 0;
> +
> +	return ret;
>  }
>  
>  int btrfs_truncate_free_space_cache(struct btrfs_root *root,
> 

