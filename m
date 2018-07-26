Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbeGZHyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 03:54:33 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1624BADDB
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:39:13 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: qgroup-verify: Don't treat qgroup difference as error if the fs hasn't initialized a rescan
Date: Thu, 26 Jul 2018 14:39:00 +0800
Message-Id: <20180726063901.1252-2-wqu@suse.com>
In-Reply-To: <20180726063901.1252-1-wqu@suse.com>
References: <20180726063901.1252-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During test btrfs/166, it's possible to hit a certain case where qgroup
is just enabled but rescan hasn't been kicked in.

Since at qgroup enable time, we mark INCONSISTENT flag, and let later
rescan to clear that flag, if power loss before we kick in rescan, it's
possible we get a qgroup status item with ON|INCONSISTENT but without
RESCAN flag.

And in that case, it will definitely cause difference in qgroup numbers
(as all numbers in qgroup tree is 0).

Fix this false alert by also checking rescan progress from
btrfs_status_item.
And if we find rescan progress is still 0, INCONSISTENT flag set and no
RESCAN flag set, we won't treat it as an error.

Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 qgroup-verify.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index e2332be2975a..21db79d5cf7d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -77,6 +77,7 @@ static struct counts_tree {
 	unsigned int		num_groups;
 	unsigned int		rescan_running:1;
 	unsigned int		qgroup_inconsist:1;
+	u64			scan_progress;
 } counts = { .root = RB_ROOT };
 
 static LIST_HEAD(bad_qgroups);
@@ -914,6 +915,7 @@ static void read_qgroup_status(struct extent_buffer *eb, int slot,
 	counts->qgroup_inconsist = !!(flags &
 			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
 	counts->rescan_running = !!(flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN);
+	counts->scan_progress = btrfs_qgroup_status_rescan(eb, status_item);
 }
 
 static int load_quota_info(struct btrfs_fs_info *info)
@@ -1311,6 +1313,7 @@ int report_qgroups(int all)
 	struct rb_node *node;
 	struct qgroup_count *c;
 	bool found_err = false;
+	bool skip_err = false;
 
 	if (!repair && counts.rescan_running) {
 		if (all) {
@@ -1322,6 +1325,15 @@ int report_qgroups(int all)
 			return 0;
 		}
 	}
+	/*
+	 * It's possible that rescan hasn't been initialized yet.
+	 */
+	if (counts.qgroup_inconsist && !counts.rescan_running &&
+	    counts.rescan_running == 0) {
+		printf(
+"Rescan hasn't been initialzied, a difference in qgroup counts is expected\n");
+		skip_err = true;
+	}
 	if (counts.qgroup_inconsist && !counts.rescan_running)
 		fprintf(stderr, "Qgroup are marked as inconsistent.\n");
 	node = rb_first(&counts.root);
@@ -1335,7 +1347,7 @@ int report_qgroups(int all)
 
 		node = rb_next(node);
 	}
-	if (found_err)
+	if (found_err && !skip_err)
 		return -EUCLEAN;
 	return 0;
 }
-- 
2.18.0

