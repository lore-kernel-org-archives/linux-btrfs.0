Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:60951 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3KDIt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 03:49:57 -0500
Message-ID: <52775FB7.7080506@giantdisaster.de>
Date: Mon, 04 Nov 2013 09:49:59 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid heavy operations in btrfs_commit_super
References: <1383492274-30311-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1383492274-30311-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun,  3 Nov 2013 23:24:34 +0800, Liu Bo wrote:
> The 'git blame' history shows that, the old transaction commit code has to do
> twice to ensure roots are updated and we have to flush metadata and super block
> manually, however, right now all of these can be handled well inside
> the transaction commit code without extra efforts.
> 
> And the error handling part remains same with the current code, -- 'return to
> caller once we get error'.
> 
> This saves us a transaction commit and a flush of super block, which are both
> heavy operations according to ftrace output analysis.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 62176ad..d6728c3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3542,25 +3542,7 @@ int btrfs_commit_super(struct btrfs_root *root)
>  	trans = btrfs_join_transaction(root);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
> -	ret = btrfs_commit_transaction(trans, root);
> -	if (ret)
> -		return ret;
> -	/* run commit again to drop the original snapshot */
> -	trans = btrfs_join_transaction(root);
> -	if (IS_ERR(trans))
> -		return PTR_ERR(trans);
> -	ret = btrfs_commit_transaction(trans, root);
> -	if (ret)
> -		return ret;
> -	ret = btrfs_write_and_wait_transaction(NULL, root);
> -	if (ret) {
> -		btrfs_error(root->fs_info, ret,
> -			    "Failed to sync btree inode to disk.");
> -		return ret;
> -	}
> -
> -	ret = write_ctree_super(NULL, root, 0);
> -	return ret;
> +	return btrfs_commit_transaction(trans, root);
>  }
>  
>  int close_ctree(struct btrfs_root *root)
> 

fs/btrfs/disk-io.c: In function 'btrfs_commit_super':
fs/btrfs/disk-io.c:3520: warning: unused variable 'ret'

