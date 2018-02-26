Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbeBZIqs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 03:46:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1Q8gmPV098261
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:46:48 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2gcdvyg9x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:46:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q8kla1029229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:46:47 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q8klpC003515
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 08:46:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: drop nonvaring variable, instead define it
Date: Mon, 26 Feb 2018 16:48:14 +0800
Message-Id: <20180226084814.7229-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_defrag_leaves() has min_trans = 0 which doesn't vary.
Defining it makes sense.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h       | 2 ++
 fs/btrfs/tree-defrag.c | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cb6c1ecb3cb0..295c6cf85d0f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -66,6 +66,8 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_MAX_LEVEL 8
 
+#define BTRFS_OLDEST_GENERATION	0ULL
+
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
 /*
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
-- 
2.15.0

