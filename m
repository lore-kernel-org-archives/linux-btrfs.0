Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:41489 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761354AbdKRMgJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 07:36:09 -0500
Subject: Re: [PATCH] btrfs: clear space cache inode generation always
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
References: <1510948246-32434-1-git-send-email-josef@toxicpanda.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <f8599fd4-f124-2f7b-4b45-1d694433f7df@gmail.com>
Date: Sat, 18 Nov 2017 14:36:01 +0200
MIME-Version: 1.0
In-Reply-To: <1510948246-32434-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.11.2017 21:50, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We discovered a box that had double allocations, and suspected the space
> cache may be to blame.  While auditing the write out path I noticed that
> if we've already setup the space cache we will just carry on.  This
> means that any error we hit after cache_save_setup before we go to
> actually write the cache out we won't reset the inode generation, so
> whatever was already written will be considered correct, except it'll be
> stale.  Fix this by _always_ resetting the generation on the block group
> inode, this way we only ever have valid or invalid cache.
> 
> With this patch I was no longer able to reproduce cache corruption with
> dm-log-writes and my bpf error injection tool.
> 



Is it normal that no function checks the return value of cache_save_setup ?

> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e2d7e86b51d1..67b26b209e23 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3526,13 +3526,6 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
>  		goto again;
>  	}
>  
> -	/* We've already setup this transaction, go ahead and exit */
> -	if (block_group->cache_generation == trans->transid &&
> -	    i_size_read(inode)) {
> -		dcs = BTRFS_DC_SETUP;
> -		goto out_put;
> -	}
> -
>  	/*
>  	 * We want to set the generation to 0, that way if anything goes wrong
>  	 * from here on out we know not to trust this cache when we load up next
> @@ -3556,6 +3549,13 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
>  	}
>  	WARN_ON(ret);
>  
> +	/* We've already setup this transaction, go ahead and exit */
> +	if (block_group->cache_generation == trans->transid &&
> +	    i_size_read(inode)) {
> +		dcs = BTRFS_DC_SETUP;
> +		goto out_put;
> +	}
> +
>  	if (i_size_read(inode) > 0) {
>  		ret = btrfs_check_trunc_cache_free_space(fs_info,
>  					&fs_info->global_block_rsv);
> 
