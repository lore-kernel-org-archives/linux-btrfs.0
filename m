From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 16/21] Btrfs: recover balance on mount
Date: Fri,  6 Jan 2012 16:31:04 +0200
Message-ID: <1325860269-15013-17-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On mount, if balance item is found, resume balance in a separate
kernel thread.

Try to be smart to continue roughly where previous balance (or convert)
was interrupted.  For chunk types that were being converted to some
profile we turn on soft convert, in case of a simple balance we turn on
usage filter and relocate only less-than-90%-full chunks of that type.
These are just heuristics but they help quite a bit, and can be improved
in future.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    4 ++
 fs/btrfs/volumes.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h |    1 +
 3 files changed, 131 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 190a1b2..eb7a11a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2427,6 +2427,10 @@ retry_root_backup:
 		if (!err)
 			err = btrfs_orphan_cleanup(fs_info->tree_root);
 		up_read(&fs_info->cleanup_work_sem);
+
+		if (!err)
+			err = btrfs_recover_balance(fs_info->tree_root);
+
 		if (err) {
 			close_ctree(tree_root);
 			return ERR_PTR(err);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1f9fdb7..c03df10 100644
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
@@ -2165,6 +2166,46 @@ out:
 }
 
 /*
+ * This is a heuristic used to reduce the number of chunks balanced on
+ * resume after balance was interrupted.
+ */
+static void update_balance_args(struct btrfs_balance_control *bctl)
+{
+	/*
+	 * Turn on soft mode for chunk types that were being converted.
+	 */
+	if (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT)
+		bctl->data.flags |= BTRFS_BALANCE_ARGS_SOFT;
+	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT)
+		bctl->sys.flags |= BTRFS_BALANCE_ARGS_SOFT;
+	if (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT)
+		bctl->meta.flags |= BTRFS_BALANCE_ARGS_SOFT;
+
+	/*
+	 * Turn on usage filter if is not already used.  The idea is
+	 * that chunks that we have already balanced should be
+	 * reasonably full.  Don't do it for chunks that are being
+	 * converted - that will keep us from relocating unconverted
+	 * (albeit full) chunks.
+	 */
+	if (!(bctl->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
+	    !(bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT)) {
+		bctl->data.flags |= BTRFS_BALANCE_ARGS_USAGE;
+		bctl->data.usage = 90;
+	}
+	if (!(bctl->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
+	    !(bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT)) {
+		bctl->sys.flags |= BTRFS_BALANCE_ARGS_USAGE;
+		bctl->sys.usage = 90;
+	}
+	if (!(bctl->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
+	    !(bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT)) {
+		bctl->meta.flags |= BTRFS_BALANCE_ARGS_USAGE;
+		bctl->meta.usage = 90;
+	}
+}
+
+/*
  * Should be called with both balance and volume mutexes held to
  * serialize other volume operations (add_dev/rm_dev/resize) with
  * restriper.  Same goes for unset_balance_control.
@@ -2621,8 +2662,13 @@ do_balance:
 		goto out;
 	BUG_ON((ret == -EEXIST && !resume) || (ret != -EEXIST && resume));
 
-	if (!resume)
+	if (!resume) {
 		set_balance_control(bctl);
+	} else {
+		spin_lock(&fs_info->balance_lock);
+		update_balance_args(bctl);
+		spin_unlock(&fs_info->balance_lock);
+	}
 
 	mutex_unlock(&fs_info->balance_mutex);
 
@@ -2641,6 +2687,85 @@ out:
 	return ret;
 }
 
+static int restriper_kthread(void *data)
+{
+	struct btrfs_balance_control *bctl =
+			(struct btrfs_balance_control *)data;
+	struct btrfs_fs_info *fs_info = bctl->fs_info;
+	int ret;
+
+	mutex_lock(&fs_info->volume_mutex);
+	mutex_lock(&fs_info->balance_mutex);
+
+	set_balance_control(bctl);
+
+	printk(KERN_INFO "btrfs: continuing balance\n");
+	ret = btrfs_balance(bctl, 1);
+
+	mutex_unlock(&fs_info->balance_mutex);
+	mutex_unlock(&fs_info->volume_mutex);
+	return ret;
+}
+
+int btrfs_recover_balance(struct btrfs_root *tree_root)
+{
+	struct task_struct *tsk;
+	struct btrfs_balance_control *bctl;
+	struct btrfs_balance_item *item;
+	struct btrfs_disk_balance_args disk_bargs;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
+	if (!bctl) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = BTRFS_BALANCE_OBJECTID;
+	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out_bctl;
+	if (ret > 0) { /* ret = -ENOENT; */
+		ret = 0;
+		goto out_bctl;
+	}
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
+
+	bctl->fs_info = tree_root->fs_info;
+	bctl->flags = btrfs_balance_flags(leaf, item);
+
+	btrfs_balance_data(leaf, item, &disk_bargs);
+	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
+	btrfs_balance_meta(leaf, item, &disk_bargs);
+	btrfs_disk_balance_args_to_cpu(&bctl->meta, &disk_bargs);
+	btrfs_balance_sys(leaf, item, &disk_bargs);
+	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
+
+	tsk = kthread_run(restriper_kthread, bctl, "btrfs-restriper");
+	if (IS_ERR(tsk))
+		ret = PTR_ERR(tsk);
+	else
+		goto out;
+
+out_bctl:
+	kfree(bctl);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9879a31..bcaddd4 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -270,6 +270,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_balance_control *rctl, int resume);
+int btrfs_recover_balance(struct btrfs_root *tree_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.6.3

