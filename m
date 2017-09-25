Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:39979 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966053AbdIYUS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:28 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] New ioctl BTRFS_IOC_GET_CHUNK_INFO
Date: Mon, 25 Sep 2017 22:10:10 +0200
Message-Id: <20170925201010.9958-2-kreijack@libero.it>
In-Reply-To: <20170925201010.9958-1-kreijack@libero.it>
References: <20170925201010.9958-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Add a new ioctl to get info about chunk without requiring the root privileges.
This allow to a non root user to know how the space of the filesystem is
allocated.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/ioctl.c           | 215 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  38 ++++++++
 2 files changed, 253 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..d9ba9ed52693 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2220,6 +2220,219 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 	return ret;
 }
 
+/*
+ * Return:
+ *	0		-> copied all data, possible further data
+ *	1		-> copied all data, no further data
+ *	-EAGAIN		-> not enough space, restart it
+ *	-EFAULT		-> the user passed an invalid address/size pair
+ */
+static noinline int copy_chunk_info(struct btrfs_path *path,
+			       char __user *ubuf,
+			       size_t buf_size,
+			       u64 *used_buf,
+			       int *num_found,
+			       u64 *offset)
+{
+	struct extent_buffer *leaf;
+	unsigned long item_off;
+	unsigned long item_len;
+	int nritems;
+	int i;
+	int slot;
+	int ret = 0;
+	struct btrfs_key key;
+
+	leaf = path->nodes[0];
+	slot = path->slots[0];
+	nritems = btrfs_header_nritems(leaf);
+
+	for (i = slot; i < nritems; i++) {
+		u64 destsize;
+		struct btrfs_chunk_info ci;
+		struct btrfs_chunk chunk;
+		int j, chunk_size;
+
+		item_off = btrfs_item_ptr_offset(leaf, i);
+		item_len = btrfs_item_size_nr(leaf, i);
+
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		/*
+		 * we are not interested in other items type
+		 */
+		if (key.type != BTRFS_CHUNK_ITEM_KEY) {
+			ret = 1;
+			goto out;
+		}
+
+		/*
+		 * In any case, the next search must start from here
+		 */
+		*offset = key.offset;
+		read_extent_buffer(leaf, &chunk, item_off, sizeof(chunk));
+
+		/*
+		 * chunk.num_stripes-1 is correct, because btrfs_chunk includes
+		 * already a stripe
+		 */
+		destsize = sizeof(struct btrfs_chunk_info) +
+			(chunk.num_stripes - 1) * sizeof(struct btrfs_stripe);
+
+		BUG_ON(destsize > item_len);
+
+		if (buf_size < destsize + *used_buf) {
+			if (*num_found)
+				/* try onother time */
+				ret = -EAGAIN;
+			else
+				/* in any case the buffer is too small */
+				ret = -EOVERFLOW;
+			goto out;
+		}
+
+		/* copy chunk */
+		chunk_size = offsetof(struct btrfs_chunk_info, stripes);
+		memset(&ci, 0, chunk_size);
+		ci.length = btrfs_stack_chunk_length(&chunk);
+		ci.stripe_len = btrfs_stack_chunk_stripe_len(&chunk);
+		ci.type = btrfs_stack_chunk_type(&chunk);
+		ci.num_stripes = btrfs_stack_chunk_num_stripes(&chunk);
+		ci.sub_stripes = btrfs_stack_chunk_sub_stripes(&chunk);
+		ci.offset = key.offset;
+
+		if (copy_to_user(ubuf + *used_buf, &ci, chunk_size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		*used_buf += chunk_size;
+
+		/* copy stripes */
+		for (j = 0 ; j < chunk.num_stripes ; j++) {
+			struct btrfs_stripe chunk_stripe;
+			struct btrfs_chunk_info_stripe csi;
+
+			/*
+			 * j-1 is correct, because btrfs_chunk includes already
+			 * a stripe
+			 */
+			read_extent_buffer(leaf, &chunk_stripe,
+					item_off + sizeof(struct btrfs_chunk) +
+						sizeof(struct btrfs_stripe) *
+						(j - 1), sizeof(chunk_stripe));
+
+			memset(&csi, 0, sizeof(csi));
+
+			csi.devid = btrfs_stack_stripe_devid(&chunk_stripe);
+			csi.offset = btrfs_stack_stripe_offset(&chunk_stripe);
+			memcpy(csi.dev_uuid, chunk_stripe.dev_uuid,
+				sizeof(chunk_stripe.dev_uuid));
+			if (copy_to_user(ubuf + *used_buf, &csi, sizeof(csi))) {
+				ret = -EFAULT;
+				goto out;
+			}
+			*used_buf += sizeof(csi);
+		}
+
+		++(*num_found);
+	}
+
+	ret = 0;
+	if (*offset < (u64)-1)
+		++(*offset);
+out:
+	return ret;
+}
+
+static noinline int search_chunk_info(struct inode *inode, u64 *offset,
+				      int *items_count,
+				      char __user *ubuf, u64 buf_size)
+{
+	struct btrfs_fs_info *info = btrfs_sb(inode->i_sb);
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	int ret;
+	u64 used_buf = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* search for BTRFS_CHUNK_TREE_OBJECTID tree */
+	key.objectid = BTRFS_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root_no_name(info, &key);
+	if (IS_ERR(root)) {
+		btrfs_err(info, "could not find root\n");
+		btrfs_free_path(path);
+		return -ENOENT;
+	}
+
+
+	while (used_buf < buf_size) {
+		key.objectid = 0x0100;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+		key.offset = *offset;
+
+		ret = btrfs_search_forward(root, &key, path, 0);
+		if (ret != 0) {
+			if (ret > 0)
+				ret = 0;
+			goto ret;
+		}
+
+		ret = copy_chunk_info(path, ubuf, buf_size,
+				      &used_buf, items_count, offset);
+
+		btrfs_release_path(path);
+		if (ret)
+			break;
+
+	}
+
+ret:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static noinline int btrfs_ioctl_get_chunk_info(struct file *file,
+					       void __user *argp)
+{
+	struct btrfs_ioctl_chunk_info arg;
+	struct inode *inode;
+	int ret;
+	size_t buf_size;
+	u64 data_offset;
+	const size_t buf_limit = SZ_16M;
+
+
+	data_offset = sizeof(struct btrfs_ioctl_chunk_info);
+	inode = file_inode(file);
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	buf_size = arg.buf_size;
+	arg.items_count = 0;
+
+	if (buf_size < sizeof(struct btrfs_ioctl_chunk_info) +
+			sizeof(struct btrfs_chunk_info))
+		return -EOVERFLOW;
+
+	/* limit result size to 16MB */
+	if (buf_size > buf_limit)
+		buf_size = buf_limit;
+
+	ret = search_chunk_info(inode, &arg.offset, &arg.items_count,
+			argp + data_offset, buf_size - data_offset);
+
+	if (copy_to_user(argp, &arg, data_offset))
+		return -EFAULT;
+
+	return ret;
+}
+
 /*
  * Search INODE_REFs to identify path name of 'dirid' directory
  * in a 'tree_id' tree. and sets path name to 'name'.
@@ -5632,6 +5845,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case BTRFS_IOC_GET_CHUNK_INFO:
+		return btrfs_ioctl_get_chunk_info(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 9aa74f317747..2982377a51bd 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -691,6 +691,42 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];		/* in */
 };
 
+struct btrfs_chunk_info_stripe {
+	__u64 devid;
+	__u64 offset;
+	__u8 dev_uuid[BTRFS_UUID_SIZE];
+};
+
+struct btrfs_chunk_info {
+	/* logical start of this chunk */
+	__u64 offset;
+	/* size of this chunk in bytes */
+	__u64 length;
+
+	__u64 stripe_len;
+	__u64 type;
+
+	/* 2^16 stripes is quite a lot, a second limit is the size of a single
+	 * item in the btree
+	 */
+	__u16 num_stripes;
+
+	/* sub stripes only matter for raid10 */
+	__u16 sub_stripes;
+
+	struct btrfs_chunk_info_stripe stripes[1];
+	/* additional stripes go here */
+};
+
+
+struct btrfs_ioctl_chunk_info {
+	u64			offset;		/* offset to start the search */
+	u32			buf_size;	/* size of the buffer, including
+						 * btrfs_ioctl_chunk_info
+						 */
+	u32			items_count;	/* number of items returned */
+};
+
 /*
  * Caller doesn't want file data in the send stream, even if the
  * search of clone sources doesn't find an extent. UPDATE_EXTENT
@@ -841,5 +877,7 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_GET_CHUNK_INFO _IOR(BTRFS_IOCTL_MAGIC, 59, \
+				   struct btrfs_ioctl_chunk_info)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.14.1

