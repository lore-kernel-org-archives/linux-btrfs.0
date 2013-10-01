Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:50024 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3JAPPa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 11:15:30 -0400
Received: by mail-we0-f172.google.com with SMTP id w61so7594323wes.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 08:15:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove unused max_key arg from btrfs_search_forward
Date: Tue,  1 Oct 2013 16:13:42 +0100
Message-Id: <1380640422-14754-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is not used for anything.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c       |    1 -
 fs/btrfs/ctree.h       |    1 -
 fs/btrfs/ioctl.c       |   16 ++--------------
 fs/btrfs/tree-defrag.c |    2 +-
 fs/btrfs/tree-log.c    |    9 ++-------
 fs/btrfs/uuid-tree.c   |    6 +-----
 fs/btrfs/volumes.c     |    2 +-
 7 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6932686..102a847 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4870,7 +4870,6 @@ static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
  * was nothing in the tree that matched the search criteria.
  */
 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
-			 struct btrfs_key *max_key,
 			 struct btrfs_path *path,
 			 u64 min_trans)
 {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ee0b8aa..d2c70bf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3309,7 +3309,6 @@ int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 			struct btrfs_key *key, int lowest_level,
 			u64 min_trans);
 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
-			 struct btrfs_key *max_key,
 			 struct btrfs_path *path,
 			 u64 min_trans);
 enum btrfs_compare_tree_result {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 385c58f..bd14500 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -842,7 +842,6 @@ static int find_new_extents(struct btrfs_root *root,
 {
 	struct btrfs_path *path;
 	struct btrfs_key min_key;
-	struct btrfs_key max_key;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *extent;
 	int type;
@@ -857,15 +856,10 @@ static int find_new_extents(struct btrfs_root *root,
 	min_key.type = BTRFS_EXTENT_DATA_KEY;
 	min_key.offset = *off;
 
-	max_key.objectid = ino;
-	max_key.type = (u8)-1;
-	max_key.offset = (u64)-1;
-
 	path->keep_locks = 1;
 
 	while(1) {
-		ret = btrfs_search_forward(root, &min_key, &max_key,
-					   path, newer_than);
+		ret = btrfs_search_forward(root, &min_key, path, newer_than);
 		if (ret != 0)
 			goto none;
 		if (min_key.objectid != ino)
@@ -1893,7 +1887,6 @@ static noinline int search_ioctl(struct inode *inode,
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	struct btrfs_key max_key;
 	struct btrfs_path *path;
 	struct btrfs_ioctl_search_key *sk = &args->key;
 	struct btrfs_fs_info *info = BTRFS_I(inode)->root->fs_info;
@@ -1925,15 +1918,10 @@ static noinline int search_ioctl(struct inode *inode,
 	key.type = sk->min_type;
 	key.offset = sk->min_offset;
 
-	max_key.objectid = sk->max_objectid;
-	max_key.type = sk->max_type;
-	max_key.offset = sk->max_offset;
-
 	path->keep_locks = 1;
 
 	while(1) {
-		ret = btrfs_search_forward(root, &key, &max_key, path,
-					   sk->min_transid);
+		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
 		if (ret != 0) {
 			if (ret > 0)
 				ret = 0;
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 94e05c1..cbaa73c 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -85,7 +85,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 
 	path->keep_locks = 1;
 
-	ret = btrfs_search_forward(root, &key, NULL, path, min_trans);
+	ret = btrfs_search_forward(root, &key, path, min_trans);
 	if (ret < 0)
 		goto out;
 	if (ret > 0) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cbc8156..e15c60c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2867,7 +2867,6 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 			  u64 min_offset, u64 *last_offset_ret)
 {
 	struct btrfs_key min_key;
-	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
 	struct extent_buffer *src;
 	int err = 0;
@@ -2879,9 +2878,6 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
-	max_key.objectid = ino;
-	max_key.offset = (u64)-1;
-	max_key.type = key_type;
 
 	min_key.objectid = ino;
 	min_key.type = key_type;
@@ -2889,8 +2885,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 
 	path->keep_locks = 1;
 
-	ret = btrfs_search_forward(root, &min_key, &max_key,
-				   path, trans->transid);
+	ret = btrfs_search_forward(root, &min_key, path, trans->transid);
 
 	/*
 	 * we didn't find anything from this transaction, see if there
@@ -3719,7 +3714,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ins_nr = 0;
-		ret = btrfs_search_forward(root, &min_key, &max_key,
+		ret = btrfs_search_forward(root, &min_key,
 					   path, trans->transid);
 		if (ret != 0)
 			break;
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index dd0dea3..fbda900 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -260,7 +260,6 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_root *root = fs_info->uuid_root;
 	struct btrfs_key key;
-	struct btrfs_key max_key;
 	struct btrfs_path *path;
 	int ret = 0;
 	struct extent_buffer *leaf;
@@ -277,13 +276,10 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 	key.objectid = 0;
 	key.type = 0;
 	key.offset = 0;
-	max_key.objectid = (u64)-1;
-	max_key.type = (u8)-1;
-	max_key.offset = (u64)-1;
 
 again_search_slot:
 	path->keep_locks = 1;
-	ret = btrfs_search_forward(root, &key, &max_key, path, 0);
+	ret = btrfs_search_forward(root, &key, path, 0);
 	if (ret) {
 		if (ret > 0)
 			ret = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0431147..32d0390 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3483,7 +3483,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 	path->keep_locks = 1;
 
 	while (1) {
-		ret = btrfs_search_forward(root, &key, &max_key, path, 0);
+		ret = btrfs_search_forward(root, &key, path, 0);
 		if (ret) {
 			if (ret > 0)
 				ret = 0;
-- 
1.7.9.5

