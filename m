From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] btrfs: flushoncommit mount option
Date: Tue, 3 Mar 2009 11:00:08 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0903031059110.18308@cobra.newdream.net>
References: <1232755349-27099-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232755349-27099-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

...and this one!

thanks-
sage

On Fri, 23 Jan 2009, Sage Weil wrote:

> Hi Chris-
> 
> Here's a simpler version of the patch that drops the unrelated sync_fs 
> stuff.
> 
> thanks-
> sage
> 
> 
> The 'flushoncommit' mount option forces any data dirtied by a write in a
> prior transaction to commit as part of the current commit.  This makes
> the committed state a fully consistent view of the file system from the
> application's perspective (i.e., it includes all completed file system
> operations).  This was previously the behavior only when a snapshot is
> created.
> 
> This is used by Ceph to ensure that completed writes make it to the
> platter along with the metadata operations they are bound to (by
> BTRFS_IOC_TRANS_{START,END}).
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/ctree.h       |    1 +
>  fs/btrfs/super.c       |   10 +++++++---
>  fs/btrfs/transaction.c |    5 ++++-
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 471fa67..019e7a7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -951,6 +951,7 @@ struct btrfs_root {
>  #define BTRFS_MOUNT_DEGRADED		(1 << 4)
>  #define BTRFS_MOUNT_COMPRESS		(1 << 5)
>  #define BTRFS_MOUNT_NOTREELOG           (1 << 6)
> +#define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
>  
>  #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>  #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d8c664c..2b33a6a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -67,7 +67,7 @@ enum {
>  	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
>  	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
>  	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_notreelog,
> -	Opt_err,
> +	Opt_flushoncommit, Opt_err,
>  };
>  
>  static match_table_t tokens = {
> @@ -85,6 +85,7 @@ static match_table_t tokens = {
>  	{Opt_ssd, "ssd"},
>  	{Opt_noacl, "noacl"},
>  	{Opt_notreelog, "notreelog"},
> +	{Opt_flushoncommit, "flushoncommit"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -228,6 +229,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			printk(KERN_INFO "btrfs: disabling tree log\n");
>  			btrfs_set_opt(info->mount_opt, NOTREELOG);
>  			break;
> +		case Opt_flushoncommit:
> +			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
> +			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
> +			break;
>  		default:
>  			break;
>  		}
> @@ -369,9 +374,8 @@ fail_close:
>  int btrfs_sync_fs(struct super_block *sb, int wait)
>  {
>  	struct btrfs_trans_handle *trans;
> -	struct btrfs_root *root;
> +	struct btrfs_root *root = btrfs_sb(sb);
>  	int ret;
> -	root = btrfs_sb(sb);
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 919172d..b8822d5 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -892,6 +892,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	struct extent_io_tree *pinned_copy;
>  	DEFINE_WAIT(wait);
>  	int ret;
> +	int ordered = btrfs_test_opt(root, FLUSHONCOMMIT);
>  
>  	INIT_LIST_HEAD(&dirty_fs_roots);
>  	mutex_lock(&root->fs_info->trans_mutex);
> @@ -952,7 +953,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  		mutex_unlock(&root->fs_info->trans_mutex);
>  
> -		if (snap_pending) {
> +		if (ordered || snap_pending) {
> +			if (ordered)
> +				btrfs_start_delalloc_inodes(root);
>  			ret = btrfs_wait_ordered_extents(root, 1);
>  			BUG_ON(ret);
>  		}
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
