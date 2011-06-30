From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: initial online fsck support
Date: Thu, 30 Jun 2011 17:33:55 +0800
Message-ID: <4E0C4303.1080406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an initial version of online fsck. What it does is:

- check the dir item and dir index pointing to a file.
- check the structure of extents of a file.

As furthur work, we should consider:

- fix but not only check the structure of a file.
- verify the extent allocation tree on the fly.
...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |  258 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   15 +++
 2 files changed, 273 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b793d11..c06f542 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2834,6 +2834,262 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
+static long check_file_extents(u64 *errors, struct inode *inode,
+			       struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct btrfs_key prev_key;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	int slot;
+	int ret;
+	int sector = root->sectorsize;
+	u64 err = 0;
+	u64 prev_num_bytes = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	mutex_lock(&inode->i_mutex);
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		if (inode->i_size)
+			err |= BTRFS_FSCK_NO_FILE_EXTENT;
+		ret = 0;
+		goto out;
+	}
+
+	if (!inode->i_size) {
+		err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+		goto out;
+	}
+
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		u64 ram_bytes;
+		u64 offset;
+		u64 num_bytes;
+		u64 disk_bytenr;
+		u64 disk_num_bytes;
+		u32 inline_size;
+		u8 compress;
+		u8 type;
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.objectid != btrfs_ino(inode) ||
+		    key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+
+		type = btrfs_file_extent_type(leaf, fi);
+		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+		compress = btrfs_file_extent_compression(leaf, fi);
+
+		if (compress >= BTRFS_COMPRESS_LAST) {
+			err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+			goto out;
+		}
+
+		switch (type) {
+		case BTRFS_FILE_EXTENT_INLINE:
+			inline_size = btrfs_file_extent_inline_item_len(leaf,
+						btrfs_item_nr(leaf, slot));
+			if (inline_size == 0) {
+				err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+				goto out;
+			}
+			num_bytes = 0;
+			break;
+		case BTRFS_FILE_EXTENT_REG:
+		case BTRFS_FILE_EXTENT_PREALLOC:
+			offset = btrfs_file_extent_offset(leaf, fi);
+			num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
+			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+			disk_num_bytes = btrfs_file_extent_disk_num_bytes(leaf,
+									  fi);
+
+			if (num_bytes == 0 || !IS_ALIGNED(num_bytes, sector)) {
+				err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+				goto out;
+			}
+
+			if (type == BTRFS_FILE_EXTENT_PREALLOC &&
+			    (compress ||
+			     btrfs_file_extent_encryption(leaf, fi) ||
+			     btrfs_file_extent_other_encoding(leaf, fi))) {
+				err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+				goto out;
+			}
+
+			if (disk_bytenr && offset + num_bytes > disk_bytenr) {
+				err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+				goto out;
+			}
+
+			if (key.offset != 0 &&
+			    key.offset != prev_key.offset + prev_num_bytes) {
+				err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+				goto out;
+			}
+
+			break;
+		default:
+			err |= BTRFS_FSCK_BAD_FILE_EXTENT;
+			goto out;
+		}
+
+		memcpy(&prev_key, &key, sizeof(key));
+		prev_num_bytes = num_bytes;
+
+		path->slots[0]++;
+	}
+
+	ret = 0;
+out:
+	*errors |= err;
+	mutex_unlock(&inode->i_mutex);
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+static bool check_dir_item(struct inode *inode, struct extent_buffer *leaf,
+			   struct btrfs_dir_item *di)
+{
+	struct btrfs_key location;
+	u8 type;
+
+	type = btrfs_dir_type(leaf, di);
+	if (type >= BTRFS_FT_MAX || type == BTRFS_FT_XATTR)
+		return false;
+	else if (S_ISDIR(inode->i_mode) && type != BTRFS_FT_DIR)
+		return false;
+
+	btrfs_dir_item_key_to_cpu(leaf, di, &location);
+	if (memcmp(&location, &BTRFS_I(inode)->location, sizeof(location)))
+		return false;
+
+	return true;
+}
+
+static int check_dir_items(u64 *errors, struct dentry *dentry,
+			   struct btrfs_root *root)
+
+{
+	struct inode *inode = dentry->d_inode;
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct btrfs_inode_ref *iref;
+	struct btrfs_dir_item *di;
+	struct btrfs_path *path;
+	int ret = 0;
+	u64 index;
+	u64 err = 0;
+	u64 ino = btrfs_ino(inode);
+	u64 dir_ino = btrfs_ino(dir);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	iref = btrfs_lookup_inode_ref(NULL, root, path, dentry->d_name.name,
+				      dentry->d_name.len, ino, dir_ino, 0);
+	if (!iref) {
+		err |= BTRFS_FSCK_NO_INODE_REF;
+		goto out;
+	} else if (IS_ERR(iref)) {
+		ret = PTR_ERR(iref);
+		goto out;
+	}
+
+	index = btrfs_inode_ref_index(path->nodes[0], iref);
+	btrfs_release_path(path);
+
+	di = btrfs_lookup_dir_item(NULL, root, path, dir_ino,
+				   dentry->d_name.name, dentry->d_name.len, 0);
+	if (!di) {
+		err |= BTRFS_FSCK_NO_DIR_ITEM;
+		goto check_dir_index;
+	} else if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
+	}
+
+	if (!check_dir_item(inode, path->nodes[0], di))
+		err |= BTRFS_FSCK_BAD_DIR_ITEM;
+	btrfs_release_path(path);
+
+check_dir_index:
+	di = btrfs_lookup_dir_index_item(NULL, root, path, dir_ino, index,
+					 dentry->d_name.name,
+					 dentry->d_name.len, 0);
+	if (!di) {
+		err |= BTRFS_FSCK_NO_DIR_INDEX;
+		goto out;
+	} else if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
+	}
+
+	if (!check_dir_item(inode, path->nodes[0], di))
+		err |= BTRFS_FSCK_BAD_DIR_INDEX;
+out:
+	*errors |= err;
+	btrfs_free_path(path);
+	return ret;
+}
+
+static long btrfs_ioctl_online_fsck(struct file *file, void __user *argp)
+{
+	struct btrfs_ioctl_online_fsck_args *args;
+	struct dentry *dentry = fdentry(file);
+	struct inode *inode = dentry->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	args = kzalloc(sizeof(*args), GFP_KERNEL);
+	if (!args)
+		return -ENOMEM;
+
+	if (copy_from_user(args, argp, sizeof(*args)))
+		return -EFAULT;
+	args->errors = 0;
+
+	ret = check_dir_items(&args->errors, dentry, root);
+	if (ret)
+		return ret;
+
+	if (S_ISDIR(inode->i_mode))
+		goto out;
+
+	ret = check_file_extents(&args->errors, inode, root);
+out:
+	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
+		return -EFAULT;
+
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2906,6 +3162,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
+	case BTRFS_IOC_ONLINE_FSCK:
+		return btrfs_ioctl_online_fsck(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..85f5c95 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -193,6 +193,19 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+#define BTRFS_FSCK_NO_INODE_REF		(1 << 0)
+#define BTRFS_FSCK_NO_DIR_ITEM		(1 << 1)
+#define BTRFS_FSCK_BAD_DIR_ITEM		(1 << 2)
+#define BTRFS_FSCK_NO_DIR_INDEX		(1 << 3)
+#define BTRFS_FSCK_BAD_DIR_INDEX	(1 << 4)
+#define BTRFS_FSCK_NO_FILE_EXTENT	(1 << 5)
+#define BTRFS_FSCK_BAD_FILE_EXTENT	(1 << 6)
+
+struct btrfs_ioctl_online_fsck_args {
+	__u64 errors;
+	__u64 unused[1024 - sizeof(__u64)];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -248,4 +261,6 @@ struct btrfs_ioctl_space_args {
 				 struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 			       struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_ONLINE_FSCK _IOWR(BTRFS_IOCTL_MAGIC, 32, \
+				    struct btrfs_ioctl_online_fsck_args)
 #endif
-- 
1.7.3.1
