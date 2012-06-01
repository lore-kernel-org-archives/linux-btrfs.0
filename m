Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53596 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab2FABRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 21:17:08 -0400
Message-ID: <4FC8196D.8010407@cn.fujitsu.com>
Date: Fri, 01 Jun 2012 09:22:53 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: track transaction aborted across the fs_info
References: <1338494656-12232-1-git-send-email-josef@redhat.com> <1338494656-12232-2-git-send-email-josef@redhat.com>
In-Reply-To: <1338494656-12232-2-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2012 04:04 AM, Josef Bacik wrote:

> If we abort a transaction during the commit phase we can have people who
> start new transactions because we nave no way of signaling to them that
> something went wrong.  So add a trans_aborted flag to the fs_info so the
> start transaction code can be notified that the last transaction was aborted
> and it needs to return an error.  Thanks,
> 


We already have a (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR),
why don't just use that?

thanks,
liubo

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/ctree.h       |    1 +
>  fs/btrfs/super.c       |    1 +
>  fs/btrfs/transaction.c |   14 ++++++++++++++
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 5f2c6d1..34549ca 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1213,6 +1213,7 @@ struct btrfs_fs_info {
>  	int log_root_recovering;
>  	int enospc_unlink;
>  	int trans_no_join;
> +	int trans_aborted;
>  
>  	u64 total_pinned;
>  
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 85cef50..e0abe7f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -226,6 +226,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>  		return;
>  	}
>  	trans->transaction->aborted = errno;
> +	root->fs_info->trans_aborted = errno;
>  	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
>  }
>  /*
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4e6f63e..e292b83 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -77,13 +77,21 @@ loop:
>  		if (cur_trans->aborted) {
>  			spin_unlock(&root->fs_info->trans_lock);
>  			return cur_trans->aborted;
> +		} else if (root->fs_info->trans_aborted) {
> +			WARN_ON(1);
> +			spin_unlock(&root->fs_info->trans_lock);
> +			return root->fs_info->trans_aborted;
>  		}
>  		atomic_inc(&cur_trans->use_count);
>  		atomic_inc(&cur_trans->num_writers);
>  		cur_trans->num_joined++;
>  		spin_unlock(&root->fs_info->trans_lock);
>  		return 0;
> +	} else if (root->fs_info->trans_aborted) {
> +		spin_unlock(&root->fs_info->trans_lock);
> +		return root->fs_info->trans_aborted;
>  	}
> +
>  	spin_unlock(&root->fs_info->trans_lock);
>  
>  	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
> @@ -99,6 +107,10 @@ loop:
>  		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
>  		cur_trans = root->fs_info->running_transaction;
>  		goto loop;
> +	} else if (root->fs_info->trans_aborted) {
> +		spin_unlock(&root->fs_info->trans_lock);
> +		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
> +		return root->fs_info->trans_aborted;
>  	}
>  
>  	atomic_set(&cur_trans->num_writers, 1);
> @@ -1209,6 +1221,8 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
>  		root->fs_info->running_transaction = NULL;
>  		root->fs_info->trans_no_join = 0;
>  	}
> +	if (!root->fs_info->trans_aborted)
> +		root->fs_info->trans_aborted = -EROFS;
>  	spin_unlock(&root->fs_info->trans_lock);
>  
>  	btrfs_cleanup_one_transaction(trans->transaction, root);


