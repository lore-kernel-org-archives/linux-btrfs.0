From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Add missing unlocks on error paths
Date: Wed, 25 Apr 2012 13:08:04 -0400
Message-ID: <20120425170803.GA17006@localhost.localdomain>
References: <1335369891-19137-1-git-send-email-daniel@quora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335369891-19137-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 12:04:51AM +0800, Daniel J Blueman wrote:
> Correctly drop locks during error cases.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  fs/btrfs/transaction.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 11b77a5..ede3988 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -73,8 +73,11 @@ loop:
>  
>  	cur_trans = root->fs_info->running_transaction;
>  	if (cur_trans) {
> -		if (cur_trans->aborted)
> +		if (cur_trans->aborted) {
> +			spin_unlock(&root->fs_info->trans_lock);
>  			return cur_trans->aborted;
> +		}
> +
>  		atomic_inc(&cur_trans->use_count);
>  		atomic_inc(&cur_trans->num_writers);
>  		cur_trans->num_joined++;
> @@ -1400,6 +1403,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	ret = commit_fs_roots(trans, root);
>  	if (ret) {
>  		mutex_unlock(&root->fs_info->tree_log_mutex);
> +		mutex_unlock(&root->fs_info->reloc_mutex);
>  		goto cleanup_transaction;
>  	}
>  
> @@ -1411,6 +1415,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	ret = commit_cowonly_roots(trans, root);
>  	if (ret) {
>  		mutex_unlock(&root->fs_info->tree_log_mutex);
> +		mutex_unlock(&root->fs_info->reloc_mutex);
>  		goto cleanup_transaction;
>  	}
>  
> -- 
> 1.7.9.5
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
