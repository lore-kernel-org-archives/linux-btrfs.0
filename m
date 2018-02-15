Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754495AbeBODem (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 22:34:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1F3Qaje053269
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 03:34:41 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2g51yu024w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 03:34:41 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1F3Yfix016889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 03:34:41 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1F3Ye7B017482
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 03:34:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove unused function btrfs_async_submit_limit()
Date: Thu, 15 Feb 2018 11:36:07 +0800
Message-Id: <20180215033607.14236-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit [1] removed the need to use btrfs_async_submit_limit(), so
delete it.

[1]
 commit 736cd52e0c720103f52ab9da47b6cc3af6b083f6
  Btrfs: remove nr_async_submits and async_submit_draining

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 8 --------
 fs/btrfs/disk-io.h | 1 -
 2 files changed, 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index aca906971abe..c412ad1f103b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -709,14 +709,6 @@ blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 	return 0;
 }
 
-unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
-{
-	unsigned long limit = min_t(unsigned long,
-				    info->thread_pool_size,
-				    info->fs_devices->open_devices);
-	return 256 * limit;
-}
-
 static void run_one_async_start(struct btrfs_work *work)
 {
 	struct async_submit_bio *async;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 301151a50ac1..e2ac6a14150a 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -133,7 +133,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			u64 bio_offset, void *private_data,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
-unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
 void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
-- 
2.15.0

