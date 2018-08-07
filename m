Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeHGKdC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:02 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5C11ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:48 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/11] btrfs-progs: qgroup-verify: Move qgroup classification out of report_qgroups
Date: Tue,  7 Aug 2018 16:19:31 +0800
Message-Id: <20180807081938.21348-5-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original qgroup-verify integrates qgroup classification into
report_qgroups().
This behavior makes silent qgroup repair (or offline rescan) impossible.

To repair qgroup, we must call report_qgroups() to trigger bad qgroup
classification, which will output error message.

This patch moves bad qgroup classification from report_qgroups() to
qgroup_verify_all().
Now report_qgroups() is pretty lightweight, only doing basic qgroup
difference report thus change it type to void.

And since the functionality of qgroup_verify_all() changes, change
callers to handle the new return value correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c    | 18 +++++++-------
 qgroup-verify.c | 62 ++++++++++++++++++++++++++++++++++++++-----------
 qgroup-verify.h |  2 +-
 3 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/check/main.c b/check/main.c
index bc2ee22f7943..9ed102c197ab 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9500,7 +9500,7 @@ int cmd_check(int argc, char **argv)
 	int clear_space_cache = 0;
 	int qgroup_report = 0;
 	int qgroups_repaired = 0;
-	int qgroup_report_ret;
+	int qgroup_verify_ret;
 	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 	int force = 0;
 
@@ -9744,8 +9744,8 @@ int cmd_check(int argc, char **argv)
 		       uuidbuf);
 		ret = qgroup_verify_all(info);
 		err |= !!ret;
-		if (ret == 0)
-			err |= !!report_qgroups(1);
+		if (ret >= 0)
+			report_qgroups(1);
 		goto close_out;
 	}
 	if (subvolid) {
@@ -9985,21 +9985,21 @@ int cmd_check(int argc, char **argv)
 			ctx.tp = TASK_QGROUPS;
 			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
 		}
-		ret = qgroup_verify_all(info);
+		qgroup_verify_ret = qgroup_verify_all(info);
 		task_stop(ctx.info);
-		err |= !!ret;
-		if (ret) {
+		if (qgroup_verify_ret < 0) {
 			error("failed to check quota groups");
+			err |= !!qgroup_verify_ret;
 			goto out;
 		}
-		qgroup_report_ret = report_qgroups(0);
+		report_qgroups(0);
 		ret = repair_qgroups(info, &qgroups_repaired);
 		if (ret) {
 			error("failed to repair quota groups");
 			goto out;
 		}
-		if (qgroup_report_ret && (!qgroups_repaired || ret))
-			err |= qgroup_report_ret;
+		if (qgroup_verify_ret && (!qgroups_repaired || ret))
+			err |= !!qgroup_verify_ret;
 		ret = 0;
 	} else {
 		fprintf(stderr,
diff --git a/qgroup-verify.c b/qgroup-verify.c
index eb42e199bcf9..f040d1df50be 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1317,12 +1317,10 @@ static int report_qgroup_difference(struct qgroup_count *count, int verbose)
  * @all:	if set, all qgroup will be checked and reported even already
  * 		inconsistent or under rescan.
  */
-int report_qgroups(int all)
+void report_qgroups(int all)
 {
 	struct rb_node *node;
 	struct qgroup_count *c;
-	bool found_err = false;
-	bool skip_err = false;
 
 	if (!repair && counts.rescan_running) {
 		if (all) {
@@ -1331,34 +1329,26 @@ int report_qgroups(int all)
 		} else {
 			printf(
 	"Qgroup rescan is running, qgroups will not be printed.\n");
-			return 0;
+			return;
 		}
 	}
 	/*
 	 * It's possible that rescan hasn't been initialized yet.
 	 */
 	if (counts.qgroup_inconsist && !counts.rescan_running &&
-	    counts.rescan_running == 0) {
+	    counts.rescan_running == 0)
 		printf(
 "Rescan hasn't been initialzied, a difference in qgroup accounting is expected\n");
-		skip_err = true;
-	}
 	if (counts.qgroup_inconsist && !counts.rescan_running)
 		fprintf(stderr, "Qgroup are marked as inconsistent.\n");
 	node = rb_first(&counts.root);
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
 
-		if (report_qgroup_difference(c, all)) {
-			list_add_tail(&c->bad_list, &bad_qgroups);
-			found_err = true;
-		}
+		report_qgroup_difference(c, all);
 
 		node = rb_next(node);
 	}
-	if (found_err && !skip_err)
-		return -EUCLEAN;
-	return 0;
 }
 
 void free_qgroup_counts(void)
@@ -1393,9 +1383,29 @@ void free_qgroup_counts(void)
 	}
 }
 
+static bool is_bad_qgroup(struct qgroup_count *count)
+{
+	struct qgroup_info *info = &count->info;
+	struct qgroup_info *disk = &count->diskinfo;
+	s64 excl_diff = info->exclusive - disk->exclusive;
+	s64 ref_diff = info->referenced - disk->referenced;
+
+	return (excl_diff || ref_diff);
+}
+
+/*
+ * Verify all qgroup numbers.
+ *
+ * Return <0 for fatal errors (e.g. ENOMEM or failed to read quota tree)
+ * Return 0 if all qgroup numbers are correct or no need to check (under rescan)
+ * Return >0 if qgroup numbers are inconsistent.
+ */
 int qgroup_verify_all(struct btrfs_fs_info *info)
 {
 	int ret;
+	bool found_err = false;
+	bool skip_err = false;
+	struct rb_node *node;
 
 	if (!info->quota_enabled)
 		return 0;
@@ -1413,6 +1423,12 @@ int qgroup_verify_all(struct btrfs_fs_info *info)
 		goto out;
 	}
 
+	if (counts.rescan_running)
+		skip_err = true;
+	if (counts.qgroup_inconsist && !counts.rescan_running &&
+	    counts.rescan_running == 0)
+		skip_err = true;
+
 	/*
 	 * Put all extent refs into our rbtree
 	 */
@@ -1430,6 +1446,22 @@ int qgroup_verify_all(struct btrfs_fs_info *info)
 
 	ret = account_all_refs(1, 0);
 
+	/*
+	 * Do the correctness check here, so for callers who don't want
+	 * verbose report can skip calling report_qgroups()
+	 */
+	node = rb_first(&counts.root);
+	while (node) {
+		struct qgroup_count *c;
+
+		c = rb_entry(node, struct qgroup_count, rb_node);
+		if (is_bad_qgroup(c)) {
+			list_add_tail(&c->bad_list, &bad_qgroups);
+			found_err = true;
+		}
+		node = rb_next(node);
+	}
+
 out:
 	/*
 	 * Don't free the qgroup count records as they will be walked
@@ -1437,6 +1469,8 @@ out:
 	 */
 	free_tree_blocks();
 	free_ref_tree(&by_bytenr);
+	if (!ret && !skip_err && found_err)
+		ret = 1;
 	return ret;
 }
 
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 20e937080893..6495dd18d39c 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -23,7 +23,7 @@
 #include "ctree.h"
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
-int report_qgroups(int all);
+void report_qgroups(int all);
 int repair_qgroups(struct btrfs_fs_info *info, int *repaired);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
-- 
2.18.0

