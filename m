Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65082 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754710AbdHVHhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 03:37:25 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/3] btrfs: Refactor check_leaf function for later expansion.
Date: Tue, 22 Aug 2017 16:37:15 +0900
Message-Id: <20170822073717.13081-2-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
References: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current check_leaf() function does a good job checking key orders and
item offset/size.

However it only checks from slot 0 to the last but one slot, this is
good but makes later expansion hard.

So this refactoring iterates from slot 0 to the last slot.
For key comparison, it uses a key with all 0 as initial key, so all
valid key should be larger than it.

And for item size/offset check, it compares current item end with
previous item offset.
For slot 0, use leaf end as special case.

This makes later item/key offset check and item size check easier to be
implemented.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/disk-io.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 080e2ebb8aa0..919ddd4b774c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -553,8 +553,9 @@ static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	/* No valid key type is 0, so all key should be larger than this key */
+	struct btrfs_key prev_key = {0, 0, 0};
 	struct btrfs_key key;
-	struct btrfs_key leaf_key;
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
@@ -597,26 +598,21 @@ static noinline int check_leaf(struct btrfs_root *root,
 	if (nritems == 0)
 		return 0;
 
-	/* Check the 0 item */
-	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
-	    BTRFS_LEAF_DATA_SIZE(fs_info)) {
-		CORRUPT("invalid item offset size pair", leaf, root, 0);
-		return -EIO;
-	}
-
 	/*
-	 * Check to make sure each items keys are in the correct order and their
-	 * offsets make sense.  We only have to loop through nritems-1 because
-	 * we check the current slot against the next slot, which verifies the
-	 * next slot's offset+size makes sense and that the current's slot
-	 * offset is correct.
+	 * Check the following things to make sure this is a good leaf, and
+	 * leaf users won't need to bother similar sanity check:
+	 *
+	 * 1) key order
+	 * 2) item offset and size
+	 *    No overlap, no hole, all inside the leaf.
 	 */
-	for (slot = 0; slot < nritems - 1; slot++) {
-		btrfs_item_key_to_cpu(leaf, &leaf_key, slot);
-		btrfs_item_key_to_cpu(leaf, &key, slot + 1);
+	for (slot = 0; slot < nritems; slot++) {
+		u32 item_end_expected;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
 
 		/* Make sure the keys are in the right order */
-		if (btrfs_comp_cpu_keys(&leaf_key, &key) >= 0) {
+		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
 			CORRUPT("bad key order", leaf, root, slot);
 			return -EIO;
 		}
@@ -626,8 +622,12 @@ static noinline int check_leaf(struct btrfs_root *root,
 		 * item data starts at the end of the leaf and grows towards the
 		 * front.
 		 */
-		if (btrfs_item_offset_nr(leaf, slot) !=
-			btrfs_item_end_nr(leaf, slot + 1)) {
+		if (slot == 0)
+			item_end_expected = BTRFS_LEAF_DATA_SIZE(fs_info);
+		else
+			item_end_expected = btrfs_item_offset_nr(leaf,
+								 slot - 1);
+		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
 			CORRUPT("slot offset bad", leaf, root, slot);
 			return -EIO;
 		}
@@ -642,6 +642,10 @@ static noinline int check_leaf(struct btrfs_root *root,
 			CORRUPT("slot end outside of leaf", leaf, root, slot);
 			return -EIO;
 		}
+
+		prev_key.objectid = key.objectid;
+		prev_key.type = key.type;
+		prev_key.offset = key.offset;
 	}
 
 	return 0;
-- 
2.14.1

