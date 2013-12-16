Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPH0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 02:26:20 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBG7QJFQ009676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:20 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QJQK008358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:19 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QIbX008342
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:18 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] Btrfs: fix EEXIST error when creating new file in subvolume/snapshot
Date: Mon, 16 Dec 2013 15:25:35 +0800
Message-Id: <1387178735-30832-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While creating a subvolume/snapshot, we don't use inode cache to allocate
an inode id for the root dir ".", so inode cache doesn't mark that id as
used, and when we create a new file, it'll be unhappy and throw out
-EEXIST.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode-map.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index b7fb1a8..77cb72a 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -532,6 +532,16 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
 	struct btrfs_key search_key;
 	struct btrfs_key found_key;
 	int slot;
+	u64 min_objectid;
+
+	/*
+	 * For fs/file tree, FIRST_FREE_OBJECTID is reserved for
+	 * root dir "."
+	 */
+	if (is_fstree(root->root_key.objectid))
+		min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+	else
+		min_objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -548,10 +558,9 @@ static int btrfs_find_highest_objectid(struct btrfs_root *root, u64 *objectid)
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

