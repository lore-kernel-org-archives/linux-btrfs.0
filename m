Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:44052 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab2FNRQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:40 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: add btrfs_next_old_leaf
Date: Thu, 14 Jun 2012 19:16:37 +0200
Message-Id: <1339694198-13388-6-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To make sense of the tree mod log, the backref walker not only needs
btrfs_search_old_slot, but it also called btrfs_next_leaf, which in turn was
calling btrfs_search_slot. This obviously didn't give the correct result.

This commit adds btrfs_next_old_leaf, a drop-in replacement for
btrfs_next_leaf with a time_seq parameter. If it is zero, it behaves exactly
like btrfs_next_leaf. If it is non-zero, it will use btrfs_search_old_slot
with this time_seq parameter.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    7 ++++---
 fs/btrfs/ctree.c   |   11 ++++++++++-
 fs/btrfs/ctree.h   |    2 ++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 579131d..8f7d123 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -179,7 +179,8 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 				struct ulist *parents, int level,
-				struct btrfs_key *key, u64 wanted_disk_byte,
+				struct btrfs_key *key, u64 time_seq,
+				u64 wanted_disk_byte,
 				const u64 *extent_item_pos)
 {
 	int ret;
@@ -212,7 +213,7 @@ add_parent:
 	 */
 	while (1) {
 		eie = NULL;
-		ret = btrfs_next_leaf(root, path);
+		ret = btrfs_next_old_leaf(root, path, time_seq);
 		if (ret < 0)
 			return ret;
 		if (ret)
@@ -297,7 +298,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	if (level == 0)
 		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
 
-	ret = add_all_parents(root, path, parents, level, &key,
+	ret = add_all_parents(root, path, parents, level, &key, time_seq,
 				ref->wanted_disk_byte, extent_item_pos);
 out:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 50d7c99..cb76b2a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5017,6 +5017,12 @@ next:
  */
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
+	return btrfs_next_old_leaf(root, path, 0);
+}
+
+int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
+			u64 time_seq)
+{
 	int slot;
 	int level;
 	struct extent_buffer *c;
@@ -5041,7 +5047,10 @@ again:
 	path->keep_locks = 1;
 	path->leave_spinning = 1;
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (time_seq)
+		ret = btrfs_search_old_slot(root, &key, path, time_seq);
+	else
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	path->keep_locks = 0;
 
 	if (ret < 0)
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0151ca1..db15e9e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2753,6 +2753,8 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
+int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
+			u64 time_seq);
 static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
 {
 	++p->slots[0];
-- 
1.7.3.4

