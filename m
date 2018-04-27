Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757642AbeD0I26 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 04:28:58 -0400
Subject: Re: [PATCH] btrfs: modify path->reada in btrfs_shrink_device to
 READA_BACK
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1524817327-32038-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b7ca6e41-ac5d-cffe-7cbc-1e0b5ab07c9a@suse.com>
Date: Fri, 27 Apr 2018 11:28:55 +0300
MIME-Version: 1.0
In-Reply-To: <1524817327-32038-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.04.2018 11:22, Gu Jinxiang wrote:
> In btrfs_shrink_device, before btrfs_search_slot, path->reada is
> set to READA_FORWARD. But I think READA_BACK is correct.
> Since,
>  1.key.offset is set to (u64)-1
>  2.After btrfs_search_slot, btrfs_previous_item is called.
> So, for readahead previous items, READA_BACK is correct one.

My analysis arrives at the same conclusions so:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 292266f6ab9c..1a3506a3003d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4473,7 +4473,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	if (!path)
>  		return -ENOMEM;
>  
> -	path->reada = READA_FORWARD;
> +	path->reada = READA_BACK;
>  
>  	mutex_lock(&fs_info->chunk_mutex);
>  
> 
