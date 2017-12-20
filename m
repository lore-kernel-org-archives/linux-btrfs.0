Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932242AbdLTGly (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 01:41:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBK6fSS8069795
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 06:41:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2eyj2f85ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 06:41:52 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBK6fpre019490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 06:41:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBK6fpun004424
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 06:41:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: optimize code converge mutex unlock
Date: Wed, 20 Dec 2017 14:42:26 +0800
Message-Id: <20171220064226.4317-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional change rearrange the mutex_unlock.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/transaction.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6348573e26a7..04f07144b45c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2265,16 +2265,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	}
 
 	ret = write_all_supers(fs_info, 0);
-	if (ret) {
-		mutex_unlock(&fs_info->tree_log_mutex);
-		goto scrub_continue;
-	}
-
 	/*
 	 * the super is written, we can safely allow the tree-loggers
 	 * to go about their business
 	 */
 	mutex_unlock(&fs_info->tree_log_mutex);
+	if (ret)
+		goto scrub_continue;
 
 	btrfs_finish_extent_commit(trans, fs_info);
 
-- 
2.15.0

