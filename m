Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933988AbeEJI3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 04:29:21 -0400
Subject: Re: [PATCH 06/10] Btrfs: don't return ino if inode item removal fails
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1525932796.git.osandov@fb.com>
 <62232de691b62b5eaf6f6b4912848e1e7bf65ebd.1525932796.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <995eb7ab-aa58-63ea-61d8-2fbcbbe767ac@suse.com>
Date: Thu, 10 May 2018 11:29:18 +0300
MIME-Version: 1.0
In-Reply-To: <62232de691b62b5eaf6f6b4912848e1e7bf65ebd.1525932796.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.05.2018 09:21, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In btrfs_evict_inode(), if btrfs_truncate_inode_items() fails, the inode
> item will still be in the tree but we still return the ino to the ino
> cache. That will blow up later when someone tries to allocate that ino,
> so don't return it to the cache.

Make the subject a bit more expicit:

"Don't return ino to ino cache if inode item removal fails"

> 
> Fixes: 581bb050941b ("Btrfs: Cache free inode numbers in memory")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/inode.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e77df96de642..9a6a4e626e01 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5368,13 +5368,18 @@ void btrfs_evict_inode(struct inode *inode)
>  		trans->block_rsv = rsv;
>  
>  		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
> -		if (ret != -ENOSPC && ret != -EAGAIN)
> +		if (ret) {
> +			trans->block_rsv = &fs_info->trans_block_rsv;
> +			btrfs_end_transaction(trans);
> +			btrfs_btree_balance_dirty(fs_info);
> +			if (ret != -ENOSPC && ret != -EAGAIN) {
> +				btrfs_orphan_del(NULL, BTRFS_I(inode));
> +				btrfs_free_block_rsv(fs_info, rsv);
> +				goto no_delete;
> +			}
> +		} else {
>  			break;
> -
> -		trans->block_rsv = &fs_info->trans_block_rsv;
> -		btrfs_end_transaction(trans);
> -		trans = NULL;
> -		btrfs_btree_balance_dirty(fs_info);
> +		}
>  	}
>  
>  	btrfs_free_block_rsv(fs_info, rsv);
> @@ -5383,12 +5388,8 @@ void btrfs_evict_inode(struct inode *inode)
>  	 * Errors here aren't a big deal, it just means we leave orphan items
>  	 * in the tree.  They will be cleaned up on the next mount.
>  	 */
> -	if (ret == 0) {
> -		trans->block_rsv = root->orphan_block_rsv;
> -		btrfs_orphan_del(trans, BTRFS_I(inode));
> -	} else {
> -		btrfs_orphan_del(NULL, BTRFS_I(inode));
> -	}
> +	trans->block_rsv = root->orphan_block_rsv;
> +	btrfs_orphan_del(trans, BTRFS_I(inode));
>  
>  	trans->block_rsv = &fs_info->trans_block_rsv;
>  	if (!(root == fs_info->tree_root ||
> 
