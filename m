Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:55869 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeERC7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 22:59:01 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 09DC6AC049B
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 11:58:58 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 1F4D169274D
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 11:58:57 +0900 (JST)
Subject: Re: [PATCH v6 1/3] btrfs: Add unprivileged ioctl which returns
 subvolume information
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <cover.1526610386.git.misono.tomohiro@jp.fujitsu.com>
 <e2fc1540ff03b368bd0c055370ecd74095afc7dc.1526610386.git.misono.tomohiro@jp.fujitsu.com>
Message-ID: <d2d79aa0-07f4-66ec-55f1-13b283cec774@jp.fujitsu.com>
Date: Fri, 18 May 2018 11:58:43 +0900
MIME-Version: 1.0
In-Reply-To: <e2fc1540ff03b368bd0c055370ecd74095afc7dc.1526610386.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/05/18 11:54, Tomohiro Misono wrote:
> Add new unprivileged ioctl BTRFS_IOC_GET_SUBVOL_INFO which returns
> the information of subvolume containing this inode.
> (i.e. returns the information in ROOT_ITEM and ROOT_BACKREF.)
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  v5 -> v6
>     - Use brfs_read_fs_root_no_name() to get subvolume root and simplify
>       code
>  v4 -> v5
>     - Update error handling of btrfs_next_leaf() to cover all cases
>     - Return error if ROOT_BACKREF is not found (except top-level)
> 
>  fs/btrfs/ioctl.c           | 125 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  51 ++++++++++++++++++
>  2 files changed, 176 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 48e2ddff32bd..31af6e91c614 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2242,6 +2242,129 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  	return ret;
>  }
>  
> +/* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
> +static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	struct btrfs_fs_info *fs_info;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +
> +	struct btrfs_root_item *root_item;
> +	struct btrfs_root_ref *rref;
> +	struct extent_buffer *l;
> +	int slot;
> +
> +	unsigned long item_off;
> +	unsigned long item_len;
> +
> +	struct inode *inode;
> +	int ret = 0;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	subvol_info = kzalloc(sizeof(*subvol_info), GFP_KERNEL);
> +	if (!subvol_info) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
> +	inode = file_inode(file);
> +	fs_info = BTRFS_I(inode)->root->fs_info;
> +
> +	/* Get root_item of inode's subvolume */
> +	key.objectid = BTRFS_I(inode)->root->root_key.objectid;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +	root = btrfs_read_fs_root_no_name(fs_info, &key);
> +	if (IS_ERR(root)) {
> +		ret = PTR_ERR(root);
> +		goto out;
> +	}
> +	root_item = &root->root_item;
> +
> +	subvol_info->id = key.objectid;
> +
> +	subvol_info->generation = btrfs_root_generation(root_item);
> +	subvol_info->flags = btrfs_root_flags(root_item);
> +
> +	memcpy(subvol_info->uuid, root_item->uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->parent_uuid, root_item->parent_uuid,
> +						    BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->received_uuid, root_item->received_uuid,
> +						    BTRFS_UUID_SIZE);
> +
> +	subvol_info->ctransid = btrfs_root_ctransid(root_item);
> +	subvol_info->ctime.sec = btrfs_stack_timespec_sec(&root_item->otime);
                                                          obviously ->ctime, sorry for messed up.

> +	subvol_info->ctime.nsec = btrfs_stack_timespec_nsec(&root_item->ctime);
> +
> +	subvol_info->otransid = btrfs_root_otransid(root_item);
> +	subvol_info->otime.sec = btrfs_stack_timespec_sec(&root_item->otime);
> +	subvol_info->otime.nsec = btrfs_stack_timespec_nsec(&root_item->otime);
> +
> +	subvol_info->stransid = btrfs_root_stransid(root_item);
> +	subvol_info->stime.sec = btrfs_stack_timespec_sec(&root_item->stime);
> +	subvol_info->stime.nsec = btrfs_stack_timespec_nsec(&root_item->stime);
> +
> +	subvol_info->rtransid = btrfs_root_rtransid(root_item);
> +	subvol_info->rtime.sec = btrfs_stack_timespec_sec(&root_item->rtime);
> +	subvol_info->rtime.nsec = btrfs_stack_timespec_nsec(&root_item->rtime);
> +
> +	if (key.objectid != BTRFS_FS_TREE_OBJECTID) {
> +		/* Search root tree for ROOT_BACKREF of this subvolume */
> +		root = fs_info->tree_root;
> +
> +		key.type = BTRFS_ROOT_BACKREF_KEY;
> +		key.offset = 0;
> +		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (path->slots[0] >=
> +				btrfs_header_nritems(path->nodes[0])) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret = -EUCLEAN;
> +				goto out;
> +			}
> +		}
> +
> +		l = path->nodes[0];
> +		slot = path->slots[0];
> +		btrfs_item_key_to_cpu(l, &key, slot);
> +		if (key.objectid == subvol_info->id &&
> +		    key.type == BTRFS_ROOT_BACKREF_KEY) {
> +			subvol_info->parent_id = key.offset;
> +
> +			rref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
> +			subvol_info->dirid = btrfs_root_ref_dirid(l, rref);
> +
> +			item_off = btrfs_item_ptr_offset(l, slot)
> +					+ sizeof(struct btrfs_root_ref);
> +			item_len = btrfs_item_size_nr(l, slot)
> +					- sizeof(struct btrfs_root_ref);
> +			read_extent_buffer(l, subvol_info->name,
> +					   item_off, item_len);
> +		} else {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +	}
> +
> +	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> +		ret = -EFAULT;
> +
> +out:
> +	kzfree(subvol_info);
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  					     void __user *arg)
>  {
> @@ -5374,6 +5497,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_features(file, argp);
>  	case BTRFS_IOC_SET_FEATURES:
>  		return btrfs_ioctl_set_features(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_INFO:
> +		return btrfs_ioctl_get_subvol_info(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index c8d99b9ca550..02cd1f1994e8 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -725,6 +725,55 @@ struct btrfs_ioctl_send_args {
>  	__u64 reserved[4];		/* in */
>  };
>  
> +struct btrfs_ioctl_get_subvol_info_args {
> +	/* All field is out */
> +	/* Id of this subvolume */
> +	__u64 id;
> +	/* Name of this subvolume, used to get the real name at mount point */
> +	char name[BTRFS_VOL_NAME_MAX + 1];
> +	/*
> +	 * Id of the subvolume which contains this subvolume.
> +	 * Zero for top-level subvolume or deleted subvolume
> +	 */
> +	__u64 parent_id;
> +	/*
> +	 * Inode number of the directory which contains this subvolume.
> +	 * Zero for top-level subvolume or deleted subvolume
> +	 */
> +	__u64 dirid;
> +
> +	/* Latest transaction id of this subvolume */
> +	__u64 generation;
> +	/* Flags of this subvolume */
> +	__u64 flags;
> +
> +	/* uuid of this subvolume */
> +	__u8 uuid[BTRFS_UUID_SIZE];
> +	/*
> +	 * uuid of the subvolume of which this subvolume is a snapshot.
> +	 * All zero for non-snapshot subvolume
> +	 */
> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
> +	/*
> +	 * uuid of the subvolume from which this subvolume is received.
> +	 * All zero for non-received subvolume
> +	 */
> +	__u8 received_uuid[BTRFS_UUID_SIZE];
> +
> +	/* Transaction id indicates when change/create/send/receive happens */
> +	__u64 ctransid;
> +	__u64 otransid;
> +	__u64 stransid;
> +	__u64 rtransid;
> +	/* Time corresponds to c/o/s/rtransid */
> +	struct btrfs_ioctl_timespec ctime;
> +	struct btrfs_ioctl_timespec otime;
> +	struct btrfs_ioctl_timespec stime;
> +	struct btrfs_ioctl_timespec rtime;
> +
> +	__u64 reserved[8];
> +};
> +
>  /* Error codes as returned by the kernel */
>  enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
> @@ -843,5 +892,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args_v2)
>  #define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>  					struct btrfs_ioctl_logical_ino_args)
> +#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
> +				struct btrfs_ioctl_get_subvol_info_args)
>  
>  #endif /* _UAPI_LINUX_BTRFS_H */
> 

