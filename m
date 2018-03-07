Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60074 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeCGJ1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 04:27:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w279Rg6Z142723
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 09:27:42 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2gjcb0gbt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 09:27:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w279RfwH016694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 09:27:41 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w279RePV018174
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Mar 2018 09:27:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: drop nonvaring variable, instead define it
Date: Wed,  7 Mar 2018 17:29:18 +0800
Message-Id: <20180307092918.32440-1-anand.jain@oracle.com>
In-Reply-To: <20180305211623.GE5942@twin.jikos.cz>
References: <20180305211623.GE5942@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_defrag_leaves() declares min_trans = 0; as variable, but
doesn't vary it, so define it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v1: Use BTRFS_OLDEST_GENERATION at more places where needed.

 fs/btrfs/ctree.h       | 2 ++
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/tree-defrag.c | 5 ++---
 fs/btrfs/uuid-tree.c   | 2 +-
 fs/btrfs/volumes.c     | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d688430f9be1..7c408062b6a5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -66,6 +66,8 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_MAX_LEVEL 8
 
+#define BTRFS_OLDEST_GENERATION	0ULL
+
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
 /*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c5a559105949..ba403c00982c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2600,7 +2600,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			range->len = (u64)-1;
 		}
 		ret = btrfs_defrag_file(file_inode(file), file,
-					range, 0, 0);
+					range, BTRFS_OLDEST_GENERATION, 0);
 		if (ret > 0)
 			ret = 0;
 		kfree(range);
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index cb65089127cc..c09dbe4bd6e7 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -39,7 +39,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	int level;
 	int next_key_ret = 0;
 	u64 last_ret = 0;
-	u64 min_trans = 0;
 
 	if (root->fs_info->extent_root == root) {
 		/*
@@ -81,7 +80,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 
 	path->keep_locks = 1;
 
-	ret = btrfs_search_forward(root, &key, path, min_trans);
+	ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
 	if (ret < 0)
 		goto out;
 	if (ret > 0) {
@@ -130,7 +129,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	 */
 	path->slots[1] = btrfs_header_nritems(path->nodes[1]);
 	next_key_ret = btrfs_find_next_key(root, path, &key, 1,
-					   min_trans);
+					   BTRFS_OLDEST_GENERATION);
 	if (next_key_ret == 0) {
 		memcpy(&root->defrag_progress, &key, sizeof(key));
 		ret = -EAGAIN;
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 726f928238d0..9916f03430bc 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -282,7 +282,7 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 again_search_slot:
-	ret = btrfs_search_forward(root, &key, path, 0);
+	ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
 	if (ret) {
 		if (ret > 0)
 			ret = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b4ada8f50f3c..328b97801836 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4206,7 +4206,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 	key.offset = 0;
 
 	while (1) {
-		ret = btrfs_search_forward(root, &key, path, 0);
+		ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
 		if (ret) {
 			if (ret > 0)
 				ret = 0;
-- 
2.15.0

