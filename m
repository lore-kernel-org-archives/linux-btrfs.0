From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3] btrfs: scrub: errors in tree enumeration
Date: Thu,  9 Jun 2011 08:42:33 +0200
Message-ID: <1307601753-25555-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

due to the semantics of btrfs_search_slot the path can point to an
invalid slot when ret > 0. This condition went unnoticed, which in
turn could have led to an incomplete scrubbing.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 
Change in v2:
 - fix return value of scrub_enumerate_chunks
 
Change in v3:
 - check return value of btrfs_previous_item
 - some error paths did a unplug without a plug

---

 fs/btrfs/scrub.c |   57 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index df50fd1..d5a4108 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -804,18 +804,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
-			goto out;
-
-		l = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(l, &key, slot);
-		if (key.objectid != logical) {
-			ret = btrfs_previous_item(root, path, 0,
-						  BTRFS_EXTENT_ITEM_KEY);
-			if (ret < 0)
-				goto out;
-		}
+			goto out_noplug;
 
+		/*
+		 * we might miss half an extent here, but that doesn't matter,
+		 * as it's only the prefetch
+		 */
 		while (1) {
 			l = path->nodes[0];
 			slot = path->slots[0];
@@ -824,7 +818,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 				if (ret == 0)
 					continue;
 				if (ret < 0)
-					goto out;
+					goto out_noplug;
 
 				break;
 			}
@@ -906,15 +900,20 @@ again:
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
-
-		l = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(l, &key, slot);
-		if (key.objectid != logical) {
+		if (ret > 0) {
 			ret = btrfs_previous_item(root, path, 0,
 						  BTRFS_EXTENT_ITEM_KEY);
 			if (ret < 0)
 				goto out;
+			if (ret > 0) {
+				/* there's no smaller item, so stick with the
+				 * larger one */
+				btrfs_release_path(path);
+				ret = btrfs_search_slot(NULL, root, &key,
+							path, 0, 0);
+				if (ret < 0)
+					goto out;
+			}
 		}
 
 		while (1) {
@@ -989,6 +988,7 @@ next:
 
 out:
 	blk_finish_plug(&plug);
+out_noplug:
 	btrfs_free_path(path);
 	return ret < 0 ? ret : 0;
 }
@@ -1064,8 +1064,15 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
-			goto out;
-		ret = 0;
+			break;
+		if (ret > 0) {
+			if (path->slots[0] >=
+			    btrfs_header_nritems(path->nodes[0])) {
+				ret = btrfs_next_leaf(root, path);
+				if (ret)
+					break;
+			}
+		}
 
 		l = path->nodes[0];
 		slot = path->slots[0];
@@ -1075,7 +1082,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		if (found_key.objectid != sdev->dev->devid)
 			break;
 
-		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
+		if (btrfs_key_type(&found_key) != BTRFS_DEV_EXTENT_KEY)
 			break;
 
 		if (found_key.offset >= end)
@@ -1104,7 +1111,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		cache = btrfs_lookup_block_group(fs_info, chunk_offset);
 		if (!cache) {
 			ret = -ENOENT;
-			goto out;
+			break;
 		}
 		ret = scrub_chunk(sdev, chunk_tree, chunk_objectid,
 				  chunk_offset, length);
@@ -1116,9 +1123,13 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		btrfs_release_path(path);
 	}
 
-out:
 	btrfs_free_path(path);
-	return ret;
+
+	/*
+	 * ret can still be 1 from search_slot or next_leaf,
+	 * that's not an error
+	 */
+	return ret < 0 ? ret : 0;
 }
 
 static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
-- 
1.7.3.4

