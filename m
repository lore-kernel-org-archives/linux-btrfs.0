Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54217 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab3BGVBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 16:01:46 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7183F7C040A
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2013 14:01:46 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id CCWICE9JKm7zAfVk (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2013 14:01:45 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: steal from global reserve if we are cleaning up orphans
Date: Thu, 7 Feb 2013 16:08:38 -0500
Message-ID: <1360271318-17721-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes xfstest 83 will fail to remount the scratch device because we've
gotten ourselves so full that we cannot cleanup the orphan items.  In this
case check to see if we're doing the orphan cleanup and if we are allow us
to steal our reservation from the global block rsv.  With this patch I've
not been able to reproduce the failed mount problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    5 +++++
 fs/btrfs/extent-tree.c |   10 ++++++++++
 fs/btrfs/inode.c       |    5 -----
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 50d1be9..2b68f88 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1237,6 +1237,11 @@ struct seq_list {
 	u64 seq;
 };
 
+enum btrfs_orphan_cleanup_state {
+	ORPHAN_CLEANUP_STARTED	= 1,
+	ORPHAN_CLEANUP_DONE	= 2,
+};
+
 /* fs_info */
 struct reloc_control;
 struct btrfs_device;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 53c2898..8dbb45c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4099,6 +4099,16 @@ again:
 		goto again;
 
 out:
+	if (ret == -ENOSPC &&
+	    unlikely(root->orphan_cleanup_state == ORPHAN_CLEANUP_STARTED)) {
+		struct btrfs_block_rsv *global_rsv =
+			&root->fs_info->global_block_rsv;
+
+		if (block_rsv != global_rsv &&
+		    !btrfs_block_rsv_migrate(global_rsv, block_rsv,
+					     orig_bytes))
+			ret = 0;
+	}
 	if (flushing) {
 		spin_lock(&space_info->lock);
 		space_info->flush = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 44d95d1..73e9409 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2218,11 +2218,6 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 	}
 }
 
-enum btrfs_orphan_cleanup_state {
-	ORPHAN_CLEANUP_STARTED	= 1,
-	ORPHAN_CLEANUP_DONE	= 2,
-};
-
 /*
  * This is called in transaction commit time. If there are no orphan
  * files in the subvolume, it removes orphan item and frees block_rsv
-- 
1.7.7.6

