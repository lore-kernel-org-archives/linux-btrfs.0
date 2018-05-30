Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935883AbeE3GoT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:44:19 -0400
Subject: Re: [PATCH v2] btrfs: returns -ENOMEM if path allocation failed in
 btrfs_cross_ref_exist()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
 <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5a25b5cf-b38a-2498-2a6d-d3f5fa729bd3@suse.com>
Date: Wed, 30 May 2018 09:44:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180530064910.8724-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 09:49, Su Yue wrote:
> btrfs_alloc_path() may fail due to no enough memory,
> so let the function return -ENOMEM instead of -ENOENT is better.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> Changelog:
> v2:
>   Add commit message to describe the patch. Thanks Nikolay.
>   
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 44093f92a532..99df6199dffc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3311,7 +3311,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> -		return -ENOENT;
> +		return -ENOMEM;
>  
>  	do {
>  		ret = check_committed_ref(root, path, objectid,
> 
