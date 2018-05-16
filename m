Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:60460 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbeEPFmt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:42:49 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 191B4AC0277
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:42:45 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 0024E6D67F1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:42:44 +0900 (JST)
Subject: Re: [PATCH v4 1/3] btrfs: Add unprivileged ioctl which returns
 subvolume information
To: =?UTF-8?B?R3UsIEppbnhpYW5nL+mhviDph5Hpppk=?= <gujx@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <cover.1526002757.git.misono.tomohiro@jp.fujitsu.com>
 <f0784a42dda08a596fcea31de73179dad5987d64.1526002757.git.misono.tomohiro@jp.fujitsu.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A850FFCC@G08CNEXMBPEKD02.g08.fujitsu.local>
 <8403d2ae-5cc6-7cc4-830e-b81f859a3b53@jp.fujitsu.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A85110BA@G08CNEXMBPEKD02.g08.fujitsu.local>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <d2b53e25-8b10-6ee1-52a0-1a0a00c14a01@jp.fujitsu.com>
Date: Wed, 16 May 2018 14:42:11 +0900
MIME-Version: 1.0
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A85110BA@G08CNEXMBPEKD02.g08.fujitsu.local>
Content-Type: text/plain; charset="gbk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/05/15 16:57, Gu, Jinxiang/¹Ë ½ðÏã wrote:
> Hi, add a missed a comment.
> 
>> -----Original Message-----
>> From: Misono Tomohiro [mailto:misono.tomohiro@jp.fujitsu.com]
>> Sent: Tuesday, May 15, 2018 3:04 PM
>> To: Gu, Jinxiang/¹Ë ½ðÏã <gujx@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH v4 1/3] btrfs: Add unprivileged ioctl which returns subvolume information
>>
>> On 2018/05/15 15:31, Gu, Jinxiang/¹Ë ½ðÏã wrote:
>>> Hi,
>>>
>>>> -----Original Message-----
>>>> From: linux-btrfs-owner@vger.kernel.org
>>>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Tomohiro
>>>> Misono
>>>> Sent: Friday, May 11, 2018 3:26 PM
>>>> To: linux-btrfs@vger.kernel.org
>>>> Subject: [PATCH v4 1/3] btrfs: Add unprivileged ioctl which returns
>>>> subvolume information
>>>>
>>>> Add new unprivileged ioctl BTRFS_IOC_GET_SUBVOL_INFO which returns the information of subvolume containing this inode.
>>>> (i.e. returns the information in ROOT_ITEM and ROOT_BACKREF.)
>>>>
>>>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>>>> ---
>>>>  fs/btrfs/ioctl.c           | 129 +++++++++++++++++++++++++++++++++++++++++++++
>>>>  include/uapi/linux/btrfs.h |  51 ++++++++++++++++++
>>>>  2 files changed, 180 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c index
>>>> 48e2ddff32bd..64b23e22852f 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -2242,6 +2242,133 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>>>>  	return ret;
>>>>  }
>>>>
>>>> +/* Get the subvolume information in BTRFS_ROOT_ITEM and
>>>> +BTRFS_ROOT_BACKREF */ static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
>>>> +					   void __user *argp)
>>>> +{
>>>> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
>>>> +	struct btrfs_root *root;
>>>> +	struct btrfs_path *path;
>>>> +	struct btrfs_key key;
>>>> +
>>>> +	struct btrfs_root_item root_item;
>>>> +	struct btrfs_root_ref *rref;
>>>> +	struct extent_buffer *l;
>>>> +	int slot;
>>>> +
>>>> +	unsigned long item_off;
>>>> +	unsigned long item_len;
>>>> +
>>>> +	struct inode *inode;
>>>> +	int ret;
>>>> +
>>>> +	path = btrfs_alloc_path();
>>>> +	if (!path)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	subvol_info = kzalloc(sizeof(*subvol_info), GFP_KERNEL);
>>>> +	if (!subvol_info) {
>>>> +		btrfs_free_path(path);
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +	inode = file_inode(file);
>>>> +
>>>> +	root = BTRFS_I(inode)->root->fs_info->tree_root;
>>>> +	key.objectid = BTRFS_I(inode)->root->root_key.objectid;
>>>> +	key.type = BTRFS_ROOT_ITEM_KEY;
>>>> +	key.offset = 0;
>>>> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>>>> +	if (ret < 0) {
>>>> +		goto out;
>>>> +	} else if (ret > 0) {
>>>> +		u64 objectid = key.objectid;
>>>> +
>>>> +		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
>>>> +			ret = btrfs_next_leaf(root, path);
>>>> +			if (ret < 0)
>>>> +				return ret;
>>> Should goto out; to free subvol_info and path.
>> Thanks, will update both.
>>
> 
> Since btrfs_next_leaf may return 1 when nritems of next leaf is 0,
> So, btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]); may goes wrong.
> And I think it should add a judge before btrfs_item_key_to_cpu.

Ok, I will update to handle all cases.

[snip]>>>> +	l = path->nodes[0];
>>>> +	slot = path->slots[0];
>>>> +	btrfs_item_key_to_cpu(l, &key, slot);
>>>> +	if (key.objectid == subvol_info->id &&
>>>> +			key.type == BTRFS_ROOT_BACKREF_KEY){
>>>> +		subvol_info->parent_id = key.offset;
>>>> +
>>>> +		rref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
>>>> +		subvol_info->dirid = btrfs_root_ref_dirid(l, rref);
>>>> +
>>>> +		item_off = btrfs_item_ptr_offset(l, slot)
>>>> +				+ sizeof(struct btrfs_root_ref);
>>>> +		item_len = btrfs_item_size_nr(l, slot)
>>>> +				- sizeof(struct btrfs_root_ref);
>>>> +		read_extent_buffer(l, subvol_info->name, item_off, item_len);
>>>> +	}
>>> If this if is not correct(ex. corrupt filesystem without backref),
>>> should it return -ENOENT, or its be ok without parent_id, dirid and name.
>>> Suggest to add logic of else.
>>
>> If backref does not exist (except top-level subvolume), it means filesystem corruption.
>> So, I'd like to return  -EUCLEAN here.

On second thought, I notice if this ioctl is called after containing subvolume is deleted,
the entry may not exist. So, -ENOENT is fine.

Thanks,
Tomohiro Misono

>>
>> Thanks,
>> Tomohiro Misono
>>
>>>
>>>> +
>>>> +	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
>>>> +		ret = -EFAULT;
>>>> +
>>>> +out:
>>>> +	kzfree(subvol_info);
>>>> +	btrfs_free_path(path);
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>>>>  					     void __user *arg)
>>>>  {
>>>> @@ -5374,6 +5501,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>>  		return btrfs_ioctl_get_features(file, argp);
>>>>  	case BTRFS_IOC_SET_FEATURES:
>>>>  		return btrfs_ioctl_set_features(file, argp);
>>>> +	case BTRFS_IOC_GET_SUBVOL_INFO:
>>>> +		return btrfs_ioctl_get_subvol_info(file, argp);
>>>>  	}
>>>>
>>>>  	return -ENOTTY;
>>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>>> index c8d99b9ca550..ed053852c71f 100644
>>>> --- a/include/uapi/linux/btrfs.h
>>>> +++ b/include/uapi/linux/btrfs.h
>>>> @@ -725,6 +725,55 @@ struct btrfs_ioctl_send_args {
>>>>  	__u64 reserved[4];		/* in */
>>>>  };
>>>>
>>>> +struct btrfs_ioctl_get_subvol_info_args {
>>>> +	/* All filed is out */
>>>> +	/* Id of this subvolume */
>>>> +	__u64 id;
>>>> +	/* Name of this subvolume, used to get the real name at mount point */
>>>> +	char name[BTRFS_VOL_NAME_MAX + 1];
>>>> +	/*
>>>> +	 * Id of the subvolume which contains this subvolume.
>>>> +	 * Zero for top-level subvolume or deleted subvolume
>>>> +	 */
>>>> +	__u64 parent_id;
>>>> +	/*
>>>> +	 * Inode number of the directory which contains this subvolume.
>>>> +	 * Zero for top-level subvolume or deleted subvolume
>>>> +	 */
>>>> +	__u64 dirid;
>>>> +
>>>> +	/* Latest transaction id of this subvolume */
>>>> +	__u64 generation;
>>>> +	/* Flags of this subvolume */
>>>> +	__u64 flags;
>>>> +
>>>> +	/* uuid of this subvolume */
>>>> +	__u8 uuid[BTRFS_UUID_SIZE];
>>>> +	/*
>>>> +	 * uuid of the subvolume of which this subvolume is a snapshot.
>>>> +	 * All zero for non-snapshot subvolume
>>>> +	 */
>>>> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
>>>> +	/*
>>>> +	 * uuid of the subvolume from which this subvolume is received.
>>>> +	 * All zero for non-received subvolume
>>>> +	 */
>>>> +	__u8 received_uuid[BTRFS_UUID_SIZE];
>>>> +
>>>> +	/* Transaction id indicates when change/create/send/receive happens */
>>>> +	__u64 ctransid;
>>>> +	__u64 otransid;
>>>> +	__u64 stransid;
>>>> +	__u64 rtransid;
>>>> +	/* Time corresponds to c/o/s/rtransid */
>>>> +	struct btrfs_ioctl_timespec ctime;
>>>> +	struct btrfs_ioctl_timespec otime;
>>>> +	struct btrfs_ioctl_timespec stime;
>>>> +	struct btrfs_ioctl_timespec rtime;
>>>> +
>>>> +	__u64 reserved[8];
>>>> +};
>>>> +
>>>>  /* Error codes as returned by the kernel */  enum btrfs_err_code {
>>>>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1, @@ -843,5 +892,7 @@ enum btrfs_err_code {
>>>>  				   struct btrfs_ioctl_vol_args_v2)  #define
>>>> BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>>>>  					struct btrfs_ioctl_logical_ino_args)
>>>> +#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
>>>> +				struct btrfs_ioctl_get_subvol_info_args)
>>>>
>>>>  #endif /* _UAPI_LINUX_BTRFS_H */
>>>> --
>>>> 2.14.3
>>>>
>>>
>>> Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>

