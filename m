Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38972 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2JASyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 14:54:41 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id kr2fCToi6VBD60vz (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 12:54:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC] [PATCH] Btrfs: rework can_nocow_odirect
Date: Mon, 1 Oct 2012 15:00:14 -0400
Message-ID: <1349118014-6319-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I need everybody to go over this with a fine toothed comb since it is a pretty
big change.  I think it is right and it seems to come out right, but if it's not
it will mean we screw up O_DIRECT on snapshotted files with preallocated
extents, so please, make sure it is correct :).

---

Subject: [PATCH] Btrfs: rework can_nocow_odirect

We are always doing the file extent lookup in here even though we've already
done the btrfs_get_extent which does the exact same thing.  So re-work
can_nocow_odirect to get the same information out of the extent_map we
already have and then do the cross ref check and csum checks as appropriate.
This reduces the number of allocations and searches we do for every O_DIRECT
write and man it helps a lot.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   93 ++++++++++++++---------------------------------------
 1 files changed, 25 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c785c0..1cd7a6b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6352,79 +6352,42 @@ out:
  * block must be cow'd
  */
 static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
-				      struct inode *inode, u64 offset, u64 len)
+				      struct inode *inode,
+				      struct extent_map *em, u64 offset,
+				      u64 len)
 {
-	struct btrfs_path *path;
-	int ret;
-	struct extent_buffer *leaf;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_key key;
 	u64 disk_bytenr;
 	u64 backref_offset;
 	u64 extent_end;
 	u64 num_bytes;
-	int slot;
-	int found_type;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
-				       offset, 0);
-	if (ret < 0)
-		goto out;
 
-	slot = path->slots[0];
-	if (ret == 1) {
-		if (slot == 0) {
-			/* can't find the item, must cow */
-			ret = 0;
-			goto out;
-		}
-		slot--;
-	}
-	ret = 0;
-	leaf = path->nodes[0];
-	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != btrfs_ino(inode) ||
-	    key.type != BTRFS_EXTENT_DATA_KEY) {
-		/* not our file or wrong item type, must cow */
-		goto out;
-	}
-
-	if (key.offset > offset) {
-		/* Wrong offset, must cow */
-		goto out;
-	}
-
-	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
-	found_type = btrfs_file_extent_type(leaf, fi);
-	if (found_type != BTRFS_FILE_EXTENT_REG &&
-	    found_type != BTRFS_FILE_EXTENT_PREALLOC) {
-		/* not a regular extent, must cow */
-		goto out;
-	}
-	disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
-	backref_offset = btrfs_file_extent_offset(leaf, fi);
+	if (em->block_start == EXTENT_MAP_INLINE ||
+	    em->block_start == EXTENT_MAP_HOLE)
+		return 0;
 
-	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-	if (extent_end < offset + len) {
-		/* extent doesn't include our full range, must cow */
-		goto out;
-	}
+	/*
+	 * The em's disk_bytenr is already adjusted for its offset so we need to
+	 * adjust it accordingly.
+	 */
+	backref_offset = em->start - em->orig_start;
+	disk_bytenr = em->block_start - backref_offset;
+	extent_end = em->start + em->len;
 
 	if (btrfs_extent_readonly(root, disk_bytenr))
-		goto out;
+		return 0;
 
 	/*
 	 * look for other files referencing this extent, if we
 	 * find any we must cow
 	 */
 	if (btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
-				  key.offset - backref_offset, disk_bytenr))
-		goto out;
+				  em->orig_start, disk_bytenr))
+		return 0;
+
+	/* No prealloc, we won't have csums */
+	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+		return 1;
 
 	/*
 	 * adjust disk_bytenr and num_bytes to cover just the bytes
@@ -6433,18 +6396,12 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	 * to keep the csums correct
 	 */
 	disk_bytenr += backref_offset;
-	disk_bytenr += offset - key.offset;
+	disk_bytenr += offset - em->start;
 	num_bytes = min(offset + len, extent_end) - offset;
 	if (csum_exist_in_range(root, disk_bytenr, num_bytes))
-				goto out;
-	/*
-	 * all of the above have passed, it is safe to overwrite this extent
-	 * without cow
-	 */
-	ret = 1;
-out:
-	btrfs_free_path(path);
-	return ret;
+		return 0;
+
+	return 1;
 }
 
 static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
@@ -6663,7 +6620,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		if (IS_ERR(trans))
 			goto must_cow;
 
-		if (can_nocow_odirect(trans, inode, start, len) == 1) {
+		if (can_nocow_odirect(trans, inode, em, start, len) == 1) {
 			u64 orig_start = em->start;
 
 			if (type == BTRFS_ORDERED_PREALLOC) {
-- 
1.7.7.6

