Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab3BVIhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 03:37:51 -0500
Message-ID: <51272E8F.9000305@cn.fujitsu.com>
Date: Fri, 22 Feb 2013 16:38:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use reserved space for creating a snapshot
References: <1361507616-12342-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1361507616-12342-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 22 Feb 2013 12:33:36 +0800, Liu Bo wrote:
> While inserting dir index and updating inode for a snapshot, we'd
> add delayed items which consume trans->block_rsv, if we don't have
> any space reserved in this trans handle, we either just return or
> reserve space again.
> 
> But before creating pending snapshots during committing transaction,
> we've done a release on this trans handle, so we don't have space reserved
> in it at this stage.
> 
> What we're using is block_rsv of pending snapshots which has already
> reserved well enough space for both inserting dir index and updating
> inode, so we need to set trans handle to indicate that we have space
> now.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/transaction.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index fc03aa6..5878bb4 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1063,6 +1063,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  
>  	rsv = trans->block_rsv;
>  	trans->block_rsv = &pending->block_rsv;
> +	trans->bytes_reserved = trans->block_rsv->reserved;
>  
>  	dentry = pending->dentry;
>  	parent = dget_parent(dentry);
> @@ -1216,6 +1217,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  fail:
>  	dput(parent);
>  	trans->block_rsv = rsv;
> +	trans->bytes_reserved = 0;
>  no_free_objectid:
>  	kfree(new_root_item);
>  root_item_alloc_fail:
> 

