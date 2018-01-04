Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbeADKGG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jan 2018 05:06:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w04A4wHY095267
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 10:06:05 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2f9j728057-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jan 2018 10:06:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w04A14lp015066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 10:01:04 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w04A14f3016979
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 10:01:04 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfS: collapse btrfs_handle_error() into __btrfs_handle_fs_error()
Date: Thu,  4 Jan 2018 18:01:55 +0800
Message-Id: <20180104100155.9160-2-anand.jain@oracle.com>
In-Reply-To: <20180104100155.9160-1-anand.jain@oracle.com>
References: <20180104100155.9160-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no other consumer for btrfs_handle_error() other than
__btrfs_handle_fs_error(), further this function quite small.
Merge it into its parent.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60766f8ca434..0216a5dd0f4b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -105,28 +105,6 @@ const char *btrfs_decode_error(int errno)
 	return errstr;
 }
 
-/* btrfs handle error by forcing the filesystem readonly */
-static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
-{
-	struct super_block *sb = fs_info->sb;
-
-	if (sb_rdonly(sb))
-		return;
-
-	sb->s_flags |= SB_RDONLY;
-	btrfs_info(fs_info, "forced readonly");
-	/*
-	 * Note that a running device replace operation is not
-	 * canceled here although there is no way to update
-	 * the progress. It would add the risk of a deadlock,
-	 * therefore the canceling is omitted. The only penalty
-	 * is that some I/O remains active until the procedure
-	 * completes. The next time when the filesystem is
-	 * mounted writeable again, the device replace
-	 * operation continues.
-	 */
-}
-
 /*
  * __btrfs_handle_fs_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -173,8 +151,25 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
 
 	/* Don't go through full error handling during mount */
-	if (sb->s_flags & SB_BORN)
-		btrfs_handle_error(fs_info);
+	if (!(sb->s_flags & SB_BORN))
+		return;
+
+	if (sb_rdonly(sb))
+		return;
+
+	/* btrfs handle error by forcing the filesystem readonly */
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
 
 #ifdef CONFIG_PRINTK
-- 
2.15.0

