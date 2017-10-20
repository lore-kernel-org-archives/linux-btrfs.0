Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37178 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbdJUAnv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 20:43:51 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L0hoJw016871
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:43:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9L0hooE012694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:43:50 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L0hoTZ030549
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:43:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid deadlock in btrfs_async_run_delayed_root
Date: Fri, 20 Oct 2017 17:40:12 -0600
Message-Id: <20171020234012.9929-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here %path is set with ->leave_spinning=1, thus it'll hold the rwlock
after btrfs_search_slot(), however, when processing delayed items in
__btrfs_commit_inode_delayed_items(), it goes to acquire node->mutex
which might sleep, that is, it may sleep under spin_lock.

Given node->mutex is necessary to avoid race between async works, this
remove the ->leave_spining setting.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 19e4ad2..a857a2f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1331,7 +1331,6 @@ static void btrfs_async_run_delayed_root(struct btrfs_work *work)
 	if (!delayed_node)
 		goto free_path;
 
-	path->leave_spinning = 1;
 	root = delayed_node->root;
 
 	trans = btrfs_join_transaction(root);
-- 
2.9.4

