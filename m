Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27075 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3GCD0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 23:26:18 -0400
Date: Wed, 3 Jul 2013 11:26:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: only do the tree_mod_log_free_eb if this is our
 last ref
Message-ID: <20130703032606.GA15921@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372709547-29418-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372709547-29418-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 04:12:27PM -0400, Josef Bacik wrote:
> There is another bug in the tree mod log stuff in that we're calling
> tree_mod_log_free_eb every single time a block is cow'ed.  The problem with this
> is that if this block is shared by multiple snapshots we will call this multiple
> times per block, so if we go to rewind the mod log for this block we'll BUG_ON()
> in __tree_mod_log_rewind because we try to rewind a free twice.  We only want to
> call tree_mod_log_free_eb if we are actually freeing the block.  With this patch
> I no longer hit the panic in __tree_mod_log_rewind.  Thanks,

This fixes my reproducer for __tree_mod_log_rewind() BUG_ON in line 1183.

Tested-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 32e30ad..127e1fd 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1093,7 +1093,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  		btrfs_set_node_ptr_generation(parent, parent_slot,
>  					      trans->transid);
>  		btrfs_mark_buffer_dirty(parent);
> -		tree_mod_log_free_eb(root->fs_info, buf);
> +		if (last_ref)
> +			tree_mod_log_free_eb(root->fs_info, buf);
>  		btrfs_free_tree_block(trans, root, buf, parent_start,
>  				      last_ref);
>  	}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
