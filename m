Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbeADNHl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jan 2018 08:07:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w04D7Y4D026401
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 13:07:41 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2f9kvpg6w8-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jan 2018 13:07:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w04A13P0031695
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 10:01:03 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w04A13q1028298
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 10:01:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove check for BTRFS_FS_STATE_ERROR which we just set
Date: Thu,  4 Jan 2018 18:01:54 +0800
Message-Id: <20180104100155.9160-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_handle_fs_error() sets BTRFS_FS_STATE_ERROR, and calls
btrfs_handle_error() so no need to check if the BTRFS_FS_STATE_ERROR
is set in btrfs_handle_error(). And there is no other user of
btrfs_handle_error() as well.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4c49bb5632a2..60766f8ca434 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -113,20 +113,18 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	if (sb_rdonly(sb))
 		return;
 
-	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
-		sb->s_flags |= SB_RDONLY;
-		btrfs_info(fs_info, "forced readonly");
-		/*
-		 * Note that a running device replace operation is not
-		 * canceled here although there is no way to update
-		 * the progress. It would add the risk of a deadlock,
-		 * therefore the canceling is omitted. The only penalty
-		 * is that some I/O remains active until the procedure
-		 * completes. The next time when the filesystem is
-		 * mounted writeable again, the device replace
-		 * operation continues.
-		 */
-	}
+	sb->s_flags |= SB_RDONLY;
+	btrfs_info(fs_info, "forced readonly");
+	/*
+	 * Note that a running device replace operation is not
+	 * canceled here although there is no way to update
+	 * the progress. It would add the risk of a deadlock,
+	 * therefore the canceling is omitted. The only penalty
+	 * is that some I/O remains active until the procedure
+	 * completes. The next time when the filesystem is
+	 * mounted writeable again, the device replace
+	 * operation continues.
+	 */
 }
 
 /*
-- 
2.15.0

