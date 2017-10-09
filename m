Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751397AbdJIBvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Oct 2017 21:51:23 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v4 4/5] btrfs: tree-checker: Enhance output for check_csum_item
Date: Mon,  9 Oct 2017 01:51:05 +0000
Message-Id: <20171009015106.9711-5-quwenruo.btrfs@gmx.com>
In-Reply-To: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
References: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output the bad value and expected good value (or its alignment).

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/tree-checker.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7bba195ecc8b..42e002f8a560 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -164,15 +164,21 @@ static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
 	u32 csumsize = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
-		CORRUPT("invalid objectid for csum item", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"invalid key objectid for csum item, have %llu expect %llu",
+			key->objectid, BTRFS_EXTENT_CSUM_OBJECTID);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"unaligned key offset for csum item, have %llu should be aligned to %u",
+			key->offset, sectorsize);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
-		CORRUPT("unaligned csum item size", leaf, root, slot);
+		generic_err(root, leaf, slot,
+			"unaligned item size for csum item, have %u should be aligned to %u",
+			btrfs_item_size_nr(leaf, slot), csumsize);
 		return -EUCLEAN;
 	}
 	return 0;
-- 
2.14.2

