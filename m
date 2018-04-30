Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46141 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbeD3G2V (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 30 Apr 2018 02:28:21 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error for qgroup mismatch
Date: Mon, 30 Apr 2018 14:28:06 +0800
Message-Id: <20180430062807.19428-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs-check will check qgroup consistency, but even when it
finds something wrong, the return value is still 0.

Fix it by allowing report_qgroups() to return int to indicate qgroup
mismatch, and also add extra logical to return no error if qgroup repair
is successful.

Without this patch, fstests can't detect qgroup corruption by its fsck
alone.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c    | 10 ++++++----
 qgroup-verify.c | 20 +++++++++++++++++---
 qgroup-verify.h |  2 +-
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/check/main.c b/check/main.c
index c4a1801fb0ef..d49b4326915e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9467,6 +9467,7 @@ int cmd_check(int argc, char **argv)
 	int clear_space_cache = 0;
 	int qgroup_report = 0;
 	int qgroups_repaired = 0;
+	int qgroup_report_ret;
 	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 	int force = 0;
 
@@ -9709,7 +9710,7 @@ int cmd_check(int argc, char **argv)
 		ret = qgroup_verify_all(info);
 		err |= !!ret;
 		if (ret == 0)
-			report_qgroups(1);
+			err |= !!report_qgroups(1);
 		goto close_out;
 	}
 	if (subvolid) {
@@ -9894,13 +9895,14 @@ int cmd_check(int argc, char **argv)
 			error("failed to check quota groups");
 			goto out;
 		}
-		report_qgroups(0);
+		qgroup_report_ret = report_qgroups(0);
 		ret = repair_qgroups(info, &qgroups_repaired);
-		err |= !!ret;
-		if (err) {
+		if (ret) {
 			error("failed to repair quota groups");
 			goto out;
 		}
+		if (qgroup_report_ret && (!qgroups_repaired || ret))
+			err |= qgroup_report_ret;
 		ret = 0;
 	}
 
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4f7171..4deb9879fb35 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1298,10 +1298,19 @@ static int report_qgroup_difference(struct qgroup_count *count, int verbose)
 	return is_different;
 }
 
-void report_qgroups(int all)
+/*
+ * Report qgroups errors
+ * Return 0 if nothing wrong.
+ * Return <0 if any qgroup is inconsistent.
+ *
+ * @all:	if set, all qgroup will be checked and reported even already
+ * 		inconsistent or under rescan.
+ */
+int report_qgroups(int all)
 {
 	struct rb_node *node;
 	struct qgroup_count *c;
+	bool found_err = false;
 
 	if (!repair && counts.rescan_running) {
 		if (all) {
@@ -1310,7 +1319,7 @@ void report_qgroups(int all)
 		} else {
 			printf(
 	"Qgroup rescan is running, qgroups will not be printed.\n");
-			return;
+			return 0;
 		}
 	}
 	if (counts.qgroup_inconsist && !counts.rescan_running)
@@ -1319,11 +1328,16 @@ void report_qgroups(int all)
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
 
-		if (report_qgroup_difference(c, all))
+		if (report_qgroup_difference(c, all)) {
 			list_add_tail(&c->bad_list, &bad_qgroups);
+			found_err = true;
+		}
 
 		node = rb_next(node);
 	}
+	if (found_err)
+		return -EUCLEAN;
+	return 0;
 }
 
 void free_qgroup_counts(void)
diff --git a/qgroup-verify.h b/qgroup-verify.h
index d7d83a46ed5a..14d36bbf81d1 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -23,7 +23,7 @@
 #include "ctree.h"
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
-void report_qgroups(int all);
+int report_qgroups(int all);
 int repair_qgroups(struct btrfs_fs_info *info, int *repaired);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
-- 
2.17.0

