Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60121 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932117AbeEWIXt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 04:23:49 -0400
Subject: Re: [PATCH] btrfs: delayed-ref: simplify btrfs_add_delayed_tree_ref()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180523080650.28286-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ca6309fc-e925-f33f-1352-d13cf2a1c710@suse.com>
Date: Wed, 23 May 2018 11:22:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180523080650.28286-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 11:06, Su Yue wrote:
> Commit 5a5003df98d5 ("btrfs: delayed-ref: double free in
> btrfs_add_delayed_tree_ref()") fixed double free problem by creating
> an unnessesary label to jump.
> The elegant way is just to change "ref" to "head_ref" and keep
> btrfs_add_delayed_tree_ref() and btrfs_add_delayed_data_ref() in
> similar structure.

I agree, personally I'm a fan of multiple returns rather than jump
labels, because at this point you know the function terminates and
that's it.

> 
> This patch reverts commit 5a5003df98d5 ("btrfs: delayed-ref: double
> free in btrfs_add_delayed_tree_ref()") and frees the right head_ref.
> No functional change.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> This patch is based on for-next to avoid conflicts with patches
> already in for-next.
> 
>  fs/btrfs/delayed-ref.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 03dec673d12a..38f8d5d549ed 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -741,14 +741,20 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  	ref->level = level;
>  
>  	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
> -	if (!head_ref)
> -		goto free_ref;
> +	if (!head_ref) {
> +		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
> +		return -ENOMEM;
> +	}
>  
>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
>  	    is_fstree(ref_root)) {
>  		record = kmalloc(sizeof(*record), GFP_NOFS);
> -		if (!record)
> -			goto free_head_ref;
> +		if (!record) {
> +			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
> +			kmem_cache_free(btrfs_delayed_ref_head_cachep,
> +					head_ref);
> +			return -ENOMEM;
> +		}
>  	}
>  
>  	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
> @@ -779,13 +785,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  		btrfs_qgroup_trace_extent_post(fs_info, record);
>  
>  	return 0;
> -
> -free_head_ref:
> -	kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
> -free_ref:
> -	kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
> -
> -	return -ENOMEM;
>  }
>  
>  /*
> 
