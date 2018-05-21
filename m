Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44353 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbeEUJlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:41:23 -0400
Subject: Re: [PATCH] btrfs: remove unnecessary if judge
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1526895134-1714-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <30512197-9d5b-1d97-6306-dba0246e6192@suse.com>
Date: Mon, 21 May 2018 12:41:21 +0300
MIME-Version: 1.0
In-Reply-To: <1526895134-1714-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.05.2018 12:32, Gu Jinxiang wrote:
> Since add_excluded_extent always returns 0,
> no need to judge ret.

This patch is conceptually wrong because:

a). Currently exclude_super_stripes is in fact buggy since it calls
set_extent_bits which *may* fail, yet the return value is completely
ignored. I think the best fix is to actually handle the failures from
set_extent_bit inside add_excluded_extent and actually propagate them to
callers.

b) If it's deemed appropriate (which I think it's not) to ignore the
return value then add_excluded_extent should be turned into a function
which returns void.


> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75cfb80d2551..4d876b32e136 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -249,8 +249,6 @@ static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
>  		cache->bytes_super += stripe_len;
>  		ret = add_excluded_extent(fs_info, cache->key.objectid,
>  					  stripe_len);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> @@ -282,10 +280,6 @@ static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
>  
>  			cache->bytes_super += len;
>  			ret = add_excluded_extent(fs_info, start, len);
> -			if (ret) {
> -				kfree(logical);
> -				return ret;
> -			}
>  		}
>  
>  		kfree(logical);
> 
