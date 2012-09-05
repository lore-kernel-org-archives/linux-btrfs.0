Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56868 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2IEQcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 12:32:15 -0400
Date: Wed, 5 Sep 2012 18:32:05 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 6/7] Btrfs: fix corrupted metadata in the snapshot
Message-ID: <20120905163205.GN17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <503D96DC.7050701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503D96DC.7050701@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 29, 2012 at 12:13:16PM +0800, Miao Xie wrote:
> When we delete a inode, we will remove all the delayed items including delayed
> inode update, and then truncate all the relative metadata. If there is lots of
> metadata, we will end the current transaction, and start a new transaction to
> truncate the left metadata. In this way, we will leave a inode item that its
> link counter is > 0, and also may leave some directory index items in fs/file tree
> after the current transaction ends. In other words, the metadata in this fs/file tree
> is inconsistent. If we create a snapshot for this tree now, we will find a inode with
> corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
> because its link counter is not 0.
> 
> We fix this problem by updating the inode item before the current transaction ends.

A comment before the while() says

3780         /*
3781          * This is a bit simpler than btrfs_truncate since
3782          *
3783          * 1) We've already reserved our space for our orphan item in the
3784          *    unlink.
3785          * 2) We're going to delete the inode item, so we don't need to update
3786          *    it at all.
3787          *
3788          * So we just need to reserve some slack space in case we add bytes when
3789          * doing the truncate.
3790          */

Point 2 states that the inode update is not needed, but as you write in the
changelog it can lead to inconsistent metadata. I can't say either way, but
rather would like to hear Josef's oppinion on that, as the comment and related
code comes from
4289a667a0d7c6b134898cac7bfbe950267c305c
(Btrfs: fix how we reserve space for deleting inodes)

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index cae4c32..02eeecb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3736,7 +3736,7 @@ void btrfs_evict_inode(struct inode *inode)
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_block_rsv *rsv, *global_rsv;
> -	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
> +	u64 min_size = btrfs_calc_trunc_metadata_size(root, 2);
>  	unsigned long nr;
>  	int ret;
>  
> @@ -3818,6 +3818,9 @@ void btrfs_evict_inode(struct inode *inode)
>  		if (ret != -EAGAIN)
>  			break;
>  
> +		ret = btrfs_update_inode(trans, root, inode);
> +		BUG_ON(ret);
> +
>  		nr = trans->blocks_used;
>  		btrfs_end_transaction(trans, root);
>  		trans = NULL;
