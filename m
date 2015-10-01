Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbbJAVat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 17:30:49 -0400
Date: Thu, 1 Oct 2015 14:30:47 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, david@fromorbit.com
Subject: [RFC][PATCH] btrfs: add ioctl to monitor subvolume dropping
Message-ID: <20151001213047.GB1044@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dropping a subvolume in btrfs is a delayed operation which can persist
across mounts (or crashes) - progress for the subvolume drop is recorded in
a key on the root object.

At the moment, userspace has no way of knowing when a snapshot is finally
removed. This has become a problem when writing tests for btrfs,

http://article.gmane.org/gmane.comp.file-systems.fstests/1239/

The following patch tries to fix this by putting orphaned subvolumes on a
per-fs rbtree. We provide an ioctl which userspace can use to query the
state of a subvolume. Internally, we'll search the rbtree and if a match is
found, the drop progress from our disk key is returned. If a match is not
found, ENOENT is returned and userspace can safely assume that the root has
been dropped (or was never orphaned to begin with).

Obviously this wants a patch to btrfsprogs, which I am currently working on.
In the meantime the ioctl can be tested with the following userspace
program (I had to indent it by 1 space so git wouldn't swallow up the
preprocessor directives).

 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
 #include <errno.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>

 static void usage(const char *prog)
 {
 	printf("Usage: %s /path/to/btrfs rootid\n", prog);
 }

 int main(int argc, char **argv)
 {
 	int ret, fd;
 	char *filename;
 	uint64_t rootid, tmp;

 	if (argc != 3) {
 		usage(argv[0]);
 		return 1;
 	}
 	filename = argv[1];
 	rootid = atoll(argv[2]);

 	ret = open(filename, O_RDONLY);
 	if (ret < 0) {
 		ret = errno;
 		fprintf(stderr, "Could not open file %s: (%d) %s\n", filename, ret,
 			strerror(ret));
 		return ret;
 	}
 	fd = ret;

 	tmp = rootid;
 	ret = ioctl(fd, BTRFS_IOC_GET_DROP_STATUS, &tmp);
 	if (ret < 0 && ret != ENOENT) {
 		ret = errno;
 		fprintf(stderr, "ioctl returned error: (%d) %s\n", ret,
 			strerror(ret));
 		return ret;
 	}

 	close(fd);

 	if (ret == ENOENT)
 		printf("Subvolume not found or already dropped\n");
 	else
 		printf("Subvolume %"PRIu64" drop is at object: %"PRIu64"\n", rootid, tmp);

 	return 0;
 }

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.h           |  8 ++++++
 fs/btrfs/disk-io.c         |  4 +++
 fs/btrfs/extent-tree.c     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c           | 24 ++++++++++++++++
 fs/btrfs/root-tree.c       |  1 +
 include/uapi/linux/btrfs.h |  1 +
 6 files changed, 109 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..45cd49e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1782,6 +1782,8 @@ struct btrfs_fs_info {
 	 * and will be latter freed. Protected by fs_info->chunk_mutex.
 	 */
 	struct list_head pinned_chunks;
+
+	struct rb_root	dropping_roots;
 };
 
 struct btrfs_subvolume_writers {
@@ -1943,6 +1945,8 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshoted;
+
+	struct rb_node	drop_status;
 };
 
 struct btrfs_ioctl_defrag_range_args {
@@ -3647,6 +3651,10 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct extent_buffer *node,
 			struct extent_buffer *parent);
+void btrfs_add_drop_status(struct btrfs_root *root);
+void btrfs_remove_drop_status(struct btrfs_root *root);
+int btrfs_get_drop_status(struct btrfs_fs_info *fs_info, u64 rootid,
+			  u64 *status);
 static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 {
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 295795a..78dd6da 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1283,6 +1283,7 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
 	root->anon_dev = 0;
 
 	spin_lock_init(&root->root_item_lock);
+	RB_CLEAR_NODE(&root->drop_status);
 }
 
 static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info)
@@ -2638,6 +2639,8 @@ int open_ctree(struct super_block *sb,
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
+	fs_info->dropping_roots = RB_ROOT;
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
@@ -3639,6 +3642,7 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 
 static void free_fs_root(struct btrfs_root *root)
 {
+	btrfs_remove_drop_status(root);
 	iput(root->ino_cache_inode);
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9f96042..75f499e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8465,6 +8465,77 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
+DEFINE_SPINLOCK(drop_status_lock);
+void btrfs_add_drop_status(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct rb_root *rbroot = &fs_info->dropping_roots;
+	struct rb_node **p = &rbroot->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_root *entry;
+
+	if (!RB_EMPTY_NODE(&root->drop_status))
+		return;
+
+	spin_lock(&drop_status_lock);
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_root, drop_status);
+		if (root->objectid < entry->objectid)
+			p = &(*p)->rb_left;
+		else if (root->objectid > entry->objectid)
+			p = &(*p)->rb_right;
+		else {
+			spin_unlock(&drop_status_lock);
+			WARN_ON(1);
+			return;
+		}
+	}
+	rb_link_node(&root->drop_status, parent_node, p);
+	rb_insert_color(&root->drop_status, rbroot);
+	spin_unlock(&drop_status_lock);
+}
+
+void btrfs_remove_drop_status(struct btrfs_root *root)
+{
+	if (!root || RB_EMPTY_NODE(&root->drop_status))
+		return;
+
+	spin_lock(&drop_status_lock);
+	rb_erase(&root->drop_status, &root->fs_info->dropping_roots);
+	spin_unlock(&drop_status_lock);
+}
+
+int btrfs_get_drop_status(struct btrfs_fs_info *fs_info,
+			  u64 rootid, u64 *status)
+{
+	int ret = -ENOENT;
+	struct rb_node *n;
+	struct btrfs_root *root = NULL;
+	struct btrfs_root_item *root_item;
+
+	spin_lock(&drop_status_lock);
+	n = fs_info->dropping_roots.rb_node;
+	while (n) {
+		root = rb_entry(n, struct btrfs_root, drop_status);
+		if (rootid < root->objectid)
+			n = n->rb_left;
+		else if (rootid > root->objectid)
+			n = n->rb_right;
+		else
+			break;
+	}
+
+	if (n) {
+		root_item = &root->root_item;
+		*status = btrfs_disk_key_objectid(&root_item->drop_progress);
+		ret = 0;
+	}
+	spin_unlock(&drop_status_lock);
+
+	return ret;
+}
+
 /*
  * drop a subvolume tree.
  *
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0adf542..cc8d9d3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2486,6 +2486,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			err = ret;
 			goto out_end_trans;
 		}
+		btrfs_add_drop_status(dest);
 	}
 
 	ret = btrfs_uuid_tree_rem(trans, root->fs_info->uuid_root,
@@ -5378,6 +5379,27 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	return btrfs_commit_transaction(trans, root);
 }
 
+static int btrfs_ioctl_get_drop_status(struct file *file, void __user *arg)
+{
+	u64 rootid, status;
+	int ret;
+	struct btrfs_fs_info *fs_info = btrfs_sb(file_inode(file)->i_sb);
+
+	if (copy_from_user(&rootid, arg, sizeof(rootid))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = btrfs_get_drop_status(fs_info, rootid, &status);
+
+	if (ret == 0) {
+		if (copy_to_user(arg, &status, sizeof(status)))
+			ret = -EFAULT;
+	}
+out:
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -5514,6 +5536,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case BTRFS_IOC_GET_DROP_STATUS:
+		return btrfs_ioctl_get_drop_status(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 360a728..76286a2 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -307,6 +307,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 		}
 
 		set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state);
+		btrfs_add_drop_status(root);
 
 		err = btrfs_insert_fs_root(root->fs_info, root);
 		if (err) {
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05..fdc3180 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -634,5 +634,6 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags[3])
+#define	BTRFS_IOC_GET_DROP_STATUS	_IOWR(BTRFS_IOCTL_MAGIC, 58, __u64)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.1.2

