Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60638 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753451AbdHWH6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 03:58:10 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/4] btrfs: Check if item pointer overlap with item itself
Date: Wed, 23 Aug 2017 16:57:57 +0900
Message-Id: <20170823075759.13982-3-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function check_leaf() checks if any item pointer points outside of the
leaf, but it doesn't check if the pointer overlap with the item itself.

Normally only the last item may be the victim, but adding such check is
never a bad idea anyway.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ebc719b790ee..e034d08bd036 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -643,6 +643,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 			return -EUCLEAN;
 		}
 
+		/* Also check if the item pointer overlaps with btrfs item. */
+		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
+		    btrfs_item_ptr_offset(leaf, slot)) {
+			CORRUPT("slot overlap with its data", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
 		prev_key.offset = key.offset;
-- 
2.14.1

