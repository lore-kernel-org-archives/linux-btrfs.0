Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56801 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751903AbeEGDKs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 18B884B34D23
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:45 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 06/10] btrfs-progs: undelete-subvol: introduce link_subvol_to_lostfound
Date: Mon, 7 May 2018 11:10:29 +0800
Message-ID: <20180507031033.4125-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will create lost+found directory, link the deleted
subvolume specified by the subvol_id to the directory, update the
information of root_item and cleanup the associated orphan item.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
V3:
pass btrfs_fs_info instead of btrfs_root;
add Reviewed-by from Qu Wenruo.

 undelete-subvol.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/undelete-subvol.c b/undelete-subvol.c
index 6d3ef19977d6..9851998ec3df 100644
--- a/undelete-subvol.c
+++ b/undelete-subvol.c
@@ -79,3 +79,79 @@ out:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Recover a subvolume specified by subvol_id, and link it to the lost+found
+ * directory.
+ *
+ * @subvol_id: specify the subvolume which will be linked, and also be the part
+ * of the subvolume name.
+ *
+ * Return 0 if no error occurred.
+ */
+static int link_subvol_to_lostfound(struct btrfs_fs_info *fs_info,
+				    u64 subvol_id)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->tree_root;
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
+	/* Clear root flags BTRFS_ROOT_SUBVOL_DEAD */
+	ret = recover_dead_root(trans, subvol_id);
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
2.17.0



