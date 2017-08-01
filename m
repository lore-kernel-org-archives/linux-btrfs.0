Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44562 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdHARP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:57 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFurV012825
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFtXQ024950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFtO1032293
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/14] Btrfs: raid56: initialize raid5/6 log after adding it
Date: Tue,  1 Aug 2017 10:14:36 -0600
Message-Id: <20170801161439.13426-14-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to initialize the raid5/6 log after adding it, but we don't
want to race with concurrent writes.  So we initialize it before
assigning the log pointer in %fs_info.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/raid56.c  | 18 ++++++++++++++++--
 fs/btrfs/raid56.h  |  3 ++-
 fs/btrfs/volumes.c |  2 ++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c2d8697..3fbd347 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3000,7 +3000,7 @@ int open_ctree(struct super_block *sb,
 		 * write-ahead log, the fsync'd data will never ends
 		 * up with being replayed by raid56 log.
 		 */
-		btrfs_r5l_load_log(fs_info, cp);
+		btrfs_r5l_load_log(fs_info, NULL, cp);
 	}
 
 	ret = btrfs_recover_balance(fs_info);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0bfc97a..b771d7d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1943,14 +1943,28 @@ static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
 }
 
 /* return 0 if success, otherwise return errors */
-int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp)
+int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, struct btrfs_r5l_log *r5log, u64 cp)
 {
-	struct btrfs_r5l_log *log = fs_info->r5log;
+	struct btrfs_r5l_log *log;
 	struct page *page;
 	struct btrfs_r5l_meta_block *mb;
 	bool create_new = false;
 	int ret;
 
+	if (r5log)
+		ASSERT(fs_info->r5log == NULL);
+	if (fs_info->r5log)
+		ASSERT(r5log == NULL);
+
+	if (fs_info->r5log)
+		log = fs_info->r5log;
+	else
+		/*
+		 * this only happens when adding the raid56 log for
+		 * the first time.
+		 */
+		log = r5log;
+
 	ASSERT(log);
 
 	page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index f6d6f36..2cc64a3 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -140,5 +140,6 @@ struct btrfs_r5l_log * btrfs_r5l_init_log_prepare(struct btrfs_fs_info *fs_info,
 void btrfs_r5l_init_log_post(struct btrfs_fs_info *fs_info,
 			     struct btrfs_r5l_log *log);
 int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device);
-int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp);
+int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info,
+		       struct btrfs_r5l_log *r5log, u64 cp);
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 851c001..7f848d7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2521,6 +2521,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	}
 
 	if (is_r5log) {
+		/* initialize r5log with cp == 0. */
+		btrfs_r5l_load_log(fs_info, r5log, 0);
 		btrfs_r5l_init_log_post(fs_info, r5log);
 	}
 
-- 
2.9.4

