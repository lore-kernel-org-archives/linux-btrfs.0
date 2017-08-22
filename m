Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53418 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754711AbdHVHh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 03:37:29 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: Check if item pointer overlap with item itself
Date: Tue, 22 Aug 2017 16:37:16 +0900
Message-Id: <20170822073717.13081-3-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
References: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function check_leaf() checks if any item pointer points outside of the
leaf, but it doesn't check if the pointer overlap with the item itself.

Normally only the last item may be the victim, but add such check is
never a bad idea anyway.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 919ddd4b774c..59ee7b959bf0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -643,6 +643,13 @@ static noinline int check_leaf(struct btrfs_root *root,
 			return -EIO;
 		}
 
+		/* Also check if the item pointer overlaps with btrfs item. */
+		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
+		    btrfs_item_ptr_offset(leaf, slot)) {
+			CORRUPT("slot overlap with its data", leaf, root, slot);
+			return -EIO;
+		}
+
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
 		prev_key.offset = key.offset;
-- 
2.14.1

