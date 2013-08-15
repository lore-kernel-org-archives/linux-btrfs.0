Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:28211 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab3HOPLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 11:11:30 -0400
Received: from pizpot.store ([192.168.43.236])
 by jored.store (RZmta 31.40 OK) with ESMTP id g00c0cp7FELBif
 for <linux-btrfs@vger.kernel.org>;
 Thu, 15 Aug 2013 17:11:24 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 7/8] Btrfs: check UUID tree during mount if required
Date: Thu, 15 Aug 2013 17:11:23 +0200
Message-Id: <ee14242070cb2d4a91d75d7115e7b938f21d2bdc.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the filesystem was mounted with an old kernel that was not
aware of the UUID tree, this is detected by looking at the
uuid_tree_generation field of the superblock (similar to how
the free space cache is doing it). If a mismatch is detected
at mount time, a thread is started that does two things:
1. Iterate through the UUID tree, check each entry, delete those
   entries that are not valid anymore (i.e., the subvol does not
   exist anymore or the value changed).
2. Iterate through the root tree, for each found subvolume, add
   the UUID tree entries for the subvolume (if they are not
   already there).

This mechanism is also used to handle and repair errors that
happened during the initial creation and filling of the tree.
The update of the uuid_tree_generation field (which indicates
that the state of the UUID tree is up to date) is blocked until
all create and repair operations are successfully completed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       |   4 ++
 fs/btrfs/disk-io.c     |  18 +++++++-
 fs/btrfs/transaction.c |   3 +-
 fs/btrfs/uuid-tree.c   | 123 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |  83 +++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |   1 +
 6 files changed, 230 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f71d254..edd74da 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1651,6 +1651,7 @@ struct btrfs_fs_info {
 	atomic_t mutually_exclusive_operation_running;
 
 	struct semaphore uuid_tree_rescan_sem;
+	unsigned int update_uuid_tree_gen:1;
 };
 
 /*
@@ -3507,6 +3508,9 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
 int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
 			struct btrfs_root *uuid_root, u8 *uuid, u8 type,
 			u64 subid);
+int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
+			    int (*check_func)(struct btrfs_fs_info *, u8 *, u8,
+					      u64));
 
 /* dir-item.c */
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9ff76e..fc3d95f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2119,7 +2119,8 @@ int open_ctree(struct super_block *sb,
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
-	bool create_uuid_tree = false;
+	bool create_uuid_tree;
+	bool check_uuid_tree;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
@@ -2722,9 +2723,13 @@ retry_root_backup:
 		if (ret != -ENOENT)
 			goto recovery_tree_root;
 		create_uuid_tree = true;
+		check_uuid_tree = false;
 	} else {
 		uuid_root->track_dirty = 1;
 		fs_info->uuid_root = uuid_root;
+		create_uuid_tree = false;
+		check_uuid_tree =
+		    generation != btrfs_super_uuid_tree_generation(disk_super);
 	}
 
 	fs_info->generation = generation;
@@ -2922,6 +2927,17 @@ retry_root_backup:
 			close_ctree(tree_root);
 			return ret;
 		}
+	} else if (check_uuid_tree) {
+		pr_info("btrfs: checking UUID tree\n");
+		ret = btrfs_check_uuid_tree(fs_info);
+		if (ret) {
+			pr_warn("btrfs: failed to check the UUID tree %d\n",
+				ret);
+			close_ctree(tree_root);
+			return ret;
+		}
+	} else {
+		fs_info->update_uuid_tree_gen = 1;
 	}
 
 	return 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 32eb543..649d3a5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1380,7 +1380,8 @@ static void update_super_roots(struct btrfs_root *root)
 	super->root_level = root_item->level;
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		super->cache_generation = root_item->generation;
-	super->uuid_tree_generation = root_item->generation;
+	if (root->fs_info->update_uuid_tree_gen)
+		super->uuid_tree_generation = root_item->generation;
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 04a04fa..dd0dea3 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -233,3 +233,126 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			       u64 subid)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	/* 1 - for the uuid item */
+	trans = btrfs_start_transaction(uuid_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = btrfs_uuid_tree_rem(trans, uuid_root, uuid, type, subid);
+	btrfs_end_transaction(trans, uuid_root);
+
+out:
+	return ret;
+}
+
+int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
+			    int (*check_func)(struct btrfs_fs_info *, u8 *, u8,
+					      u64))
+{
+	struct btrfs_root *root = fs_info->uuid_root;
+	struct btrfs_key key;
+	struct btrfs_key max_key;
+	struct btrfs_path *path;
+	int ret = 0;
+	struct extent_buffer *leaf;
+	int slot;
+	u32 item_size;
+	unsigned long offset;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = 0;
+	key.type = 0;
+	key.offset = 0;
+	max_key.objectid = (u64)-1;
+	max_key.type = (u8)-1;
+	max_key.offset = (u64)-1;
+
+again_search_slot:
+	path->keep_locks = 1;
+	ret = btrfs_search_forward(root, &key, &max_key, path, 0);
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+
+	while (1) {
+		cond_resched();
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.type != BTRFS_UUID_KEY_SUBVOL &&
+		    key.type != BTRFS_UUID_KEY_RECEIVED_SUBVOL)
+			goto skip;
+
+		offset = btrfs_item_ptr_offset(leaf, slot);
+		item_size = btrfs_item_size_nr(leaf, slot);
+		if (!IS_ALIGNED(item_size, sizeof(u64))) {
+			pr_warn("btrfs: uuid item with illegal size %lu!\n",
+				(unsigned long)item_size);
+			goto skip;
+		}
+		while (item_size) {
+			u8 uuid[BTRFS_UUID_SIZE];
+			__le64 subid_le;
+			u64 subid_cpu;
+
+			put_unaligned_le64(key.objectid, uuid);
+			put_unaligned_le64(key.offset, uuid + sizeof(u64));
+			read_extent_buffer(leaf, &subid_le, offset,
+					   sizeof(subid_le));
+			subid_cpu = le64_to_cpu(subid_le);
+			ret = check_func(fs_info, uuid, key.type, subid_cpu);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {
+				btrfs_release_path(path);
+				ret = btrfs_uuid_iter_rem(root, uuid, key.type,
+							  subid_cpu);
+				if (ret == 0) {
+					/*
+					 * this might look inefficient, but the
+					 * justification is that it is an
+					 * exception that check_func returns 1,
+					 * and that in the regular case only one
+					 * entry per UUID exists.
+					 */
+					goto again_search_slot;
+				}
+				if (ret < 0 && ret != -ENOENT)
+					goto out;
+			}
+			item_size -= sizeof(subid_le);
+			offset += sizeof(subid_le);
+		}
+
+skip:
+		ret = btrfs_next_item(root, path);
+		if (ret == 0)
+			continue;
+		else if (ret > 0)
+			ret = 0;
+		break;
+	}
+
+out:
+	btrfs_free_path(path);
+	if (ret)
+		pr_warn("btrfs: btrfs_uuid_tree_iterate failed %d\n", ret);
+	return 0;
+}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e0aeef..a4d196d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3562,10 +3562,76 @@ out:
 	btrfs_free_path(path);
 	if (ret)
 		pr_warn("btrfs: btrfs_uuid_scan_kthread failed %d\n", ret);
+	else
+		fs_info->update_uuid_tree_gen = 1;
 	up(&fs_info->uuid_tree_rescan_sem);
 	return 0;
 }
 
+/*
+ * Callback for btrfs_uuid_tree_iterate().
+ * returns:
+ * 0	check succeeded, the entry is not outdated.
+ * < 0	if an error occured.
+ * > 0	if the check failed, which means the caller shall remove the entry.
+ */
+static int btrfs_check_uuid_tree_entry(struct btrfs_fs_info *fs_info,
+				       u8 *uuid, u8 type, u64 subid)
+{
+	struct btrfs_key key;
+	int ret = 0;
+	struct btrfs_root *subvol_root;
+
+	if (type != BTRFS_UUID_KEY_SUBVOL &&
+	    type != BTRFS_UUID_KEY_RECEIVED_SUBVOL)
+		goto out;
+
+	key.objectid = subid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	subvol_root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(subvol_root)) {
+		ret = PTR_ERR(subvol_root);
+		if (ret == -ENOENT)
+			ret = 1;
+		goto out;
+	}
+
+	switch (type) {
+	case BTRFS_UUID_KEY_SUBVOL:
+		if (memcmp(uuid, subvol_root->root_item.uuid, BTRFS_UUID_SIZE))
+			ret = 1;
+		break;
+	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+		if (memcmp(uuid, subvol_root->root_item.received_uuid,
+			   BTRFS_UUID_SIZE))
+			ret = 1;
+		break;
+	}
+
+out:
+	return ret;
+}
+
+static int btrfs_uuid_rescan_kthread(void *data)
+{
+	struct btrfs_fs_info *fs_info = (struct btrfs_fs_info *)data;
+	int ret;
+
+	/*
+	 * 1st step is to iterate through the existing UUID tree and
+	 * to delete all entries that contain outdated data.
+	 * 2nd step is to add all missing entries to the UUID tree.
+	 */
+	ret = btrfs_uuid_tree_iterate(fs_info, btrfs_check_uuid_tree_entry);
+	if (ret < 0) {
+		pr_warn("btrfs: iterating uuid_tree failed %d\n", ret);
+		up(&fs_info->uuid_tree_rescan_sem);
+		return ret;
+	}
+	return btrfs_uuid_scan_kthread(data);
+}
+
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_trans_handle *trans;
@@ -3599,6 +3665,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	down(&fs_info->uuid_tree_rescan_sem);
 	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
+		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
 		pr_warn("btrfs: failed to start uuid_scan task\n");
 		up(&fs_info->uuid_tree_rescan_sem);
 		return PTR_ERR(task);
@@ -3607,6 +3674,22 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
+{
+	struct task_struct *task;
+
+	down(&fs_info->uuid_tree_rescan_sem);
+	task = kthread_run(btrfs_uuid_rescan_kthread, fs_info, "btrfs-uuid");
+	if (IS_ERR(task)) {
+		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
+		pr_warn("btrfs: failed to start uuid_rescan task\n");
+		up(&fs_info->uuid_tree_rescan_sem);
+		return PTR_ERR(task);
+	}
+
+	return 0;
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7071b298..d98b942 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -323,6 +323,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
+int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.8.3.4

