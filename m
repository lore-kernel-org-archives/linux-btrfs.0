Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37242 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaHDRho (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 4 Aug 2014 13:37:44 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: make btrfs_search_forward return with nodes unlocked
Date: Mon,  4 Aug 2014 19:37:21 +0100
Message-Id: <1407177441-11152-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

None of the uses of btrfs_search_forward() need to have the path
nodes (level >= 1) read locked, only the leaf needs to be locked
while the caller processes it. Therefore make it return a path
with all nodes unlocked, except for the leaf.

This change is motivated by the observation that during a file
fsync we repeatdly call btrfs_search_forward() and process the
returned leaf while upper nodes of the returned path (level >= 1)
are read locked, which unnecessarily blocks other tasks that want
to write to the same fs/subvol btree.
Therefore instead of modifying the fsync code to unlock all nodes
with level >= 1 immediately after calling btrfs_search_forward(),
change btrfs_search_forward() to do it, so that it benefits all
callers.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c     | 11 +++++++----
 fs/btrfs/ioctl.c     |  5 -----
 fs/btrfs/tree-log.c  |  3 ---
 fs/btrfs/uuid-tree.c |  1 -
 fs/btrfs/volumes.c   |  2 --
 5 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8ca6761..993d81b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5144,8 +5144,9 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 	u32 nritems;
 	int level;
 	int ret = 1;
+	int keep_locks = path->keep_locks;
 
-	WARN_ON(!path->keep_locks);
+	path->keep_locks = 1;
 again:
 	cur = btrfs_read_lock_root_node(root);
 	level = btrfs_header_level(cur);
@@ -5209,7 +5210,6 @@ find_next_key:
 		path->slots[level] = slot;
 		if (level == path->lowest_level) {
 			ret = 0;
-			unlock_up(path, level, 1, 0, NULL);
 			goto out;
 		}
 		btrfs_set_path_blocking(path);
@@ -5224,9 +5224,12 @@ find_next_key:
 		btrfs_clear_path_blocking(path, NULL, 0);
 	}
 out:
-	if (ret == 0)
+	path->keep_locks = keep_locks;
+	if (ret == 0) {
+		btrfs_unlock_up_safe(path, path->lowest_level + 1);
+		btrfs_set_path_blocking(path);
 		memcpy(min_key, &found_key, sizeof(found_key));
-	btrfs_set_path_blocking(path);
+	}
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ef2e073..d490abd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -936,12 +936,9 @@ static int find_new_extents(struct btrfs_root *root,
 	min_key.offset = *off;
 
 	while (1) {
-		path->keep_locks = 1;
 		ret = btrfs_search_forward(root, &min_key, path, newer_than);
 		if (ret != 0)
 			goto none;
-		path->keep_locks = 0;
-		btrfs_unlock_up_safe(path, 1);
 process_slot:
 		if (min_key.objectid != ino)
 			goto none;
@@ -2083,8 +2080,6 @@ static noinline int search_ioctl(struct inode *inode,
 	key.type = sk->min_type;
 	key.offset = sk->min_offset;
 
-	path->keep_locks = 1;
-
 	while (1) {
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
 		if (ret != 0) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6e0fa17..df332dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2981,8 +2981,6 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	min_key.type = key_type;
 	min_key.offset = min_offset;
 
-	path->keep_locks = 1;
-
 	ret = btrfs_search_forward(root, &min_key, path, trans->transid);
 
 	/*
@@ -3950,7 +3948,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		err = ret;
 		goto out_unlock;
 	}
-	path->keep_locks = 1;
 
 	while (1) {
 		ins_nr = 0;
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index f6a4c03..7782829 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -279,7 +279,6 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 again_search_slot:
-	path->keep_locks = 1;
 	ret = btrfs_search_forward(root, &key, path, 0);
 	if (ret) {
 		if (ret > 0)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0daf748..73e4d30 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3629,8 +3629,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 	max_key.type = BTRFS_ROOT_ITEM_KEY;
 	max_key.offset = (u64)-1;
 
-	path->keep_locks = 1;
-
 	while (1) {
 		ret = btrfs_search_forward(root, &key, path, 0);
 		if (ret) {
-- 
1.9.1

