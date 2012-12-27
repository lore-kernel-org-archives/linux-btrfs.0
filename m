Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46497 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2L0JDj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:39 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93bso012806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:38 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93b0q001139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:37 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93a5c026171
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:36 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] Btrfs: kill unused arguments of cache_block_group
Date: Thu, 27 Dec 2012 17:01:18 +0800
Message-Id: <1356598884-22952-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' and 'root' are not used any more.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8540f94..b57c233 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -468,8 +468,6 @@ out:
 }
 
 static int cache_block_group(struct btrfs_block_group_cache *cache,
-			     struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
 			     int load_cache_only)
 {
 	DEFINE_WAIT(wait);
@@ -4769,7 +4767,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		 * space back to the block group, otherwise we will leak space.
 		 */
 		if (!alloc && cache->cached == BTRFS_CACHE_NO)
-			cache_block_group(cache, trans, NULL, 1);
+			cache_block_group(cache, 1);
 
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
@@ -4884,7 +4882,7 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
 	 * to one because the slow code to read in the free extents does check
 	 * the pinned extents.
 	 */
-	cache_block_group(cache, trans, root, 1);
+	cache_block_group(cache, 1);
 
 	pin_down_extent(root, cache, bytenr, num_bytes, 0);
 
@@ -5674,8 +5672,7 @@ have_block_group:
 		cached = block_group_cache_done(block_group);
 		if (unlikely(!cached)) {
 			found_uncached_bg = true;
-			ret = cache_block_group(block_group, trans,
-						orig_root, 0);
+			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
 			ret = 0;
 		}
@@ -6211,7 +6208,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = ins->offset;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	cache_block_group(block_group, trans, NULL, 0);
+	cache_block_group(block_group, 0);
 	caching_ctl = get_caching_control(block_group);
 
 	if (!caching_ctl) {
@@ -8152,7 +8149,7 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 
 		if (end - start >= range->minlen) {
 			if (!block_group_cache_done(cache)) {
-				ret = cache_block_group(cache, NULL, root, 0);
+				ret = cache_block_group(cache, 0);
 				if (!ret)
 					wait_block_group_cache_done(cache);
 			}
-- 
1.7.7.6

