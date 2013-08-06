Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3HFUhf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 16:37:35 -0400
Message-ID: <52015E8A.9000300@redhat.com>
Date: Tue, 06 Aug 2013 15:37:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/6/13 1:27 PM, Filipe David Borba Manana wrote:
> This change allows for most mount options to be persisted in
> the filesystem, and be applied when the filesystem is mounted.
> If the same options are specified at mount time, the persisted
> values for those options are ignored.
> 
> The only options not supported are: subvol, subvolid, subvolrootid,
> device and thread_pool. This limitation is due to how this feature
> is implemented: basically there's an optional value (of type
> struct btrfs_dir_item) in the tree of tree roots used to store the
> list of options in the same format as they are passed to btrfs_mount().
> This means any mount option that takes effect before the tree of tree
> roots is setup is not supported.
> 
> To set these options, the user space tool btrfstune was modified
> to persist the list of options into an unmounted filesystem's
> tree of tree roots.

So, it does this thing, ok - but why?
What is seen as the administrative advantage of this new mechanism?

Just to play devil's advocate, and to add a bit of history:

On any production system, the filesystems will be mounted via fstab,
which has the advantages of being widely known, well understood, and
100% expected - as well as being transparent, unsurprising, and seamless.

For history: ext4 did this too.  And now it's in a situation where it's
got mount options coming at it from both the superblock and from
the commandline (or fstab), and sometimes they conflict; it also tries
to report mount options in /proc/mounts, but has grown hairy code
to decide which ones to print and which ones to not print (if it's
a "default" option, don't print it in /proc/mounts, but what's default,
code-default or fs-default?)  And it's really kind of an ugly mess.

Further, mounting 2 filesystems w/ no options in fstab or on the
commandline, and getting different behavior due to hidden (sorry,
persistent) options in the fs itself is surprising, and surprise
is rarely good.

So this patch adds 100+ lines of new code, to implement this idea, but:
what is the advantage?  Unless there is a compelling administrative
use case, I'd vote against it.  Lines of code that don't exist don't
have bugs.  ;)

-Eric

> NOTE: Like the corresponding btrfs-progs patch, this is a WIP with
> the goal o gathering feedback.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ctree.h   |   11 +++++++-
>  fs/btrfs/disk-io.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/super.c   |   46 +++++++++++++++++++++++++++++++--
>  3 files changed, 125 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index cbb1263..24363df 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -121,6 +121,14 @@ struct btrfs_ordered_sum;
>   */
>  #define BTRFS_FREE_INO_OBJECTID -12ULL
>  
> +/*
> + * Item that stores permanent mount options. These options
> + * have effect if they are not specified as well at mount
> + * time (that is, if a permanent option is also specified at
> + * mount time, the later wins).
> + */
> +#define BTRFS_PERSISTENT_OPTIONS_OBJECTID -13ULL
> +
>  /* dummy objectid represents multiple objectids */
>  #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
>  
> @@ -3739,7 +3747,8 @@ void btrfs_exit_sysfs(void);
>  ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
>  
>  /* super.c */
> -int btrfs_parse_options(struct btrfs_root *root, char *options);
> +int btrfs_parse_options(struct btrfs_root *root, char *options,
> +			int parsing_persistent, int **options_parsed);
>  int btrfs_sync_fs(struct super_block *sb, int wait);
>  
>  #ifdef CONFIG_PRINTK
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 254cdc8..eeabdd4 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2077,6 +2077,53 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
>  	}
>  }
>  
> +static char *get_persistent_options(struct btrfs_root *tree_root)
> +{
> +	int ret;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	struct btrfs_dir_item *di;
> +	u32 name_len, data_len;
> +	char *options = NULL;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return ERR_PTR(-ENOMEM);
> +
> +	key.objectid = BTRFS_PERSISTENT_OPTIONS_OBJECTID;
> +	key.type = 0;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	di = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
> +	name_len = btrfs_dir_name_len(leaf, di);
> +	data_len = btrfs_dir_data_len(leaf, di);
> +	options = kmalloc(data_len + 1, GFP_NOFS);
> +	if (!options) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	read_extent_buffer(leaf, options,
> +			   (unsigned long)((char *)(di + 1) + name_len),
> +			   data_len);
> +	options[data_len] = '\0';
> +
> +out:
> +	btrfs_free_path(path);
> +	if (ret)
> +		return ERR_PTR(ret);
> +	return options;
> +}
> +
>  int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options)
> @@ -2103,6 +2150,8 @@ int open_ctree(struct super_block *sb,
>  	int err = -EINVAL;
>  	int num_backups_tried = 0;
>  	int backup_index = 0;
> +	int *mnt_options = NULL;
> +	char *persist_options = NULL;
>  
>  	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
>  	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
> @@ -2372,7 +2421,7 @@ int open_ctree(struct super_block *sb,
>  	 */
>  	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
>  
> -	ret = btrfs_parse_options(tree_root, options);
> +	ret = btrfs_parse_options(tree_root, options, 0, &mnt_options);
>  	if (ret) {
>  		err = ret;
>  		goto fail_alloc;
> @@ -2656,6 +2705,26 @@ retry_root_backup:
>  	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
>  	tree_root->commit_root = btrfs_root_node(tree_root);
>  
> +	persist_options = get_persistent_options(tree_root);
> +	if (IS_ERR(persist_options)) {
> +		ret = PTR_ERR(persist_options);
> +		goto fail_tree_roots;
> +	} else if (persist_options) {
> +		ret = btrfs_parse_options(tree_root, persist_options,
> +					  1, &mnt_options);
> +		kfree(mnt_options);
> +		mnt_options = NULL;
> +		if (ret) {
> +			err = ret;
> +			goto fail_tree_roots;
> +		}
> +		if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO) {
> +			features = btrfs_super_incompat_flags(disk_super);
> +			features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
> +			btrfs_set_super_incompat_flags(disk_super, features);
> +		}
> +	}
> +
>  	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
>  	location.type = BTRFS_ROOT_ITEM_KEY;
>  	location.offset = 0;
> @@ -2904,6 +2973,7 @@ fail_block_groups:
>  	btrfs_free_block_groups(fs_info);
>  
>  fail_tree_roots:
> +	kfree(mnt_options);
>  	free_root_pointers(fs_info, 1);
>  	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 2cc5b80..ced0a85 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -369,7 +369,8 @@ static match_table_t tokens = {
>   * reading in a new superblock is parsed here.
>   * XXX JDM: This needs to be cleaned up for remount.
>   */
> -int btrfs_parse_options(struct btrfs_root *root, char *options)
> +int btrfs_parse_options(struct btrfs_root *root, char *options,
> +			int parsing_persistent, int **options_parsed)
>  {
>  	struct btrfs_fs_info *info = root->fs_info;
>  	substring_t args[MAX_OPT_ARGS];
> @@ -379,11 +380,21 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  	int ret = 0;
>  	char *compress_type;
>  	bool compress_force = false;
> +	int *parsed = NULL;
>  
>  	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
>  	if (cache_gen)
>  		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
>  
> +	if (!parsing_persistent && options_parsed) {
> +		parsed = kzalloc(sizeof(int) * ARRAY_SIZE(tokens), GFP_NOFS);
> +		if (!parsed)
> +			return -ENOMEM;
> +		*options_parsed = parsed;
> +	} else if (parsing_persistent && options_parsed) {
> +		parsed = *options_parsed;
> +	}
> +
>  	if (!options)
>  		goto out;
>  
> @@ -403,6 +414,37 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			continue;
>  
>  		token = match_token(p, tokens, args);
> +
> +		if (parsing_persistent && parsed) {
> +			/*
> +			 * A persistent option value is ignored if a value for
> +			 * that option was given at mount time.
> +			 */
> +
> +			if (parsed[token])
> +				continue;
> +			if (token == Opt_no_space_cache &&
> +			    parsed[Opt_space_cache])
> +				continue;
> +			if (token == Opt_space_cache &&
> +			    parsed[Opt_no_space_cache])
> +				continue;
> +
> +			if (token == Opt_subvol)
> +				printk(KERN_WARNING "btrfs: subvol not supported as a persistent option");
> +			else if (token == Opt_subvolid)
> +				printk(KERN_WARNING "btrfs: subvolid not supported as a persistent option");
> +			else if (token == Opt_subvolrootid)
> +				printk(KERN_WARNING "btrfs: subvolrootid not supported as a persistent option");
> +			else if (token == Opt_device)
> +				printk(KERN_WARNING "btrfs: device not supported as a persistent option");
> +			else if (token == Opt_thread_pool)
> +				printk(KERN_WARNING "btrfs: thread_pool not supported as a persistent option");
> +		}
> +
> +		if (!parsing_persistent && parsed)
> +			parsed[token] = 1;
> +
>  		switch (token) {
>  		case Opt_degraded:
>  			printk(KERN_INFO "btrfs: allowing degraded mounts\n");
> @@ -1279,7 +1321,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  
>  	btrfs_remount_prepare(fs_info);
>  
> -	ret = btrfs_parse_options(root, data);
> +	ret = btrfs_parse_options(root, data, 0, NULL);
>  	if (ret) {
>  		ret = -EINVAL;
>  		goto restore;
> 

