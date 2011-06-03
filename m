From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: scrub: errors in tree enumeration
Date: Fri,  3 Jun 2011 11:28:05 +0200
Message-ID: <1307093285-7966-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

due to the semantics of btrfs_search_slot the path can point to an
invalid slot when ret > 0. This condition went unnoticed, which in
turn could have led to an incomplete scrubbing.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2d1f890..3dff244 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -906,11 +906,7 @@ again:
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
@@ -1063,7 +1059,15 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
-			goto out;
+			break;
+		if (ret > 0) {
+			if (path->slots[0] >=
+			    btrfs_header_nritems(path->nodes[0])) {
+				ret = btrfs_next_leaf(root, path);
+				if (ret)
+					break;
+			}
+		}
 		ret = 0;
 
 		l = path->nodes[0];
@@ -1074,7 +1078,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		if (found_key.objectid != sdev->dev->devid)
 			break;
 
-		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
+		if (btrfs_key_type(&found_key) != BTRFS_DEV_EXTENT_KEY)
 			break;
 
 		if (found_key.offset >= end)
@@ -1103,7 +1107,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		cache = btrfs_lookup_block_group(fs_info, chunk_offset);
 		if (!cache) {
 			ret = -ENOENT;
-			goto out;
+			break;
 		}
 		ret = scrub_chunk(sdev, chunk_tree, chunk_objectid,
 				  chunk_offset, length);
@@ -1115,7 +1119,6 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 		btrfs_release_path(path);
 	}
 
-out:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.3.4

