Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28999 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213AbaDIHJv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:09:51 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v9 12/16] Btrfs: fix deadlock of dedup work
Date: Wed,  9 Apr 2014 15:08:40 +0800
Message-Id: <1397027325-27151-13-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
References: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Checking for dedup references needs to allocate memory so it cannot
be run within spin_lock, otherwise it will end up with heavy deadlock.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8da7aa..4c1c342 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5720,7 +5720,6 @@ again:
 	dedup_hash = 0;
 
 	path->reada = 1;
-	path->leave_spinning = 1;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	BUG_ON(!is_data && refs_to_drop != 1);
@@ -5774,7 +5773,6 @@ again:
 				goto out;
 			}
 			btrfs_release_path(path);
-			path->leave_spinning = 1;
 
 			key.objectid = bytenr;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -5942,6 +5940,7 @@ again:
 				dedup_hash = extent_data_ref_offset(root,
 								    path, iref);
 
+			WARN_ON_ONCE(path->leave_spinning);
 			ret = btrfs_free_dedup_extent(trans, root,
 						      dedup_hash, bytenr);
 			if (ret) {
-- 
1.8.2.1

