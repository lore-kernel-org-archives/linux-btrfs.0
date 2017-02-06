Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751093AbdBFFrw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:47:52 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 03/12] btrfs-progs: lowmem check: Fix false alert in checking data extent csums
Date: Mon, 6 Feb 2017 13:47:26 +0800
Message-ID: <20170206054735.5227-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs lowmem check can report false csum error like:
ERROR: root 5 EXTENT_DATA[257 0] datasum missing
ERROR: root 5 EXTENT_DATA[257 4096] prealloc shouldn't have datasum

This is because lowmem check code always compare the found csum size
with the whole extent which data extents points to.

Normally it's OK, but when prealloc extent is written, or reflink is
done, data extent can points to part of a larger extent, making the csum
check wrong.

To fix it, the csum check part is modified to handle plain and
compressed extents in different ways:

1) Plain extent
   Only search csums for the range it refers to.
   So the search range is from (disk_bytenr + extent_offset) and search
   length is (extent_num_bytes)

2) Compressed extent
   Search the whole extent.
   Search range is from (disk_bytner) and search length is
   (disk_num_bytes)

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 107359f8..e99e3c36 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4703,9 +4703,13 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	u64 disk_bytenr;
 	u64 disk_num_bytes;
 	u64 extent_num_bytes;
-	u64 found;
+	u64 extent_offset;
+	u64 csum_found;		/* In byte size, sectorsize aligned */
+	u64 search_start;	/* Logical range start we search for csum */
+	u64 search_len;		/* Logical range len we search for csum */
 	unsigned int extent_type;
 	unsigned int is_hole;
+	int compressed = 0;
 	int ret;
 	int err = 0;
 
@@ -4739,24 +4743,45 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
 	disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
 	extent_num_bytes = btrfs_file_extent_num_bytes(node, fi);
+	extent_offset = btrfs_file_extent_offset(node, fi);
+	compressed = btrfs_file_extent_compression(node, fi);
 	is_hole = (disk_bytenr == 0) && (disk_num_bytes == 0);
 
-	/* Check EXTENT_DATA datasum */
-	ret = count_csum_range(root, disk_bytenr, disk_num_bytes, &found);
-	if (found > 0 && nodatasum) {
+	/*
+	 * Check EXTENT_DATA datasum
+	 *
+	 * For plain(uncompressed) extent, we should only check the range
+	 * we're referring to, as it's possible that part of prealloc extent
+	 * has been written, and has csum:
+	 *
+	 * |<-----Original large preallocate extent A ---->|
+	 * |<- Prealloc File Extent ->|<- Regular Extent ->|
+	 *	No csum				Has csum
+	 *
+	 * For compressed extent, we should check the whole range.
+	 */
+	if (!compressed) {
+		search_start = disk_bytenr + extent_offset;
+		search_len = extent_num_bytes;
+	} else {
+		search_start = disk_bytenr;
+		search_len = disk_num_bytes;
+	}
+	ret = count_csum_range(root, search_start, search_len, &csum_found);
+	if (csum_found > 0 && nodatasum) {
 		err |= ODD_CSUM_ITEM;
 		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG && !nodatasum &&
-		   !is_hole &&
-		   (ret < 0 || found == 0 || found < disk_num_bytes)) {
+		   !is_hole && (ret < 0 || csum_found < search_len)) {
 		err |= CSUM_ITEM_MISSING;
-		error("root %llu EXTENT_DATA[%llu %llu] datasum missing",
-		      root->objectid, fkey->objectid, fkey->offset);
-	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC && found > 0) {
+		error("root %llu EXTENT_DATA[%llu %llu] datasum missing, have: %llu, expect: %llu",
+		      root->objectid, fkey->objectid, fkey->offset,
+		      csum_found, search_len);
+	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC && csum_found > 0) {
 		err |= ODD_CSUM_ITEM;
-		error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have datasum",
-		      root->objectid, fkey->objectid, fkey->offset);
+		error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have datasum, but have: %llu",
+		      root->objectid, fkey->objectid, fkey->offset, csum_found);
 	}
 
 	/* Check EXTENT_DATA hole */
-- 
2.11.0



