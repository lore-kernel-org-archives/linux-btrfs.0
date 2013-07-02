Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59816 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab3GBHgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 03:36:39 -0400
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 2C8F7C96001
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jul 2013 09:36:37 +0200 (CEST)
Message-ID: <51D28306.6050203@jan-o-sch.net>
Date: Tue, 02 Jul 2013 09:36:38 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: only do the tree_mod_log_free_eb if this is our
 last ref
References: <1372709547-29418-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372709547-29418-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(resent to list)

On Mon, July 01, 2013 at 22:12 (+0200), Josef Bacik wrote:
> There is another bug in the tree mod log stuff in that we're calling
> tree_mod_log_free_eb every single time a block is cow'ed.  The problem with this
> is that if this block is shared by multiple snapshots we will call this multiple
> times per block, so if we go to rewind the mod log for this block we'll BUG_ON()
> in __tree_mod_log_rewind because we try to rewind a free twice.  We only want to
> call tree_mod_log_free_eb if we are actually freeing the block.  With this patch
> I no longer hit the panic in __tree_mod_log_rewind.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Strange that never really popped up largely so far, should be quite easy to hit.
Anyway,

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

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
> 
