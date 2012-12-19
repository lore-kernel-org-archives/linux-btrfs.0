Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2LSB6H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 20:58:07 -0500
Message-ID: <50D11F49.4070005@cn.fujitsu.com>
Date: Wed, 19 Dec 2012 09:58:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't bother updating the inode when evicting
References: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 18 Dec 2012 15:51:57 -0500, Josef Bacik wrote:
> We're deleting the stupid thing, no sense in updating the inode for the new
> size.  We're running into having 50-100 orphans left over with xfstests 83
> because of ENOSPC when trying to start the transaction for the inode update.
> This patch fixes this problem.  Thanks,

This patch is wrong, it will introduce the inconsonant metadata in the snapshot
tree. The reason is folloing:

commit 8407aa464331556e4f6784f974030b83fc7585ed
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Fri Sep 7 01:43:32 2012 -0600

    Btrfs: fix corrupted metadata in the snapshot
    
    When we delete a inode, we will remove all the delayed items including delayed
    inode update, and then truncate all the relative metadata. If there is lots of
    metadata, we will end the current transaction, and start a new transaction to
    truncate the left metadata. In this way, we will leave a inode item that its
    link counter is > 0, and also may leave some directory index items in fs/file tree
    after the current transaction ends. In other words, the metadata in this fs/file tree
    is inconsistent. If we create a snapshot for this tree now, we will find a inode with
    corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
    because its link counter is not 0.
    
    We fix this problem by updating the inode item before the current transaction ends.
    
    Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>


I will write a new patch to fix the problem you said above.

Thanks
Miao

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f33269a..ac7f471 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3898,7 +3898,7 @@ void btrfs_evict_inode(struct inode *inode)
>  			goto no_delete;
>  		}
>  
> -		trans = btrfs_start_transaction_lflush(root, 1);
> +		trans = btrfs_join_transaction(root);
>  		if (IS_ERR(trans)) {
>  			btrfs_orphan_del(NULL, inode);
>  			btrfs_free_block_rsv(root, rsv);
> @@ -3911,10 +3911,6 @@ void btrfs_evict_inode(struct inode *inode)
>  		if (ret != -ENOSPC)
>  			break;
>  
> -		trans->block_rsv = &root->fs_info->trans_block_rsv;
> -		ret = btrfs_update_inode(trans, root, inode);
> -		BUG_ON(ret);
> -
>  		btrfs_end_transaction(trans, root);
>  		trans = NULL;
>  		btrfs_btree_balance_dirty(root);
> 

