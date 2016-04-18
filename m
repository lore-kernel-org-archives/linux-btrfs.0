Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35964 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcDRC3w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 22:29:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: [PATCH 1/3] btrfs-progs: Fix return value bug of qgroups check
Date: Mon, 18 Apr 2016 10:27:07 +0800
Message-Id: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, although btrfsck will check qgroups if quota is
enabled, it always return 0 even qgroup numbers are corrupted.

Fix it by allowing return value from report_qgroups function (formally
defined as print_qgroup_difference).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c    | 8 ++++++--
 qgroup-verify.c | 9 ++++++---
 qgroup-verify.h | 2 +-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d59968b..de17be3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9698,7 +9698,7 @@ int cmd_check(int argc, char **argv)
 		       uuidbuf);
 		ret = qgroup_verify_all(info);
 		if (ret == 0)
-			print_qgroup_report(1);
+			ret = report_qgroups(1);
 		goto close_out;
 	}
 	if (subvolid) {
@@ -9859,7 +9859,11 @@ int cmd_check(int argc, char **argv)
 		ret = 1;
 	}
 out:
-	print_qgroup_report(0);
+	/* Don't override original ret */
+	if (ret)
+		report_qgroups(0);
+	else
+		ret = report_qgroups(0);
 	if (found_old_backref) { /*
 		 * there was a disk format change when mixed
 		 * backref was in testing tree. The old format
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 10ff8e0..c4e9201 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1016,7 +1016,7 @@ static void print_fields_signed(long long bytes,
 	       prefix, type, bytes, type, bytes_compressed);
 }
 
-static void print_qgroup_difference(struct qgroup_count *count, int verbose)
+static int report_qgroup_difference(struct qgroup_count *count, int verbose)
 {
 	int is_different;
 	struct qgroup_info *info = &count->info;
@@ -1046,19 +1046,22 @@ static void print_qgroup_difference(struct qgroup_count *count, int verbose)
 			print_fields_signed(excl_diff, excl_diff,
 					    "diff:", "exclusive");
 	}
+	return (is_different && count->subvol_exists);
 }
 
-void print_qgroup_report(int all)
+int report_qgroups(int all)
 {
 	struct rb_node *node;
 	struct qgroup_count *c;
+	int ret = 0;
 
 	node = rb_first(&counts.root);
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
-		print_qgroup_difference(c, all);
+		ret |= report_qgroup_difference(c, all);
 		node = rb_next(node);
 	}
+	return ret;
 }
 
 int qgroup_verify_all(struct btrfs_fs_info *info)
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 7d91c19..3747465 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -23,7 +23,7 @@
 #include "ctree.h"
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
-void print_qgroup_report(int all);
+int report_qgroups(int all);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
-- 
2.8.0



