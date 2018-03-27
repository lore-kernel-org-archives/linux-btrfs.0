Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35533 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752026AbeC0HHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C169F48AE76C
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 06/10] btrfs-progs: undelete-subvol: introduce link_subvol_to_lostfound
Date: Tue, 27 Mar 2018 15:06:54 +0800
Message-ID: <20180327070658.13064-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will create lost+found directory, link the deleted
subvolume specified by the subvol_id to the directory, update the
information of root_item and cleanup the associated orphan item.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 undelete-subvol.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/undelete-subvol.c b/undelete-subvol.c
index 781057df2b84..9243e35545c5 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -106,3 +106,79 @@ out:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Recover a subvolume specified by subvol_id, and link it to the lost+found
+ * directory.
+ *
+ * @root: the root of the root tree.
+ * @subvol_id: specify the subvolume which will be linked, and also be the part
+ * of the subvolume name.
+ *
+ * Return 0 if no error occurred.
+ */
+static int link_subvol_to_lostfound(struct btrfs_root *root, u64 subvol_id)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *fs_root = fs_info->fs_root;
+	char buf[BTRFS_NAME_LEN + 1] = {0}; /* 1 for snprintf null */
+	char *dir_name = "lost+found";
+	u64 lost_found_ino = 0;
+	u32 mode = 0700;
+	int ret;
+
+	/*
+	 * For link subvolume to lost+found,
+	 * 2 for parent(256)'s dir_index and dir_item
+	 * 2 for lost+found dir's inode_item and inode_ref
+	 * 2 for lost+found dir's dir_index and dir_item for the subvolume
+	 * 2 for the subvolume's root_ref and root_backref
+	 */
+	trans = btrfs_start_transaction(fs_root, 8);
+	if (IS_ERR(trans)) {
+		error("unable to start transaction");
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	/* Create lost+found directory */
+	ret = btrfs_mkdir(trans, fs_root, dir_name, strlen(dir_name),
+			  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
+			  mode);
+	if (ret < 0) {
+		error("failed to create '%s' dir: %d", dir_name, ret);
+		goto out;
+	}
+
+	/* Link the subvolume to lost+found directory */
+	snprintf(buf, BTRFS_NAME_LEN + 1, "sub%llu", subvol_id);
+	ret = btrfs_link_subvol(trans, fs_root, buf, subvol_id, lost_found_ino,
+				false);
+	if (ret) {
+		error("failed to link the subvol %llu: %d", subvol_id, ret);
+		goto out;
+	}
+
+	/* Clear root flags BTRFS_ROOT_SUBVOL_DEAD and increase root refs */
+	ret = recover_dead_root(trans, root, subvol_id);
+	if (ret)
+		goto out;
+
+	/* Delete the orphan item after undeletion is completed. */
+	ret = btrfs_del_orphan_item(trans, root, subvol_id);
+	if (ret) {
+		error("failed to delete the orphan_item for %llu: %d",
+				subvol_id, ret);
+		goto out;
+	}
+
+	ret = btrfs_commit_transaction(trans, fs_root);
+	if (ret) {
+		error("transaction commit failed: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
-- 
2.16.2



