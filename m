Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbeIEK3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 06:29:30 -0400
Subject: Re: [PATCH v2] Btrfs: remove confusing tracepoint in
 btrfs_add_reserved_bytes
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536111445-126664-1-git-send-email-bo.liu@linux.alibaba.com>
 <1536112527-16758-1-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ca61572f-1a26-8f89-b0e0-587978fc8dd1@suse.com>
Date: Wed, 5 Sep 2018 09:00:56 +0300
MIME-Version: 1.0
In-Reply-To: <1536112527-16758-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.09.2018 04:55, Liu Bo wrote:
> Here we're not releasing any space, but transferring bytes from
> ->bytes_may_use to ->bytes_reserved.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v2: Add missing commit log.
> 
>  fs/btrfs/extent-tree.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 41a02cbb5a4a..76ee5ebef2b9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6401,10 +6401,6 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
>  	} else {
>  		cache->reserved += num_bytes;
>  		space_info->bytes_reserved += num_bytes;
> -
> -		trace_btrfs_space_reservation(cache->fs_info,
> -				"space_info", space_info->flags,
> -				ram_bytes, 0);
>  		space_info->bytes_may_use -= ram_bytes;
>  		if (delalloc)
>  			cache->delalloc_bytes += num_bytes;
> 
