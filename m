Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753583AbeAaIwH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 03:52:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A1EBAC2C
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 08:52:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable
Date: Wed, 31 Jan 2018 10:52:04 +0200
Message-Id: <1517388724-1483-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_run_qgroups is doing a bit too much. Not only is it
responsible for synchronizing in-memory state of qgroups to disk but
it also contains code to trigger the initial qgroup rescan when
quota is enabled initially. This condition is detected by checking that
BTRFS_FS_QUOTA_ENABLED is not set and BTRFS_FS_QUOTA_ENABLING is set.
Nothing really requires fro the code to be structured (and scattered)
the way it is so let's streamline things. First move the quota rescan
code into btrfs_quota_enable, where its invocation is closer to the
user. This also makes the FS_QUOTA_ENABLING flag redundant so let's
remove it as well.i

This has been tested with a full xfstest run with qgroups enabled on
the scratch device of every xfstest and no regressions were observed.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h  |  1 -
 fs/btrfs/qgroup.c | 35 ++++++++++-------------------------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a462ab85c49..83b645920aba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -707,7 +707,6 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_LOG_RECOVERING			4
 #define BTRFS_FS_OPEN				5
 #define BTRFS_FS_QUOTA_ENABLED			6
-#define BTRFS_FS_QUOTA_ENABLING			7
 #define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
 #define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
 #define BTRFS_FS_BTREE_ERR			11
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f822152693a4..5b446d1bb22d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -826,10 +826,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	int slot;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	if (fs_info->quota_root) {
-		set_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags);
+	if (fs_info->quota_root)
 		goto out;
-	}
 
 	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
 	if (!fs_info->qgroup_ulist) {
@@ -923,8 +921,15 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	}
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
-	set_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags);
+	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
+	ret = qgroup_rescan_init(fs_info, 0, 1);
+	if (!ret) {
+	        qgroup_rescan_zero_tracking(fs_info);
+	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
+	                         &fs_info->qgroup_rescan_work);
+	}
+
 out_free_path:
 	btrfs_free_path(path);
 out_free_root:
@@ -2077,17 +2082,9 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
-	int start_rescan_worker = 0;
 
 	if (!quota_root)
-		goto out;
-
-	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    test_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags))
-		start_rescan_worker = 1;
-
-	if (test_and_clear_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags))
-		set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+		return ret;
 
 	spin_lock(&fs_info->qgroup_lock);
 	while (!list_empty(&fs_info->dirty_qgroups)) {
@@ -2116,18 +2113,6 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 	if (ret)
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 
-	if (!ret && start_rescan_worker) {
-		ret = qgroup_rescan_init(fs_info, 0, 1);
-		if (!ret) {
-			qgroup_rescan_zero_tracking(fs_info);
-			btrfs_queue_work(fs_info->qgroup_rescan_workers,
-					 &fs_info->qgroup_rescan_work);
-		}
-		ret = 0;
-	}
-
-out:
-
 	return ret;
 }
 
-- 
2.7.4

