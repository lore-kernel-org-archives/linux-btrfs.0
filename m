Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55448 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751644AbeEQGL1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:11:27 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 6FD8A4B3ED60
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 14:11:23 +0800 (CST)
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH v5 1/3] btrfs: Add unprivileged ioctl which returns
 subvolume information
Date: Thu, 17 May 2018 06:11:23 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8512B71@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Tomohiro Misono
> Sent: Wednesday, May 16, 2018 1:50 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH v5 1/3] btrfs: Add unprivileged ioctl which returns subvolume information
> 
> Add new unprivileged ioctl BTRFS_IOC_GET_SUBVOL_INFO which returns the information of subvolume containing this inode.
> (i.e. returns the information in ROOT_ITEM and ROOT_BACKREF.)
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  v4 -> v5
>     - Update error handling of btrfs_next_leaf() to cover all cases
>     - Return error if ROOT_BACKREF is not found (except top-level)
> 
>  fs/btrfs/ioctl.c           | 146 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  51 ++++++++++++++++
>  2 files changed, 197 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c index 48e2ddff32bd..c1c9ae9a937d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2242,6 +2242,150 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  	return ret;
>  }
> 
> +/* Get the subvolume information in BTRFS_ROOT_ITEM and
> +BTRFS_ROOT_BACKREF */ static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +
> +	struct btrfs_root_item root_item;
> +	struct btrfs_root_ref *rref;
> +	struct extent_buffer *l;
> +	int slot;
> +
> +	unsigned long item_off;
> +	unsigned long item_len;
> +
> +	struct inode *inode;
> +	int ret;
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
> +	root = BTRFS_I(inode)->root->fs_info->tree_root;
> +
> +	key.objectid = BTRFS_I(inode)->root->root_key.objectid;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		u64 objectid = key.objectid;
> +
> +		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret = -ENOENT;
> +				goto out;
> +			}
> +		}
> +
> +		/* If the subvolume is a snapshot, offset is not zero */
> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		if (key.objectid != objectid ||
> +		    key.type != BTRFS_ROOT_ITEM_KEY) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +	}
> +
> +	l = path->nodes[0];
> +	slot = path->slots[0];
> +	item_off = btrfs_item_ptr_offset(l, slot);
> +	item_len = btrfs_item_size_nr(l, slot);
> +	read_extent_buffer(l, &root_item, item_off, item_len);
> +
> +	subvol_info->id = key.objectid;
> +
> +	subvol_info->generation = btrfs_root_generation(&root_item);
> +	subvol_info->flags = btrfs_root_flags(&root_item);
> +
> +	memcpy(subvol_info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->parent_uuid, root_item.parent_uuid,
> +						    BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->received_uuid, root_item.received_uuid,
> +						    BTRFS_UUID_SIZE);
> +
> +	subvol_info->ctransid = btrfs_root_ctransid(&root_item);
> +	subvol_info->ctime.sec = btrfs_stack_timespec_sec(&root_item.ctime);
> +	subvol_info->ctime.nsec = btrfs_stack_timespec_nsec(&root_item.ctime);
> +
> +	subvol_info->otransid = btrfs_root_otransid(&root_item);
> +	subvol_info->otime.sec = btrfs_stack_timespec_sec(&root_item.otime);
> +	subvol_info->otime.nsec = btrfs_stack_timespec_nsec(&root_item.otime);
> +
> +	subvol_info->stransid = btrfs_root_stransid(&root_item);
> +	subvol_info->stime.sec = btrfs_stack_timespec_sec(&root_item.stime);
> +	subvol_info->stime.nsec = btrfs_stack_timespec_nsec(&root_item.stime);
> +
> +	subvol_info->rtransid = btrfs_root_rtransid(&root_item);
> +	subvol_info->rtime.sec = btrfs_stack_timespec_sec(&root_item.rtime);
> +	subvol_info->rtime.nsec = btrfs_stack_timespec_nsec(&root_item.rtime);
> +
> +	btrfs_release_path(path);
> +	if (key.objectid != BTRFS_FS_TREE_OBJECTID) {
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
> +				ret = -ENOENT;
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
> @@ -5374,6 +5518,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_features(file, argp);
>  	case BTRFS_IOC_SET_FEATURES:
>  		return btrfs_ioctl_set_features(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_INFO:
> +		return btrfs_ioctl_get_subvol_info(file, argp);
>  	}
> 
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h index c8d99b9ca550..02cd1f1994e8 100644
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
>  /* Error codes as returned by the kernel */  enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1, @@ -843,5 +892,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args_v2)
>  #define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>  					struct btrfs_ioctl_logical_ino_args)
> +#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
> +				struct btrfs_ioctl_get_subvol_info_args)
> 
>  #endif /* _UAPI_LINUX_BTRFS_H */
> --

Looks good to me.
Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Thks.
> 2.14.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
