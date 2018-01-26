Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45455 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbeAZLjS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 06:39:18 -0500
Subject: Re: [PATCH] Btrfs: fix btrfs_evict_inode to handle abnormal inodes
 correctly
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180125180256.10844-6-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <91c651c2-bdbb-8e6b-e453-a5289378f5e6@suse.com>
Date: Fri, 26 Jan 2018 13:35:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180125180256.10844-6-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.01.2018 20:02, Liu Bo wrote:
> This regression is introduced in
> commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction").
> 
> There are two problems,
> 
> a) it is ->destroy_inode() that does the final free on inode, not
>    ->evict_inode(),
> b) clear_inode() must be called before ->evict_inode() returns.
> 
> This could end up hitting BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> in evict() because I_CLEAR is set in clear_inode().
> 

Oops, It seems I've missed that when I wrote the original patch.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> Fixes: commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction")
> Cc: <stable@vger.kernel.org> # v4.7-rc6+
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 281a250..bc6ef73 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5286,7 +5286,7 @@ void btrfs_evict_inode(struct inode *inode)
>  	trace_btrfs_inode_evict(inode);
>  
>  	if (!root) {
> -		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
> +		clear_inode(inode);
>  		return;
>  	}
>  
> 
