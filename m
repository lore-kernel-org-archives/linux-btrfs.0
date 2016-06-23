Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbcFWB2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 21:28:23 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5N1SMgl012462
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1SMAQ024279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1SKhV007033
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check inconsistence between chunk and block group
Date: Wed, 22 Jun 2016 18:31:27 -0700
Message-Id: <1466645487-26678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With btrfs-corrupt-block, one can drop one chunk item and mounting
will end up with a panic in btrfs_full_stripe_len().

This doesn't not remove the BUG_ON, but instead checks it a bit
earlier when we find the block group item.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 689d25a..d860291 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9662,7 +9662,22 @@ static int find_first_block_group(struct btrfs_root *root,
 
 		if (found_key.objectid >= key->objectid &&
 		    found_key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
-			ret = 0;
+			struct extent_map_tree *em_tree;
+			struct extent_map *em;
+
+			em_tree = &root->fs_info->mapping_tree.map_tree;
+			read_lock(&em_tree->lock);
+			em = lookup_extent_mapping(em_tree, found_key.objectid,
+						   found_key.offset);
+			read_unlock(&em_tree->lock);
+			if (!em) {
+				btrfs_err(root->fs_info,
+			"logical %llu len %llu found bg but no related chunk",
+					  found_key.objectid, found_key.offset);
+				ret = -ENOENT;
+			} else {
+				ret = 0;
+			}
 			goto out;
 		}
 		path->slots[0]++;
-- 
2.5.5

