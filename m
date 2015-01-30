Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29041 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760101AbbA3JXO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 04:23:14 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0U9MMnt028867
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 17:22:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 9/9] btrfs: Use sb_want_write() to protect sysfs feature change.
Date: Fri, 30 Jan 2015 17:20:54 +0800
Message-ID: <1422609654-19519-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like label change, use sb_want_write() to do a correct protection.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v4:
  Newly introduced.
v5:
  Change to sb_want_write().
---
 fs/btrfs/sysfs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3218245..64f876e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -154,9 +154,15 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
+	ret = sb_want_write(fs_info->sb);
+	if (ret)
+		return ret;
+
 	trans = btrfs_start_transaction(fs_info->fs_root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	spin_lock(&fs_info->super_lock);
 	features = get_features(fs_info, fa->feature_set);
@@ -168,10 +174,12 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	spin_unlock(&fs_info->super_lock);
 
 	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
-	if (ret)
-		return ret;
 
-	return count;
+out:
+	sb_drop_write(fs_info->sb);
+	if (!ret)
+		return count;
+	return ret;
 }
 
 static umode_t btrfs_feature_visible(struct kobject *kobj,
-- 
2.2.2

