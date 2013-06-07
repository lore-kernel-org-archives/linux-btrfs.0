Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:8630 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab3FGK14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Jun 2013 06:27:56 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.27 OK)
	with ESMTP id p04004p56BjnhG for <linux-btrfs@vger.kernel.org>;
	Fri, 7 Jun 2013 12:27:54 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 5/8] Btrfs: fill UUID tree initially
Date: Fri,  7 Jun 2013 12:27:50 +0200
Message-Id: <9c19309fec3f04b1f0c0dc0d8081568759ea3582.1370534938.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1370534937.git.sbehrens@giantdisaster.de>
References: <cover.1370534937.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1370534937.git.sbehrens@giantdisaster.de>
References: <cover.1370534937.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the UUID tree is initially created, a task is spawned that
walks through the root tree. For each found subvolume root_item,
the uuid and received_uuid entries in the UUID tree are added.
This is such a quick operation so that in case somebody wants
to unmount the filesystem while the task is still running, the
unmount is delayed until the UUID tree building task is finished.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   |   3 ++
 fs/btrfs/disk-io.c |   5 ++
 fs/btrfs/volumes.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a635dbf..9393228 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -23,6 +23,7 @@
 #include <linux/highmem.h>
 #include <linux/fs.h>
 #include <linux/rwsem.h>
+#include <linux/semaphore.h>
 #include <linux/completion.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
@@ -1645,6 +1646,8 @@ struct btrfs_fs_info {
 	struct btrfs_dev_replace dev_replace;
 
 	atomic_t mutually_exclusive_operation_running;
+
+	struct semaphore uuid_scan_sem;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 00bac63..89f99aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -31,6 +31,7 @@
 #include <linux/migrate.h>
 #include <linux/ratelimit.h>
 #include <linux/uuid.h>
+#include <linux/semaphore.h>
 #include <asm/unaligned.h>
 #include "compat.h"
 #include "ctree.h"
@@ -2288,6 +2289,7 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
+	sema_init(&fs_info->uuid_scan_sem, 1);
 	fs_info->dev_replace.lock_owner = 0;
 	atomic_set(&fs_info->dev_replace.nesting_level, 0);
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
@@ -3543,6 +3545,9 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
+	/* wait for the uuid_scan task to finish */
+	down(&fs_info->uuid_scan_sem);
+
 	/* pause restriper - we want to resume on mount */
 	btrfs_pause_balance(fs_info);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d4c7955..9ccdf36 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -26,6 +26,7 @@
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
+#include <linux/semaphore.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -3411,11 +3412,145 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+static int btrfs_uuid_scan_kthread(void *data)
+{
+	struct btrfs_fs_info *fs_info = data;
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_key key;
+	struct btrfs_key max_key;
+	struct btrfs_path *path = NULL;
+	int ret = 0;
+	struct extent_buffer *eb;
+	int slot;
+	struct btrfs_root_item root_item;
+	u32 item_size;
+	struct btrfs_trans_handle *trans;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	max_key.objectid = (u64)-1;
+	max_key.type = BTRFS_ROOT_ITEM_KEY;
+	max_key.offset = (u64)-1;
+
+	path->keep_locks = 1;
+
+	while (1) {
+		ret = btrfs_search_forward(root, &key, &max_key, path, 0);
+		if (ret) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
+
+		if (key.type != BTRFS_ROOT_ITEM_KEY ||
+		    (key.objectid < BTRFS_FIRST_FREE_OBJECTID &&
+		     key.objectid != BTRFS_FS_TREE_OBJECTID) ||
+		    key.objectid > BTRFS_LAST_FREE_OBJECTID)
+			goto skip;
+
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		item_size = btrfs_item_size_nr(eb, slot);
+		if (item_size < sizeof(root_item))
+			goto skip;
+
+		trans = NULL;
+		read_extent_buffer(eb, &root_item,
+				   btrfs_item_ptr_offset(eb, slot),
+				   (int)sizeof(root_item));
+		if (btrfs_root_refs(&root_item) == 0)
+			goto skip;
+		if (!btrfs_is_empty_uuid(root_item.uuid)) {
+			/*
+			 * 1 - subvol uuid item
+			 * 1 - received_subvol uuid item
+			 */
+			trans = btrfs_start_transaction(fs_info->uuid_root, 2);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				break;
+			}
+			ret = btrfs_insert_uuid_subvol_item(trans,
+							    fs_info->uuid_root,
+							    root_item.uuid,
+							    key.objectid);
+			if (ret < 0) {
+				pr_warn("btrfs: insert_uuid_received_subvol_item failed %d\n",
+					ret);
+				btrfs_end_transaction(trans,
+						      fs_info->uuid_root);
+				break;
+			}
+		}
+
+		if (!btrfs_is_empty_uuid(root_item.received_uuid)) {
+			if (!trans) {
+				/* 1 - received_subvol uuid item */
+				trans = btrfs_start_transaction(
+						fs_info->uuid_root, 1);
+				if (IS_ERR(trans)) {
+					ret = PTR_ERR(trans);
+					break;
+				}
+			}
+			ret = btrfs_insert_uuid_received_subvol_item(
+				trans, fs_info->uuid_root,
+				root_item.received_uuid, key.objectid);
+			if (ret < 0) {
+				pr_warn("btrfs: insert_uuid_received_subvol_item failed %d\n",
+					ret);
+				btrfs_end_transaction(trans,
+						      fs_info->uuid_root);
+				break;
+			}
+		}
+
+		if (trans) {
+			ret = btrfs_end_transaction(trans, fs_info->uuid_root);
+			if (ret)
+				break;
+		}
+
+skip:
+		btrfs_release_path(path);
+		if (key.offset < (u64)-1) {
+			key.offset++;
+		} else if (key.type < BTRFS_ROOT_ITEM_KEY) {
+			key.offset = 0;
+			key.type = BTRFS_ROOT_ITEM_KEY;
+		} else if (key.objectid < (u64)-1) {
+			key.offset = 0;
+			key.type = BTRFS_ROOT_ITEM_KEY;
+			key.objectid++;
+		} else {
+			break;
+		}
+		cond_resched();
+	}
+
+out:
+	btrfs_free_path(path);
+	if (ret)
+		pr_warn("btrfs: btrfs_uuid_scan_kthread failed %d\n", ret);
+	up(&fs_info->uuid_scan_sem);
+	return 0;
+}
+
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *uuid_root;
+	struct task_struct *task;
+	int ret;
 
 	/*
 	 * 1 - root node
@@ -3435,8 +3570,21 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 
 	fs_info->uuid_root = uuid_root;
 
-	return btrfs_commit_transaction(trans, tree_root);
+	ret = btrfs_commit_transaction(trans, tree_root);
+	if (ret)
+		return ret;
+
+	down(&fs_info->uuid_scan_sem);
+	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
+	if (IS_ERR(task)) {
+		pr_warn("btrfs: failed to start uuid_scan task\n");
+		up(&fs_info->uuid_scan_sem);
+		return PTR_ERR(task);
+	}
+
+	return 0;
 }
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
-- 
1.8.3

