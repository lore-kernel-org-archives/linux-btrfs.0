Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39937 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/12] btrfs: factor btrfs_balance_init() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:39 -0500
Message-Id: <1406934766-16974-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b95635f..8c7113b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2145,6 +2145,17 @@ static void btrfs_scrub_init(struct btrfs_fs_info *fs_info)
 	fs_info->scrub_workers_refcnt = 0;
 }
 
+static void btrfs_balance_init(struct btrfs_fs_info *fs_info)
+{
+	spin_lock_init(&fs_info->balance_lock);
+	mutex_init(&fs_info->balance_mutex);
+	atomic_set(&fs_info->balance_running, 0);
+	atomic_set(&fs_info->balance_pause_req, 0);
+	atomic_set(&fs_info->balance_cancel_req, 0);
+	fs_info->balance_ctl = NULL;
+	init_waitqueue_head(&fs_info->balance_wait_q);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2297,14 +2308,7 @@ int open_ctree(struct super_block *sb,
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	fs_info->check_integrity_print_mask = 0;
 #endif
-
-	spin_lock_init(&fs_info->balance_lock);
-	mutex_init(&fs_info->balance_mutex);
-	atomic_set(&fs_info->balance_running, 0);
-	atomic_set(&fs_info->balance_pause_req, 0);
-	atomic_set(&fs_info->balance_cancel_req, 0);
-	fs_info->balance_ctl = NULL;
-	init_waitqueue_head(&fs_info->balance_wait_q);
+	btrfs_balance_init(fs_info);
 	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
 
 	sb->s_blocksize = 4096;
-- 
1.7.1

