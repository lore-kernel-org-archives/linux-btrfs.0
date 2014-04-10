Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226AbaDJDt7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:49:59 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 13/16] Btrfs: fix transactin abortion in __btrfs_free_extent
Date: Thu, 10 Apr 2014 11:48:43 +0800
Message-Id: <1397101727-20806-14-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to reset @refs_to_drop to 1 when we're going to delete the last
special dedup reference, otherwise we can trigger (@refs < @refs_to_drop)
and end up with transaction abortion.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c1c342..1cb3ec5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5931,6 +5931,7 @@ again:
 			btrfs_release_path(path);
 			root_objectid = BTRFS_DEDUP_TREE_OBJECTID;
 			parent = 0;
+			refs_to_drop = 1;
 
 			goto again;
 		}
-- 
1.8.1.4

