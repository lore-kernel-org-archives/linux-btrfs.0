Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17162 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932953AbbA2C0D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:26:03 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T2PJSs026486
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 10:25:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND v4 8/8] btrfs: Use mnt_want_write() to protect sysfs feature change.
Date: Thu, 29 Jan 2015 10:24:41 +0800
Message-ID: <1422498281-20493-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like label change, use mnt_want_write() to do a correct protection.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index cdfa6b9..71e50ba 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -113,6 +113,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
 	struct btrfs_trans_handle *trans;
+	struct vfsmount *vfsmount;
 	u64 features, set, clear;
 	unsigned long val;
 	int ret;
@@ -154,9 +155,20 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
+	vfsmount = get_vfsmount_sb(fs_info->sb);
+	if (!vfsmount)
+		return -EINVAL;
+
+	ret = mnt_want_write(vfsmount);
+	if (ret) {
+		mntput(vfsmount);
+		return ret;
+	}
 	trans = btrfs_start_transaction(fs_info->fs_root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	spin_lock(&fs_info->super_lock);
 	features = get_features(fs_info, fa->feature_set);
@@ -168,10 +180,13 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	spin_unlock(&fs_info->super_lock);
 
 	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
-	if (ret)
-		return ret;
 
-	return count;
+out:
+	mnt_drop_write(vfsmount);
+	mntput(vfsmount);
+	if (!ret)
+		return count;
+	return ret;
 }
 
 static umode_t btrfs_feature_visible(struct kobject *kobj,
-- 
2.2.2

