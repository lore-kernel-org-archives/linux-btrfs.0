Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52537 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935258AbeE3GY0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:24:26 -0400
Subject: Re: [PATCH 1/2] btrfs: returns -ENOMEM if path allocation failed in
 btrfs_cross_ref_exist()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c739075f-9505-d117-983a-91f4e8d686bb@suse.com>
Date: Wed, 30 May 2018 09:24:22 +0300
MIME-Version: 1.0
In-Reply-To: <20180530020752.23788-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 05:07, Su Yue wrote:
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Generally we discourage commit log messages. I understand this patch is
very obvious but put a sentence saying that btrfs_alloc_path can fail
due to enomem hence returning enomem is the right ting to do here.
> ---
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
