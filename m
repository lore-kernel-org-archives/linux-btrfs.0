Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31778 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdIMT1I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 15:27:08 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8DJR73m007629
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:27:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8DJR7Ce006467
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:27:07 GMT
Received: from ubhmp0007.oracle.com (ubhmp0007.oracle.com [156.151.24.60])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8DJR7AO003596
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:27:07 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not backup tree roots when fsync
Date: Wed, 13 Sep 2017 12:25:21 -0600
Message-Id: <20170913182521.31304-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It doens't make sense to backup tree roots when doing fsync, since
during fsync those tree roots have not been consistent on disk.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 79ac228..a145a88 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3668,7 +3668,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	u64 flags;
 
 	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
-	backup_super_roots(fs_info);
+
+	/*
+	 * max_mirrors == 0 indicates we're from commit_transaction,
+	 * not from fsync where the tree roots in fs_info have not
+	 * been consistent on disk.
+	 */
+	if (max_mirrors == 0)
+		backup_super_roots(fs_info);
 
 	sb = fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
-- 
2.9.4

