Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48087 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762892AbcINNal (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 09:30:41 -0400
Subject: Re: [PATCH] Btrfs: remove BUG_ON in start_transaction
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1473819348-8681-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <9b7c046c-1259-788b-f976-32cc2207caf2@fb.com>
Date: Wed, 14 Sep 2016 09:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <1473819348-8681-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/13/2016 10:15 PM, Liu Bo wrote:
> Since we could get errors from the concurrent aborted transaction,
> the check of this BUG_ON in start_transaction is not true any more.
>
> Say, while flushing free space cache inode's dirty pages,
> btrfs_finish_ordered_io
>  -> btrfs_join_transaction_nolock
>       (the transaction has been aborted.)
>       -> BUG_ON(type == TRANS_JOIN_NOLOCK);
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/transaction.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 95d4191..6d06365 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -549,11 +549,8 @@ again:
>  		}
>  	} while (ret == -EBUSY);
>
> -	if (ret < 0) {
> -		/* We must get the transaction if we are JOIN_NOLOCK. */
> -		BUG_ON(type == TRANS_JOIN_NOLOCK);
> +	if (ret < 0)
>  		goto join_fail;
> -	}
>
>  	cur_trans = root->fs_info->running_transaction;
>
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
