Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54351 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaBEQtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 11:49:08 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so483791wgh.14
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 08:49:07 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] Btrfs: make some tree searches in send.c more efficient
Date: Wed,  5 Feb 2014 16:48:56 +0000
Message-Id: <1391618936-8716-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1391618936-8716-1-git-send-email-fdmanana@gmail.com>
References: <1391618936-8716-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have this pattern where we do search for a contiguous group of
items in a tree and everytime we find an item, we process it, then
we release our path, increment the offset of the search key, do
another full tree search and repeat these steps until a tree search
can't find more items we're interested in.

Instead of doing these full tree searches after processing each item,
just process the next item/slot in our leaf and don't release the path.
Since all these trees are read only and we always use the commit root
for a search and skip node/leaf locks, we're not affecting concurrency
on the trees.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |  105 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7a1b547..f46c43f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2460,17 +2460,26 @@ static int did_create_dir(struct send_ctx *sctx, u64 dir)
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = 0;
+	ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
 	while (1) {
-		ret = btrfs_search_slot_for_read(sctx->send_root, &key, path,
-				1, 0);
-		if (ret < 0)
-			goto out;
-		if (!ret) {
-			eb = path->nodes[0];
-			slot = path->slots[0];
-			btrfs_item_key_to_cpu(eb, &found_key, slot);
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(eb)) {
+			ret = btrfs_next_leaf(sctx->send_root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			continue;
 		}
-		if (ret || found_key.objectid != key.objectid ||
+
+		btrfs_item_key_to_cpu(eb, &found_key, slot);
+		if (found_key.objectid != key.objectid ||
 		    found_key.type != key.type) {
 			ret = 0;
 			goto out;
@@ -2485,8 +2494,7 @@ static int did_create_dir(struct send_ctx *sctx, u64 dir)
 			goto out;
 		}
 
-		key.offset = found_key.offset + 1;
-		btrfs_release_path(path);
+		path->slots[0]++;
 	}
 
 out:
@@ -2652,19 +2660,24 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 send_progress)
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = 0;
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
 
 	while (1) {
-		ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
-		if (ret < 0)
-			goto out;
-		if (!ret) {
-			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-					path->slots[0]);
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+			continue;
 		}
-		if (ret || found_key.objectid != key.objectid ||
-		    found_key.type != key.type) {
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		if (found_key.objectid != key.objectid ||
+		    found_key.type != key.type)
 			break;
-		}
 
 		di = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				struct btrfs_dir_item);
@@ -2675,8 +2688,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 send_progress)
 			goto out;
 		}
 
-		btrfs_release_path(path);
-		key.offset = found_key.offset + 1;
+		path->slots[0]++;
 	}
 
 	ret = 1;
@@ -3581,15 +3593,22 @@ static int process_all_refs(struct send_ctx *sctx,
 	key.objectid = sctx->cmp_key->objectid;
 	key.type = BTRFS_INODE_REF_KEY;
 	key.offset = 0;
-	while (1) {
-		ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
-		if (ret < 0)
-			goto out;
-		if (ret)
-			break;
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
 
+	while (1) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(eb)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
 		btrfs_item_key_to_cpu(eb, &found_key, slot);
 
 		if (found_key.objectid != key.objectid ||
@@ -3598,11 +3617,10 @@ static int process_all_refs(struct send_ctx *sctx,
 			break;
 
 		ret = iterate_inode_ref(root, path, &found_key, 0, cb, sctx);
-		btrfs_release_path(path);
 		if (ret < 0)
 			goto out;
 
-		key.offset = found_key.offset + 1;
+		path->slots[0]++;
 	}
 	btrfs_release_path(path);
 
@@ -3883,19 +3901,25 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 	key.objectid = sctx->cmp_key->objectid;
 	key.type = BTRFS_XATTR_ITEM_KEY;
 	key.offset = 0;
-	while (1) {
-		ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
-		if (ret < 0)
-			goto out;
-		if (ret) {
-			ret = 0;
-			goto out;
-		}
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
 
+	while (1) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
-		btrfs_item_key_to_cpu(eb, &found_key, slot);
+		if (slot >= btrfs_header_nritems(eb)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			continue;
+		}
 
+		btrfs_item_key_to_cpu(eb, &found_key, slot);
 		if (found_key.objectid != key.objectid ||
 		    found_key.type != key.type) {
 			ret = 0;
@@ -3907,8 +3931,7 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 		if (ret < 0)
 			goto out;
 
-		btrfs_release_path(path);
-		key.offset = found_key.offset + 1;
+		path->slots[0]++;
 	}
 
 out:
-- 
1.7.9.5

