Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55942 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbeAYTIr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7QTA064428
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2fqk3sgqu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:47 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8jsQ001140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8j3Q007091
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix unexpected -EEXIST when creating new inode
Date: Thu, 25 Jan 2018 11:02:56 -0700
Message-Id: <20180125180256.10844-9-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The highest objectid, which is assigned to new inode, is decided at
the time of initializing fs roots.  However, in cases where log replay
gets processed, the btree which fs root owns might be changed, so we
have to search it again for the highest objectid, otherwise creating
new inode would end up with -EEXIST.

cc: <stable@vger.kernel.org> v4.4-rc6+
Fixes: f32e48e92596 ("Btrfs: Initialize btrfs_root->highest_objectid when loading tree root and subvolume roots")
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a7e6235..646cdbf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -28,6 +28,7 @@
 #include "hash.h"
 #include "compression.h"
 #include "qgroup.h"
+#include "inode-map.h"
 
 /* magic values for the inode_only field in btrfs_log_inode:
  *
@@ -5715,6 +5716,24 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 						      path);
 		}
 
+		if (!ret && wc.stage == LOG_WALK_REPLAY_ALL) {
+			struct btrfs_root *root = wc.replay_dest;
+
+			btrfs_release_path(path);
+
+			/*
+			 * We have just replayed everything, and the highest
+			 * objectid of fs roots probably has changed in case
+			 * some inode_item's got replayed.
+			 */
+			/*
+			 * root->objectid_mutex is not acquired as log replay
+			 * could only happen during mount.
+			 */
+			ret = btrfs_find_highest_objectid(root,
+						  &root->highest_objectid);
+		}
+
 		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
 		free_extent_buffer(log->node);
-- 
2.9.4

