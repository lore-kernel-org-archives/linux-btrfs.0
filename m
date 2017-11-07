Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39090 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933659AbdKGInZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 07/12] btrfs-progs: mkfs: Introduce function to setup quota root and rescan
Date: Tue,  7 Nov 2017 16:42:54 +0800
Message-Id: <20171107084259.22367-11-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, setup_quota_root(), which will create quota
root, and do an offline rescan to ensure all quota accounting numbers
are correct.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 0f0dabd36d14..a846540b37ff 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -46,6 +46,7 @@
 #include "help.h"
 #include "mkfs/common.h"
 #include "fsfeatures.h"
+#include "qgroup-verify.h"
 
 int path_cat_out(char *out, const char *p1, const char *p2);
 
@@ -1438,6 +1439,91 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int setup_quota_root(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_qgroup_status_item *qsi;
+	struct btrfs_root *quota_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int qgroup_repaired = 0;
+	int ret;
+
+	/* One to modify tree root, one for quota root */
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+	ret = btrfs_create_root(trans, fs_info, BTRFS_QUOTA_TREE_OBJECTID);
+	if (ret < 0) {
+		error("failed to create quota root: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+	quota_root = fs_info->quota_root;
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_STATUS_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
+				      sizeof(*qsi));
+	if (ret < 0) {
+		error("failed to insert qgroup status item: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+
+	qsi = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			     struct btrfs_qgroup_status_item);
+	btrfs_set_qgroup_status_generation(path.nodes[0], qsi, 0);
+	btrfs_set_qgroup_status_rescan(path.nodes[0], qsi, 0);
+
+	/* Mark current status info inconsistent, and fix it later */
+	btrfs_set_qgroup_status_flags(path.nodes[0], qsi,
+			BTRFS_QGROUP_STATUS_FLAG_ON |
+			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
+	btrfs_release_path(&path);
+
+	/* Currently mkfs will only create one subvolume */
+	ret = insert_qgroup_items(trans, fs_info, BTRFS_FS_TREE_OBJECTID);
+	if (ret < 0) {
+		error("failed to insert qgroup items: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+
+	/*
+	 * Qgroup is setup but with wrong info, use qgroup-verify
+	 * infrastructure to repair them.
+	 * (Just acts as offline rescan)
+	 */
+	ret = qgroup_verify_all(fs_info);
+	if (ret < 0) {
+		error("qgroup rescan failed: %d (%s)", ret, strerror(-ret));
+		return ret;
+	}
+	ret = repair_qgroups(fs_info, &qgroup_repaired, true);
+	if (ret < 0)
+		error("failed to fill qgroup info: %d (%s)", ret,
+			strerror(-ret));
+	return ret;
+fail:
+	btrfs_commit_transaction(trans, fs_info->tree_root);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
-- 
2.15.0

