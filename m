Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934004AbbEMDUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 23:20:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4D3IopV006845
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 11:18:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Qgroup: Do early check on snapshot create with qgroup_inherit.
Date: Wed, 13 May 2015 11:18:10 +0800
Message-ID: <1431487090-11885-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
When quota is enabled, and we pass invalid inherit to create a snapshot,
it will cause abort_transaction() and the filesystem is mounted as RO.

[CAUSE]
Unlike subvolume creation, snapshot creation is delayed until
commit_transaction(), making it too late to detect invalid
qgroup_inherit but only to abort transaction.

[FIX]
The fix is to check the qgroup_inherit() early before going to
create_snapshot().
Although this fix is not perfect as it doesn't completely kill the
possible concurrency to trigger abort_transaction().

Reported-by: Remi Rampin <remirampin@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c  | 14 ++++++++++++++
 fs/btrfs/qgroup.c | 55 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.h |  3 +++
 3 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b9..95494e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -846,6 +846,20 @@ static noinline int btrfs_mksubvol(struct path *parent,
 	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
 		goto out_up_read;
 
+	/*
+	 * FIXME: The check here is not perfect, as for create_snapshot(),
+	 * we should ensure the valid inherit is not changed during
+	 * qgroup_check_inherit() to create_pending_snapshots().
+	 *
+	 * Unforunately, we can't use qgroup_ioctl_lock, as
+	 * create_pending_snapshots() can be called async in
+	 * commit_transaction_async().
+	 */
+	error = btrfs_qgroup_check_inherit(BTRFS_I(dir)->root->fs_info,
+					   inherit, 0);
+	if (error)
+		goto out_up_read;
+
 	if (snap_src) {
 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 058c79e..4d822a0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2184,6 +2184,47 @@ out:
 }
 
 /*
+ * Check if the qgroup_inherit is valid.
+ *
+ * If no_ioctl_lock is set, this will not lock qgroup_ioctl_lock and caller
+ * should lock it correctly
+ */
+int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
+			       struct btrfs_qgroup_inherit *inherit,
+			       int no_ioctl_lock)
+{
+	struct btrfs_qgroup *qg;
+	int i;
+	int num;
+	int ret = 0;
+
+	if (!inherit || !fs_info->quota_enabled)
+		goto out_nolock;
+
+	if (!fs_info->quota_root) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!no_ioctl_lock)
+		mutex_lock(&fs_info->qgroup_ioctl_lock);
+	num = inherit->num_qgroups + 2 * inherit->num_ref_copies +
+	      2 * inherit->num_excl_copies;
+	for (i = 0; i < num; i++) {
+		qg = find_qgroup_rb(fs_info, inherit->qgroups[i]);
+		if (!qg) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+out:
+	if (!no_ioctl_lock)
+		mutex_unlock(&fs_info->qgroup_ioctl_lock);
+out_nolock:
+	return ret;
+}
+
+/*
  * copy the acounting information between qgroups. This is necessary when a
  * snapshot or a subvolume is created
  */
@@ -2210,17 +2251,9 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	}
 
 	if (inherit) {
-		i_qgroups = (u64 *)(inherit + 1);
-		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
-		       2 * inherit->num_excl_copies;
-		for (i = 0; i < nums; ++i) {
-			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
-			if (!srcgroup) {
-				ret = -EINVAL;
-				goto out;
-			}
-			++i_qgroups;
-		}
+		ret = btrfs_qgroup_check_inherit(fs_info, inherit, 1);
+		if (ret < 0)
+			goto out;
 	}
 
 	/*
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..9fdc085 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -92,6 +92,9 @@ void btrfs_remove_qgroup_operation(struct btrfs_trans_handle *trans,
 				   struct btrfs_qgroup_operation *oper);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
+int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
+			       struct btrfs_qgroup_inherit *inherit,
+			       int no_ioctl_lock);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
-- 
1.8.3.1

