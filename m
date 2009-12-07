From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: change how we mount subvolumes
Date: Mon, 07 Dec 2009 09:52:30 +0900
Message-ID: <4B1C51CE.5070700@jp.fujitsu.com>
References: <20091204173827.GB5962@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091204173827.GB5962@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When I made snapshot listing, I thought 'subvol' parameter
is not enough as G.Baroncelli wrote. I think nice feature too.
(I tried to expand subvol parameter feature, by iterating
 dentry search(lookup_one_len) but I cannot treat dentries
 correctly yet. :)

But, is 'subvol=name' not prohibited yet? When I specified
'subvol=name', mount command simply mounts filesystem root
without error.

Josef Bacik wrote:
> This work is in preperation for being able to set a different root as the
> default mounting root.
> 
> There is currently a problem with how we mount subvolumes.  We cannot currently
> mount a subvolume of a subvolume, you can only mount subvolumes/snapshots of the
> default subvolume.  So say you take a snapshot of the default subvolume and call
> it snap1, and then take a snapshot of snap1 and call it snap2, so now you have
> 
> /
> /snap1
> /snap1/snap2
> 
> as your available volumes.  Currently you can only mount / and /snap1, you
> cannot mount /snap1/snap2.  To fix this problem instead of passing subvol=<name>
> you must pass in subvol=<treeid>, where <treeid> is the tree id that gets spit
> out via the subvolume listing you get from the subvolume listing patches
> (btrfsctl -l).  This allows us to mount /, /snap1 and /snap1/snap2 as the root
> volume.
> 
> In addition to the above, we also now read the default dir item in the tree root
> to get the root key that it points to.  For now this just points at what has
> always been the default subvolme, but later on I plan to change it to point at
> whatever root you want to be the new default root, so you can just set the
> default mount and not have to mount with -o subvol=<treeid>.  I tested this out
> with the above scenario and it worked perfectly.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/ctree.h      |    2 +-
>  fs/btrfs/export.c     |    4 +-
>  fs/btrfs/inode.c      |   10 ++-
>  fs/btrfs/relocation.c |    2 +-
>  fs/btrfs/super.c      |  167 +++++++++++++++++++++++++++++++++++-------------
>  fs/btrfs/tree-log.c   |    2 +-
>  6 files changed, 133 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 444b3e9..464f688 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2318,7 +2318,7 @@ int btrfs_init_cachep(void);
>  void btrfs_destroy_cachep(void);
>  long btrfs_ioctl_trans_end(struct file *file);
>  struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
> -			 struct btrfs_root *root);
> +			 struct btrfs_root *root, int *was_new);
>  int btrfs_commit_write(struct file *file, struct page *page,
>  		       unsigned from, unsigned to);
>  struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index ba5c3fd..951ef09 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -95,7 +95,7 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
>  	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
>  	key.offset = 0;
>  
> -	inode = btrfs_iget(sb, &key, root);
> +	inode = btrfs_iget(sb, &key, root, NULL);
>  	if (IS_ERR(inode)) {
>  		err = PTR_ERR(inode);
>  		goto fail;
> @@ -223,7 +223,7 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
>  
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
> -	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root));
> +	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root, NULL));
>  	if (!IS_ERR(dentry))
>  		dentry->d_op = &btrfs_dentry_operations;
>  	return dentry;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b3ad168..b383e53 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2131,7 +2131,7 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
>  		found_key.objectid = found_key.offset;
>  		found_key.type = BTRFS_INODE_ITEM_KEY;
>  		found_key.offset = 0;
> -		inode = btrfs_iget(root->fs_info->sb, &found_key, root);
> +		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
>  		if (IS_ERR(inode))
>  			break;
>  
> @@ -3609,7 +3609,7 @@ static struct inode *btrfs_iget_locked(struct super_block *s,
>   * Returns in *is_new if the inode was read from disk
>   */
>  struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
> -			 struct btrfs_root *root)
> +			 struct btrfs_root *root, int *new)
>  {
>  	struct inode *inode;
>  
> @@ -3624,6 +3624,8 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
>  
>  		inode_tree_add(inode);
>  		unlock_new_inode(inode);
> +		if (new)
> +			*new = 1;
>  	}
>  
>  	return inode;
> @@ -3676,7 +3678,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  		return NULL;
>  
>  	if (location.type == BTRFS_INODE_ITEM_KEY) {
> -		inode = btrfs_iget(dir->i_sb, &location, root);
> +		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
>  		return inode;
>  	}
>  
> @@ -3691,7 +3693,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  		else
>  			inode = new_simple_dir(dir->i_sb, &location, sub_root);
>  	} else {
> -		inode = btrfs_iget(dir->i_sb, &location, sub_root);
> +		inode = btrfs_iget(dir->i_sb, &location, sub_root, NULL);
>  	}
>  	srcu_read_unlock(&root->fs_info->subvol_srcu, index);
>  
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index cfcc93c..69fc10b 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3478,7 +3478,7 @@ static struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
>  	key.objectid = objectid;
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
> -	inode = btrfs_iget(root->fs_info->sb, &key, root);
> +	inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
>  	BUG_ON(IS_ERR(inode) || is_bad_inode(inode));
>  	BTRFS_I(inode)->index_cnt = group->key.objectid;
>  
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 752a546..bcbdc1b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -72,7 +72,7 @@ enum {
>  
>  static match_table_t tokens = {
>  	{Opt_degraded, "degraded"},
> -	{Opt_subvol, "subvol=%s"},
> +	{Opt_subvol, "subvol=%d"},
>  	{Opt_device, "device=%s"},
>  	{Opt_nodatasum, "nodatasum"},
>  	{Opt_nodatacow, "nodatacow"},
> @@ -277,12 +277,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>   * only when we need to allocate a new super block.
>   */
>  static int btrfs_parse_early_options(const char *options, fmode_t flags,
> -		void *holder, char **subvol_name,
> +		void *holder, u64 *subvol_objectid,
>  		struct btrfs_fs_devices **fs_devices)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *opts, *p;
>  	int error = 0;
> +	int intarg;
>  
>  	if (!options)
>  		goto out;
> @@ -303,7 +304,10 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  		token = match_token(p, tokens, args);
>  		switch (token) {
>  		case Opt_subvol:
> -			*subvol_name = match_strdup(&args[0]);
> +			intarg = 0;
> +			match_int(&args[0], &intarg);
> +			if (intarg)
> +				*subvol_objectid = intarg;
>  			break;
>  		case Opt_device:
>  			error = btrfs_scan_one_device(match_strdup(&args[0]),
> @@ -319,17 +323,110 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>   out_free_opts:
>  	kfree(opts);
>   out:
> +	return error;
> +}
> +
> +static struct dentry *get_default_root(struct super_block *sb, u64 subvol_objectid)
> +{
> +	struct btrfs_root *root = sb->s_fs_info;
> +	struct btrfs_root *new_root;
> +	struct btrfs_dir_item *di;
> +	struct btrfs_path *path;
> +	struct btrfs_key location;
> +	struct inode *inode;
> +	struct dentry *dentry;
> +	u64 dir_id;
> +	int new = 0;
> +
>  	/*
> -	 * If no subvolume name is specified we use the default one.  Allocate
> -	 * a copy of the string "." here so that code later in the
> -	 * mount path doesn't care if it's the default volume or another one.
> +	 * We have a specific subvol we want to mount, just setup location and
> +	 * go look up the root.
>  	 */
> -	if (!*subvol_name) {
> -		*subvol_name = kstrdup(".", GFP_KERNEL);
> -		if (!*subvol_name)
> -			return -ENOMEM;
> +	if (subvol_objectid) {
> +		location.objectid = subvol_objectid;
> +		location.type = BTRFS_ROOT_ITEM_KEY;
> +		location.offset = (u64)-1;
> +		goto find_root;
>  	}
> -	return error;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return ERR_PTR(-ENOMEM);
> +	path->leave_spinning = 1;
> +
> +	/*
> +	 * Find the "default" dir item which points to the root item that we
> +	 * will mount by default if we haven't been given a specific subvolume
> +	 * to mount.
> +	 */
> +	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
> +	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
> +	if (!di) {
> +		/*
> +		 * Ok the default dir item isn't there.  This is weird since
> +		 * it's always been there, but don't freak out, just try and
> +		 * mount to root most subvolume.
> +		 */
> +		btrfs_free_path(path);
> +		dir_id = BTRFS_FIRST_FREE_OBJECTID;
> +		new_root = root->fs_info->fs_root;
> +		goto setup_root;
> +	}
> +
> +	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
> +	btrfs_free_path(path);
> +
> +find_root:
> +	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
> +	if (IS_ERR(new_root))
> +		return ERR_PTR(PTR_ERR(new_root));
> +
> +	if (btrfs_root_refs(&new_root->root_item) == 0)
> +		return ERR_PTR(-ENOENT);
> +
> +	dir_id = btrfs_root_dirid(&new_root->root_item);
> +setup_root:
> +	location.objectid = dir_id;
> +	location.type = BTRFS_INODE_ITEM_KEY;
> +	location.offset = 0;
> +
> +	inode = btrfs_iget(sb, &location, new_root, &new);
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/*
> +	 * If we're just mounting the root most subvol put the inode and return
> +	 * a reference to the dentry.  We will have already gotten a reference
> +	 * to the inode in btrfs_fill_super so we're good to go.
> +	 */
> +	if (!new && sb->s_root->d_inode == inode) {
> +		iput(inode);
> +		return dget(sb->s_root);
> +	}
> +
> +	if (new) {
> +		const struct qstr name = { .name = "/", .len = 1 };
> +
> +		/*
> +		 * New inode, we need to make the dentry a sibling of s_root so
> +		 * everything gets cleaned up properly on unmount.
> +		 */
> +		dentry = d_alloc(sb->s_root, &name);
> +		if (!dentry) {
> +			iput(inode);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		d_splice_alias(inode, dentry);
> +	} else {
> +		/*
> +		 * We found the inode in cache, just find a dentry for it and
> +		 * put the reference to the inode we just got.
> +		 */
> +		dentry = d_find_alias(inode);
> +		iput(inode);
> +	}
> +
> +	return dentry;
>  }
>  
>  static int btrfs_fill_super(struct super_block *sb,
> @@ -365,7 +462,7 @@ static int btrfs_fill_super(struct super_block *sb,
>  	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
> -	inode = btrfs_iget(sb, &key, tree_root->fs_info->fs_root);
> +	inode = btrfs_iget(sb, &key, tree_root->fs_info->fs_root, NULL);
>  	if (IS_ERR(inode)) {
>  		err = PTR_ERR(inode);
>  		goto fail_close;
> @@ -377,12 +474,6 @@ static int btrfs_fill_super(struct super_block *sb,
>  		err = -ENOMEM;
>  		goto fail_close;
>  	}
> -#if 0
> -	/* this does the super kobj at the same time */
> -	err = btrfs_sysfs_add_super(tree_root->fs_info);
> -	if (err)
> -		goto fail_close;
> -#endif
>  
>  	sb->s_root = root_dentry;
>  
> @@ -472,29 +563,30 @@ static int btrfs_test_super(struct super_block *s, void *data)
>  static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  		const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -	char *subvol_name = NULL;
>  	struct block_device *bdev = NULL;
>  	struct super_block *s;
>  	struct dentry *root;
>  	struct btrfs_fs_devices *fs_devices = NULL;
>  	fmode_t mode = FMODE_READ;
> +	u64 subvol_objectid = 0;
>  	int error = 0;
> +	int found = 0;
>  
>  	if (!(flags & MS_RDONLY))
>  		mode |= FMODE_WRITE;
>  
>  	error = btrfs_parse_early_options(data, mode, fs_type,
> -					  &subvol_name, &fs_devices);
> +					  &subvol_objectid, &fs_devices);
>  	if (error)
>  		return error;
>  
>  	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
>  	if (error)
> -		goto error_free_subvol_name;
> +		goto error;
>  
>  	error = btrfs_open_devices(fs_devices, mode, fs_type);
>  	if (error)
> -		goto error_free_subvol_name;
> +		goto error;
>  
>  	if (!(flags & MS_RDONLY) && fs_devices->rw_devices == 0) {
>  		error = -EACCES;
> @@ -513,6 +605,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  			goto error_close_devices;
>  		}
>  
> +		found = 1;
>  		btrfs_close_devices(fs_devices);
>  	} else {
>  		char b[BDEVNAME_SIZE];
> @@ -523,46 +616,30 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  					 flags & MS_SILENT ? 1 : 0);
>  		if (error) {
>  			deactivate_locked_super(s);
> -			goto error_free_subvol_name;
> +			goto error;
>  		}
>  
>  		btrfs_sb(s)->fs_info->bdev_holder = fs_type;
>  		s->s_flags |= MS_ACTIVE;
>  	}
>  
> -	if (!strcmp(subvol_name, "."))
> -		root = dget(s->s_root);
> -	else {
> -		mutex_lock(&s->s_root->d_inode->i_mutex);
> -		root = lookup_one_len(subvol_name, s->s_root,
> -				      strlen(subvol_name));
> -		mutex_unlock(&s->s_root->d_inode->i_mutex);
> -
> -		if (IS_ERR(root)) {
> -			deactivate_locked_super(s);
> -			error = PTR_ERR(root);
> -			goto error_free_subvol_name;
> -		}
> -		if (!root->d_inode) {
> -			dput(root);
> -			deactivate_locked_super(s);
> -			error = -ENXIO;
> -			goto error_free_subvol_name;
> -		}
> +	root = get_default_root(s, subvol_objectid);
> +	if (IS_ERR(root)) {
> +		error = PTR_ERR(root);
> +		deactivate_locked_super(s);
> +		goto error;
>  	}
>  
>  	mnt->mnt_sb = s;
>  	mnt->mnt_root = root;
>  
> -	kfree(subvol_name);
>  	return 0;
>  
>  error_s:
>  	error = PTR_ERR(s);
>  error_close_devices:
>  	btrfs_close_devices(fs_devices);
> -error_free_subvol_name:
> -	kfree(subvol_name);
> +error:
>  	return error;
>  }
>  
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 741666a..c0c2c1c 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -445,7 +445,7 @@ static noinline struct inode *read_one_inode(struct btrfs_root *root,
>  	key.objectid = objectid;
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
> -	inode = btrfs_iget(root->fs_info->sb, &key, root);
> +	inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
>  	if (IS_ERR(inode)) {
>  		inode = NULL;
>  	} else if (is_bad_inode(inode)) {


-- 
taruisi

