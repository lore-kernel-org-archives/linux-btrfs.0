Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3A1Mnx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 07:43:53 -0500
Message-ID: <510672B2.7000601@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 20:44:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, jmwdev38@gmail.com,
        jbacik@fusionio.com, sensille@gmx.net
Subject: Re: [PATCH] Btrfs: fix ENOSPC in qgroups (metadata)
References: <1359374626-14109-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1359374626-14109-1-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 28 Jan 2013 13:03:46 +0100, Jan Schmidt wrote:
> When start_transaction() returns ENOSPC after btrfs_qgroup_reserve(), we
> must call btrfs_qgroup_free() to avoid the qgroup counters increasing when
> there's actually no data being written.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> Josef: It looks like these places (except the first) are candidates for
> btrfs_block_rsv_release, please check.

I didn't note that you have made a patch for the qgroup reservation problem, so I sent
my fix patch.

But start_transaction() has reservation problems not only for qgroup, but also for
the free space, your patch didn't fix the free space reservation problem.

Thanks
Miao

> 
> ---
>  fs/btrfs/transaction.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 87fac9a..f2430fd 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -332,13 +332,17 @@ start_transaction(struct btrfs_root *root, u64 num_items, int type,
>  		ret = btrfs_block_rsv_add(root,
>  					  &root->fs_info->trans_block_rsv,
>  					  num_bytes, flush);
> -		if (ret)
> +		if (ret) {
> +			btrfs_qgroup_free(root, qgroup_reserved);
>  			return ERR_PTR(ret);
> +		}
>  	}
>  again:
>  	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
> -	if (!h)
> +	if (!h) {
> +		btrfs_qgroup_free(root, qgroup_reserved);
>  		return ERR_PTR(-ENOMEM);
> +	}
>  
>  	/*
>  	 * If we are JOIN_NOLOCK we're already committing a transaction and
> @@ -369,6 +373,7 @@ again:
>  		if (type < TRANS_JOIN_NOLOCK)
>  			sb_end_intwrite(root->fs_info->sb);
>  		kmem_cache_free(btrfs_trans_handle_cachep, h);
> +		btrfs_qgroup_free(root, qgroup_reserved);
>  		return ERR_PTR(ret);
>  	}
>  
> 

