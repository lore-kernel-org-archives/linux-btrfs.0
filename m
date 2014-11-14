Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbaKNKdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:19 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 09B17AD1E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 10:33:18 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/6] btrfs: move commit out of sysfs when changing features
Date: Fri, 14 Nov 2014 11:33:17 +0100
Message-Id: <0eae2747ec1ddcef5018827bce8f7d33b7d920e1.1415894838.git.dsterba@suse.cz>
In-Reply-To: <cover.1415894837.git.dsterba@suse.cz>
References: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index b2e7bb4393f6..226f7261533a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -111,7 +111,6 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
-	struct btrfs_trans_handle *trans;
 	u64 features, set, clear;
 	unsigned long val;
 	int ret;
@@ -153,10 +152,6 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
-	trans = btrfs_start_transaction(fs_info->fs_root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
 	spin_lock(&fs_info->super_lock);
 	features = get_features(fs_info, fa->feature_set);
 	if (val)
@@ -166,9 +161,11 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	set_features(fs_info, fa->feature_set, features);
 	spin_unlock(&fs_info->super_lock);
 
-	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
-	if (ret)
-		return ret;
+	/*
+	 * We don't want to do full transaction commit from inside sysfs
+	 */
+	btrfs_set_pending(fs_info, COMMIT);
+	wake_up_process(fs_info->transaction_kthread);
 
 	return count;
 }
-- 
1.8.4.5

