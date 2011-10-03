From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: introduce mount option no_space_cache
Date: Mon, 3 Oct 2011 23:51:30 +0200
Message-ID: <20111003215130.GN22205@twin.jikos.cz>
References: <1317665561-8114-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317665561-8114-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 03, 2011 at 02:12:41PM -0400, Josef Bacik wrote:
> Some users have requested this and I've found I needed a way to disable cache
> loading without actually clearing the cache, so introduce the no_space_cache
> option.  Before we check the super blocks cache generation field and if it was
> populated we always turned space caching on.  Now we check this and set the
> space cache option on, and then parse the mount options so that if we want it
> off it get's turned off.  Then we check the mount option all the places we do
> the caching work instead of checking the super's cache generation.  This makes
> things more consistent and lets us turn space caching off.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/extent-tree.c |    9 ++++-----
>  fs/btrfs/super.c       |   23 ++++++++++++++++++-----
>  fs/btrfs/transaction.c |    2 +-
>  3 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 25b69d0..f9711a8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -481,7 +481,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
>  	 * we likely hold important locks.
>  	 */
>  	if (trans && (!trans->transaction->in_commit) &&
> -	    (root && root != root->fs_info->tree_root)) {
> +	    (root && root != root->fs_info->tree_root) &&
> +	    btrfs_test_opt(root, SPACE_CACHE)) {
>  		spin_lock(&cache->lock);
>  		if (cache->cached != BTRFS_CACHE_NO) {
>  			spin_unlock(&cache->lock);
> @@ -4223,7 +4224,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
>  		spin_lock(&cache->space_info->lock);
>  		spin_lock(&cache->lock);
>  
> -		if (btrfs_super_cache_generation(&info->super_copy) != 0 &&
> +		if (btrfs_test_opt(root, SPACE_CACHE) &&
>  		    cache->disk_cache_state < BTRFS_DC_CLEAR)
>  			cache->disk_cache_state = BTRFS_DC_CLEAR;
>  
> @@ -7038,13 +7039,11 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>  	path->reada = 1;
>  
>  	cache_gen = btrfs_super_cache_generation(&root->fs_info->super_copy);
> -	if (cache_gen != 0 &&
> +	if (btrfs_test_opt(root, SPACE_CACHE) &&
>  	    btrfs_super_generation(&root->fs_info->super_copy) != cache_gen)
>  		need_clear = 1;
>  	if (btrfs_test_opt(root, CLEAR_CACHE))
>  		need_clear = 1;
> -	if (!btrfs_test_opt(root, SPACE_CACHE) && cache_gen)
> -		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
>  
>  	while (1) {
>  		ret = find_first_block_group(root, path, &key);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 934789f..bfee12d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -164,7 +164,7 @@ enum {
>  	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
>  	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
>  	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
> -	Opt_inode_cache, Opt_err,
> +	Opt_inode_cache, Opt_no_space_cache, Opt_err,

how about _not_ adding a new optoin and just extend the existing one:

space_cache=off

>  };
>  
>  static match_table_t tokens = {
> @@ -197,6 +197,7 @@ static match_table_t tokens = {
>  	{Opt_subvolrootid, "subvolrootid=%d"},
>  	{Opt_defrag, "autodefrag"},
>  	{Opt_inode_cache, "inode_cache"},
> +	{Opt_no_space_cache, "no_space_cache"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -208,14 +209,19 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  {
>  	struct btrfs_fs_info *info = root->fs_info;
>  	substring_t args[MAX_OPT_ARGS];
> -	char *p, *num, *orig;
> +	char *p, *num, *orig = NULL;
> +	u64 cache_gen;
>  	int intarg;
>  	int ret = 0;
>  	char *compress_type;
>  	bool compress_force = false;
>  
> +	cache_gen = btrfs_super_cache_generation(&root->fs_info->super_copy);
> +	if (cache_gen)
> +		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> +
>  	if (!options)
> -		return 0;
> +		goto out;
>  
>  	/*
>  	 * strsep changes the string, duplicate it because parse_options
> @@ -362,9 +368,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			btrfs_set_opt(info->mount_opt, DISCARD);
>  			break;
>  		case Opt_space_cache:
> -			printk(KERN_INFO "btrfs: enabling disk space caching\n");
>  			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
>  			break;
> +		case Opt_no_space_cache:
> +			printk(KERN_INFO "btrfs: disabling disk space caching\n");
> +			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
> +			break;
>  		case Opt_inode_cache:
>  			printk(KERN_INFO "btrfs: enabling inode map caching\n");
>  			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
> @@ -393,6 +402,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  		}
>  	}
>  out:
> +	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
> +		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
>  	kfree(orig);
>  	return ret;
>  }
> @@ -686,7 +697,9 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
>  		seq_puts(seq, ",noacl");
>  	if (btrfs_test_opt(root, SPACE_CACHE))
> -		seq_puts(seq, ",space_cache");
> +		seq_puts(seq, ",space_cache=on");
> +	else
> +		seq_puts(seq, ",space_cache=off");

and this is not symmetric to how it's specified to mount, there is no
'no_space_cache' option.

>  	if (btrfs_test_opt(root, CLEAR_CACHE))
>  		seq_puts(seq, ",clear_cache");
>  	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4565579..1e1a481 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1003,7 +1003,7 @@ static void update_super_roots(struct btrfs_root *root)
>  	super->root = root_item->bytenr;
>  	super->generation = root_item->generation;
>  	super->root_level = root_item->level;
> -	if (super->cache_generation != 0 || btrfs_test_opt(root, SPACE_CACHE))
> +	if (btrfs_test_opt(root, SPACE_CACHE))
>  		super->cache_generation = root_item->generation;
>  }

otherwise, I agree that this option may come handy, I have seen delayed
mounts when freespace thread was writing out tons of data for ~5-10
minutes during umount.

Same =off extension can be added to inode_cache.


david
