From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] btrfs: notreelog mount option
Date: Tue, 3 Mar 2009 11:00:03 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0903031053210.18308@cobra.newdream.net>
References: <1232744949-25011-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232744949-25011-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris-

Just pinging you on this patch...

On Fri, 23 Jan 2009, Sage Weil wrote:

> Add a 'notreelog' mount option to disable the tree log (used by fsync,
> O_SYNC writes).
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/ctree.h    |    1 +
>  fs/btrfs/super.c    |    8 +++++++-
>  fs/btrfs/tree-log.c |    4 ++++
>  3 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index de103a8..471fa67 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -950,6 +950,7 @@ struct btrfs_root {
>  #define BTRFS_MOUNT_SSD			(1 << 3)
>  #define BTRFS_MOUNT_DEGRADED		(1 << 4)
>  #define BTRFS_MOUNT_COMPRESS		(1 << 5)
> +#define BTRFS_MOUNT_NOTREELOG           (1 << 6)
>  
>  #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>  #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4c0b756..d8c664c 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -66,7 +66,8 @@ static void btrfs_put_super(struct super_block *sb)
>  enum {
>  	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
>  	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
> -	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_err,
> +	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_notreelog,
> +	Opt_err,
>  };
>  
>  static match_table_t tokens = {
> @@ -83,6 +84,7 @@ static match_table_t tokens = {
>  	{Opt_compress, "compress"},
>  	{Opt_ssd, "ssd"},
>  	{Opt_noacl, "noacl"},
> +	{Opt_notreelog, "notreelog"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -222,6 +224,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  		case Opt_noacl:
>  			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
>  			break;
> +		case Opt_notreelog:
> +			printk(KERN_INFO "btrfs: disabling tree log\n");
> +			btrfs_set_opt(info->mount_opt, NOTREELOG);
> +			break;
>  		default:
>  			break;
>  		}
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 4f26f3e..ac58991 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2757,6 +2757,10 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
>  			  struct btrfs_root *root, struct dentry *dentry)
>  {
>  	u64 gen;
> +
> +	if (btrfs_test_opt(root, NOTREELOG))
> +		return 1;
> +
>  	gen = root->fs_info->last_trans_new_blockgroup;
>  	if (gen > root->fs_info->last_trans_committed)
>  		return 1;
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
