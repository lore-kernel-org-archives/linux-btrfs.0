Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43809 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2JXJzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 05:55:37 -0400
Message-ID: <5087BB1D.4020501@oracle.com>
Date: Wed, 24 Oct 2012 17:55:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] Btrfs: tree mod log's old roots could still be part
 of the tree
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-4-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> Tree mod log treated old root buffers as always empty buffers when starting
> the rewind operations. However, the old root may still be part of the
> current tree at a lower level, with still some valid entries.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index e6b75cc..1b60c56 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1239,6 +1239,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  	struct tree_mod_root *old_root = NULL;
>  	u64 old_generation = 0;
>  	u64 logical;
> +	u32 blocksize;
>  
>  	eb = btrfs_read_lock_root_node(root);
>  	tm = __tree_mod_log_oldest_root(root->fs_info, root, time_seq);
> @@ -1254,10 +1255,21 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  	}
>  
>  	tm = tree_mod_log_search(root->fs_info, logical, time_seq);
> -	if (old_root)
> +	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
> +		blocksize = btrfs_level_size(root, old_root->level);
> +		eb = read_tree_block(root, logical, blocksize, 0);

I found that read_tree_block() may use GFP_NOFS if we need to create an eb,
and this may block read_lock().
It's not always blocked but it did block, so we'd better give an atomic version of this.

thanks,
liubo

> +		if (!eb) {
> +			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
> +				logical);
> +			WARN_ON(1);
> +		} else {
> +			eb = btrfs_clone_extent_buffer(eb);
> +		}
> +	} else if (old_root) {
>  		eb = alloc_dummy_extent_buffer(logical, root->nodesize);
> -	else
> +	} else {
>  		eb = btrfs_clone_extent_buffer(root->node);
> +	}
>  	btrfs_tree_read_unlock(root->node);
>  	free_extent_buffer(root->node);
>  	if (!eb)
> 

