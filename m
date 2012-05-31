Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2EaSaa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 14:30:30 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VIUUXn007056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 14:30:30 -0400
Date: Thu, 31 May 2012 14:30:29 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make sure to unblock the transaction when
 cleaning it up
Message-ID: <20120531183028.GG2080@localhost.localdomain>
References: <1338477277-5793-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338477277-5793-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 11:14:37AM -0400, Josef Bacik wrote:
> When a transaction aborts we can get stuck in places where tasks are waiting
> for the transaction to become unblocked.  So we need to unblock the
> transaction and wake up any waiters so they can exit properly.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/transaction.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7aed0e8..1715afb 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1204,9 +1204,16 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
>  	WARN_ON(trans->use_count > 1);
>  
>  	spin_lock(&root->fs_info->trans_lock);
> +	cur_trans->blocked = 0;
>  	list_del_init(&cur_trans->list);
> +	if (root->fs_info->running_transaction == cur_trans) {
> +		root->fs_info->running_transaction = NULL;
> +		root->fs_info->trans_no_join = 0;
> +	}
>  	spin_unlock(&root->fs_info->trans_lock);
>  
> +	wake_up(&root->fs_info->transaction_wait);
> +
>  	btrfs_cleanup_one_transaction(trans->transaction, root);
>  
>  	put_transaction(cur_trans);
> -- 
> 1.7.7.6

Actually ignore this, the problem is btrfs_cleanup_one_transaction is just doing
waitqueue_active() which is racy, we need to fix it to wake_up, so I'll fix that
and send it along.  Thanks,

Josef
