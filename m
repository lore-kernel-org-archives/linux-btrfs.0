Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41077 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbeEUIrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 04:47:49 -0400
Subject: Re: [PATCH] Btrfs: fix error handling in btrfs_truncate()
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
References: <e59e9745f1c052ae0df24378455ad3e74eed7f3a.1526679483.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f4040f83-9664-90a6-19c2-4b0b71bd5a92@suse.com>
Date: Mon, 21 May 2018 11:47:46 +0300
MIME-Version: 1.0
In-Reply-To: <e59e9745f1c052ae0df24378455ad3e74eed7f3a.1526679483.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.05.2018 00:43, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Jun Wu at Facebook reported that an internal service was seeing a return
> value of 1 from ftruncate() on Btrfs when compression is enabled. This
> is coming from the NEED_TRUNCATE_BLOCK return value from
> btrfs_truncate_inode_items().
> 
> btrfs_truncate() uses two variables for error handling, ret and err (if
> this sounds familiar, it's because btrfs_truncate_inode_items() does
> something similar). When btrfs_truncate_inode_items() returns non-zero,
> we set err to the return value, but we don't reset it to zero in the
> successful NEED_TRUNCATE_BLOCK case. We only have err because we don't
> want to mask an error if we call btrfs_update_inode() and
> btrfs_end_transaction(), so let's make that its own scoped return
> variable and use ret everywhere else.
> 
> Fixes: ddfae63cc8e0 ("btrfs: move btrfs_truncate_block out of trans handle")
> Reported-by: Jun Wu <quark@fb.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> This is based on Linus' master rather than my orphan ENOSPC fixes
> because I think we want to get this in for v4.17 and stable, and rebase
> my fixes on top of this.
> 
>  fs/btrfs/inode.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..d4a47ae36ed8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9031,8 +9031,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_block_rsv *rsv;
> -	int ret = 0;
> -	int err = 0;
> +	int ret;
>  	struct btrfs_trans_handle *trans;
>  	u64 mask = fs_info->sectorsize - 1;
>  	u64 min_size = btrfs_calc_trunc_metadata_size(fs_info, 1);
> @@ -9092,7 +9091,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  	 */
>  	trans = btrfs_start_transaction(root, 2);
>  	if (IS_ERR(trans)) {
> -		err = PTR_ERR(trans);
> +		ret = PTR_ERR(trans);
>  		goto out;
>  	}
>  
> @@ -9116,23 +9115,19 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  						 inode->i_size,
>  						 BTRFS_EXTENT_DATA_KEY);
>  		trans->block_rsv = &fs_info->trans_block_rsv;
> -		if (ret != -ENOSPC && ret != -EAGAIN) {
> -			err = ret;
> +		if (ret != -ENOSPC && ret != -EAGAIN)
>  			break;
> -		}
>  
>  		ret = btrfs_update_inode(trans, root, inode);
> -		if (ret) {
> -			err = ret;
> +		if (ret)
>  			break;
> -		}
>  
>  		btrfs_end_transaction(trans);
>  		btrfs_btree_balance_dirty(fs_info);
>  
>  		trans = btrfs_start_transaction(root, 2);
>  		if (IS_ERR(trans)) {
> -			ret = err = PTR_ERR(trans);
> +			ret = PTR_ERR(trans);
>  			trans = NULL;
>  			break;
>  		}
> @@ -9168,26 +9163,25 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  	if (ret == 0 && inode->i_nlink > 0) {
>  		trans->block_rsv = root->orphan_block_rsv;
>  		ret = btrfs_orphan_del(trans, BTRFS_I(inode));
> -		if (ret)
> -			err = ret;
>  	}
>  
>  	if (trans) {
> +		int ret2;
> +
>  		trans->block_rsv = &fs_info->trans_block_rsv;
> -		ret = btrfs_update_inode(trans, root, inode);
> -		if (ret && !err)
> -			err = ret;
> +		ret2 = btrfs_update_inode(trans, root, inode);
> +		if (ret2 && !ret)
> +			ret = ret2;
>  
> -		ret = btrfs_end_transaction(trans);
> +		ret2 = btrfs_end_transaction(trans);
> +		if (ret2 && !ret)
> +			ret = ret2;
>  		btrfs_btree_balance_dirty(fs_info);
>  	}
>  out:
>  	btrfs_free_block_rsv(fs_info, rsv);
>  
> -	if (ret && !err)
> -		err = ret;
> -
> -	return err;
> +	return ret;
>  }
>  
>  /*
> 
