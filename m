Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3JHKT1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 06:19:27 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r98AJPIs024019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:26 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJPA1027891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:25 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJP1G027887
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:25 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup dead code of defragment
Date: Tue,  8 Oct 2013 18:19:14 +0800
Message-Id: <1381227554-6783-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@is_extent is no more needed since we don't defrag extent root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-defrag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 94e05c1..e6d992e 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -37,7 +37,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int wret;
 	int level;
-	int is_extent = 0;
 	int next_key_ret = 0;
 	u64 last_ret = 0;
 	u64 min_trans = 0;
@@ -50,7 +49,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (root->ref_cows == 0 && !is_extent)
+	if (root->ref_cows == 0)
 		goto out;
 
 	if (btrfs_test_opt(root, SSD))
-- 
1.8.1.4

