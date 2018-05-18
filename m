Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:53258 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751405AbeERMaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 08:30:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2A866472400A
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 20:30:07 +0800 (CST)
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH v6 3/3] btrfs: Add unprivileged version of ino_lookup
 ioctl
Date: Fri, 18 May 2018 12:30:07 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A851333B@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <cover.1526610386.git.misono.tomohiro@jp.fujitsu.com>
 <ec0214c9b1e56eaa856b3dbbed2567691fbd3bd9.1526610386.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <ec0214c9b1e56eaa856b3dbbed2567691fbd3bd9.1526610386.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Tomohiro Misono
> Sent: Friday, May 18, 2018 10:55 AM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH v6 3/3] btrfs: Add unprivileged version of ino_lookup ioctl
> 
> Add unprivileged version of ino_lookup ioctl BTRFS_IOC_INO_LOOKUP_USER to allow normal users to call "btrfs subvolume list/show" etc.
> in combination with BTRFS_IOC_GET_SUBVOL_INFO/BTRFS_IOC_GET_SUBVOL_ROOTREF.
> 
> This can be used like BTRFS_IOC_INO_LOOKUP but the argument is different. This is  because it always searches the fs/file tree
> correspoinding to the fd with which this ioctl is called and also returns the name of bottom subvolume.
> 
> The main differences from original ino_lookup ioctl are:
>   1. Read + Exec permission will be checked using inode_permission()
>      during path construction. -EACCES will be returned in case
>      of failure.
>   2. Path construction will be stopped at the inode number which
>      corresponds to the fd with which this ioctl is called. If
>      constructed path does not exist under fd's inode, -EACCES
>      will be returned.
>   3. The name of bottom subvolume is also searched and filled.
> 
> Note that the maximum length of path is shorter 256 (BTRFS_VOL_NAME_MAX+1) bytes than ino_lookup ioctl because of space of
> subvolume's name.
> 
> Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c           | 204 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  17 ++++
>  2 files changed, 221 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c index 463ddedd90da..5e8dfa816ba9 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2200,6 +2200,166 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
>  	return ret;
>  }
> 
> +static noinline int btrfs_search_path_in_tree_user(struct inode *inode,
> +				struct btrfs_ioctl_ino_lookup_user_args *args) {
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> +	struct super_block *sb = inode->i_sb;
> +	struct btrfs_key upper_limit = BTRFS_I(inode)->location;
> +	u64 treeid = BTRFS_I(inode)->root->root_key.objectid;
> +	u64 dirid = args->dirid;
> +
> +	unsigned long item_off;
> +	unsigned long item_len;
> +	struct btrfs_inode_ref *iref;
> +	struct btrfs_root_ref *rref;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key, key2;
> +	struct extent_buffer *l;
> +	struct inode *temp_inode;
> +	char *ptr;
> +	int slot;
> +	int len;
> +	int total_len = 0;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	/*
> +	 * If the bottom subvolume does not exist directly under upper_limit,
> +	 * construct the path in bottomup way.
> +	 */
> +	if (dirid != upper_limit.objectid) {
> +		ptr = &args->path[BTRFS_INO_LOOKUP_USER_PATH_MAX - 1];
> +
> +		key.objectid = treeid;
> +		key.type = BTRFS_ROOT_ITEM_KEY;
> +		key.offset = (u64)-1;
> +		root = btrfs_read_fs_root_no_name(fs_info, &key);
> +		if (IS_ERR(root)) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +
> +		key.objectid = dirid;
> +		key.type = BTRFS_INODE_REF_KEY;
> +		key.offset = (u64)-1;
> +		while (1) {
> +			ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret = btrfs_previous_item(root, path, dirid,
> +							  BTRFS_INODE_REF_KEY);
> +				if (ret < 0) {
> +					goto out;
> +				} else if (ret > 0) {
> +					ret = -ENOENT;
> +					goto out;
> +				}
> +			}
> +
> +			l = path->nodes[0];
> +			slot = path->slots[0];
> +			btrfs_item_key_to_cpu(l, &key, slot);
> +
> +			iref = btrfs_item_ptr(l, slot, struct btrfs_inode_ref);
> +			len = btrfs_inode_ref_name_len(l, iref);
> +			ptr -= len + 1;
> +			total_len += len + 1;
> +			if (ptr < args->path) {
> +				ret = -ENAMETOOLONG;
> +				goto out;
> +			}
> +
> +			*(ptr + len) = '/';
> +			read_extent_buffer(l, ptr,
> +			    (unsigned long)(iref + 1), len);
> +
> +			/* Check the read+exec permission of this directory */
> +			ret = btrfs_previous_item(root, path, dirid,
> +						  BTRFS_INODE_ITEM_KEY);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
> +
> +			l = path->nodes[0];
> +			slot = path->slots[0];
> +			btrfs_item_key_to_cpu(l, &key2, slot);
> +			if (key2.objectid != dirid) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
> +
> +			temp_inode = btrfs_iget(sb, &key2, root, NULL);
> +			ret = inode_permission(temp_inode, MAY_READ | MAY_EXEC);
> +			iput(temp_inode);
> +			if (ret) {
> +				ret = -EACCES;
> +				goto out;
> +			}
> +
> +			if (key.offset == upper_limit.objectid)
> +				break;
> +			if (key.objectid == BTRFS_FIRST_FREE_OBJECTID) {
> +				ret = -EACCES;
> +				goto out;
> +			}
> +
> +			btrfs_release_path(path);
> +			key.objectid = key.offset;
> +			key.offset = (u64)-1;
> +			dirid = key.objectid;
> +		}
> +
> +		memmove(args->path, ptr, total_len);
> +		args->path[total_len] = '\0';
> +		btrfs_release_path(path);
> +	}
> +
> +	/* get the bottom subvolume's name from ROOT_REF */
> +	root = fs_info->tree_root;
> +	key.objectid = treeid;
> +	key.type = BTRFS_ROOT_REF_KEY;
> +	key.offset = args->subvolid;
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	l = path->nodes[0];
> +	slot = path->slots[0];
> +	btrfs_item_key_to_cpu(l, &key, slot);
> +
> +	item_off = btrfs_item_ptr_offset(l, slot);
> +	item_len = btrfs_item_size_nr(l, slot);
> +	/* check if dirid in ROOT_REF corresponds to passed dirid */
> +	rref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
> +	if (args->dirid != btrfs_root_ref_dirid(l, rref)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* copy subvolume's name */
> +	item_off += sizeof(struct btrfs_root_ref);
> +	item_len -= sizeof(struct btrfs_root_ref);
> +	read_extent_buffer(l, args->name, item_off, item_len);
> +	args->name[item_len] = '\0';
> +
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  					   void __user *argp)
>  {
> @@ -2242,6 +2402,48 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  	return ret;
>  }
> 
> +/*
> + * User version of ino_lookup ioctl (unprivileged)
> + *
> + * The main differences from original ino_lookup ioctl are:
> + *   1. Read + Exec permission will be checked using inode_permission()
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
> +	int ret;
> +
> +	args = memdup_user(argp, sizeof(*args));
> +	if (IS_ERR(args))
> +		return PTR_ERR(args);
> +
> +	inode = file_inode(file);
> +
> +	if (args->dirid == BTRFS_FIRST_FREE_OBJECTID &&
> +	    BTRFS_I(inode)->location.objectid != BTRFS_FIRST_FREE_OBJECTID) {
> +	/* The subvolume does not exist under fd with which this is called */
> +		kfree(args);
> +		return -EACCES;
> +	}
> +
> +	ret = btrfs_search_path_in_tree_user(inode, args);
> +
> +	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
> +		ret = -EFAULT;
> +
> +	kfree(args);
> +	return ret;
> +}
> +
>  /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */  static noinline int
> btrfs_ioctl_get_subvol_info(struct file *file,
>  					   void __user *argp)
> @@ -5601,6 +5803,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_subvol_info(file, argp);
>  	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
>  		return btrfs_ioctl_get_subvol_rootref(file, argp);
> +	case BTRFS_IOC_INO_LOOKUP_USER:
> +		return btrfs_ioctl_ino_lookup_user(file, argp);
>  	}
> 
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h index b6633f5d4847..177447c4d4c6 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -422,6 +422,21 @@ struct btrfs_ioctl_ino_lookup_args {
>  	char name[BTRFS_INO_LOOKUP_PATH_MAX];
>  };
> 
> +#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4080-BTRFS_VOL_NAME_MAX-1)
> +struct btrfs_ioctl_ino_lookup_user_args {
> +	/* in, inode number containing the subvolume of 'subvolid' */
> +	__u64 dirid;
> +	/* in */
> +	__u64 subvolid;
> +	/* out, name of the subvolume of 'subvolid' */
> +	char name[BTRFS_VOL_NAME_MAX + 1];
> +	/*
> +	 * out, constructed path from the directory with which
> +	 * the ioctl is called to dirid
> +	 */
> +	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
> +};
> +
>  /* Search criteria for the btrfs SEARCH ioctl family. */  struct btrfs_ioctl_search_key {
>  	/*
> @@ -910,5 +925,7 @@ enum btrfs_err_code {
>  				struct btrfs_ioctl_get_subvol_info_args)  #define BTRFS_IOC_GET_SUBVOL_ROOTREF
> _IOWR(BTRFS_IOCTL_MAGIC, 61, \
>  				struct btrfs_ioctl_get_subvol_rootref_args)
> +#define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
> +				struct btrfs_ioctl_ino_lookup_user_args)
> 
>  #endif /* _UAPI_LINUX_BTRFS_H */
> --
Tested-by: Gu Jinxiang <gujx@cn.fujitsu.com>


> 2.14.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
