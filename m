From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] Btrfs: fix how we freeze
Date: Tue, 23 Mar 2010 22:54:08 +0800
Message-ID: <20100323145408.GD2481@laptop.oracle.com>
References: <20100323142818.GB2381@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100323142818.GB2381@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

If the only thing is returning 0 in the freeze/unfreeze member functions, why
not just remove the two functions?

regards,
wengang.
On 10-03-23 10:28, Josef Bacik wrote:
> Currently we hold the transaction mutex and the cleaner mutex when we do a
> freeze, but the cleaner kthread does a vfs_check_frozen() to make sure it
> doesn't run while the fs is frozen, so the only thing thats left is the
> transaction stuff.  So add a vfs_check_frozen() into start_transaction and then
> make the freeze functions just return, since vfs_check_frozen() covers us in all
> the cases.  This works because the vfs freezer function sync's the filesystem
> first, and then sets SB_FREEZE_TRANS, so no transaction started after
> SB_FREEZE_TRANS is set should be allowed to complete, including people calling
> btrfs_join_transaction.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/super.c       |    6 ------
>  fs/btrfs/transaction.c |    2 ++
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 9ac612e..c9ded47 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -811,17 +811,11 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  
>  static int btrfs_freeze(struct super_block *sb)
>  {
> -	struct btrfs_root *root = btrfs_sb(sb);
> -	mutex_lock(&root->fs_info->transaction_kthread_mutex);
> -	mutex_lock(&root->fs_info->cleaner_mutex);
>  	return 0;
>  }
>  
>  static int btrfs_unfreeze(struct super_block *sb)
>  {
> -	struct btrfs_root *root = btrfs_sb(sb);
> -	mutex_unlock(&root->fs_info->cleaner_mutex);
> -	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 2d654c1..c3bc9ba 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -176,6 +176,8 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>  		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
>  	int ret;
>  
> +	vfs_check_frozen(root->fs_info->sb, SB_FREEZE_TRANS);
> +
>  	mutex_lock(&root->fs_info->trans_mutex);
>  	if (!root->fs_info->log_root_recovering &&
>  	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
