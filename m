Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42987 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3LMJQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:16:43 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBD9GgIk026210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:43 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBD9Gf0h016990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:41 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBD9GfO0016982
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix EEXIST error when creating new file in subvolume/snapshot
Date: Fri, 13 Dec 2013 17:16:23 +0800
Message-Id: <1386926183-18325-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com>
References: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While creating a subvolume/snapshot, we don't use inode cache to allocate
an inode id for the root dir "..", so inode cache doesn't mark that id as
used, and when we create a new file, it'll find that fact and throw out
-EEXIST.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode-map.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 493694f..bcff910 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -528,6 +528,16 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 	struct btrfs_key search_key;
 	struct btrfs_key found_key;
 	int slot;
+	u64 min_objectid;
+
+	/*
+	 * For fs/file tree, FIRST_FREE_OBJECTID is reserved for
+	 * root dir ".."
+	 */
+	if (is_fstree(root->root_key.objectid))
+		min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+	else
+		min_objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -544,10 +554,9 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 		slot = path->slots[0] - 1;
 		l = path->nodes[0];
 		btrfs_item_key_to_cpu(l, &found_key, slot);
-		*objectid = max_t(u64, found_key.objectid,
-				  BTRFS_FIRST_FREE_OBJECTID - 1);
+		*objectid = max_t(u64, found_key.objectid, min_objectid);
 	} else {
-		*objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
+		*objectid = min_objectid;
 	}
 	ret = 0;
 error:
-- 
1.8.2.1

