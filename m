Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754189AbeEHGcH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 743A8AF68
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:06 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 04/12] btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent repair
Date: Tue,  8 May 2018 14:31:48 +0800
Message-Id: <20180508063156.24665-5-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
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
index 891a6d797756..84b298af8ee4 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9884,7 +9884,7 @@ int cmd_check(int argc, char **argv)
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
2.17.0

