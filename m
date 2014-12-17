Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaLQIOT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 03:14:19 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sBH8EIUR001461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 08:14:19 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBH8EHxU000485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 08:14:17 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBH8EGwX000478
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 08:14:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup unused run_most
Date: Wed, 17 Dec 2014 16:14:09 +0800
Message-Id: <1418804049-11323-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"run_most" is not used anymore.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 222d6ae..4f54c30 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2768,7 +2768,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head;
 	int ret;
 	int run_all = count == (unsigned long)-1;
-	int run_most = 0;
 
 	/* We'll clean this up in btrfs_cleanup_transaction */
 	if (trans->aborted)
@@ -2778,10 +2777,8 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		root = root->fs_info->tree_root;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	if (count == 0) {
+	if (count == 0)
 		count = atomic_read(&delayed_refs->num_entries) * 2;
-		run_most = 1;
-	}
 
 again:
 #ifdef SCRAMBLE_DELAYED_REFS
-- 
1.8.1.4

