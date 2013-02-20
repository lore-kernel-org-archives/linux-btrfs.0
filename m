Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab3BTOht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:37:49 -0500
Date: Wed, 20 Feb 2013 22:36:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 1/3] Btrfs: fix the qgroup reserved space is released
 prematurely
Message-ID: <20130220143628.GC4941@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <512493BC.4070105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512493BC.4070105@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 05:13:32PM +0800, Miao Xie wrote:
> In start_transactio(), we will try to join the transaction again after
> the current transaction is committed, so we should not release the
> reserved space of the qgroup. Fix it.

Why do we release the reserved space of the qgroup?

join
 |
 v
blocked && commit && goto again
 |
 v
fail somehow
 |
 v
release qgroup reserved space

The release part seems to be all right, am I missing something?

thanks,
liubo

> 
> Cc: Arne Jansen <sensille@gmx.net>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/transaction.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index fc03aa6..bc2f2d1 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -383,7 +383,7 @@ again:
>  	h->block_rsv = NULL;
>  	h->orig_rsv = NULL;
>  	h->aborted = 0;
> -	h->qgroup_reserved = qgroup_reserved;
> +	h->qgroup_reserved = 0;
>  	h->delayed_ref_elem.seq = 0;
>  	h->type = type;
>  	INIT_LIST_HEAD(&h->qgroup_ref_list);
> @@ -401,6 +401,7 @@ again:
>  		h->block_rsv = &root->fs_info->trans_block_rsv;
>  		h->bytes_reserved = num_bytes;
>  	}
> +	h->qgroup_reserved = qgroup_reserved;
>  
>  got_it:
>  	btrfs_record_root_in_trans(h, root);
> -- 
> 1.6.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
