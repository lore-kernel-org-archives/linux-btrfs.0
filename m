Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50701 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdGMXBv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 19:01:51 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6DN1oC9015872
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 23:01:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6DN1oiI025318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 23:01:50 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6DN1n9N020610
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 23:01:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix unexpected return value of bio_readpage_error
Date: Thu, 13 Jul 2017 15:00:50 -0700
Message-Id: <20170713220050.22720-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With blk_status_t, in bio_readpage_error() may return 1 as now
->submit_bio_hook() may not set %ret if it runs without problem.

This fixes that unexpected return value by changing
btrfs_check_repairable() to return a bool instead of updating %ret.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 12 ++++++------
 fs/btrfs/extent_io.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 556484c..098c319 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2258,7 +2258,7 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 	return 0;
 }
 
-int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 			   struct io_failure_record *failrec, int failed_mirror)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -2274,7 +2274,7 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 		btrfs_debug(fs_info,
 			"Check Repairable: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d",
 			num_copies, failrec->this_mirror, failed_mirror);
-		return 0;
+		return false;
 	}
 
 	/*
@@ -2315,10 +2315,10 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 		btrfs_debug(fs_info,
 			"Check Repairable: (fail) num_copies=%d, next_mirror %d, failed_mirror %d",
 			num_copies, failrec->this_mirror, failed_mirror);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 
@@ -2382,8 +2382,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	if (ret)
 		return ret;
 
-	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
-	if (!ret) {
+	if (!btrfs_check_repairable(inode, failed_bio, failrec,
+				    failed_mirror)) {
 		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3fb8513..4f03091 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -539,8 +539,8 @@ void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start,
 		u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
-int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
-			   struct io_failure_record *failrec, int fail_mirror);
+bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+			    struct io_failure_record *failrec, int fail_mirror);
 struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
-- 
2.9.4

