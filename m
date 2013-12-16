Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40247 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPH0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 02:26:18 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBG7QGrc009650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:17 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QGet018677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:16 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QGMq013109
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] Btrfs: avoid building inode cache repeatly
Date: Mon, 16 Dec 2013 15:25:33 +0800
Message-Id: <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inode cache is similar to free space cache and in fact shares the same
code, however, we don't load inode cache unless we're about to allocate
inode id, then there is a case where we only commit the transaction during
other operations, such as snapshot creation, we now update fs roots' generation
to the new transaction id, after that when we want to load the inode cache,
we'll find that it's not valid thanks to the mismatch of generation, and we
have to push btrfs-ino-cache thread to build inode cache from disk, and
this operation is sometimes time-costing.

So to fix the above, we load inode cache into memory during reading fs root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix race issue pointed by Miao.

 fs/btrfs/disk-io.c   | 3 +++
 fs/btrfs/inode-map.c | 6 ++++++
 fs/btrfs/inode-map.h | 1 +
 fs/btrfs/root-tree.c | 3 +++
 4 files changed, 13 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..59af2aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1630,6 +1630,9 @@ again:
 		}
 		goto fail;
 	}
+
+	btrfs_start_ino_caching(root);
+
 	return root;
 fail:
 	free_fs_root(root);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ab485e5..f23b0df 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -179,6 +179,12 @@ static void start_caching(struct btrfs_root *root)
 	BUG_ON(IS_ERR(tsk)); /* -ENOMEM */
 }
 
+void btrfs_start_ino_caching(struct btrfs_root *root)
+{
+	if (root)
+		start_caching(root);
+}
+
 int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
 {
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
index ddb347b..5acf943 100644
--- a/fs/btrfs/inode-map.h
+++ b/fs/btrfs/inode-map.h
@@ -4,6 +4,7 @@
 void btrfs_init_free_ino_ctl(struct btrfs_root *root);
 void btrfs_unpin_free_ino(struct btrfs_root *root);
 void btrfs_return_ino(struct btrfs_root *root, u64 objectid);
+void btrfs_start_ino_caching(struct btrfs_root *root);
 int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid);
 int btrfs_save_ino_cache(struct btrfs_root *root,
 			 struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ec71ea4..d4b6cfc 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -21,6 +21,7 @@
 #include "transaction.h"
 #include "disk-io.h"
 #include "print-tree.h"
+#include "inode-map.h"
 
 /*
  * Read a root item from the tree. In case we detect a root item smaller then
@@ -316,6 +317,8 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 
 		if (btrfs_root_refs(&root->root_item) == 0)
 			btrfs_add_dead_root(root);
+		else
+			btrfs_start_ino_caching(root);
 	}
 
 	btrfs_free_path(path);
-- 
1.8.2.1

