Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751776AbbDIEgW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 00:36:22 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t394ZCdP019919
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Apr 2015 12:35:13 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/9] btrfs: Fix tail space processing in find_free_dev_extent()
Date: Thu, 9 Apr 2015 12:34:37 +0800
Message-ID: <c69b475cde6f430b123ce3d56535c2a153096aa8.1428554023.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It is another reason for NO_SPACE case.

When we found enough free space in loop and saved them to
max_hole_start/size before, and tail space contains pending extent,
origional innocent max_hole_start/size are reset in retry.

As a result, find_free_dev_extent() returns less space than it can,
and cause NO_SPACE in user program.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f..586824a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1136,11 +1136,11 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-again:
+
 	max_hole_start = search_start;
 	max_hole_size = 0;
-	hole_size = 0;
 
+again:
 	if (search_start >= search_end || device->is_tgtdev_for_dev_replace) {
 		ret = -ENOSPC;
 		goto out;
@@ -1233,21 +1233,23 @@ next:
 	 * allocated dev extents, and when shrinking the device,
 	 * search_end may be smaller than search_start.
 	 */
-	if (search_end > search_start)
+	if (search_end > search_start) {
 		hole_size = search_end - search_start;
 
-	if (hole_size > max_hole_size) {
-		max_hole_start = search_start;
-		max_hole_size = hole_size;
-	}
+		if (contains_pending_extent(trans, device, &search_start,
+					    hole_size)) {
+			btrfs_release_path(path);
+			goto again;
+		}
 
-	if (contains_pending_extent(trans, device, &search_start, hole_size)) {
-		btrfs_release_path(path);
-		goto again;
+		if (hole_size > max_hole_size) {
+			max_hole_start = search_start;
+			max_hole_size = hole_size;
+		}
 	}
 
 	/* See above. */
-	if (hole_size < num_bytes)
+	if (max_hole_size < num_bytes)
 		ret = -ENOSPC;
 	else
 		ret = 0;
-- 
1.8.5.1

