Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36890 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbcDRC3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 22:29:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: [PATCH 3/3] btrfs-progs: Read qgroup status for qgroup verify
Date: Mon, 18 Apr 2016 10:27:09 +0800
Message-Id: <1460946429-578-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1460946429-578-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Read qgroup status for its flags like QGROUP_STATUS_FLAG_RESCAN and
QGROUP_STATUS_FLAG_INCONSISTENT.

This will help to avoid false alert for case like qgroup rescan is still
running when un-mounted.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 qgroup-verify.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 48e4d22..e2b8be3 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -59,6 +59,8 @@ struct qgroup_count {
 static struct counts_tree {
 	struct rb_root		root;
 	unsigned int		num_groups;
+	unsigned int		rescan_running:1;
+	unsigned int		qgroup_inconsist:1;
 } counts = { .root = RB_ROOT };
 
 static struct rb_root by_bytenr = RB_ROOT;
@@ -700,6 +702,19 @@ static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive)
 	}
 }
 
+static void read_qgroup_status(struct btrfs_path *path,
+			      struct counts_tree *counts)
+{
+	struct btrfs_qgroup_status_item *status_item;
+	u64 flags;
+
+	status_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				     struct btrfs_qgroup_status_item);
+	flags = btrfs_qgroup_status_flags(path->nodes[0], status_item);
+	counts->qgroup_inconsist = flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	counts->rescan_running = flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+}
+
 static int load_quota_info(struct btrfs_fs_info *info)
 {
 	int ret;
@@ -734,13 +749,17 @@ static int load_quota_info(struct btrfs_fs_info *info)
 			btrfs_item_key(leaf, &disk_key, i);
 			btrfs_disk_key_to_cpu(&key, &disk_key);
 
+			if (key.type == BTRFS_QGROUP_STATUS_KEY) {
+				read_qgroup_status(&path, &counts);
+				continue;
+			}
 			if (key.type == BTRFS_QGROUP_RELATION_KEY)
 				printf("Ignoring qgroup relation key %llu\n",
 				       key.objectid);
 
 			/*
-			 * Ignore: BTRFS_QGROUP_STATUS_KEY,
-			 * BTRFS_QGROUP_LIMIT_KEY, BTRFS_QGROUP_RELATION_KEY
+			 * Ignore: BTRFS_QGROUP_LIMIT_KEY,
+			 * 	   BTRFS_QGROUP_RELATION_KEY
 			 */
 			if (key.type != BTRFS_QGROUP_INFO_KEY)
 				continue;
@@ -1055,6 +1074,16 @@ int report_qgroups(int all)
 	struct qgroup_count *c;
 	int ret = 0;
 
+	if (counts.rescan_running) {
+		if (all)
+			printf("Qgroup rescan is running, qgroup counts difference is expected\n");
+		else {
+			printf("Qgroup rescan is running, ignore qgroup check\n");
+			return ret;
+		}
+	}
+	if (counts.qgroup_inconsist && !counts.rescan_running)
+		fprintf(stderr, "Qgroup is already inconsistent before checking\n");
 	node = rb_first(&counts.root);
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
-- 
2.8.0



