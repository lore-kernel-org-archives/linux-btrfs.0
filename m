Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753415AbdHWH6N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 03:58:13 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 4/4] btrfs: Add checker for EXTENT_CSUM
Date: Wed, 23 Aug 2017 16:57:59 +0900
Message-Id: <20170823075759.13982-5-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EXTENT_CSUM checker is a relatively easy checker, only needs to check:

1) Objectid
   Fixed to BTRFS_EXTENT_CSUM_OBJECTID.

2) Key offset alignment
   Must be aligned to sectorsize

3) Item size alignedment
   Must be aligned to csum size.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/disk-io.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b92296c6a698..1746c5a2a7f7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -628,6 +628,27 @@ static int check_extent_data_item(struct btrfs_root *root,
 	return 0;
 }
 
+static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
+			   struct btrfs_key *key, int slot)
+{
+	u32 sectorsize = root->fs_info->sectorsize;
+	u32 csumsize = btrfs_super_csum_size(root->fs_info->super_copy);
+
+	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
+		CORRUPT("invalid objectid for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(key->offset, sectorsize)) {
+		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
+		CORRUPT("unaligned csum item size", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_leaf_item(struct btrfs_root *root,
 			   struct extent_buffer *leaf,
 			   struct btrfs_key *key, int slot)
@@ -642,6 +663,9 @@ static int check_leaf_item(struct btrfs_root *root,
 	case BTRFS_EXTENT_DATA_KEY:
 		ret = check_extent_data_item(root, leaf, key, slot);
 		break;
+	case BTRFS_EXTENT_CSUM_KEY:
+		ret = check_csum_item(root, leaf, key, slot);
+		break;
 	}
 	return ret;
 }
-- 
2.14.1

