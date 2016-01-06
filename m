Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcAFCdq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 21:33:46 -0500
Date: Tue, 5 Jan 2016 18:33:41 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix transaction handle leak on failure to create
 hard link
Message-ID: <20160106023341.GC23191@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1452011582-9460-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452011582-9460-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 05, 2016 at 04:33:02PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we failed to create a hard link we were not always releasing the
> the transaction handle we got before, resulting in a memory leak and
> preventing any other tasks from being able to commit the current
> transaction.
> Fix this by always releasing our transaction handle.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/inode.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5dbc07a..018c2a6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6488,7 +6488,7 @@ out_unlock_inode:
>  static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>  		      struct dentry *dentry)
>  {
> -	struct btrfs_trans_handle *trans;
> +	struct btrfs_trans_handle *trans = NULL;
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	struct inode *inode = d_inode(old_dentry);
>  	u64 index;
> @@ -6514,6 +6514,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>  	trans = btrfs_start_transaction(root, 5);
>  	if (IS_ERR(trans)) {
>  		err = PTR_ERR(trans);
> +		trans = NULL;
>  		goto fail;
>  	}
>  
> @@ -6547,9 +6548,10 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>  		btrfs_log_new_name(trans, inode, NULL, parent);
>  	}
>  
> -	btrfs_end_transaction(trans, root);
>  	btrfs_balance_delayed_items(root);
>  fail:
> +	if (trans)
> +		btrfs_end_transaction(trans, root);
>  	if (drop_inode) {
>  		inode_dec_link_count(inode);
>  		iput(inode);
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
