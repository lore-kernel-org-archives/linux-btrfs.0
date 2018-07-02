Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752756AbeGBHk5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 03:40:57 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AEE0ACE7
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 07:40:56 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: free-space-cache: Don't panic when free
 space cache is corrupted
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180701024526.25740-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3fca50d7-a539-63d5-444b-646bd21b8176@suse.com>
Date: Mon, 2 Jul 2018 10:40:55 +0300
MIME-Version: 1.0
In-Reply-To: <20180701024526.25740-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.07.2018 05:45, Qu Wenruo wrote:
> In btrfs_add_free_space(), if the free space to be added is already
> here, we trigger ASSERT() which is just another BUG_ON().
> 
> Let's remove such BUG_ON() at all.
> 
> Reported-by: Lewis Diamond <me@lewisdiamond.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  free-space-cache.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/free-space-cache.c b/free-space-cache.c
> index 9b83a71ca59a..2ef2d307cc5d 100644
> --- a/free-space-cache.c
> +++ b/free-space-cache.c
> @@ -838,10 +838,8 @@ int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
>  	try_merge_free_space(ctl, info);
>  
>  	ret = link_free_space(ctl, info);
> -	if (ret) {
> +	if (ret)
>  		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
> -		BUG_ON(ret == -EEXIST);
> -	}
>  
>  	return ret;
>  }
> 
