From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v5 6/7] btrfs: test ioctl for readahead
Date: Fri,  1 Jul 2011 22:58:52 +0200
Message-ID: <6c55be9d1ea447a88a08c060e5703ae185abe30a.1309553533.git.sensille@gmx.net>
References: <cover.1309553533.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
In-Reply-To: <cover.1309553533.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This ioctl is added to trigger a readahead from user mode. It implements
a readahead using the new interface and also a traditional tree walk.
This way it's possible to measure the two side by side.

Changes v5:
 - handle is not of type struct reada_control

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ioctl.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.h |   16 +++++++++
 2 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..a60325b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2784,6 +2784,93 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static noinline long btrfs_ioctl_reada_test(struct btrfs_fs_info *fs_info,
+					    void __user *argp)
+{
+	struct btrfs_key start = { 0 };
+	struct btrfs_key end = {
+		.objectid = (u64)-1,
+		.type = (u8)-1,
+		.offset = (u64)-1
+	};
+	struct btrfs_ioctl_reada_args reada_args;
+	struct btrfs_key key;
+	struct btrfs_root *root = NULL;
+
+	if (!argp)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&reada_args,
+			   (struct btrfs_ioctl_reada_args __user *)argp,
+			   sizeof(reada_args)))
+		return -EFAULT;
+
+	start.objectid = reada_args.start_objectid;
+	start.type = reada_args.start_type;
+	start.offset = reada_args.start_offset;
+	end.objectid = reada_args.end_objectid;
+	end.type = reada_args.end_type;
+	end.offset = reada_args.end_offset;
+
+	key.objectid = reada_args.tree;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root))
+		return -ENOENT;
+
+	if (!(reada_args.flags & BTRFS_READA_IOC_FLAGS_TRAD)) {
+		struct reada_control *handle;
+
+		handle = btrfs_reada_add(root, &start, &end);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		if (reada_args.flags & BTRFS_READA_IOC_FLAGS_WAIT)
+			btrfs_reada_wait(handle);
+		else
+			btrfs_reada_detach(handle);
+	} else {
+		struct btrfs_path *path;
+		struct extent_buffer *leaf;
+		int slot;
+		int ret;
+
+		/*
+		 * enumerate the tree the traditional way
+		 */
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+		path->reada = 2;
+
+		ret = btrfs_search_slot(NULL, root, &start, path, 0, 0);
+		if (ret < 0)
+			goto out;
+
+		do {
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+			btrfs_item_key_to_cpu(leaf, &key, slot);
+
+			if (key.objectid > end.objectid)
+				break;
+			if (key.objectid == end.objectid && key.type > end.type)
+				break;
+			if (key.objectid == end.objectid &&
+			    key.type == end.type && key.offset > end.offset)
+				break;
+		} while ((ret = btrfs_next_leaf(root, path)) == 0);
+out:
+		btrfs_free_path(path);
+		return ret >= 0 ? 0 : ret;
+	}
+	return 0;
+}
+
 static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
 {
 	int ret;
@@ -2836,8 +2923,7 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
 	return ret;
 }
 
-long btrfs_ioctl(struct file *file, unsigned int
-		cmd, unsigned long arg)
+long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	void __user *argp = (void __user *)arg;
@@ -2908,7 +2994,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_scrub_cancel(root, argp);
 	case BTRFS_IOC_SCRUB_PROGRESS:
 		return btrfs_ioctl_scrub_progress(root, argp);
+	case BTRFS_IOC_READA_TEST:
+		return btrfs_ioctl_reada_test(root->fs_info, argp);
 	}
-
 	return -ENOTTY;
 }
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..ee83259 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -193,6 +193,20 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+#define BTRFS_READA_IOC_FLAGS_WAIT	1
+#define BTRFS_READA_IOC_FLAGS_TRAD	2
+struct btrfs_ioctl_reada_args {
+	__u64 flags;
+	__u64 tree;
+	__u64 start_objectid;
+	__u8 start_type;
+	__u64 start_offset;
+	__u64 end_objectid;
+	__u8 end_type;
+	__u64 end_offset;
+	__u64 unused[100];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -248,4 +262,6 @@ struct btrfs_ioctl_space_args {
 				 struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
 			       struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_READA_TEST _IOW(BTRFS_IOCTL_MAGIC, 99, \
+				struct btrfs_ioctl_reada_args)
 #endif
-- 
1.7.3.4

