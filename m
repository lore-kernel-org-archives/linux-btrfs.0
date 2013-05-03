Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44458 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759572Ab3EBPv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 11:51:59 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so416274pbc.29
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 08:51:59 -0700 (PDT)
From: Lin Ming <mlin@kernel.org>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] btrfs-progs: pass up return value of walk_down_tree
Date: Thu,  2 May 2013 23:51:38 -0400
Message-Id: <1367553098-6315-1-git-send-email-mlin@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pass up return value of walk_down_tree, so the caller can handle it.
This also fixes a segfault when read_tree_block fails with NULL returned.

Signed-off-by: Lin Ming <mlin@kernel.org>
---
 cmds-check.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 12192fa..7a51627 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1201,7 +1201,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 	struct extent_buffer *next;
 	struct extent_buffer *cur;
 	u32 blocksize;
-	int ret;
+	int ret, err = 0;
 	u64 refs;
 
 	WARN_ON(*level < 0);
@@ -1209,14 +1209,18 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 	ret = btrfs_lookup_extent_info(NULL, root,
 				       path->nodes[*level]->start,
 				       path->nodes[*level]->len, &refs, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		err = ret;
 		goto out;
+	}
 
 	if (refs > 1) {
 		ret = enter_shared_node(root, path->nodes[*level]->start,
 					refs, wc, *level);
-		if (ret > 0)
+		if (ret > 0) {
+			err = ret;
 			goto out;
+		}
 	}
 
 	while (*level >= 0) {
@@ -1256,6 +1260,10 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			reada_walk_down(root, cur, path->slots[*level]);
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
+			if (!next) {
+				err = -EIO;
+				goto out;
+			}
 		}
 
 		*level = *level - 1;
@@ -1265,7 +1273,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 	}
 out:
 	path->slots[*level] = btrfs_header_nritems(path->nodes[*level]);
-	return 0;
+	return err;
 }
 
 static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
-- 
1.7.2.5

