Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55662 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2INLPW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 07:15:22 -0400
Date: Fri, 14 Sep 2012 13:15:16 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] Btrfs: fix trans block rsv regression
Message-ID: <20120914111516.GF17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 04:58:04PM +0800, Liu Bo wrote:
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -306,9 +306,17 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>  		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK &&
>  			type != TRANS_JOIN_ONLY);
>  		h = current->journal_info;
> -		h->use_count++;
> -		h->orig_rsv = h->block_rsv;
> +		if (h->block_rsv) {
> +			struct btrfs_trans_rsv_item *item;
> +			item = kmalloc(sizeof(*item), GFP_NOFS);

I'd rather avoid the kmalloc here and add a list hook into
btrfs_block_rsv itself (used only for this purpose).

It also does not increase the failure surface and we don't have to
handle error conditions from deep callchains.

> +			if (!item)
> +				return ERR_PTR(-ENOMEM);
> +			item->rsv = h->block_rsv;
> +			INIT_LIST_HEAD(&item->list);
> +			list_add(&item->list, &h->blk_rsv_list);
> +		}
>  		h->block_rsv = NULL;
> +		h->use_count++;
>  		goto got_it;
>  	} else if (type == TRANS_JOIN_ONLY) {
>  		return ERR_PTR(-ENOENT);
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -57,7 +57,6 @@ struct btrfs_trans_handle {
>  	unsigned long delayed_ref_updates;
>  	struct btrfs_transaction *transaction;
>  	struct btrfs_block_rsv *block_rsv;
> -	struct btrfs_block_rsv *orig_rsv;
>  	int aborted;
>  	int adding_csums;
>  	/*
> @@ -68,6 +67,12 @@ struct btrfs_trans_handle {
>  	struct btrfs_root *root;
>  	struct seq_list delayed_ref_elem;
>  	struct list_head qgroup_ref_list;
> +	struct list_head blk_rsv_list;

Does it refer to chain of orig_rsv's ? Ie. naming it orig_blk_rsv_list

> +};
> +
> +struct btrfs_trans_rsv_item {
> +	struct btrfs_block_rsv *rsv;
> +	struct list_head list;

Generally, for such 'list of single pointers' structs I'd evaluate the
possibility of embedding the hook inside the struct, the overhead
(memory, processing) is not desirable.

>  };
>  
>  struct btrfs_pending_snapshot {
