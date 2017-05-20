Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36854 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755602AbdETIiz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:38:55 -0400
Received: by mail-it0-f48.google.com with SMTP id o5so130128321ith.1
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:38:55 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id y7sm11684495itc.27.2017.05.20.01.38.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:38:54 -0700 (PDT)
Date: Sat, 20 May 2017 08:38:53 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] btrfs: Split up btrfs_remove_qgroup, no logic changes
Message-ID: <20170520083851.GA4195@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

This change is purely a style change, so that btrfs_remove_qgroup is
split. There is some whitespace changes, but this shouldn't have any
effect on the logic of the code.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.c | 49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deffbeb..a2add44 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1281,40 +1281,35 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+/* Must be called with qgroup_ioctl_lock held */
+static int __btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
+				 struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
+	struct btrfs_qgroup_list *list;
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup_list *list;
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
 
 	qgroup = find_qgroup_rb(fs_info, qgroupid);
-	if (!qgroup) {
-		ret = -ENOENT;
-		goto out;
-	} else {
-		/* check if there are no children of this qgroup */
-		if (!list_empty(&qgroup->members)) {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
+	if (!qgroup)
+		return -ENOENT;
+
+	/* check if there are no children of this qgroup */
+	if (!list_empty(&qgroup->members))
+		return -EBUSY;
+
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, fs_info,
-					   qgroupid,
-					   list->group->qgroupid);
+					    qgroupid,
+					    list->group->qgroupid);
 		if (ret)
 			goto out;
 	}
@@ -1322,8 +1317,20 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	spin_lock(&fs_info->qgroup_lock);
 	del_qgroup_rb(fs_info, qgroupid);
 	spin_unlock(&fs_info->qgroup_lock);
+
 out:
+	return ret;
+}
+
+int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info, u64 qgroupid)
+{
+	int ret;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	ret = __btrfs_remove_qgroup(trans, fs_info, qgroupid);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
 	return ret;
 }
 
-- 
2.9.3

