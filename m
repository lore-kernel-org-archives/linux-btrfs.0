Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbeILLym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 07:54:42 -0400
Subject: Re: [PATCH] Btrfs: skip setting path to blocking mode if balance is
 not needed
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-5-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a66438ea-7da5-a207-d368-70f4072c9958@suse.com>
Date: Wed, 12 Sep 2018 09:51:33 +0300
MIME-Version: 1.0
In-Reply-To: <1536703587-94565-5-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2018 01:06, Liu Bo wrote:
> balance_level() may return early in some cases, but these checks don't
> have to be done with blocking write lock.
> 
> This puts together these checks into a helper and the benefit is to
> avoid switching spinning locks to blocking locks (in these paticular
> cases) which slows down btrfs overall.

Performance patches without numbers are frowned upon. You need to
substantiate your claims.


> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/ctree.c | 41 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 858085490e23..ba267a069ca1 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1758,6 +1758,29 @@ static void root_sub_used(struct btrfs_root *root, u32 size)
>  	return eb;
>  }
>  
> +static bool need_balance_level(struct btrfs_fs_info *fs_info,

nit: I think should_balance_level seems more readable, but it could be
just me so won't insist on that.

> +			      struct btrfs_trans_handle *trans,
> +			      struct btrfs_path *path, int level)
> +{
> +	struct extent_buffer *mid;
> +
> +	mid = path->nodes[level];
> +
> +	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
> +		path->locks[level] != BTRFS_WRITE_LOCK_BLOCKING);
> +	WARN_ON(btrfs_header_generation(mid) != trans->transid);
> +
> +	/* If mid is the root node. */
> +	if (level < BTRFS_MAX_LEVEL - 1 && path->nodes[level + 1] == NULL)
> +		if (btrfs_header_nritems(mid) != 1)
> +			return false;
> +
> +	if (btrfs_header_nritems(mid) > BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * node level balancing, used to make sure nodes are in proper order for
>   * item deletion.  We balance from the top down, so we have to make sure
> @@ -1780,10 +1803,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  
>  	mid = path->nodes[level];
>  
> -	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
> -		path->locks[level] != BTRFS_WRITE_LOCK_BLOCKING);
> -	WARN_ON(btrfs_header_generation(mid) != trans->transid);
> -
>  	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
>  
>  	if (level < BTRFS_MAX_LEVEL - 1) {
> @@ -1798,9 +1817,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  	if (!parent) {
>  		struct extent_buffer *child;
>  
> -		if (btrfs_header_nritems(mid) != 1)
> -			return 0;
> -
>  		/* promote the child to a root */
>  		child = read_node_slot(fs_info, mid, 0);
>  		if (IS_ERR(child)) {
> @@ -1838,9 +1854,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  		free_extent_buffer_stale(mid);
>  		return 0;
>  	}
> -	if (btrfs_header_nritems(mid) >
> -	    BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
> -		return 0;
>  
>  	left = read_node_slot(fs_info, parent, pslot - 1);
>  	if (IS_ERR(left))
> @@ -2460,14 +2473,20 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
>  			goto again;
>  		}
>  
> +		/* Skip setting path to blocking if balance is not needed. */
> +		if (!need_balance_level(fs_info, trans, p, level)) {
> +			ret = 0;
> +			goto done;
> +		}
> +
>  		btrfs_set_path_blocking(p);
>  		reada_for_balance(fs_info, p, level);
>  		sret = balance_level(trans, root, p, level);
> -
>  		if (sret) {
>  			ret = sret;
>  			goto done;
>  		}
> +
>  		b = p->nodes[level];
>  		if (!b) {
>  			btrfs_release_path(p);
> 
