Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29076 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdIWAiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 20:38:10 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8N0c99j011400
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Sep 2017 00:38:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8N0c8Y5002066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Sep 2017 00:38:08 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8N0c8eD024676
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Sep 2017 00:38:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use self-explaining variable
Date: Fri, 22 Sep 2017 17:36:18 -0600
Message-Id: <20170922233618.20034-1-bo.li.liu@oracle.com>
In-Reply-To: <20170913182521.31304-1-bo.li.liu@oracle.com>
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This uses a bool 'do_backup' to help understand this piece of code.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
This is based on a patch "Btrfs: do not backup tree roots when fsync".

 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cdb7043..9811b9d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3691,6 +3691,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	int max_errors;
 	int total_errors = 0;
 	u64 flags;
+	bool do_backup = (max_mirrors == 0);
 
 	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
 
@@ -3699,7 +3700,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	 * not from fsync where the tree roots in fs_info have not
 	 * been consistent on disk.
 	 */
-	if (max_mirrors == 0)
+	if (do_backup)
 		backup_super_roots(fs_info);
 
 	sb = fs_info->super_for_commit;
-- 
2.9.4

