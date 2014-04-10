Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34446 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965315AbaDJDuD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:50:03 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 14/16] Btrfs: fix wrong pinned bytes in __btrfs_free_extent
Date: Thu, 10 Apr 2014 11:48:44 +0800
Message-Id: <1397101727-20806-15-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the special dedup reference, in the case of (refs == 1) in __btrfs_free_extent,
we'll actually free the extent, so pinned_bytes of it should not be added to that
global counter.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1cb3ec5..b8fee86 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5915,9 +5915,6 @@ again:
 				goto out;
 			}
 		}
-		add_pinned_bytes(root->fs_info, -num_bytes, owner_objectid,
-				 root_objectid);
-
 		/*
 		 * special case for dedup
 		 *
@@ -5934,6 +5931,9 @@ again:
 			refs_to_drop = 1;
 
 			goto again;
+		} else {
+			add_pinned_bytes(root->fs_info, -num_bytes,
+					 owner_objectid, root_objectid);
 		}
 	} else {
 		if (is_data && root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
-- 
1.8.1.4

