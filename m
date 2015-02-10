Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754985AbbBJK1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:25 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQc6j000929
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:38 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: qgroup: allow to remove qgroup which has parent but no child.
Date: Tue, 10 Feb 2015 18:24:04 +0800
Message-ID: <1423563845-9103-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a qgroup has parents but no child, it should be removable in
Theory I think. But currently, we can not remove it when it has
either parent or child.

Example:
	# btrfs quota enable /mnt
	# btrfs qgroup create 1/0 /mnt
	# btrfs qgroup create 2/0 /mnt
	# btrfs qgroup assign 1/0 2/0 /mnt
	# btrfs qgroup show -pcre /mnt
qgroupid rfer  excl  max_rfer max_excl parent  child
-------- ----  ----  -------- -------- ------  -----
0/5      16384 16384 0        0        ---     ---
1/0      0     0     0        0        2/0     ---
2/0      0     0     0        0        ---     1/0

At this time, there is no subvol or qgroup depending on it.
Just a qgroup 2/0 is its parent, but 2/0 can work well without
1/0. So I think 1/0 should be removalbe. But:
	# btrfs qgroup destroy 1/0 /mnt
ERROR: unable to destroy quota group: Device or resource busy

This patch remove the check of qgroup->parent in removing it,
then we can remove a qgroup when it has a parent.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d519055..28b0aa5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1062,7 +1062,7 @@ out:
 	return ret;
 }
 
-int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
+int __del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
 	struct btrfs_root *quota_root;
@@ -1072,7 +1072,6 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int err;
 
-	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
 	if (!quota_root) {
 		ret = -EINVAL;
@@ -1103,7 +1102,18 @@ exist:
 	del_relation_rb(fs_info, src, dst);
 	spin_unlock(&fs_info->qgroup_lock);
 out:
+	return ret;
+}
+
+int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
+{
+	int ret = 0;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	ret = __del_qgroup_relation(trans, fs_info, src, dst);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
 	return ret;
 }
 
@@ -1146,6 +1156,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_list *list;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
@@ -1160,15 +1171,24 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 		ret = -ENOENT;
 		goto out;
 	} else {
-		/* check if there are no relations to this qgroup */
-		if (!list_empty(&qgroup->groups) ||
-		    !list_empty(&qgroup->members)) {
+		/* check if there are no children of this qgroup */
+		if (!list_empty(&qgroup->members)) {
 			ret = -EBUSY;
 			goto out;
 		}
 	}
 	ret = del_qgroup_item(trans, quota_root, qgroupid);
 
+	while (!list_empty(&qgroup->groups)) {
+		list = list_first_entry(&qgroup->groups,
+					struct btrfs_qgroup_list, next_group);
+		ret = __del_qgroup_relation(trans, fs_info,
+					   qgroupid,
+					   list->group->qgroupid);
+		if (ret)
+			goto out;
+	}
+
 	spin_lock(&fs_info->qgroup_lock);
 	del_qgroup_rb(quota_root->fs_info, qgroupid);
 	spin_unlock(&fs_info->qgroup_lock);
-- 
1.8.4.2

