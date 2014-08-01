Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39934 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbaHAXMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:48 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/12] btrfs: factor btrfs_scrub_init() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:38 -0500
Message-Id: <1406934766-16974-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 28d35a8..b95635f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2134,6 +2134,17 @@ void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
 	}
 }
 
+static void btrfs_scrub_init(struct btrfs_fs_info *fs_info)
+{
+	mutex_init(&fs_info->scrub_lock);
+	atomic_set(&fs_info->scrubs_running, 0);
+	atomic_set(&fs_info->scrub_pause_req, 0);
+	atomic_set(&fs_info->scrubs_paused, 0);
+	atomic_set(&fs_info->scrub_cancel_req, 0);
+	init_waitqueue_head(&fs_info->scrub_pause_wait);
+	fs_info->scrub_workers_refcnt = 0;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2281,14 +2292,8 @@ int open_ctree(struct super_block *sb,
 	}
 	btrfs_init_delayed_root(fs_info->delayed_root);
 
-	mutex_init(&fs_info->scrub_lock);
-	atomic_set(&fs_info->scrubs_running, 0);
-	atomic_set(&fs_info->scrub_pause_req, 0);
-	atomic_set(&fs_info->scrubs_paused, 0);
-	atomic_set(&fs_info->scrub_cancel_req, 0);
+	btrfs_scrub_init(fs_info);
 	init_waitqueue_head(&fs_info->replace_wait);
-	init_waitqueue_head(&fs_info->scrub_pause_wait);
-	fs_info->scrub_workers_refcnt = 0;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	fs_info->check_integrity_print_mask = 0;
 #endif
-- 
1.7.1

