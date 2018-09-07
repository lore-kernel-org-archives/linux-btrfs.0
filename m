Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbeIGLYR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 07:24:17 -0400
Subject: Re: [PATCH 33/35] btrfs: fix insert_reserved error handling
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-34-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6fa77bba-bab0-0c83-3607-e75d0539cbd1@suse.com>
Date: Fri, 7 Sep 2018 09:44:47 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-34-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> We were not handling the reserved byte accounting properly for data
> references.  Metadata was fine, if it errored out the error paths would
> free the bytes_reserved count and pin the extent, but it even missed one
> of the error cases.  So instead move this handling up into
> run_one_delayed_ref so we are sure that both cases are properly cleaned
> up in case of a transaction abort.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 132a1157982c..fd9169f80de0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2405,6 +2405,9 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  					   insert_reserved);
>  	else
>  		BUG();
> +	if (ret && insert_reserved)> +		btrfs_pin_extent(trans->fs_info, node->bytenr,
> +				 node->num_bytes, 1);
>  	return ret;
>  }
>  
> @@ -8227,21 +8230,14 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>  	}
>  
>  	path = btrfs_alloc_path();
> -	if (!path) {
> -		btrfs_free_and_pin_reserved_extent(fs_info,
> -						   extent_key.objectid,
> -						   fs_info->nodesize);
> +	if (!path)
>  		return -ENOMEM;
> -	}
>  
>  	path->leave_spinning = 1;
>  	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
>  				      &extent_key, size);
>  	if (ret) {
>  		btrfs_free_path(path);
> -		btrfs_free_and_pin_reserved_extent(fs_info,
> -						   extent_key.objectid,
> -						   fs_info->nodesize);
>  		return ret;
>  	}
>  
> 
