From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 5/5] btrfs: test ioctl for readahead
Date: Mon, 23 May 2011 14:59:08 +0200
Message-ID: <96392f63f0e0dc6cc798e5032c5f807d4d59439f.1306154794.git.sensille@gmx.net>
References: <cover.1306154794.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This ioctl is added to trigger a readahead from user mode. It implements
a readahead using the new interface and also a traditional tree walk.
This way it's possible to measure the two side by side.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ioctl.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h |   16 ++++++++++
 2 files changed, 101 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f580a3a..13a88d7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2465,6 +2465,89 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static noinline long btrfs_ioctl_reada_test(struct btrfs_fs_info *fs_info,
+					    void __user *argp)
+{
+	struct btrfs_key start = {0, 0, 0};
+	struct btrfs_key end = {(u64)-1ll, (u8)-1, (u64)-1ll};
+	struct btrfs_ioctl_reada_args reada_args;
+	struct btrfs_key key;
+	struct btrfs_root *root = NULL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!argp)
+		return -EINVAL;
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
+		void *handle;
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
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2527,7 +2610,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_start_sync(file, argp);
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(file, argp);
+	case BTRFS_IOC_READA_TEST:
+		return btrfs_ioctl_reada_test(root->fs_info, argp);
 	}
-
 	return -ENOTTY;
 }
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 8fb3821..9c744ce 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -157,6 +157,20 @@ struct btrfs_ioctl_space_args {
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
@@ -203,4 +217,6 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_READA_TEST _IOW(BTRFS_IOCTL_MAGIC, 99, \
+				struct btrfs_ioctl_reada_args)
 #endif
-- 
1.7.3.4

