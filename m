Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53206 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753042Ab2GPQfo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jul 2012 12:35:44 -0400
Message-ID: <50042BB8.4060904@gmx.net>
Date: Mon, 16 Jul 2012 16:56:56 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com> <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.07.2012 15:38, Alexander Block wrote:
> This patch introduces uuids for subvolumes. Each
> subvolume has it's own uuid. In case it was snapshotted,
> it also contains parent_uuid. In case it was received,
> it also contains received_uuid.
> 
> It also introduces subvolume ctime/otime/stime/rtime. The
> first two are comparable to the times found in inodes. otime
> is the origin/creation time and ctime is the change time.
> stime/rtime are only valid on received subvolumes.
> stime is the time of the subvolume when it was
> sent. rtime is the time of the subvolume when it was
> received.
> 
> Additionally to the times, we have a transid for each
> time. They are updated at the same place as the times.
> 
> btrfs receive uses stransid and rtransid to find out
> if a received subvolume changed in the meantime.
> 
> If an older kernel mounts a filesystem with the
> extented fields, all fields become invalid. The next
> mount with a new kernel will detect this and reset the
> fields.
> 
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
>  fs/btrfs/ctree.h       |   43 ++++++++++++++++++++++
>  fs/btrfs/disk-io.c     |    2 +
>  fs/btrfs/inode.c       |    4 ++
>  fs/btrfs/ioctl.c       |   96 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/ioctl.h       |   13 +++++++
>  fs/btrfs/root-tree.c   |   92 +++++++++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/transaction.c |   17 +++++++++
>  7 files changed, 258 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8cfde93..2bd5df8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -709,6 +709,35 @@ struct btrfs_root_item {
>  	struct btrfs_disk_key drop_progress;
>  	u8 drop_level;
>  	u8 level;
> +
> +	/*
> +	 * The following fields appear after subvol_uuids+subvol_times
> +	 * were introduced.
> +	 */
> +
> +	/*
> +	 * This generation number is used to test if the new fields are valid
> +	 * and up to date while reading the root item. Everytime the root item
> +	 * is written out, the "generation" field is copied into this field. If
> +	 * anyone ever mounted the fs with an older kernel, we will have
> +	 * mismatching generation values here and thus must invalidate the
> +	 * new fields. See btrfs_update_root and btrfs_find_last_root for
> +	 * details.
> +	 * the offset of generation_v2 is also used as the start for the memset
> +	 * when invalidating the fields.
> +	 */
> +	__le64 generation_v2;
> +	u8 uuid[BTRFS_UUID_SIZE];
> +	u8 parent_uuid[BTRFS_UUID_SIZE];
> +	u8 received_uuid[BTRFS_UUID_SIZE];
> +	__le64 ctransid; /* updated when an inode changes */
> +	__le64 otransid; /* trans when created */
> +	__le64 stransid; /* trans when sent. non-zero for received subvol */
> +	__le64 rtransid; /* trans when received. non-zero for received subvol */
> +	struct btrfs_timespec ctime;
> +	struct btrfs_timespec otime;
> +	struct btrfs_timespec stime;
> +	struct btrfs_timespec rtime;
>  } __attribute__ ((__packed__));
>  
>  /*
> @@ -1416,6 +1445,8 @@ struct btrfs_root {
>  	dev_t anon_dev;
>  
>  	int force_cow;
> +
> +	spinlock_t root_times_lock;
>  };
>  
>  struct btrfs_ioctl_defrag_range_args {
> @@ -2189,6 +2220,16 @@ BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
>  			 last_snapshot, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
> +			 generation_v2, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_ctransid, struct btrfs_root_item,
> +			 ctransid, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_otransid, struct btrfs_root_item,
> +			 otransid, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
> +			 stransid, 64);
> +BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
> +			 rtransid, 64);
>  
>  static inline bool btrfs_root_readonly(struct btrfs_root *root)
>  {
> @@ -2829,6 +2870,8 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
>  void btrfs_set_root_node(struct btrfs_root_item *item,
>  			 struct extent_buffer *node);
>  void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
> +void btrfs_update_root_times(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root);
>  
>  /* dir-item.c */
>  int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7b845ff..d3b49ad 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1182,6 +1182,8 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
>  	root->defrag_running = 0;
>  	root->root_key.objectid = objectid;
>  	root->anon_dev = 0;
> +
> +	spin_lock_init(&root->root_times_lock);
>  }
>  
>  static int __must_check find_and_setup_root(struct btrfs_root *tree_root,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 139be17..0f6a65d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2734,6 +2734,8 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
>  	 */
>  	if (!btrfs_is_free_space_inode(root, inode)
>  	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
> +		btrfs_update_root_times(trans, root);
> +
>  		ret = btrfs_delayed_update_inode(trans, root, inode);
>  		if (!ret)
>  			btrfs_set_inode_last_trans(trans, inode);
> @@ -4728,6 +4730,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	trace_btrfs_inode_new(inode);
>  	btrfs_set_inode_last_trans(trans, inode);
>  
> +	btrfs_update_root_times(trans, root);
> +
>  	return inode;
>  fail:
>  	if (dir)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 7011871..8d258cb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -41,6 +41,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/uuid.h>
>  #include "compat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -346,11 +347,13 @@ static noinline int create_subvol(struct btrfs_root *root,
>  	struct btrfs_root *new_root;
>  	struct dentry *parent = dentry->d_parent;
>  	struct inode *dir;
> +	struct timespec cur_time = CURRENT_TIME;
>  	int ret;
>  	int err;
>  	u64 objectid;
>  	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
>  	u64 index = 0;
> +	uuid_le new_uuid;
>  
>  	ret = btrfs_find_free_objectid(root->fs_info->tree_root, &objectid);
>  	if (ret)
> @@ -389,8 +392,9 @@ static noinline int create_subvol(struct btrfs_root *root,
>  			    BTRFS_UUID_SIZE);
>  	btrfs_mark_buffer_dirty(leaf);
>  
> +	memset(&root_item, 0, sizeof(root_item));
> +
>  	inode_item = &root_item.inode;
> -	memset(inode_item, 0, sizeof(*inode_item));
>  	inode_item->generation = cpu_to_le64(1);
>  	inode_item->size = cpu_to_le64(3);
>  	inode_item->nlink = cpu_to_le32(1);
> @@ -408,8 +412,15 @@ static noinline int create_subvol(struct btrfs_root *root,
>  	btrfs_set_root_used(&root_item, leaf->len);
>  	btrfs_set_root_last_snapshot(&root_item, 0);
>  
> -	memset(&root_item.drop_progress, 0, sizeof(root_item.drop_progress));
> -	root_item.drop_level = 0;
> +	btrfs_set_root_generation_v2(&root_item,
> +			btrfs_root_generation(&root_item));
> +	uuid_le_gen(&new_uuid);
> +	memcpy(root_item.uuid, new_uuid.b, BTRFS_UUID_SIZE);
> +	root_item.otime.sec = cpu_to_le64(cur_time.tv_sec);
> +	root_item.otime.nsec = cpu_to_le64(cur_time.tv_nsec);
> +	root_item.ctime = root_item.otime;
> +	btrfs_set_root_ctransid(&root_item, trans->transid);
> +	btrfs_set_root_otransid(&root_item, trans->transid);
>  
>  	btrfs_tree_unlock(leaf);
>  	free_extent_buffer(leaf);
> @@ -3395,6 +3406,83 @@ out:
>  	return ret;
>  }
>  
> +static long btrfs_ioctl_set_received_subvol(struct file *file,
> +					    void __user *arg)
> +{
> +	struct btrfs_ioctl_received_subvol_args *sa = NULL;
> +	struct inode *inode = fdentry(file)->d_inode;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_root_item *root_item = &root->root_item;
> +	struct btrfs_trans_handle *trans;
> +	int ret = 0;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret < 0)
> +		return ret;
> +
> +	down_write(&root->fs_info->subvol_sem);
> +
> +	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (btrfs_root_readonly(root)) {
> +		ret = -EROFS;
> +		goto out;
> +	}
> +
> +	if (!inode_owner_or_capable(inode)) {
> +		ret = -EACCES;
> +		goto out;
> +	}
> +
> +	sa = memdup_user(arg, sizeof(*sa));
> +	if (IS_ERR(sa)) {
> +		ret = PTR_ERR(sa);
> +		sa = NULL;
> +		goto out;
> +	}
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		trans = NULL;
> +		goto out;
> +	}
> +
> +	sa->rtransid = trans->transid;
> +	sa->rtime = CURRENT_TIME;
> +
> +	memcpy(root_item->received_uuid, sa->uuid, BTRFS_UUID_SIZE);
> +	btrfs_set_root_stransid(root_item, sa->stransid);
> +	btrfs_set_root_rtransid(root_item, sa->rtransid);
> +	root_item->stime.sec = cpu_to_le64(sa->stime.tv_sec);
> +	root_item->stime.nsec = cpu_to_le64(sa->stime.tv_nsec);
> +	root_item->rtime.sec = cpu_to_le64(sa->rtime.tv_sec);
> +	root_item->rtime.nsec = cpu_to_le64(sa->rtime.tv_nsec);
> +
> +	ret = btrfs_update_root(trans, root->fs_info->tree_root,
> +				&root->root_key, &root->root_item);
> +	if (ret < 0) {
> +		goto out;

are you leaking a trans handle here?

> +	} else {
> +		ret = btrfs_commit_transaction(trans, root);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	ret = copy_to_user(arg, sa, sizeof(*sa));
> +	if (ret)
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(sa);
> +	up_write(&root->fs_info->subvol_sem);
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3477,6 +3565,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_balance_ctl(root, arg);
>  	case BTRFS_IOC_BALANCE_PROGRESS:
>  		return btrfs_ioctl_balance_progress(root, argp);
> +	case BTRFS_IOC_SET_RECEIVED_SUBVOL:
> +		return btrfs_ioctl_set_received_subvol(file, argp);
>  	case BTRFS_IOC_GET_DEV_STATS:
>  		return btrfs_ioctl_get_dev_stats(root, argp, 0);
>  	case BTRFS_IOC_GET_AND_RESET_DEV_STATS:
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index e440aa6..c9e3fac 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -295,6 +295,15 @@ struct btrfs_ioctl_get_dev_stats {
>  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
>  };
>  
> +struct btrfs_ioctl_received_subvol_args {
> +	char	uuid[BTRFS_UUID_SIZE];	/* in */
> +	__u64	stransid;		/* in */
> +	__u64	rtransid;		/* out */
> +	struct timespec stime;		/* in */
> +	struct timespec rtime;		/* out */
> +	__u64	reserved[16];

What is this reserved used for? I don't see a mechanism that could be
used to signal that there are useful information here, other than
using a different ioctl.

> +};
> +
>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
> @@ -359,6 +368,10 @@ struct btrfs_ioctl_get_dev_stats {
>  					struct btrfs_ioctl_ino_path_args)
>  #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
>  					struct btrfs_ioctl_ino_path_args)
> +
> +#define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
> +				struct btrfs_ioctl_received_subvol_args)
> +
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 24fb8ce..17d638e 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -16,6 +16,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#include <linux/uuid.h>
>  #include "ctree.h"
>  #include "transaction.h"
>  #include "disk-io.h"
> @@ -25,6 +26,9 @@
>   * lookup the root with the highest offset for a given objectid.  The key we do
>   * find is copied into 'key'.  If we find something return 0, otherwise 1, < 0
>   * on error.
> + * We also check if the root was once mounted with an older kernel. If we detect
> + * this, the new fields coming after 'level' get overwritten with zeros so to
> + * invalidate the fields.

... "This is detected by a mismatch of the 2 generation fields" ... or something
like that.

>   */
>  int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
>  			struct btrfs_root_item *item, struct btrfs_key *key)
> @@ -35,6 +39,9 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
>  	struct extent_buffer *l;
>  	int ret;
>  	int slot;
> +	int len;
> +	int need_reset = 0;
> +	uuid_le uuid;
>  
>  	search_key.objectid = objectid;
>  	search_key.type = BTRFS_ROOT_ITEM_KEY;
> @@ -60,11 +67,36 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
>  		ret = 1;
>  		goto out;
>  	}
> -	if (item)
> +	if (item) {
> +		len = btrfs_item_size_nr(l, slot);
>  		read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
> -				   sizeof(*item));
> +				min_t(int, len, (int)sizeof(*item)));
> +		if (len < sizeof(*item))
> +			need_reset = 1;
> +		if (!need_reset && btrfs_root_generation(item)
> +			!= btrfs_root_generation_v2(item)) {
> +			if (btrfs_root_generation_v2(item) != 0) {
> +				printk(KERN_WARNING "btrfs: mismatching "
> +						"generation and generation_v2 "
> +						"found in root item. This root "
> +						"was probably mounted with an "
> +						"older kernel. Resetting all "
> +						"new fields.\n");
> +			}
> +			need_reset = 1;
> +		}
> +		if (need_reset) {
> +			memset(&item->generation_v2, 0,
> +				sizeof(*item) - offsetof(struct btrfs_root_item,
> +						generation_v2));
> +
> +			uuid_le_gen(&uuid);
> +			memcpy(item->uuid, uuid.b, BTRFS_UUID_SIZE);
> +		}
> +	}
>  	if (key)
>  		memcpy(key, &found_key, sizeof(found_key));
> +
>  	ret = 0;
>  out:
>  	btrfs_free_path(path);
> @@ -91,16 +123,15 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  	int ret;
>  	int slot;
>  	unsigned long ptr;
> +	int old_len;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
>  
>  	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
> -	if (ret < 0) {
> -		btrfs_abort_transaction(trans, root, ret);
> -		goto out;
> -	}
> +	if (ret < 0)
> +		goto out_abort;
>  
>  	if (ret != 0) {
>  		btrfs_print_leaf(root, path->nodes[0]);
> @@ -113,11 +144,47 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  	l = path->nodes[0];
>  	slot = path->slots[0];
>  	ptr = btrfs_item_ptr_offset(l, slot);
> +	old_len = btrfs_item_size_nr(l, slot);
> +
> +	/*
> +	 * If this is the first time we update the root item which originated
> +	 * from an older kernel, we need to enlarge the item size to make room
> +	 * for the added fields.
> +	 */
> +	if (old_len < sizeof(*item)) {
> +		btrfs_release_path(path);
> +		ret = btrfs_search_slot(trans, root, key, path,
> +				-1, 1);
> +		if (ret < 0)
> +			goto out_abort;
> +		ret = btrfs_del_item(trans, root, path);
> +		if (ret < 0)
> +			goto out_abort;
> +		btrfs_release_path(path);
> +		ret = btrfs_insert_empty_item(trans, root, path,
> +				key, sizeof(*item));
> +		if (ret < 0)
> +			goto out_abort;
> +		l = path->nodes[0];
> +		slot = path->slots[0];
> +		ptr = btrfs_item_ptr_offset(l, slot);
> +	}
> +
> +	/*
> +	 * Update generation_v2 so at the next mount we know the new root
> +	 * fields are valid.
> +	 */
> +	btrfs_set_root_generation_v2(item, btrfs_root_generation(item));
> +
>  	write_extent_buffer(l, item, ptr, sizeof(*item));
>  	btrfs_mark_buffer_dirty(path->nodes[0]);
>  out:
>  	btrfs_free_path(path);
>  	return ret;
> +
> +out_abort:
> +	btrfs_abort_transaction(trans, root, ret);
> +	goto out;
>  }
>  
>  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> @@ -454,3 +521,16 @@ void btrfs_check_and_init_root_item(struct btrfs_root_item *root_item)
>  		root_item->byte_limit = 0;
>  	}
>  }
> +
> +void btrfs_update_root_times(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root)
> +{
> +	struct btrfs_root_item *item = &root->root_item;
> +	struct timespec ct = CURRENT_TIME;
> +
> +	spin_lock(&root->root_times_lock);
> +	item->ctransid = trans->transid;
> +	item->ctime.sec = cpu_to_le64(ct.tv_sec);
> +	item->ctime.nsec = cpu_to_le64(ct.tv_nsec);
> +	spin_unlock(&root->root_times_lock);
> +}
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index b72b068..a21f308 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -22,6 +22,7 @@
>  #include <linux/writeback.h>
>  #include <linux/pagemap.h>
>  #include <linux/blkdev.h>
> +#include <linux/uuid.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -926,11 +927,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	struct dentry *dentry;
>  	struct extent_buffer *tmp;
>  	struct extent_buffer *old;
> +	struct timespec cur_time = CURRENT_TIME;
>  	int ret;
>  	u64 to_reserve = 0;
>  	u64 index = 0;
>  	u64 objectid;
>  	u64 root_flags;
> +	uuid_le new_uuid;
>  
>  	rsv = trans->block_rsv;
>  
> @@ -1016,6 +1019,20 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  		root_flags &= ~BTRFS_ROOT_SUBVOL_RDONLY;
>  	btrfs_set_root_flags(new_root_item, root_flags);
>  
> +	btrfs_set_root_generation_v2(new_root_item,
> +			trans->transid);
> +	uuid_le_gen(&new_uuid);
> +	memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
> +	memcpy(new_root_item->parent_uuid, root->root_item.uuid,
> +			BTRFS_UUID_SIZE);
> +	new_root_item->otime.sec = cpu_to_le64(cur_time.tv_sec);
> +	new_root_item->otime.nsec = cpu_to_le64(cur_time.tv_nsec);
> +	btrfs_set_root_otransid(new_root_item, trans->transid);
> +	memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
> +	memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
> +	btrfs_set_root_stransid(new_root_item, 0);
> +	btrfs_set_root_rtransid(new_root_item, 0);
> +
>  	old = btrfs_lock_root_node(root);
>  	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
>  	if (ret) {

