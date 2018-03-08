Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48155 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbeCHJre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 04:47:34 -0500
Subject: Re: [PATCH 2/2] btrfs: Add unprivileged version of ino_lookup ioctl
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
 <4c126e0b-9fea-f489-992d-71dba1f63c4d@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b8b89390-7bba-9f6b-2c79-5b60b4c3d085@suse.com>
Date: Thu, 8 Mar 2018 11:47:32 +0200
MIME-Version: 1.0
In-Reply-To: <4c126e0b-9fea-f489-992d-71dba1f63c4d@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.03.2018 10:31, Misono, Tomohiro wrote:
> Add unprivileged version of ino_lookup ioctl (BTRFS_IOC_INO_LOOKUP_USER)
> to allow normal users to call "btrfs subvololume list/show" etc. in
> combination with BTRFS_IOC_GET_SUBVOL_INFO.
> 
> This can be used like BTRFS_IOC_INO_LOOKUP but the argument is
> different because it also returns the name of bottom subvolume,
> which is ommited by BTRFS_IOC_GET_SUBVOL_INFO ioctl.
> Also, this must be called with fd which exists under the tree of
> args->treeid to prevent for user to search any tree.
> 
> The main differences from original ino_lookup ioctl are:
>   1. Read permission will be checked using inode_permission()
>      during path construction. -EACCES will be returned in case
>      of failure.
>   2. Path construction will be stopped at the inode number which
>      corresponds to the fd with which this ioctl is called. If
>      constructed path does not exist under fd's inode, -EACCES
>      will be returned.
>   3. The name of bottom subvolume is also searched and filled.
> 
> Note that the maximum length of path is shorter 272 bytes than

Did you mean 255? Since BTRFS_VOL_NAME_MAX is defined as 255?

> ino_lookup ioctl because of space of subvolume's id and name.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c           | 218 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  16 ++++
>  2 files changed, 234 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1dba309dce31..ac23da98b7e7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2425,6 +2425,179 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
>  	return ret;
>  }
>  
> +static noinline int btrfs_search_path_in_tree_user(struct btrfs_fs_info *info,
> +				struct super_block *sb,
> +				struct btrfs_key upper_limit,
> +				struct btrfs_ioctl_ino_lookup_user_args *args)
> +{
> +	struct btrfs_root *root;
> +	struct btrfs_key key, key2;
> +	char *ptr;
> +	int ret = -1;
> +	int slot;
> +	int len;
> +	int total_len = 0;
> +	u64 dirid = args->dirid;
> +	struct btrfs_inode_ref *iref;
> +	struct btrfs_root_ref rref;
> +
> +	unsigned long item_off;
> +	unsigned long item_len;
> +
> +	struct extent_buffer *l;
> +	struct btrfs_path *path = NULL;
> +
> +	struct inode *inode;
> +	int *new = 0;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	if (dirid == upper_limit.objectid)
> +		/*
> +		 * If the bottom subvolume exists directly under upper limit,
> +		 * there is no need to construct the path and just get the
> +		 * subvolume's name
> +		 */
> +		goto get_subvol_name;

Eliminate the label and factor out the code in a new function or just
put in the body of the if.

> +	if (dirid == BTRFS_FIRST_FREE_OBJECTID)
> +		/* The subvolume does not exist under upper_limit */
> +		goto access_err;

just set ret to -EACCESS and goto out. And eliminate access_err label
altogether. Furthermore, shouldn't this check really ether:

a) Be the first one in this function so that we return ASAP (i.e. even
before calling btrfs_alloc_path)

or

b) Put in the ioctl function itself. Currently for the
btrfs_ioctl_ino_lookup case it's duplicated in both that function and
btrfs_search_path_in_tree

> +
> +	ptr = &args->path[BTRFS_INO_LOOKUP_PATH_MAX - 1];
> +
> +	key.objectid = args->treeid;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +	root = btrfs_read_fs_root_no_name(info, &key);
> +	if (IS_ERR(root)) {
> +		btrfs_err(info, "could not find root %llu", args->treeid);
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	key.objectid = dirid;
> +	key.type = BTRFS_INODE_REF_KEY;
> +	key.offset = (u64)-1;
> +
> +	while (1) {
> +		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0)
> +			goto out;
> +		else if (ret > 0) {
> +			ret = btrfs_previous_item(root, path, dirid,
> +						  BTRFS_INODE_REF_KEY);
> +			if (ret < 0)
> +				goto out;
> +			else if (ret > 0) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
> +		}
> +
> +		l = path->nodes[0];
> +		slot = path->slots[0];
> +		btrfs_item_key_to_cpu(l, &key, slot);
> +
> +		iref = btrfs_item_ptr(l, slot, struct btrfs_inode_ref);
> +		len = btrfs_inode_ref_name_len(l, iref);
> +		ptr -= len + 1;
> +		total_len += len + 1;
> +		if (ptr < args->path) {
> +			ret = -ENAMETOOLONG;
> +			goto out;
> +		}
> +
> +		*(ptr + len) = '/';
> +		read_extent_buffer(l, ptr, (unsigned long)(iref + 1), len);
> +
> +		/* Check the read permission */
> +		ret = btrfs_previous_item(root, path, dirid,
> +					  BTRFS_INODE_ITEM_KEY);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (ret > 0) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		l = path->nodes[0];
> +		slot = path->slots[0];
> +
> +		btrfs_item_key_to_cpu(l, &key2, slot);
> +		inode = btrfs_iget(sb, &key2, root, new);
> +		ret = inode_permission(inode, MAY_READ);
> +		iput(inode);
> +		if (ret)
> +			goto access_err;
> +
> +		if (key.offset == BTRFS_FIRST_FREE_OBJECTID ||
> +		    key.offset == upper_limit.objectid)
> +			break;
> +
> +		btrfs_release_path(path);
> +		key.objectid = key.offset;
> +		key.offset = (u64)-1;
> +		dirid = key.objectid;
> +	}
> +	 /* Check if the searched path exists under the upper_limit */
> +	if (key.offset == BTRFS_FIRST_FREE_OBJECTID &&
> +	    upper_limit.objectid != BTRFS_FIRST_FREE_OBJECTID)
> +		goto access_err;
> +
> +	memmove(args->path, ptr, total_len);
> +	args->path[total_len] = '\0';
> +	btrfs_release_path(path);
> +	ret = 0;
> +
> +get_subvol_name:
> +	/* Get subolume's name from ROOT_REF */
> +	key.objectid = BTRFS_ROOT_TREE_OBJECTID;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +	root = btrfs_read_fs_root_no_name(info, &key);
> +	if (IS_ERR(root)) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	key.objectid = args->treeid;
> +	key.type = BTRFS_ROOT_REF_KEY;
> +	key.offset = args->subid;
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret != 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +	l = path->nodes[0];
> +	slot = path->slots[0];
> +	btrfs_item_key_to_cpu(l, &key, slot);
> +
> +	item_off = btrfs_item_ptr_offset(l, slot);
> +	item_len = btrfs_item_size_nr(l, slot);
> +	/* Check if dirid in ROOT_REF corresponds to passed arg */
> +	read_extent_buffer(l, &rref, item_off, sizeof(struct btrfs_root_ref));
> +	if (rref.dirid != args->dirid) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Copy subvolume's name */
> +	item_off += sizeof(struct btrfs_root_ref);
> +	item_len -= sizeof(struct btrfs_root_ref);
> +	read_extent_buffer(l, args->name, item_off, item_len);
> +	args->name[item_len] = '\0';
> +
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +
> +access_err:
> +	btrfs_free_path(path);
> +	ret = -EACCES;
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  					   void __user *argp)
>  {
> @@ -2467,6 +2640,49 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  	return ret;
>  }
>  
> +/*
> + * User version of ino_lookup ioctl (unprivileged)
> + *
> + * The main differences from original ino_lookup ioctl are:
> + *   1. Read permission will be checked using inode_permission()
> + *      during path construction. -EACCES will be returned in case
> + *      of failure.
> + *   2. Path construction will be stopped at the inode number which
> + *      corresponds to the fd with which this ioctl is called. If
> + *      constructed path does not exist under fd's inode, -EACCES
> + *      will be returned.
> + *   3. The name of bottom subvolume is also searched and filled.
> + */
> +static noinline int btrfs_ioctl_ino_lookup_user(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_ino_lookup_user_args *args;
> +	struct inode *inode;
> +	int ret = 0;
> +
> +	args = memdup_user(argp, sizeof(*args));
> +	if (IS_ERR(args))
> +		return PTR_ERR(args);
> +
> +	inode = file_inode(file);
> +	/*
> +	 * args->treeid must be matched with this inode's objectid
> +	 * to previent for user to search any fs/file tree.
> +	 */
> +	if (args->treeid != BTRFS_I(inode)->root->root_key.objectid)
> +		return -EINVAL;

Do we want something like :
if (args->treeid == 0)
                args->treeid = BTRFS_I(inode)->root->root_key.objectid;

or does the ioctl impose a hard requirement for treeid to be set?

> +
> +	ret = btrfs_search_path_in_tree_user(BTRFS_I(inode)->root->fs_info,
> +					inode->i_sb, BTRFS_I(inode)->location,
> +					args);

Just pass in the the inode and reference all the parameters inside the
function. btrfs_search_path_in_tree_user really requires only 2 args:
inode and 'args'

> +
> +	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
> +		ret = -EFAULT;
> +
> +	kfree(args);
> +	return ret;
> +}
> +
>  static noinline int search_subvol(struct inode *inode,
>  				 struct btrfs_ioctl_search_key *sk,
>  				 size_t *buf_size,
> @@ -5917,6 +6133,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_set_features(file, argp);
>  	case BTRFS_IOC_GET_SUBVOL_INFO:
>  		return btrfs_ioctl_get_subvol_info(file, argp);
> +	case BTRFS_IOC_INO_LOOKUP_USER:
> +		return btrfs_ioctl_ino_lookup_user(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 1e9361cf66d5..22326d631417 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -422,6 +422,20 @@ struct btrfs_ioctl_ino_lookup_args {
>  	char name[BTRFS_INO_LOOKUP_PATH_MAX];
>  };
>  
> +#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4072-BTRFS_VOL_NAME_MAX)
Where does 4072 come from? Is it related to
#define BTRFS_INO_LOOKUP_PATH_MAX 4080

in any way ?
> +struct btrfs_ioctl_ino_lookup_user_args {
> +	/* in */
> +	__u64 treeid;
> +	/* in, 'dirid' is the same as objectid in btrfs_ioctl_ino_lookup_args */

Given there is no description of the objectid parameter of
ino_lookup_args. Your reference to it doesn't really make its purpose
any more clear.

> +	__u64 dirid;
> +	/* in, subvolume id which exists under the directory of 'dirid' */
> +	__u64 subid;
> +	/* out, name of the subvolume of 'subid' */
> +	char name[BTRFS_VOL_NAME_MAX];
> +	/* out, 'path' is the same as 'name' in btrfs_ioctl_ino_lookup_args */
> +	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
> +};
> +
>  /* Search criteria for the btrfs SEARCH ioctl family. */
>  struct btrfs_ioctl_search_key {
>  	/*
> @@ -845,5 +859,7 @@ enum btrfs_err_code {
>  					struct btrfs_ioctl_logical_ino_args)
>  #define BTRFS_IOC_GET_SUBVOL_INFO _IOWR(BTRFS_IOCTL_MAGIC, 60, \
>  					struct btrfs_ioctl_search_args)
> +#define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 61, \
> +					struct btrfs_ioctl_ino_lookup_args)
>  
>  #endif /* _UAPI_LINUX_BTRFS_H */
> 
