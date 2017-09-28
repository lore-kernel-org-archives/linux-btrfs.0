Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61960 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752581AbdI1DgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 23:36:23 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/5] btrfs: tree-checker: Enhance output for check_csum_item
Date: Thu, 28 Sep 2017 12:36:09 +0900
Message-Id: <20170928033610.16882-5-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
References: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output the bad value and expected good value (or its alignment).

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/tree-checker.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 4f847955fdc6..52e9ab8c2a79 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -147,15 +147,21 @@ static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
 	u32 csumsize = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
-		CORRUPT("invalid objectid for csum item", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"invalid objectid for CSUM_ITEM, have %llu expect %llu",
+			key->objectid, BTRFS_EXTENT_CSUM_OBJECTID);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"unaligned key offset for CSUM_ITEM, have %llu should be aligned to %u",
+			key->offset, sectorsize);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
-		CORRUPT("unaligned csum item size", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"unaligned item size for CSUM_ITEM, have %u should be aligned to %u",
+			btrfs_item_size_nr(leaf, slot), csumsize);
 		return -EUCLEAN;
 	}
 	return 0;
-- 
2.14.1

