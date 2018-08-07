Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727216AbeHGKdE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:04 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96D9CADB9
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:50 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/11] btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent repair
Date: Tue,  7 Aug 2018 16:19:32 +0800
Message-Id: <20180807081938.21348-6-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow repair_qgroups() to do silent repair, so it can acts as offline
qgroup rescan.

This provides the basis for later mkfs quota support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c    |  2 +-
 qgroup-verify.c | 19 +++++++++++--------
 qgroup-verify.h |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/check/main.c b/check/main.c
index 9ed102c197ab..80c13cc6291e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9993,7 +9993,7 @@ int cmd_check(int argc, char **argv)
 			goto out;
 		}
 		report_qgroups(0);
-		ret = repair_qgroups(info, &qgroups_repaired);
+		ret = repair_qgroups(info, &qgroups_repaired, false);
 		if (ret) {
 			error("failed to repair quota groups");
 			goto out;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index f040d1df50be..328c0a1e1da0 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1543,7 +1543,7 @@ out:
 }
 
 static int repair_qgroup_info(struct btrfs_fs_info *info,
-			      struct qgroup_count *count)
+			      struct qgroup_count *count, bool silent)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
@@ -1552,8 +1552,10 @@ static int repair_qgroup_info(struct btrfs_fs_info *info,
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
@@ -1598,7 +1600,7 @@ out:
 	return ret;
 }
 
-static int repair_qgroup_status(struct btrfs_fs_info *info)
+static int repair_qgroup_status(struct btrfs_fs_info *info, bool silent)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
@@ -1607,7 +1609,8 @@ static int repair_qgroup_status(struct btrfs_fs_info *info)
 	struct btrfs_key key;
 	struct btrfs_qgroup_status_item *status_item;
 
-	printf("Repair qgroup status item\n");
+	if (!silent)
+		printf("Repair qgroup status item\n");
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
@@ -1644,7 +1647,7 @@ out:
 	return ret;
 }
 
-int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired, bool silent)
 {
 	int ret = 0;
 	struct qgroup_count *count, *tmpcount;
@@ -1655,7 +1658,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 		return 0;
 
 	list_for_each_entry_safe(count, tmpcount, &bad_qgroups, bad_list) {
-		ret = repair_qgroup_info(info, count);
+		ret = repair_qgroup_info(info, count, silent);
 		if (ret) {
 			goto out;
 		}
@@ -1671,7 +1674,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 	 * mount.
 	 */
 	if (*repaired || counts.qgroup_inconsist || counts.rescan_running) {
-		ret = repair_qgroup_status(info);
+		ret = repair_qgroup_status(info, silent);
 		if (ret)
 			goto out;
 
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 6495dd18d39c..8a8694b6fe3d 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -24,7 +24,7 @@
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
 void report_qgroups(int all);
-int repair_qgroups(struct btrfs_fs_info *info, int *repaired);
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired, bool silent);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
-- 
2.18.0

