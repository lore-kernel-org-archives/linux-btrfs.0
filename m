Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:43285 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbeEVRy6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:54:58 -0400
Received: by mail-pf0-f193.google.com with SMTP id j20-v6so9139182pff.10
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 10:54:57 -0700 (PDT)
Date: Tue, 22 May 2018 10:54:56 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: kill btrfs_write_inode
Message-ID: <20180522175456.GE9536@vader>
References: <20180522174723.13620-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522174723.13620-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 01:47:22PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We don't actually need this.  It used to be in place for O_SYNC writes,
> but we've used the normal fsync() path for that for years now.

Specifically, I believe 148f948ba877 ("vfs: Introduce new helpers for
syncing after writing to O_SYNC file or IS_SYNC inode") is where we
stopped using this for O_SYNC.

> The
> other case we hit this is through sync(), which will commit the
> transaction anyway.  All this does is make us commit the transaction a
> bunch for no reason, and it could deadlock with delayed iput's.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 26 --------------------------
>  fs/btrfs/super.c |  1 -
>  2 files changed, 27 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 92b629212c81..5d47206604ca 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6263,32 +6263,6 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  	return ret;
>  }
>  
> -int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
> -{
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct btrfs_trans_handle *trans;
> -	int ret = 0;
> -	bool nolock = false;
> -
> -	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
> -		return 0;
> -
> -	if (btrfs_fs_closing(root->fs_info) &&
> -			btrfs_is_free_space_inode(BTRFS_I(inode)))
> -		nolock = true;
> -
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> -		if (nolock)
> -			trans = btrfs_join_transaction_nolock(root);
> -		else
> -			trans = btrfs_join_transaction(root);
> -		if (IS_ERR(trans))
> -			return PTR_ERR(trans);
> -		ret = btrfs_commit_transaction(trans);
> -	}
> -	return ret;
> -}
> -
>  /*
>   * This is somewhat expensive, updating the tree every time the
>   * inode changes.  But, it is most likely to find the inode in cache.
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4a584a7ad371..0a4fb69e0ddf 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2331,7 +2331,6 @@ static const struct super_operations btrfs_super_ops = {
>  	.sync_fs	= btrfs_sync_fs,
>  	.show_options	= btrfs_show_options,
>  	.show_devname	= btrfs_show_devname,
> -	.write_inode	= btrfs_write_inode,
>  	.alloc_inode	= btrfs_alloc_inode,
>  	.destroy_inode	= btrfs_destroy_inode,
>  	.statfs		= btrfs_statfs,
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
