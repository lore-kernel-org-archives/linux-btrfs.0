Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:54444 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753070AbeCFU32 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 15:29:28 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/2] btrfs: Add unprivileged subvolume search ioctl
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
 <62ce1ddf-a7cd-f770-b4c8-5d47b8d4d31d@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <4de7f3e0-49c3-4fb8-8e66-b7829bf7dc5d@libero.it>
Date: Tue, 6 Mar 2018 21:29:21 +0100
MIME-Version: 1.0
In-Reply-To: <62ce1ddf-a7cd-f770-b4c8-5d47b8d4d31d@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/06/2018 09:30 AM, Misono, Tomohiro wrote:
> Add new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO) which searches
> and returns only subvolume related item (ROOT_ITEM/ROOT_BACKREF/ROOT_REF)
> from root tree. The arguments of this ioctl are the same as treesearch
> ioctl and can be used like treesearch ioctl.

Is it a pro ? The treesearch ioctl is tightly coupled to the btrfs internal structure, this means that if we would change the btrfs internal structure, we have to update all the clients of this api. For the treesearch it is an acceptable compromise between flexibility and speed of developing. But for a more specialized API, I think that it would make sense to provide a less coupled api to the internal structure.

Below some comments


> 
> Since treesearch ioctl requires root privilege, this ioctl is needed
> to allow normal users to call "btrfs subvolume list/show" etc.
> 
> Note that the subvolume name in ROOT_BACKREF/ROOT_REF will not be copied to
> prevent potential name leak. The name can be obtained by calling
> user version's ino_lookup ioctl (BTRFS_IOC_INO_LOOKUP_USER).
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c           | 254 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |   2 +
>  2 files changed, 256 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 111ee282b777..1dba309dce31 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1921,6 +1921,28 @@ static noinline int key_in_sk(struct btrfs_key *key,
>  	return 1;
>  }
>  
> +/*
> + * check if key is in sk and subvolume related range
> + */
> +static noinline int key_in_sk_and_subvol(struct btrfs_key *key,
> +			      struct btrfs_ioctl_search_key *sk)
> +{
> +	int ret;
> +
> +	ret = key_in_sk(key, sk);
> +	if (!ret)
> +		return 0;
> +
> +	if ((key->objectid == BTRFS_FS_TREE_OBJECTID ||
> +		(key->objectid >= BTRFS_FIRST_FREE_OBJECTID &&
> +		 key->objectid <= BTRFS_LAST_FREE_OBJECTID)) &&
> +	    key->type >= BTRFS_ROOT_ITEM_KEY &&
> +	    key->type <= BTRFS_ROOT_BACKREF_KEY)

Why returning all the range [BTRFS_ROOT_ITEM_KEY...BTRFS_ROOT_BACKREF_KEY]. It would be sufficient to return only

  +	    (key->type == BTRFS_ROOT_ITEM_KEY ||
  +	     key->type == BTRFS_ROOT_BACKREF_KEY))


> +		return 1;
> +
> +	return 0;
> +}
> +
>  static noinline int copy_to_sk(struct btrfs_path *path,
>  			       struct btrfs_key *key,
>  			       struct btrfs_ioctl_search_key *sk,
> @@ -2045,6 +2067,142 @@ static noinline int copy_to_sk(struct btrfs_path *path,
>  	return ret;
>  }
>  
> +/*
> + * Basically the same as copy_to_sk() but restricts the copied item
> + * within subvolume related one using key_in_sk_and_subvol().
> + * Also, the name of subvolume will be omitted from
> + * ROOT_BACKREF/ROOT_REF item.
> + */
> +static noinline int copy_subvol_item(struct btrfs_path *path,
> +			       struct btrfs_key *key,
> +			       struct btrfs_ioctl_search_key *sk,
> +			       size_t *buf_size,
> +			       char __user *ubuf,
> +			       unsigned long *sk_offset,
> +			       int *num_found)
> +{
> +	u64 found_transid;
> +	struct extent_buffer *leaf;
> +	struct btrfs_ioctl_search_header sh;
> +	struct btrfs_key test;
> +	unsigned long item_off;
> +	unsigned long item_len;
> +	int nritems;
> +	int i;
> +	int slot;
> +	int ret = 0;
> +
> +	leaf = path->nodes[0];
> +	slot = path->slots[0];
> +	nritems = btrfs_header_nritems(leaf);
> +
> +	if (btrfs_header_generation(leaf) > sk->max_transid) {
> +		i = nritems;
> +		goto advance_key;
> +	}
> +	found_transid = btrfs_header_generation(leaf);
> +
> +	for (i = slot; i < nritems; i++) {
> +		item_off = btrfs_item_ptr_offset(leaf, i);
> +		item_len = btrfs_item_size_nr(leaf, i);
> +
> +		btrfs_item_key_to_cpu(leaf, key, i);
> +		if (!key_in_sk_and_subvol(key, sk))
> +			continue;
> +
> +		/* will not copy the name of subvolume */
> +		if (key->type == BTRFS_ROOT_BACKREF_KEY ||
> +		    key->type == BTRFS_ROOT_REF_KEY)
> +			item_len = sizeof(struct btrfs_root_ref);
> +
> +		if (sizeof(sh) + item_len > *buf_size) {
> +			if (*num_found) {
> +				ret = 1;
> +				goto out;
> +			}
> +
> +			/*
> +			 * return one empty item back for v1, which does not
> +			 * handle -EOVERFLOW
> +			 */
It is still applicable ?
> +
> +			*buf_size = sizeof(sh) + item_len;
> +			item_len = 0;
> +			ret = -EOVERFLOW;> +		}
> +
> +		if (sizeof(sh) + item_len + *sk_offset > *buf_size) {
> +			ret = 1;
> +			goto out;
> +		}
> +
> +		sh.objectid = key->objectid;
> +		sh.offset = key->offset;
> +		sh.type = key->type;
> +		sh.len = item_len;
> +		sh.transid = found_transid;
> +
> +		/* copy search result header */
> +		if (copy_to_user(ubuf + *sk_offset, &sh, sizeof(sh))) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		*sk_offset += sizeof(sh);
> +
> +		if (item_len) {
> +			char __user *up = ubuf + *sk_offset;
> +
> +			/* copy the item */
> +			if (read_extent_buffer_to_user(leaf, up,
> +						       item_off, item_len)) {
> +				ret = -EFAULT;
> +				goto out;
> +			}
> +
> +			*sk_offset += item_len;
> +		}
> +		(*num_found)++;
> +
> +		if (ret) /* -EOVERFLOW from above */
> +			goto out;
> +
> +		if (*num_found >= sk->nr_items) {
> +			ret = 1;
> +			goto out;
> +		}
> +	}
> +advance_key:
> +	ret = 0;
> +	test.objectid = sk->max_objectid;
> +	test.type = sk->max_type;
> +	test.offset = sk->max_offset;
> +	if (btrfs_comp_cpu_keys(key, &test) >= 0)
> +		ret = 1;
> +	else if (key->offset < (u64)-1)
> +		key->offset++;
> +	else if (key->type < (u8)-1) {
> +		key->offset = 0;
> +		key->type++;
> +	} else if (key->objectid < (u64)-1) {
> +		key->offset = 0;
> +		key->type = 0;
> +		key->objectid++;

It would be doable to check that type is in the range 
	[BTRFS_ROOT_ITEM_KEY...BTRFS_ROOT_BACKREF_KEY]

I.e. something like


 +	if (btrfs_comp_cpu_keys(key, &test) >= 0)
 +		ret = 1;
 +	else if (key->offset < (u64)-1)
 +		key->offset++;
 +	else if (key->type < BTRFS_ROOT_BACKREF_KEY) {
 +		key->offset = 0;
 +		key->type++;
 +	} else if (key->objectid < (u64)-1) {
 +		key->offset = 0;
 +		key->type = BTRFS_ROOT_ITEM_KEY;
 +		key->objectid++;



> +	} else
> +		ret = 1;
> +out:
> +	/*
> +	 *  0: all items from this leaf copied, continue with next
> +	 *  1: * more items can be copied, but unused buffer is too small
> +	 *     * all items were found
> +	 *     Either way, it will stops the loop which iterates to the next
> +	 *     leaf
> +	 *  -EOVERFLOW: item was to large for buffer
> +	 *  -EFAULT: could not copy extent buffer back to userspace
> +	 */
> +	return ret;
> +}
> +
>  static noinline int search_ioctl(struct inode *inode,
>  				 struct btrfs_ioctl_search_key *sk,
>  				 size_t *buf_size,
> @@ -2309,6 +2467,100 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  	return ret;
>  }
>  
> +static noinline int search_subvol(struct inode *inode,
> +				 struct btrfs_ioctl_search_key *sk,
> +				 size_t *buf_size,
> +				 char __user *ubuf)
> +{
> +	struct btrfs_fs_info *info = btrfs_sb(inode->i_sb);
> +	struct btrfs_root *root;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	unsigned long sk_offset = 0;
> +	int num_found = 0;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	/* search ROOT TREEE */
> +	key.objectid = BTRFS_ROOT_TREE_OBJECTID;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +	root = btrfs_read_fs_root_no_name(info, &key);
> +	if (IS_ERR(root)) {
> +		btrfs_free_path(path);
> +		return -ENOENT;
> +	}
> +
> +	key.objectid = sk->min_objectid;
> +	key.type = sk->min_type;
> +	key.offset = sk->min_offset;
> +
> +	while (1) {
> +		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
> +		if (ret != 0) {
> +			if (ret > 0)
> +				ret = 0;
> +			goto err;
> +		}
> +
> +		ret = copy_subvol_item(path, &key, sk, buf_size, ubuf,
> +				 &sk_offset, &num_found);
> +		btrfs_release_path(path);
> +		if (ret)
> +			break;
> +	}
> +
> +	if (ret > 0)
> +		ret = 0;
> +err:
> +	sk->nr_items = num_found;
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +/*
> + * Unprivileged ioctl for getting subvolume related item.
> + * The arguments are the same as btrfs_ioctl_tree_search()
> + * and can be used like tree search ioctl.
> + *
> + * Only returns ROOT_ITEM/ROOT_BACKREF/ROOT_REF key of subvolumes
> + * from root tree. Also, the name of subvolume will be omitted from
> + * ROOT_BACKREF/ROOT_REF item to prevent name leak.
> + */
> +static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_search_args __user *uargs;
> +	struct btrfs_ioctl_search_key sk;
> +	struct inode *inode;
> +	size_t buf_size;
> +	int ret;
> +
> +	uargs = (struct btrfs_ioctl_search_args __user *)argp;
> +
> +	if (copy_from_user(&sk, &uargs->key, sizeof(sk)))
> +		return -EFAULT;
> +
> +	buf_size = sizeof(uargs->buf);
> +
> +	inode = file_inode(file);
> +	ret = search_subvol(inode, &sk, &buf_size, uargs->buf);
> +
> +	/*
> +	 * In the original implementation an overflow is handled by returning a
> +	 * search header with a len of zero, so reset ret.
> +	 */
> +	if (ret == -EOVERFLOW)
> +		ret = 0;
> +
> +	if (ret == 0 && copy_to_user(&uargs->key, &sk, sizeof(sk)))
> +		ret = -EFAULT;
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  					     void __user *arg)
>  {
> @@ -5663,6 +5915,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_features(file, argp);
>  	case BTRFS_IOC_SET_FEATURES:
>  		return btrfs_ioctl_set_features(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_INFO:
> +		return btrfs_ioctl_get_subvol_info(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index c8d99b9ca550..1e9361cf66d5 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -843,5 +843,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args_v2)
>  #define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>  					struct btrfs_ioctl_logical_ino_args)
> +#define BTRFS_IOC_GET_SUBVOL_INFO _IOWR(BTRFS_IOCTL_MAGIC, 60, \
> +					struct btrfs_ioctl_search_args)
>  
>  #endif /* _UAPI_LINUX_BTRFS_H */
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
