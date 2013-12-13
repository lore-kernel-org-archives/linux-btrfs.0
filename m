Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3LMJmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:42:10 -0500
Message-ID: <52AAD6B5.6030505@cn.fujitsu.com>
Date: Fri, 13 Dec 2013 17:43:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: don't build inode cache for orphan root
References: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com> <1386926183-18325-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1386926183-18325-3-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 13 Dec 2013 17:16:22 +0800, Liu Bo wrote:
> We check if we have orphan roots when mounting btrfs, but orphan roots
> are those who are already dead and about to be freed, so don't start building
> inode cache for them, otherwise we'll get an ugly crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Acked-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/inode-map.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index 6c8d7bb..493694f 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -141,7 +141,9 @@ static void start_caching(struct btrfs_root *root)
>  	int ret;
>  	u64 objectid;
>  
> -	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
> +	/* Don't even start if this is an orphan root. */
> +	if (!btrfs_test_opt(root, INODE_MAP_CACHE) ||
> +	    btrfs_root_refs(&root->root_item) == 0)
>  		return;
>  
>  	spin_lock(&root->cache_lock);
> 

