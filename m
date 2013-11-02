Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61068 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3KBPOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 11:14:47 -0400
Received: by mail-pb0-f45.google.com with SMTP id ma3so5457584pbc.18
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 08:14:46 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, wangsl.fnst@cn.fujitsu.com
Subject: [RFC PATCH 2/2] Btrfs: remove subvolume qgroup automatically with qgroup enabled
Date: Sat,  2 Nov 2013 23:14:33 +0800
Message-Id: <1383405273-27304-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1383405273-27304-1-git-send-email-wangshilong1991@gmail.com>
References: <1383405273-27304-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

When we delete subvolume, the corresponding qgroup will be dead,
because Qgroupid/Subvolumeid is not resued.

Qgroup accounting will also be triggered to update subvolume qgroup's
parent qgroup's referenced size.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  |  2 ++
 fs/btrfs/ioctl.c  |  5 ++++-
 fs/btrfs/qgroup.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 941019d..19a6575 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3997,6 +3997,8 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 			char *name);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 qgroupid);
+int btrfs_remove_subvolume_qgroup(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 qgroupid,
 		       struct btrfs_qgroup_limit *limit);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6523108..fdff50d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2250,7 +2250,10 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			goto out_end_trans;
 		}
 	}
-
+	ret = btrfs_remove_subvolume_qgroup(trans, root->fs_info,
+					dest->root_key.objectid);
+	if (ret)
+		btrfs_abort_transaction(trans, root, ret);
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 32bedb5..9e9dba9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1985,3 +1985,68 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 		btrfs_queue_worker(&fs_info->qgroup_rescan_workers,
 				   &fs_info->qgroup_rescan_work);
 }
+
+int btrfs_remove_subvolume_qgroup(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *fs_info,
+				  u64 qgroupid)
+{
+	struct btrfs_root *quota_root;
+	struct btrfs_qgroup *qgroup;
+	struct btrfs_qgroup_list *list;
+	int ret = 0;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	quota_root = fs_info->quota_root;
+	if (!quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	qgroup = find_qgroup_rb(fs_info, qgroupid);
+	if (!qgroup) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	list_for_each_entry(list, &qgroup->groups, next_group) {
+		ret = del_qgroup_relation_item(trans, quota_root, qgroupid,
+						list->group->qgroupid);
+		if (ret && ret != -ENOENT)
+			goto out;
+		ret = del_qgroup_relation_item(trans, quota_root,
+					list->group->qgroupid, qgroupid);
+		if (ret && ret != -ENOENT)
+			goto out;
+	}
+
+	/*
+	 * this should not happen with strict hierarchical level
+	 * qgroup.
+	 */
+	list_for_each_entry(list, &qgroup->members, next_group) {
+		ret = del_qgroup_relation_item(trans, quota_root,
+					list->member->qgroupid, qgroupid);
+		if (ret && ret != -ENOENT)
+			goto out;
+		ret = del_qgroup_relation_item(trans, quota_root,
+					qgroupid, list->member->qgroupid);
+		if (ret && ret != -ENOENT)
+			goto out;
+	}
+	ret = del_qgroup_item(trans, quota_root, qgroupid);
+	if (ret && ret != -ENOENT)
+		goto out;
+	spin_lock(&fs_info->qgroup_lock);
+	ret = qgroup_account_ref_step2(quota_root->fs_info,
+				quota_root->fs_info->qgroup_ulist, -1,
+				qgroup->rfer, qgroup);
+	del_qgroup_rb(quota_root->fs_info, qgroupid);
+	spin_unlock(&fs_info->qgroup_lock);
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (ret == -ENOENT)
+		ret = 0;
+	return ret;
+
+}
+
-- 
1.7.11.7

