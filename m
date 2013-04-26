Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37318 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] Btrfs-progs: remove cut & paste btrfs_next_leaf from restore
Date: Fri, 26 Apr 2013 16:06:03 -0500
Message-Id: <1367010370-21571-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmds-restore.c cut & paste btrfs_next_leaf w/ a little
extra; we can just call btrfs_next_leaf from there, after
the bit of additional pre-checking that it does.

Strangely, every caller in restore checks for a negative
return as an error, but the copy never returned negative.
Calling btrfs_next_leaf does return -EIO in cases where
read_node_slot fails.

Also, remove the slot assignment which was overwritten
in every case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-restore.c |   41 ++---------------------------------------
 ctree.c        |    5 +++--
 ctree.h        |    4 ----
 3 files changed, 5 insertions(+), 45 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index fc31f0c..e2c1640 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -147,12 +147,9 @@ static int decompress(char *inbuf, char *outbuf, u64 compress_len,
 	return -1;
 }
 
-int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
+static int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
-	int slot;
 	int level = 1;
-	struct extent_buffer *c;
-	struct extent_buffer *next = NULL;
 
 	for (; level < BTRFS_MAX_LEVEL; level++) {
 		if (path->nodes[level])
@@ -162,41 +159,7 @@ int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	if (level == BTRFS_MAX_LEVEL)
 		return 1;
 
-	slot = path->slots[level] + 1;
-
-	while(level < BTRFS_MAX_LEVEL) {
-		if (!path->nodes[level])
-			return 1;
-
-		slot = path->slots[level] + 1;
-		c = path->nodes[level];
-		if (slot >= btrfs_header_nritems(c)) {
-			level++;
-			if (level == BTRFS_MAX_LEVEL)
-				return 1;
-			continue;
-		}
-
-		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
-
-		next = read_node_slot(root, c, slot);
-		break;
-	}
-	path->slots[level] = slot;
-	while(1) {
-		level--;
-		c = path->nodes[level];
-		free_extent_buffer(c);
-		path->nodes[level] = next;
-		path->slots[level] = 0;
-		if (!level)
-			break;
-		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
-		next = read_node_slot(root, next, 0);
-	}
-	return 0;
+	return btrfs_next_leaf(root, path);
 }
 
 static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
diff --git a/ctree.c b/ctree.c
index 16f4daa..0311e25 100644
--- a/ctree.c
+++ b/ctree.c
@@ -777,7 +777,7 @@ static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 	return -1;
 }
 
-struct extent_buffer *read_node_slot(struct btrfs_root *root,
+static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
 				   struct extent_buffer *parent, int slot)
 {
 	int level = btrfs_header_level(parent);
@@ -1104,7 +1104,8 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 /*
  * readahead one full node of leaves
  */
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
+static void reada_for_search(struct btrfs_root *root,
+			     struct btrfs_path *path,
 			     int level, int slot, u64 objectid)
 {
 	struct extent_buffer *node;
diff --git a/ctree.h b/ctree.h
index 0ebb72a..0506aa1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2177,10 +2177,6 @@ int btrfs_check_leaf(struct btrfs_root *root,
 		      struct extent_buffer *buf);
 int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
-			     int level, int slot, u64 objectid);
-struct extent_buffer *read_node_slot(struct btrfs_root *root,
-				   struct extent_buffer *parent, int slot);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-- 
1.7.1

