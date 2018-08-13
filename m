Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728240AbeHMJnW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 05:43:22 -0400
Subject: Re: [PATCH] btrfs:free-space-cache: remove unneeded NULL check before
 kfree
To: zhong jiang <zhongjiang@huawei.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1534140369-11578-1-git-send-email-zhongjiang@huawei.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <50a4185c-5276-e33a-afff-102ed32171f2@suse.com>
Date: Mon, 13 Aug 2018 10:02:23 +0300
MIME-Version: 1.0
In-Reply-To: <1534140369-11578-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.08.2018 09:06, zhong jiang wrote:
> Kfree has taken the null pointer into account. So remove the check
> before kfree.
> 
> The issue is detected with the help of Coccinelle.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/free-space-cache.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index c3888c1..69d639f 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2110,8 +2110,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
>  
>  out:
>  	if (info) {
> -		if (info->bitmap)
> -			kfree(info->bitmap);
> +		kfree(info->bitmap);
>  		kmem_cache_free(btrfs_free_space_cachep, info);
>  	}
>  
> @@ -3605,8 +3604,7 @@ int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
>  
>  	if (info)
>  		kmem_cache_free(btrfs_free_space_cachep, info);
> -	if (map)
> -		kfree(map);
> +	kfree(map);
>  	return 0;
>  }
>  
> 
