Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45219 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752525AbdGYUyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:54:08 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges while iterating files
Date: Tue, 25 Jul 2017 16:54:41 -0400
Message-Id: <20170725205443.29874-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Commit 522ef705e38 (btrfs-progs: convert: Introduce function to calculate
the available space) changed how we handle migrating file data so that
we never have btrfs space associated with the reserved ranges.  This
works pretty well and when we iterate over the file blocks, the
associations are redirected to the migrated locations.

This commit missed the case in block_iterate_proc where we just check
for intersection with a superblock location before looking up a block
group.  intersect_with_sb checks to see if the range intersects with
a stripe containing a superblock but, in fact, we've reserved the
full 0-1MB range at the start of the disk.  So a file block located
at e.g. 160kB will fall in the reserved region but won't be excepted
in block_iterate_block.  We ultimately hit a BUG_ON when we fail
to look up the block group for that location.

This is reproducible using convert-tests/003-ext4-basic.

The fix is to have intersect_with_sb and block_iterate_proc understand
the full size of the reserved ranges.  Since we use the range to
determine the boundary for the block iterator, let's just return the
boundary.  0 isn't a valid boundary and means that we proceed normally
with block group lookup.

Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 convert/source-fs.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/convert/source-fs.c b/convert/source-fs.c
index 80e4e41..09f6995 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -28,18 +28,16 @@ const struct simple_range btrfs_reserved_ranges[3] = {
 	{ BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
 };
 
-static int intersect_with_sb(u64 bytenr, u64 num_bytes)
+static u64 intersect_with_reserved(u64 bytenr, u64 num_bytes)
 {
 	int i;
-	u64 offset;
 
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		offset = btrfs_sb_offset(i);
-		offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
-		if (bytenr < offset + BTRFS_STRIPE_LEN &&
-		    bytenr + num_bytes > offset)
-			return 1;
+		if (bytenr < range_end(range) &&
+		    bytenr + num_bytes >= range->start)
+			return range_end(range);
 	}
 	return 0;
 }
@@ -64,14 +62,14 @@ int block_iterate_proc(u64 disk_block, u64 file_block,
 		              struct blk_iterate_data *idata)
 {
 	int ret = 0;
-	int sb_region;
+	u64 reserved_boundary;
 	int do_barrier;
 	struct btrfs_root *root = idata->root;
 	struct btrfs_block_group_cache *cache;
 	u64 bytenr = disk_block * root->sectorsize;
 
-	sb_region = intersect_with_sb(bytenr, root->sectorsize);
-	do_barrier = sb_region || disk_block >= idata->boundary;
+	reserved_boundary = intersect_with_reserved(bytenr, root->sectorsize);
+	do_barrier = reserved_boundary || disk_block >= idata->boundary;
 	if ((idata->num_blocks > 0 && do_barrier) ||
 	    (file_block > idata->first_block + idata->num_blocks) ||
 	    (disk_block != idata->disk_block + idata->num_blocks)) {
@@ -91,9 +89,8 @@ int block_iterate_proc(u64 disk_block, u64 file_block,
 				goto fail;
 		}
 
-		if (sb_region) {
-			bytenr += BTRFS_STRIPE_LEN - 1;
-			bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
+		if (reserved_boundary) {
+			bytenr = reserved_boundary;
 		} else {
 			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
 			BUG_ON(!cache);
-- 
2.11.0

