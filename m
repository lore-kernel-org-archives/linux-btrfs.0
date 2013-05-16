Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:14797 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3EPOpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:45:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.27 OK)
	with ESMTP id g06c9fp4G8b881 for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:45:07 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 7/8] Btrfs: check UUID tree during mount if required
Date: Thu, 16 May 2013 16:45:06 +0200
Message-Id: <0857df2f45d3911f01a7c5050c27bc18e4a30620.1368713300.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713300.git.sbehrens@giantdisaster.de>
References: <cover.1368713300.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713300.git.sbehrens@giantdisaster.de>
References: <cover.1368713300.git.sbehrens@giantdisaster.de>
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
 fs/btrfs/disk-io.c     |  18 +++++-
 fs/btrfs/transaction.c |   3 +-
 fs/btrfs/uuid-tree.c   | 156 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |  83 ++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |   1 +
 6 files changed, 263 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3662d7..7efe25c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1653,6 +1653,7 @@ struct btrfs_fs_info {
 	atomic_t mutually_exclusive_operation_running;
 
 	struct semaphore uuid_scan_sem;
+	unsigned int update_uuid_tree_gen:1;
 };
 
 /*
@@ -3412,6 +3413,9 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 
 /* uuid-tree.c */
+int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
+			    int (*check_func)(struct btrfs_fs_info *, u8 *, u16,
+					      u64));
 int btrfs_lookup_uuid_subvol_item(struct btrfs_root *uuid_root, u8 *uuid,
 				  u64 *subvol_id);
 int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e99514e..30513c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2047,7 +2047,8 @@ int open_ctree(struct super_block *sb,
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
-	bool create_uuid_tree = false;
+	bool create_uuid_tree;
+	bool check_uuid_tree;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
 	extent_root = fs_info->extent_root = btrfs_alloc_root(fs_info);
@@ -2629,8 +2630,12 @@ retry_root_backup:
 		kfree(uuid_root);
 		uuid_root = fs_info->uuid_root = NULL;
 		create_uuid_tree = true;
+		check_uuid_tree = false;
 	} else {
 		uuid_root->track_dirty = 1;
+		create_uuid_tree = false;
+		check_uuid_tree =
+		    generation != btrfs_super_uuid_tree_generation(disk_super);
 	}
 
 	fs_info->generation = generation;
@@ -2826,6 +2831,17 @@ retry_root_backup:
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
index eed52bb..0c3f0d3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1331,7 +1331,8 @@ static void update_super_roots(struct btrfs_root *root)
 	super->root_level = root_item->level;
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		super->cache_generation = root_item->generation;
-	super->uuid_tree_generation = root_item->generation;
+	if (root->fs_info->update_uuid_tree_gen)
+		super->uuid_tree_generation = root_item->generation;
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 3939a54..0bc6a8b 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -415,6 +415,162 @@ out:
 	return ret;
 }
 
+static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid,
+			       u16 sub_item_type, u64 subid)
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
+	ret = btrfs_uuid_tree_rem(trans, uuid_root, uuid,
+				  sub_item_type, subid);
+	if (ret && ret != -ENOENT)
+		btrfs_end_transaction(trans, uuid_root);
+	else
+		ret = btrfs_end_transaction(trans, uuid_root);
+
+out:
+	return ret;
+}
+
+int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
+			    int (*check_func)(struct btrfs_fs_info *, u8 *, u16,
+					      u64))
+{
+	struct btrfs_root *root = fs_info->uuid_root;
+	struct btrfs_key key;
+	struct btrfs_key max_key;
+	struct btrfs_path *path = NULL;
+	int ret = 0;
+	struct extent_buffer *eb;
+	int slot;
+	u32 item_size;
+	struct btrfs_uuid_item *ptr;
+	u64 subid;
+	unsigned long offset;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_UUID_KEY;
+	key.offset = 0;
+
+	max_key.objectid = (u64)-1;
+	max_key.type = BTRFS_UUID_KEY;
+	max_key.offset = (u64)-1;
+
+	path->keep_locks = 1;
+
+	while (1) {
+again:
+		cond_resched();
+		ret = btrfs_search_forward(root, &key, &max_key, path, 0);
+		if (ret) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
+
+		if (key.type != BTRFS_UUID_KEY)
+			goto skip;
+
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		ptr = btrfs_item_ptr(eb, slot, struct btrfs_uuid_item);
+		item_size = btrfs_item_size_nr(eb, slot);
+		do {
+			u16 sub_item_type;
+			u64 sub_item_len;
+
+			if (item_size < sizeof(*ptr)) {
+				pr_warn("btrfs: uuid item too short (%lu < %d)!\n",
+					(unsigned long)item_size,
+					(int)sizeof(*ptr));
+				goto skip; /* is this an old kernel? */
+			}
+			sub_item_type = btrfs_uuid_type(eb, ptr);
+			sub_item_len = btrfs_uuid_len(eb, ptr);
+			ptr++;
+			item_size -= sizeof(*ptr);
+			if (sub_item_len * sizeof(u64) > item_size) {
+				pr_warn("btrfs: uuid item too short (%llu > %lu)!\n",
+					(unsigned long long)(sub_item_len *
+							     sizeof(u64)),
+					(unsigned long)item_size);
+				goto skip;
+			}
+			offset = (unsigned long)ptr;
+			ptr = (struct btrfs_uuid_item *)
+				(((char *)ptr) + sub_item_len * sizeof(u64));
+			item_size -= sub_item_len * sizeof(u64);
+			while (sub_item_len) {
+				u8 uuid[BTRFS_UUID_SIZE];
+
+				put_unaligned_le64(key.objectid, uuid);
+				put_unaligned_le64(key.offset,
+						   uuid + sizeof(u64));
+				read_extent_buffer(eb, &subid, offset,
+						   sizeof(subid));
+				subid = le64_to_cpu(subid);
+				ret = check_func(fs_info, uuid,
+						 sub_item_type, subid);
+				if (ret < 0)
+					goto out;
+				if (ret > 0) {
+					btrfs_release_path(path);
+					ret = btrfs_uuid_iter_rem(
+						fs_info->uuid_root, uuid,
+						sub_item_type, subid);
+					if (ret < 0)
+						goto out;
+					/*
+					 * this might look inefficient, but
+					 * the justification is that it is an
+					 * exception that check_func returns 1,
+					 * and that in the regular case only
+					 * one or two entries per UUID exist.
+					 */
+					goto again;
+				}
+				sub_item_len--;
+				offset += sizeof(u64);
+			}
+		} while (item_size);
+
+skip:
+		btrfs_release_path(path);
+		if (key.offset < (u64)-1) {
+			key.offset++;
+		} else if (key.type < BTRFS_UUID_KEY) {
+			key.offset = 0;
+			key.type = BTRFS_UUID_KEY;
+		} else if (key.objectid < (u64)-1) {
+			key.offset = 0;
+			key.type = 0;
+			key.objectid++;
+		} else {
+			break;
+		}
+	}
+
+out:
+	btrfs_free_path(path);
+	if (ret)
+		pr_warn("btrfs: btrfs_uuid_tree_iterate failed %d\n", ret);
+	up(&fs_info->uuid_scan_sem);
+	return 0;
+}
+
 int btrfs_lookup_uuid_subvol_item(struct btrfs_root *uuid_root, u8 *uuid,
 				  u64 *subvol_id)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b7ac61b..3b54060 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3556,10 +3556,76 @@ out:
 	btrfs_free_path(path);
 	if (ret)
 		pr_warn("btrfs: btrfs_uuid_scan_kthread failed %d\n", ret);
+	else
+		fs_info->update_uuid_tree_gen = 1;
 	up(&fs_info->uuid_scan_sem);
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
+				       u8 *uuid, u16 type, u64 subid)
+{
+	struct btrfs_key key;
+	int ret = 0;
+	struct btrfs_root *subvol_root;
+
+	if (type != BTRFS_UUID_ITEM_TYPE_SUBVOL &&
+	    type != BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL)
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
+	case BTRFS_UUID_ITEM_TYPE_SUBVOL:
+		if (memcmp(uuid, subvol_root->root_item.uuid, BTRFS_UUID_SIZE))
+			ret = 1;
+		break;
+	case BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL:
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
+		up(&fs_info->uuid_scan_sem);
+		return ret;
+	}
+	return btrfs_uuid_scan_kthread(data);
+}
+
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_trans_handle *trans;
@@ -3593,6 +3659,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	down(&fs_info->uuid_scan_sem);
 	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
+		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
 		pr_warn("btrfs: failed to start uuid_scan task\n");
 		up(&fs_info->uuid_scan_sem);
 		return PTR_ERR(task);
@@ -3601,6 +3668,22 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
+{
+	struct task_struct *task;
+
+	down(&fs_info->uuid_scan_sem);
+	task = kthread_run(btrfs_uuid_rescan_kthread, fs_info, "btrfs-uuid");
+	if (IS_ERR(task)) {
+		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
+		pr_warn("btrfs: failed to start uuid_rescan task\n");
+		up(&fs_info->uuid_scan_sem);
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
index 3479532..b0ce9a1 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -296,6 +296,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
+int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-- 
1.8.2.3

