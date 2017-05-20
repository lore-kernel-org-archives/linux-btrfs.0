Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38645 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755635AbdETIjU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:39:20 -0400
Received: by mail-it0-f45.google.com with SMTP id r63so1904141itc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:39:19 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id b10sm4958799iod.33.2017.05.20.01.39.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:39:14 -0700 (PDT)
Date: Sat, 20 May 2017 08:39:12 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] btrfs: Split up btrfs_create_qgroup, no logic changes
Message-ID: <20170520083911.GA4213@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

This change is purely a style change, so that btrfs_create_qgroup is
split. There is some whitespace changes, but this shouldn't have any
effect on the logic of the code.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7e772ba..588248b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1247,24 +1247,21 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+/* Must be called with qgroup_ioctl_lock held */
+static int __btrfs_create_qgroup(struct btrfs_trans_handle *trans,
+				 struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	int ret = 0;
+	int ret;
 
-	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
-	if (!quota_root) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!quota_root)
+		return -EINVAL;
+
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
-	if (qgroup) {
-		ret = -EEXIST;
-		goto out;
-	}
+	if (qgroup)
+		return -EEXIST;
 
 	ret = add_qgroup_item(trans, quota_root, qgroupid);
 	if (ret)
@@ -1277,7 +1274,18 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 	if (IS_ERR(qgroup))
 		ret = PTR_ERR(qgroup);
 out:
+	return ret;
+}
+
+int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info, u64 qgroupid)
+{
+	int ret;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	ret = __btrfs_create_qgroup(trans, fs_info, qgroupid);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
 	return ret;
 }
 
-- 
2.9.3

