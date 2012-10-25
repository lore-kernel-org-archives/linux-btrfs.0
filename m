Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:56436 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2JYNYA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 09:24:00 -0400
Message-ID: <50893D6D.1000705@jan-o-sch.net>
Date: Thu, 25 Oct 2012 15:23:57 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak when cloning root's node
References: <1351171079-5950-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1351171079-5950-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

On Thu, October 25, 2012 at 15:17 (+0200), Liu Bo wrote:
> After cloning root's node, we forgot to dec the src's ref
> which can lead to a memory leak.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> Jan,
> 
> Please add this patch to your pull and notice Chris about it :)
> 
> I didn't get this bug out since I didn't do rmmod yesterday...
> 
> thanks,
> 
>  fs/btrfs/ctree.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index eba44b0..2afa585 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1261,16 +1261,19 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  
>  	tm = tree_mod_log_search(root->fs_info, logical, time_seq);
>  	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
> +		struct extent_buffer *old;

I'd rather put this in the beginning of the function.

> +
>  		btrfs_tree_read_unlock(root->node);
>  		free_extent_buffer(root->node);
>  		blocksize = btrfs_level_size(root, old_root->level);
> -		eb = read_tree_block(root, logical, blocksize, 0);
> -		if (!eb) {
> +		old = read_tree_block(root, logical, blocksize, 0);
> +		if (!old) {
>  			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
>  				logical);
>  			WARN_ON(1);
>  		} else {
> -			eb = btrfs_clone_extent_buffer(eb);
> +			eb = btrfs_clone_extent_buffer(old);
> +			free_extent_buffer(eb);

You meant free_extent_buffer(old) here. Otherwise ok.

Thanks,
-Jan

>  		}
>  	} else if (old_root) {
>  		btrfs_tree_read_unlock(root->node);
