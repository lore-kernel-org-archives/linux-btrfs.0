Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42399 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbbATJHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:48 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 5/5] Revert "btrfs: move commit out of sysfs when changing features"
Date: Tue, 20 Jan 2015 17:05:37 +0800
Message-ID: <1421744737-16586-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 0eae2747ec1dd ("btrfs: move commit out of sysfs
when changing features").

Unlike most btrfs file operations, sysfs don't go through the normal
open/read/write routine which will initiate a sb_start_*write/read.

This is very dangerous on frozen btrfs, if using the pending changes
method, sysfs change can make fs_info->pending_changes to 1, and later
sync_fs() call will cause deadlock.

So revert the patch to deal the deadlock caused by the following workload:
freeze() -> change features -> sync() -> unfreeze()

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 226f726..b2e7bb4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -111,6 +111,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
+	struct btrfs_trans_handle *trans;
 	u64 features, set, clear;
 	unsigned long val;
 	int ret;
@@ -152,6 +153,10 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
+	trans = btrfs_start_transaction(fs_info->fs_root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	spin_lock(&fs_info->super_lock);
 	features = get_features(fs_info, fa->feature_set);
 	if (val)
@@ -161,11 +166,9 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	set_features(fs_info, fa->feature_set, features);
 	spin_unlock(&fs_info->super_lock);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
+	if (ret)
+		return ret;
 
 	return count;
 }
-- 
2.2.2

