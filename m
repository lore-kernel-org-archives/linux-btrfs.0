Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:28856 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071Ab3FTRpm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 13:45:42 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 31.28 OK)
	with ESMTP id X0314dp5KHFkb4 for <linux-btrfs@vger.kernel.org>;
	Thu, 20 Jun 2013 19:45:40 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 5/8] Btrfs: fill UUID tree initially
Date: Thu, 20 Jun 2013 19:45:36 +0200
Message-Id: <cd973d895a734ba7e09bfdc44c0215eb05951335.1371749051.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1371749051.git.sbehrens@giantdisaster.de>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1371749051.git.sbehrens@giantdisaster.de>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
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
 fs/btrfs/ctree.h   |   2 +
 fs/btrfs/disk-io.c |   6 +++
 fs/btrfs/volumes.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f2751e7..89b2d78 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1645,6 +1645,8 @@ struct btrfs_fs_info {
 	struct btrfs_dev_replace dev_replace;
 
 	atomic_t mutually_exclusive_operation_running;
+
+	struct completion uuid_tree_rescan_completion;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1db446a..a52504b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2288,6 +2288,7 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
+	init_completion(&fs_info->uuid_tree_rescan_completion);
 	fs_info->dev_replace.lock_owner = 0;
 	atomic_set(&fs_info->dev_replace.nesting_level, 0);
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
@@ -2913,6 +2914,8 @@ retry_root_backup:
 			close_ctree(tree_root);
 			return ret;
 		}
+	} else {
+		complete_all(&fs_info->uuid_tree_rescan_completion);
 	}
 
 	return 0;
@@ -3543,6 +3546,9 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
+	/* wait for the uuid_scan task to finish */
+	wait_for_completion(&fs_info->uuid_tree_rescan_completion);
+
 	/* pause restriper - we want to resume on mount */
 	btrfs_pause_balance(fs_info);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d4c7955..e2e2bbc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3411,11 +3411,145 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
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
+	complete_all(&fs_info->uuid_tree_rescan_completion);
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
@@ -3435,8 +3569,20 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 
 	fs_info->uuid_root = uuid_root;
 
-	return btrfs_commit_transaction(trans, tree_root);
+	ret = btrfs_commit_transaction(trans, tree_root);
+	if (ret)
+		return ret;
+
+	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
+	if (IS_ERR(task)) {
+		pr_warn("btrfs: failed to start uuid_scan task\n");
+		complete_all(&fs_info->uuid_tree_rescan_completion);
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

