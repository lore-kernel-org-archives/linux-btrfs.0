Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757753AbeD0KQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 06:16:19 -0400
Subject: Re: [PATCH] btrfs: Take trans lock before access running trans in
 check_delayed_ref
To: ethanwu <ethanwu@synology.com>, linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
References: <1524823126-23414-1-git-send-email-ethanwu@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <85f3de8b-3b59-954e-e293-269b18c90e7c@suse.com>
Date: Fri, 27 Apr 2018 13:16:15 +0300
MIME-Version: 1.0
In-Reply-To: <1524823126-23414-1-git-send-email-ethanwu@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.04.2018 12:58, ethanwu wrote:
> In preivous patch:
> Btrfs: kill trans in run_delalloc_nocow and btrfs_cross_ref_exist
> We avoid starting btrfs transaction and get this information from
> fs_info->running_transaction directly.
> 
> When accessing running_transaction in check_delayed_ref, there's a
> chance that current transaction will be freed by commit transaction
> after the NULL pointer check of running_transaction is passed.
> 
> After looking all the other places using fs_info->running_transaction,
> they are either protected by trans_lock or holding the transactions.
> 
> Fix this by using trans_lock and incrementing the use_count.

Yep, looking at how ->running_transaction is set/cleared, holding the
trans_lock is correct here. However there is one point which you need to
fix.

> 
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---
>  fs/btrfs/extent-tree.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c1618ab..c8fd37b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3149,7 +3149,11 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
>  	struct rb_node *node;
>  	int ret = 0;
>  
> +	spin_lock(&root->fs_info->trans_lock);
>  	cur_trans = root->fs_info->running_transaction;
> +	if (cur_trans)
> +		atomic_inc(&cur_trans->use_count);

The ->use_count is using refcount_inc now, not atomic_inc. Please base
all further upstream patches on upstream code

> +	spin_unlock(&root->fs_info->trans_lock);
>  	if (!cur_trans)
>  		return 0;
>  
> @@ -3158,6 +3162,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
>  	head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
>  	if (!head) {
>  		spin_unlock(&delayed_refs->lock);
> +		btrfs_put_transaction(cur_trans);
>  		return 0;
>  	}
>  
> @@ -3174,6 +3179,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
>  		mutex_lock(&head->mutex);
>  		mutex_unlock(&head->mutex);
>  		btrfs_put_delayed_ref_head(head);
> +		btrfs_put_transaction(cur_trans);
>  		return -EAGAIN;
>  	}
>  	spin_unlock(&delayed_refs->lock);
> @@ -3206,6 +3212,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
>  	}
>  	spin_unlock(&head->lock);
>  	mutex_unlock(&head->mutex);
> +	btrfs_put_transaction(cur_trans);
>  	return ret;
>  }
>  
> 
