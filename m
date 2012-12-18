Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24608 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2LROtr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:49:47 -0500
Date: Tue, 18 Dec 2012 22:47:51 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jim Schutt <jaschut@sandia.gov>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20121218144750.GB14017@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121218135242.GC2403@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 08:52:42AM -0500, Josef Bacik wrote:
> On Wed, Dec 12, 2012 at 06:52:37PM -0700, Liu Bo wrote:
> > An user reported that he has hit an annoying deadlock while playing with
> > ceph based on btrfs.
> > 
> > Current updating device tree requires space from METADATA chunk,
> > so we -may- need to do a recursive chunk allocation when adding/updating
> > dev extent, that is where the deadlock comes from.
> > 
> > If we use SYSTEM metadata to update device tree, we can avoid the recursive
> > stuff.
> > 
> 
> This is going to cause us to allocate much more system chunks than we used to
> which could land us in trouble.  Instead let's just keep us from re-entering if
> we're already allocating a chunk.  We do the chunk allocation when we don't have
> enough space for a cluster, but we'll likely have plenty of space to make an
> allocation.  Can you give this patch a try Jim and see if it fixes your problem?
> Thanks,

>From the stack info Jim gave, returning ENOSPC to caller will end up with
aborting to readonly if there is no others save the situation by 
allocating another METADATA chunk, it is recursive allocation though.

thanks,
liubo

> 
> Josef
> 
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e152809..59df5e7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3564,6 +3564,10 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  	int wait_for_alloc = 0;
>  	int ret = 0;
>  
> +	/* Don't re-enter if we're already allocating a chunk */
> +	if (trans->allocating_chunk)
> +		return -ENOSPC;
> +
>  	space_info = __find_space_info(extent_root->fs_info, flags);
>  	if (!space_info) {
>  		ret = update_space_info(extent_root->fs_info, flags,
> @@ -3606,6 +3610,8 @@ again:
>  		goto again;
>  	}
>  
> +	trans->allocating_chunk = true;
> +
>  	/*
>  	 * If we have mixed data/metadata chunks we want to make sure we keep
>  	 * allocating mixed chunks instead of individual chunks.
> @@ -3632,6 +3638,7 @@ again:
>  	check_system_chunk(trans, extent_root, flags);
>  
>  	ret = btrfs_alloc_chunk(trans, extent_root, flags);
> +	trans->allocating_chunk = false;
>  	if (ret < 0 && ret != -ENOSPC)
>  		goto out;
>  
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index e6509b9..47ad8be 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -388,6 +388,7 @@ again:
>  	h->qgroup_reserved = qgroup_reserved;
>  	h->delayed_ref_elem.seq = 0;
>  	h->type = type;
> +	h->allocating_chunk = false;
>  	INIT_LIST_HEAD(&h->qgroup_ref_list);
>  	INIT_LIST_HEAD(&h->new_bgs);
>  
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 0e8aa1e..69700f7 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -68,6 +68,7 @@ struct btrfs_trans_handle {
>  	struct btrfs_block_rsv *orig_rsv;
>  	short aborted;
>  	short adding_csums;
> +	bool allocating_chunk;
>  	enum btrfs_trans_type type;
>  	/*
>  	 * this root is only needed to validate that the root passed to
