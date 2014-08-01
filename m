Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39940 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/12] btrfs: factor btrfs_dev_replace_locks_init() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:41 -0500
Message-Id: <1406934766-16974-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6636386..a5fa84f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2186,6 +2186,15 @@ static void btrfs_btree_inode_init(struct btrfs_fs_info *fs_info,
 	btrfs_insert_inode_hash(fs_info->btree_inode);
 }
 
+static void btrfs_dev_replace_locks_init(struct btrfs_fs_info *fs_info)
+{
+	fs_info->dev_replace.lock_owner = 0;
+	atomic_set(&fs_info->dev_replace.nesting_level, 0);
+	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
+	mutex_init(&fs_info->dev_replace.lock_management_lock);
+	mutex_init(&fs_info->dev_replace.lock);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2370,11 +2379,8 @@ int open_ctree(struct super_block *sb,
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
 	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
-	fs_info->dev_replace.lock_owner = 0;
-	atomic_set(&fs_info->dev_replace.nesting_level, 0);
-	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
-	mutex_init(&fs_info->dev_replace.lock_management_lock);
-	mutex_init(&fs_info->dev_replace.lock);
+
+	btrfs_dev_replace_locks_init(fs_info);
 
 	spin_lock_init(&fs_info->qgroup_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
-- 
1.7.1

