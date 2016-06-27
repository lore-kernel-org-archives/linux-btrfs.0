Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbcF0Hwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 03:52:39 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 768D24056404
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:52:15 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: convert: Fix a bug leads to discontinuous extents
Date: Mon, 27 Jun 2016 15:50:10 +0800
Message-Id: <20160627075011.24330-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_record_file_extent() will split extents using max extent size(128M).
It works well for real file extents, but not that well for large
hole extent, as hole doesn't have extent size limit.

In that case, it will only insert one 128M hole, and skip the rest,
leading to discontinuous extent error for converted btrfs.

Fix it by not splitting hole extents.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 5ca53fa..a58da23 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3985,10 +3985,11 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset;
 	u64 num_bytes = *ret_num_bytes;
 
-	num_bytes = min_t(u64, num_bytes, BTRFS_MAX_EXTENT_SIZE);
 	/*
 	 * All supported file system should not use its 0 extent.
 	 * As it's for hole
+	 *
+	 * And hole extent has no size limit, no need to loop.
 	 */
 	if (disk_bytenr == 0) {
 		ret = btrfs_insert_file_extent(trans, root, objectid,
@@ -3996,6 +3997,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 						num_bytes, num_bytes);
 		return ret;
 	}
+	num_bytes = min_t(u64, num_bytes, BTRFS_MAX_EXTENT_SIZE);
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
2.9.0



