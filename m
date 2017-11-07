Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59465 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933655AbdKGInY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:24 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 04/12] btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent repair
Date: Tue,  7 Nov 2017 16:42:51 +0800
Message-Id: <20171107084259.22367-8-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow repair_qgroups() to do silent repair, so it can acts as offline
qgroup rescan.

This provides the basis for later mkfs quota support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c    |  2 +-
 qgroup-verify.c | 19 +++++++++++--------
 qgroup-verify.h |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5c822b848608..955049b95f3c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13360,7 +13360,7 @@ int cmd_check(int argc, char **argv)
 			goto out;
 		}
 		report_qgroups(0);
-		ret = repair_qgroups(info, &qgroups_repaired);
+		ret = repair_qgroups(info, &qgroups_repaired, false);
 		err |= !!ret;
 		if (err) {
 			error("failed to repair quota groups");
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 67bd8b96ddd3..bb77eac139aa 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1498,7 +1498,7 @@ out:
 }
 
 static int repair_qgroup_info(struct btrfs_fs_info *info,
-			      struct qgroup_count *count)
+			      struct qgroup_count *count, bool silent)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
@@ -1507,8 +1507,10 @@ static int repair_qgroup_info(struct btrfs_fs_info *info,
 	struct btrfs_qgroup_info_item *info_item;
 	struct btrfs_key key;
 
-	printf("Repair qgroup %llu/%llu\n", btrfs_qgroup_level(count->qgroupid),
-	       btrfs_qgroup_subvid(count->qgroupid));
+	if (!silent)
+		printf("Repair qgroup %llu/%llu\n",
+			btrfs_qgroup_level(count->qgroupid),
+			btrfs_qgroup_subvid(count->qgroupid));
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
@@ -1553,7 +1555,7 @@ out:
 	return ret;
 }
 
-static int repair_qgroup_status(struct btrfs_fs_info *info)
+static int repair_qgroup_status(struct btrfs_fs_info *info, bool silent)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
@@ -1562,7 +1564,8 @@ static int repair_qgroup_status(struct btrfs_fs_info *info)
 	struct btrfs_key key;
 	struct btrfs_qgroup_status_item *status_item;
 
-	printf("Repair qgroup status item\n");
+	if (!silent)
+		printf("Repair qgroup status item\n");
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
@@ -1599,7 +1602,7 @@ out:
 	return ret;
 }
 
-int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired, bool silent)
 {
 	int ret = 0;
 	struct qgroup_count *count, *tmpcount;
@@ -1610,7 +1613,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 		return 0;
 
 	list_for_each_entry_safe(count, tmpcount, &bad_qgroups, bad_list) {
-		ret = repair_qgroup_info(info, count);
+		ret = repair_qgroup_info(info, count, silent);
 		if (ret) {
 			goto out;
 		}
@@ -1626,7 +1629,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 	 * mount.
 	 */
 	if (*repaired || counts.qgroup_inconsist || counts.rescan_running) {
-		ret = repair_qgroup_status(info);
+		ret = repair_qgroup_status(info, silent);
 		if (ret)
 			goto out;
 
diff --git a/qgroup-verify.h b/qgroup-verify.h
index d7d83a46ed5a..7e5697024f31 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -24,7 +24,7 @@
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
 void report_qgroups(int all);
-int repair_qgroups(struct btrfs_fs_info *info, int *repaired);
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired, bool silent);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
-- 
2.15.0

