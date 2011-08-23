From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 15/21] Btrfs: recover restripe on mount
Date: Tue, 23 Aug 2011 23:01:56 +0300
Message-ID: <1314129722-31601-16-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On mount, if restripe item is found, resume restripe in a separate
kernel thread.

Try to be smart to continue roughly where previous balance (or convert)
was interrupted.  For chunk types that were being converted to some
profile we turn on soft convert, in case of a simple balance we turn on
usage filter and relocate only less-than-90%-full chunks of that type.
These are just heuristics but they help quite a bit, and can be improved
in future.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    3 +
 fs/btrfs/ioctl.c   |    2 +-
 fs/btrfs/volumes.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h |    3 +-
 4 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa2301b..b3950f2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2103,6 +2103,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		if (!err)
 			err = btrfs_orphan_cleanup(fs_info->tree_root);
 		up_read(&fs_info->cleanup_work_sem);
+
+		err = btrfs_recover_restripe(fs_info->tree_root);
+
 		if (err) {
 			close_ctree(tree_root);
 			return ERR_PTR(err);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9dfc686..f371edd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2899,7 +2899,7 @@ static long btrfs_ioctl_restripe(struct btrfs_root *root, void __user *arg)
 	memcpy(&rctl->meta, &rargs->meta, sizeof(rctl->meta));
 	memcpy(&rctl->sys, &rargs->sys, sizeof(rctl->sys));
 
-	ret = btrfs_restripe(rctl);
+	ret = btrfs_restripe(rctl, 0);
 
 	/* rctl freed in unset_restripe_control */
 	kfree(rargs);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1057ad3..4490124 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -23,6 +23,7 @@
 #include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
+#include <linux/kthread.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -2242,16 +2243,58 @@ out:
 }
 
 /*
+ * This is a heuristic used to reduce the number of chunks restriped on
+ * resume after balance was interrupted.
+ */
+static void update_restripe_args(struct restripe_control *rctl)
+{
+	/*
+	 * Turn on soft mode for chunk types that were being converted.
+	 */
+	if (rctl->data.flags & BTRFS_RESTRIPE_ARGS_CONVERT)
+		rctl->data.flags |= BTRFS_RESTRIPE_ARGS_SOFT;
+	if (rctl->sys.flags & BTRFS_RESTRIPE_ARGS_CONVERT)
+		rctl->sys.flags |= BTRFS_RESTRIPE_ARGS_SOFT;
+	if (rctl->meta.flags & BTRFS_RESTRIPE_ARGS_CONVERT)
+		rctl->meta.flags |= BTRFS_RESTRIPE_ARGS_SOFT;
+
+	/*
+	 * Turn on usage filter if is not already used.  The idea is
+	 * that chunks that we have already balanced should be
+	 * reasonably full.  Don't do it for chunks that are being
+	 * converted - that will keep us from relocating unconverted
+	 * (albeit full) chunks.
+	 */
+	if (!(rctl->data.flags & BTRFS_RESTRIPE_ARGS_USAGE) &&
+	    !(rctl->data.flags & BTRFS_RESTRIPE_ARGS_CONVERT)) {
+		rctl->data.flags |= BTRFS_RESTRIPE_ARGS_USAGE;
+		rctl->data.usage = 90;
+	}
+	if (!(rctl->sys.flags & BTRFS_RESTRIPE_ARGS_USAGE) &&
+	    !(rctl->sys.flags & BTRFS_RESTRIPE_ARGS_CONVERT)) {
+		rctl->sys.flags |= BTRFS_RESTRIPE_ARGS_USAGE;
+		rctl->sys.usage = 90;
+	}
+	if (!(rctl->meta.flags & BTRFS_RESTRIPE_ARGS_USAGE) &&
+	    !(rctl->meta.flags & BTRFS_RESTRIPE_ARGS_CONVERT)) {
+		rctl->meta.flags |= BTRFS_RESTRIPE_ARGS_USAGE;
+		rctl->meta.usage = 90;
+	}
+}
+
+/*
  * Should be called with both restripe and volume mutexes held to
  * serialize other volume operations (add_dev/rm_dev/resize) wrt
  * restriper.  Same goes for unset_restripe_control().
  */
-static void set_restripe_control(struct restripe_control *rctl)
+static void set_restripe_control(struct restripe_control *rctl, int update)
 {
 	struct btrfs_fs_info *fs_info = rctl->fs_info;
 
 	spin_lock(&fs_info->restripe_lock);
 	fs_info->restripe_ctl = rctl;
+	if (update)
+		update_restripe_args(rctl);
 	spin_unlock(&fs_info->restripe_lock);
 }
 
@@ -2572,7 +2615,7 @@ error:
 /*
  * Should be called with restripe_mutex held
  */
-int btrfs_restripe(struct restripe_control *rctl)
+int btrfs_restripe(struct restripe_control *rctl, int resume)
 {
 	struct btrfs_fs_info *fs_info = rctl->fs_info;
 	u64 allowed;
@@ -2667,9 +2710,9 @@ do_restripe:
 	ret = insert_restripe_item(fs_info->tree_root, rctl);
 	if (ret && ret != -EEXIST)
 		goto out;
-	BUG_ON(ret == -EEXIST);
+	BUG_ON(ret == -EEXIST && !resume);
 
-	set_restripe_control(rctl);
+	set_restripe_control(rctl, resume);
 	mutex_unlock(&fs_info->volume_mutex);
 
 	err = __btrfs_restripe(fs_info->dev_root);
@@ -2690,6 +2733,80 @@ out:
 	return ret;
 }
 
+static int restriper_kthread(void *data)
+{
+	struct restripe_control *rctl = (struct restripe_control *)data;
+	struct btrfs_fs_info *fs_info = rctl->fs_info;
+	int ret;
+
+	mutex_lock(&fs_info->restripe_mutex);
+
+	printk(KERN_INFO "btrfs: continuing restripe\n");
+	ret = btrfs_restripe(rctl, 1);
+
+	mutex_unlock(&fs_info->restripe_mutex);
+	return ret;
+}
+
+int btrfs_recover_restripe(struct btrfs_root *tree_root)
+{
+	struct task_struct *tsk;
+	struct restripe_control *rctl;
+	struct btrfs_restripe_item *item;
+	struct btrfs_disk_restripe_args disk_rargs;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	rctl = kzalloc(sizeof(*rctl), GFP_NOFS);
+	if (!rctl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = BTRFS_RESTRIPE_OBJECTID;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out_free;
+	if (ret > 0) { /* ret = -ENOENT; */
+		ret = 0;
+		goto out_free;
+	}
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_restripe_item);
+
+	rctl->fs_info = tree_root->fs_info;
+	rctl->flags = btrfs_restripe_flags(leaf, item);
+
+	btrfs_restripe_data(leaf, item, &disk_rargs);
+	btrfs_disk_restripe_args_to_cpu(&rctl->data, &disk_rargs);
+	btrfs_restripe_meta(leaf, item, &disk_rargs);
+	btrfs_disk_restripe_args_to_cpu(&rctl->meta, &disk_rargs);
+	btrfs_restripe_sys(leaf, item, &disk_rargs);
+	btrfs_disk_restripe_args_to_cpu(&rctl->sys, &disk_rargs);
+
+	tsk = kthread_run(restriper_kthread, rctl, "btrfs-restriper");
+	if (IS_ERR(tsk))
+		ret = PTR_ERR(tsk);
+	else
+		goto out;
+
+out_free:
+	kfree(rctl);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9726180..6fcb4a5 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -252,7 +252,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
-int btrfs_restripe(struct restripe_control *rctl);
+int btrfs_restripe(struct restripe_control *rctl, int resume);
+int btrfs_recover_restripe(struct btrfs_root *tree_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.5.4

