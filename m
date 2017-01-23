Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18859 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750889AbdAWJPN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 04:15:13 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH 4/9] btrfs-progs: lowmem check: Fix false alert in checking data extent pointing to prealloc extent
Date: Mon, 23 Jan 2017 17:13:53 +0800
Message-ID: <20170123091359.21390-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
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

The fix changes the csum check part to the data extent size, other than
the disk_bytenr/disk_num_bytes which points to a larger extent.

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index f158daf9..fd176b76 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4695,6 +4695,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	u64 disk_bytenr;
 	u64 disk_num_bytes;
 	u64 extent_num_bytes;
+	u64 extent_offset;
 	u64 found;
 	unsigned int extent_type;
 	unsigned int is_hole;
@@ -4731,17 +4732,28 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
 	disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
 	extent_num_bytes = btrfs_file_extent_num_bytes(node, fi);
+	extent_offset = btrfs_file_extent_offset(node, fi);
 	is_hole = (disk_bytenr == 0) && (disk_num_bytes == 0);
 
-	/* Check EXTENT_DATA datasum */
-	ret = count_csum_range(root, disk_bytenr, disk_num_bytes, &found);
+	/*
+	 * Check EXTENT_DATA datasum
+	 *
+	 * We should only check the range we're referring to, as it's possible
+	 * that part of prealloc extent has been written, and has csum:
+	 *
+	 * |<------- Original large preallocate extent A -------->|
+	 * |<- Prealloc File Extent ->|<- Regular Extent ->|
+	 *	No csum				Has csum
+	 */
+	ret = count_csum_range(root, disk_bytenr + extent_offset,
+			       extent_num_bytes, &found);
 	if (found > 0 && nodatasum) {
 		err |= ODD_CSUM_ITEM;
 		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG && !nodatasum &&
 		   !is_hole &&
-		   (ret < 0 || found == 0 || found < disk_num_bytes)) {
+		   (ret < 0 || found == 0 || found < extent_num_bytes)) {
 		err |= CSUM_ITEM_MISSING;
 		error("root %llu EXTENT_DATA[%llu %llu] datasum missing",
 		      root->objectid, fkey->objectid, fkey->offset);
-- 
2.11.0



