Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39941 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/12] btrfs: factor btrfs_qgroup_init() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:42 -0500
Message-Id: <1406934766-16974-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a5fa84f..47fcacf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2195,6 +2195,20 @@ static void btrfs_dev_replace_locks_init(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->dev_replace.lock);
 }
 
+static void btrfs_qgroup_init(struct btrfs_fs_info *fs_info)
+{
+	spin_lock_init(&fs_info->qgroup_lock);
+	mutex_init(&fs_info->qgroup_ioctl_lock);
+	fs_info->qgroup_tree = RB_ROOT;
+	fs_info->qgroup_op_tree = RB_ROOT;
+	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
+	fs_info->qgroup_seq = 1;
+	fs_info->quota_enabled = 0;
+	fs_info->pending_quota_state = 0;
+	fs_info->qgroup_ulist = NULL;
+	mutex_init(&fs_info->qgroup_rescan_lock);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2381,17 +2395,7 @@ int open_ctree(struct super_block *sb,
 	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
 
 	btrfs_dev_replace_locks_init(fs_info);
-
-	spin_lock_init(&fs_info->qgroup_lock);
-	mutex_init(&fs_info->qgroup_ioctl_lock);
-	fs_info->qgroup_tree = RB_ROOT;
-	fs_info->qgroup_op_tree = RB_ROOT;
-	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
-	fs_info->qgroup_seq = 1;
-	fs_info->quota_enabled = 0;
-	fs_info->pending_quota_state = 0;
-	fs_info->qgroup_ulist = NULL;
-	mutex_init(&fs_info->qgroup_rescan_lock);
+	btrfs_qgroup_init(fs_info);
 
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
-- 
1.7.1

