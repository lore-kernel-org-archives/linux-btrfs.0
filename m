Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33465 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934833Ab2JXOSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 10:18:47 -0400
Message-ID: <5087F8C8.40605@oracle.com>
Date: Wed, 24 Oct 2012 22:18:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: drop locks before calling read_tree_block from
 get_old_root
References: <5087BB1D.4020501@oracle.com> <1351075516-16344-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351075516-16344-1-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2012 06:45 PM, Jan Schmidt wrote:
> get_old_root needs its lock on the root node only to clone that buffer.
> However, when we call read_tree_block, we know already that we're not
> going to clone the root node. Thus we can safely unlock before, to avoid
> issues where read_tree_block makes potentially sleeping allocations.
> 

I tested this for 20 times, it's no more blocked.

So you can add

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Tested-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> Thanks for pointing that out, liubo!
> 
> I added this additional patch on top of my patch staple at:
> 
>     git://git.jan-o-sch.net/btrfs-unstable for-chris
> 
> I also made a second branch, because this last commit actually fixes
> that's introduced by one of the patches in the patch set. So I folded
> it into the respective commit:
> 
>     git://git.jan-o-sch.net/btrfs-unstable for-chris-fixed
> 
> I made sure that the resulting code is the same.
> 
> Chris: please pull either one for rc3.
> 
> -Jan
> 
> ---
>  fs/btrfs/ctree.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index c608b3c..eba44b0 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1261,6 +1261,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  
>  	tm = tree_mod_log_search(root->fs_info, logical, time_seq);
>  	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
> +		btrfs_tree_read_unlock(root->node);
> +		free_extent_buffer(root->node);
>  		blocksize = btrfs_level_size(root, old_root->level);
>  		eb = read_tree_block(root, logical, blocksize, 0);
>  		if (!eb) {
> @@ -1271,12 +1273,15 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  			eb = btrfs_clone_extent_buffer(eb);
>  		}
>  	} else if (old_root) {
> +		btrfs_tree_read_unlock(root->node);
> +		free_extent_buffer(root->node);
>  		eb = alloc_dummy_extent_buffer(logical, root->nodesize);
>  	} else {
>  		eb = btrfs_clone_extent_buffer(root->node);
> +		btrfs_tree_read_unlock(root->node);
> +		free_extent_buffer(root->node);
>  	}
> -	btrfs_tree_read_unlock(root->node);
> -	free_extent_buffer(root->node);
> +
>  	if (!eb)
>  		return NULL;
>  	extent_buffer_get(eb);
> 

