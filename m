From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: don't reserve metadata when we're using the delalloc
 reserve
Date: Wed, 13 Apr 2011 18:34:09 +0200
Message-ID: <4DA5D081.4070108@gmx.net>
References: <1302710775-29602-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302710775-29602-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13.04.2011 18:06, Josef Bacik wrote:
> There are a bunch of places where we do btrfs_join_transaction(root, 1), but
> really we set the block_rsv to the delalloc reserve because our metadata was
> reserved at delalloc time.  This means we don't need to reserve space at all,
> and can just join the transaction and go.  This patch also fixes a few places
> where we weren't actually setting the block_rsv to the delalloc reserve.
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/inode.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c4b914e..e9bda50 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -420,7 +420,7 @@ again:
>  		}
>  	}
>  	if (start == 0) {
> -		trans = btrfs_join_transaction(root, 1);
> +		trans = btrfs_join_transaction(root, 0);

btrfs_join_transaction ignores the num_blocks parameter, so this
shouldn't change anything. Maybe it's cleaner to just eradicate
the parameter.

-Arne



>  		BUG_ON(IS_ERR(trans));
>  		btrfs_set_trans_block_group(trans, inode);
>  		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> @@ -617,8 +617,9 @@ retry:
>  			    async_extent->start + async_extent->ram_size - 1,
>  			    GFP_NOFS);
>  
> -		trans = btrfs_join_transaction(root, 1);
> +		trans = btrfs_join_transaction(root, 0);
>  		BUG_ON(IS_ERR(trans));
> +		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
>  		ret = btrfs_reserve_extent(trans, root,
>  					   async_extent->compressed_size,
>  					   async_extent->compressed_size,
> @@ -778,7 +779,12 @@ static noinline int cow_file_range(struct inode *inode,
>  	int ret = 0;
>  
>  	BUG_ON(root == root->fs_info->tree_root);
> -	trans = btrfs_join_transaction(root, 1);
> +
> +	/*
> +	 * Our metadata reservations should have been taken care of in the
> +	 * delalloc stuff, so we don't need to reserve space here.
> +	 */
> +	trans = btrfs_join_transaction(root, 0);
>  	BUG_ON(IS_ERR(trans));
>  	btrfs_set_trans_block_group(trans, inode);
>  	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> @@ -1054,11 +1060,12 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  	BUG_ON(!path);
>  	if (root == root->fs_info->tree_root) {
>  		nolock = true;
> -		trans = btrfs_join_transaction_nolock(root, 1);
> +		trans = btrfs_join_transaction_nolock(root, 0);
>  	} else {
> -		trans = btrfs_join_transaction(root, 1);
> +		trans = btrfs_join_transaction(root, 0);
>  	}
>  	BUG_ON(IS_ERR(trans));
> +	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
>  
>  	cow_start = (u64)-1;
>  	cur_offset = start;
> @@ -1715,9 +1722,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
>  		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
>  		if (!ret) {
>  			if (nolock)
> -				trans = btrfs_join_transaction_nolock(root, 1);
> +				trans = btrfs_join_transaction_nolock(root, 0);
>  			else
> -				trans = btrfs_join_transaction(root, 1);
> +				trans = btrfs_join_transaction(root, 0);
>  			BUG_ON(IS_ERR(trans));
>  			btrfs_set_trans_block_group(trans, inode);
>  			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> @@ -1732,9 +1739,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
>  			 0, &cached_state, GFP_NOFS);
>  
>  	if (nolock)
> -		trans = btrfs_join_transaction_nolock(root, 1);
> +		trans = btrfs_join_transaction_nolock(root, 0);
>  	else
> -		trans = btrfs_join_transaction(root, 1);
> +		trans = btrfs_join_transaction(root, 0);
>  	BUG_ON(IS_ERR(trans));
>  	btrfs_set_trans_block_group(trans, inode);
>  	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> @@ -5839,7 +5846,7 @@ again:
>  
>  	BUG_ON(!ordered);
>  
> -	trans = btrfs_join_transaction(root, 1);
> +	trans = btrfs_join_transaction(root, 0);
>  	if (IS_ERR(trans)) {
>  		err = -ENOMEM;
>  		goto out;

