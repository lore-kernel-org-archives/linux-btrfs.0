Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51355 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752059AbeEOHsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:48:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F19144D0EFFC
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 15:48:00 +0800 (CST)
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] btrfs: Add unprivileged ioctl which returns
 subvolume's ROOT_REF
Date: Tue, 15 May 2018 07:48:00 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A851109D@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <cover.1526002757.git.misono.tomohiro@jp.fujitsu.com>
 <908997fbce2f442231a9cc43524d05ec2c4e05b7.1526002757.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <908997fbce2f442231a9cc43524d05ec2c4e05b7.1526002757.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Tomohiro Misono
> Sent: Friday, May 11, 2018 3:26 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH v4 2/3] btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
> 
> Add unprivileged ioctl BTRFS_IOC_GET_SUBVOL_ROOTREF which returns ROOT_REF information of the subvolume containing this inode
> except the subvolume name (this is because to prevent potential name leak). The subvolume name will be gained by user version of
> ino_lookup ioctl (BTRFS_IOC_INO_LOOKUP_USER) which also performs permission check.
> 
> The min id of root ref's subvolume to be searched is specified by @min_id in struct btrfs_ioctl_get_subvol_rootref_args. After the search
> ends, @min_id is set to the last searched root ref's subvolid + 1. Also, if there are more root refs than
> BTRFS_MAX_ROOTREF_BUFFER_NUM, -EOVERFLOW is returned. Therefore the caller can just call this ioctl again without changing the
> argument to continue search.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c           | 102 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  16 +++++++
>  2 files changed, 118 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c index 64b23e22852f..7988d328aed5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2369,6 +2369,106 @@ static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
>  	return ret;
>  }
> 
> +/*
> + * Return ROOT_REF information of the subvolume contining this inode
s/contining/containing

> + * except the subvolume name.
> + */
> +static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_rootref_args *rootrefs;
> +	struct btrfs_root_ref *rref;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +
> +	struct extent_buffer *l;
> +	int slot;
> +
> +	struct inode *inode;
> +	int i, nritems;
> +	int ret;
> +	u64 objectid;
> +	u8 found;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	rootrefs = memdup_user(argp, sizeof(*rootrefs));
> +	if (!rootrefs) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
> +	inode = file_inode(file);
> +	root = BTRFS_I(inode)->root->fs_info->tree_root;
> +	objectid = BTRFS_I(inode)->root->root_key.objectid;
> +
> +	key.objectid = objectid;
> +	key.type = BTRFS_ROOT_REF_KEY;
> +	key.offset = rootrefs->min_id;
> +	found = 0;
> +	while (1) {
> +		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (path->slots[0] >=
> +				btrfs_header_nritems(path->nodes[0])) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				return ret;
Should goto out; to do free work.
> +		}
> +
> +		l = path->nodes[0];
> +		slot = path->slots[0];
> +		nritems = btrfs_header_nritems(l);
> +		if (nritems - slot == 0) {
> +			ret = 0;
> +			goto out;
> +		}
> +
> +		for (i = slot; i < nritems; i++) {
> +			btrfs_item_key_to_cpu(l, &key, i);
> +			if (key.objectid != objectid ||
> +					key.type != BTRFS_ROOT_REF_KEY) {
> +				ret = 0;
> +				goto out;
> +			}
> +
> +			if (found == BTRFS_MAX_ROOTREF_BUFFER_NUM) {
> +				ret = -EOVERFLOW;
> +				goto out;
> +			}
> +
> +			rref = btrfs_item_ptr(l, i, struct btrfs_root_ref);
> +			rootrefs->rootref[found].subvolid = key.offset;
> +			rootrefs->rootref[found].dirid =
> +					  btrfs_root_ref_dirid(l, rref);
> +			found++;
> +		}
> +
> +		btrfs_release_path(path);
> +		key.offset++;
> +	}
Suggest to use btrfs_search_slot and btrfs_next_item to reduce counts of btrfs_search_slot.

> +
> +out:
> +	if (!ret || ret == -EOVERFLOW) {
> +		rootrefs->num_items = found;
> +		/* update min_id for next search */
> +		if (found)
> +			rootrefs->min_id =
> +				rootrefs->rootref[found - 1].subvolid + 1;
> +		if (copy_to_user(argp, rootrefs, sizeof(*rootrefs)))
> +			ret = -EFAULT;
> +	}
> +
> +	btrfs_free_path(path);
> +	kfree(rootrefs);
> +
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  					     void __user *arg)
>  {
> @@ -5503,6 +5603,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_set_features(file, argp);
>  	case BTRFS_IOC_GET_SUBVOL_INFO:
>  		return btrfs_ioctl_get_subvol_info(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
> +		return btrfs_ioctl_get_subvol_rootref(file, argp);
>  	}
> 
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h index ed053852c71f..82c88d52d6e6 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -774,6 +774,20 @@ struct btrfs_ioctl_get_subvol_info_args {
>  	__u64 reserved[8];
>  };
> 
> +#define BTRFS_MAX_ROOTREF_BUFFER_NUM 255 struct
> +btrfs_ioctl_get_subvol_rootref_args {
> +		/* in/out, min id of rootref's subvolid to be searched */
> +		__u64 min_id;
> +		/* out */
> +		struct {
> +			__u64 subvolid;
> +			__u64 dirid;
> +		} rootref[BTRFS_MAX_ROOTREF_BUFFER_NUM];
> +		/* out, number of found items */
> +		__u8 num_items;
> +		__u8 align[7];
> +};
> +
>  /* Error codes as returned by the kernel */  enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1, @@ -894,5 +908,7 @@ enum btrfs_err_code {
>  					struct btrfs_ioctl_logical_ino_args)  #define BTRFS_IOC_GET_SUBVOL_INFO
> _IOR(BTRFS_IOCTL_MAGIC, 60, \
>  				struct btrfs_ioctl_get_subvol_info_args)
> +#define BTRFS_IOC_GET_SUBVOL_ROOTREF _IOWR(BTRFS_IOCTL_MAGIC, 61, \
> +				struct btrfs_ioctl_get_subvol_rootref_args)
> 
>  #endif /* _UAPI_LINUX_BTRFS_H */
> --
> 2.14.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
