Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbcFQUiB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 16:38:01 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/2] btrfs-progs: btrfsck: write corrected qgroup info to disk
Date: Fri, 17 Jun 2016 13:37:49 -0700
Message-Id: <1466195869-28109-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1466195869-28109-1-git-send-email-mfasheh@suse.de>
References: <1466195869-28109-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we can verify all qgroups, we can write the corrected qgroups out
to disk when '--repair' is specified. The qgroup status item is also updated
to clear any out-of-date state. The repair_ functions were modeled after the
inode repair code in cmds-check.c.

I also renamed the 'scan' member of qgroup_status_item to 'rescan' in order
to keep consistency with the kernel.

Testing this was easy, I just reproduced qgroup inconsistencies via the
usual routes and had btrfsck fix them.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-check.c    |  15 +++--
 ctree.h         |  10 ++--
 print-tree.c    |   2 +-
 qgroup-verify.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 qgroup-verify.h |   3 +-
 repair.c        |   2 +
 repair.h        |   2 +
 7 files changed, 189 insertions(+), 23 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7b65f89..b7f4bd5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -67,7 +67,6 @@ static u64 data_bytes_referenced = 0;
 static int found_old_backref = 0;
 static LIST_HEAD(duplicate_extents);
 static LIST_HEAD(delete_items);
-static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
@@ -9543,6 +9542,7 @@ int cmd_check(int argc, char **argv)
 	int init_csum_tree = 0;
 	int readonly = 0;
 	int qgroup_report = 0;
+	int qgroups_repaired = 0;
 	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
@@ -9698,7 +9698,7 @@ int cmd_check(int argc, char **argv)
 		       uuidbuf);
 		ret = qgroup_verify_all(info);
 		if (ret == 0)
-			ret = report_qgroups(1);
+			report_qgroups(1);
 		goto close_out;
 	}
 	if (subvolid) {
@@ -9852,6 +9852,10 @@ int cmd_check(int argc, char **argv)
 		err = qgroup_verify_all(info);
 		if (err)
 			goto out;
+		report_qgroups(0);
+		err = repair_qgroups(info, &qgroups_repaired);
+		if (err)
+			goto out;
 	}
 
 	if (!list_empty(&root->fs_info->recow_ebs)) {
@@ -9860,10 +9864,9 @@ int cmd_check(int argc, char **argv)
 	}
 out:
 	/* Don't override original ret */
-	if (ret)
-		report_qgroups(0);
-	else
-		ret = report_qgroups(0);
+	if (!ret && qgroups_repaired)
+		ret = qgroups_repaired;
+
 	if (found_old_backref) { /*
 		 * there was a disk format change when mixed
 		 * backref was in testing tree. The old format
diff --git a/ctree.h b/ctree.h
index 86227f8..34c6b73 100644
--- a/ctree.h
+++ b/ctree.h
@@ -897,7 +897,7 @@ struct btrfs_qgroup_status_item {
 	__le64 version;
 	__le64 generation;
 	__le64 flags;
-	__le64 scan;		/* progress during scanning */
+	__le64 rescan;		/* progress during scanning */
 } __attribute__ ((__packed__));
 
 struct btrfs_block_group_item {
@@ -2130,8 +2130,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
 		   generation, 64);
 BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
 		   flags, 64);
-BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
-		   scan, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
+		   rescan, 64);
 
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_version,
 			 struct btrfs_qgroup_status_item, version, 64);
@@ -2139,8 +2139,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_generation,
 			 struct btrfs_qgroup_status_item, generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_flags,
 			 struct btrfs_qgroup_status_item, flags, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_scan,
-			 struct btrfs_qgroup_status_item, scan, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_rescan,
+			 struct btrfs_qgroup_status_item, rescan, 64);
 
 /* btrfs_qgroup_info_item */
 BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
diff --git a/print-tree.c b/print-tree.c
index 746f25b..9f9e11e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1037,7 +1037,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 				btrfs_qgroup_status_generation(l, qg_status),
 				flags_str,
 				(unsigned long long)
-				btrfs_qgroup_status_scan(l, qg_status));
+				btrfs_qgroup_status_rescan(l, qg_status));
 			break;
 		case BTRFS_QGROUP_RELATION_KEY:
 			break;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 23f2961..12921ad 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -29,6 +29,8 @@
 #include "utils.h"
 #include "ulist.h"
 #include "rbtree-utils.h"
+#include "repair.h"
+#include "transaction.h"
 
 #include "qgroup-verify.h"
 
@@ -65,6 +67,8 @@ struct qgroup_count {
 	struct list_head members;
 
 	u64 cur_refcnt;
+
+	struct list_head bad_list;
 };
 
 static struct counts_tree {
@@ -74,6 +78,8 @@ static struct counts_tree {
 	unsigned int		qgroup_inconsist:1;
 } counts = { .root = RB_ROOT };
 
+static LIST_HEAD(bad_qgroups);
+
 static struct rb_root by_bytenr = RB_ROOT;
 
 /*
@@ -817,6 +823,7 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 			btrfs_qgroup_info_exclusive_compressed(leaf, disk);
 		INIT_LIST_HEAD(&c->groups);
 		INIT_LIST_HEAD(&c->members);
+		INIT_LIST_HEAD(&c->bad_list);
 
 		if (insert_count(c)) {
 			free(c);
@@ -1243,34 +1250,36 @@ static int report_qgroup_difference(struct qgroup_count *count, int verbose)
 			print_fields_signed(excl_diff, excl_diff,
 					    "diff:", "exclusive");
 	}
-	return (is_different && count->subvol_exists);
+
+	return is_different;
 }
 
-int report_qgroups(int all)
+void report_qgroups(int all)
 {
 	struct rb_node *node;
 	struct qgroup_count *c;
-	int ret = 0;
 
-	if (counts.rescan_running) {
+	if (!repair && counts.rescan_running) {
 		if (all) {
 			printf(
-	"Qgroup rescan is running, qgroup counts difference is expected\n");
+	"Qgroup rescan is running, a difference in qgroup counts is expected\n");
 		} else {
 			printf(
-	"Qgroup rescan is running, ignore qgroup check\n");
-			return ret;
+	"Qgroup rescan is running, qgroups will not be printed.\n");
+			return;
 		}
 	}
 	if (counts.qgroup_inconsist && !counts.rescan_running)
-		fprintf(stderr, "Qgroup is already inconsistent before checking\n");
+		fprintf(stderr, "Qgroup are marked as inconsistent.\n");
 	node = rb_first(&counts.root);
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
-		ret |= report_qgroup_difference(c, all);
+
+		if (report_qgroup_difference(c, all))
+			list_add_tail(&c->bad_list, &bad_qgroups);
+
 		node = rb_next(node);
 	}
-	return ret;
 }
 
 void free_qgroup_counts(void)
@@ -1283,6 +1292,8 @@ void free_qgroup_counts(void)
 	while (node) {
 		c = rb_entry(node, struct qgroup_count, rb_node);
 
+		list_del(&c->bad_list);
+
 		list_for_each_entry_safe(glist, tmpglist, &c->groups,
 					 next_group) {
 			list_del(&glist->next_group);
@@ -1418,3 +1429,150 @@ out:
 	return ret;
 }
 
+static int repair_qgroup_info(struct btrfs_fs_info *info,
+			      struct qgroup_count *count)
+{
+	int ret;
+	struct btrfs_root *root = info->quota_root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_qgroup_info_item *info_item;
+	struct btrfs_key key;
+
+	printf("Repair qgroup %llu/%llu\n", btrfs_qgroup_level(count->qgroupid),
+	       btrfs_qgroup_subvid(count->qgroupid));
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_INFO_KEY;
+	key.offset = count->qgroupid;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret) {
+		error("Could not find disk item for qgroup %llu/%llu.\n",
+		      btrfs_qgroup_level(count->qgroupid),
+		      btrfs_qgroup_subvid(count->qgroupid));
+		if (ret > 0)
+			ret = -ENOENT;
+		goto out;
+	}
+
+	info_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				   struct btrfs_qgroup_info_item);
+
+	btrfs_set_qgroup_info_generation(path->nodes[0], info_item,
+					 trans->transid);
+
+	btrfs_set_qgroup_info_referenced(path->nodes[0], info_item,
+					 count->info.referenced);
+	btrfs_set_qgroup_info_referenced_compressed(path->nodes[0], info_item,
+					    count->info.referenced_compressed);
+
+	btrfs_set_qgroup_info_exclusive(path->nodes[0], info_item,
+					count->info.exclusive);
+	btrfs_set_qgroup_info_exclusive_compressed(path->nodes[0], info_item,
+					   count->info.exclusive_compressed);
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+static int repair_qgroup_status(struct btrfs_fs_info *info)
+{
+	int ret;
+	struct btrfs_root *root = info->quota_root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_qgroup_status_item *status_item;
+
+	printf("Repair qgroup status item\n");
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_STATUS_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret) {
+		error("Could not find qgroup status item\n");
+		if (ret > 0)
+			ret = -ENOENT;
+		goto out;
+	}
+
+	status_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				     struct btrfs_qgroup_status_item);
+	btrfs_set_qgroup_status_flags(path->nodes[0], status_item,
+				      BTRFS_QGROUP_STATUS_FLAG_ON);
+	btrfs_set_qgroup_status_rescan(path->nodes[0], status_item, 0);
+	btrfs_set_qgroup_status_generation(path->nodes[0], status_item,
+					   trans->transid);
+
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
+{
+	int ret;
+	struct qgroup_count *count, *tmpcount;
+
+	*repaired = 0;
+
+	if (!repair)
+		return 0;
+
+	list_for_each_entry_safe(count, tmpcount, &bad_qgroups, bad_list) {
+		ret = repair_qgroup_info(info, count);
+		if (ret) {
+			goto out;
+		}
+
+		(*repaired)++;
+
+		list_del_init(&count->bad_list);
+	}
+
+	/*
+	 * Do this step last as we want the latest transaction id on
+	 * our qgroup status to avoid a (useless) warning after
+	 * mount.
+	 */
+	if (*repaired || counts.qgroup_inconsist || counts.rescan_running) {
+		ret = repair_qgroup_status(info);
+		if (ret)
+			goto out;
+
+		(*repaired)++;
+	}
+
+out:
+	return ret;
+}
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 0f8ff9b..d7d83a4 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -23,7 +23,8 @@
 #include "ctree.h"
 
 int qgroup_verify_all(struct btrfs_fs_info *info);
-int report_qgroups(int all);
+void report_qgroups(int all);
+int repair_qgroups(struct btrfs_fs_info *info, int *repaired);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
diff --git a/repair.c b/repair.c
index 4f74742..07a1232 100644
--- a/repair.c
+++ b/repair.c
@@ -21,6 +21,8 @@
 #include "utils.h"
 #include "repair.h"
 
+int repair = 0;
+
 int btrfs_add_corrupt_extent_record(struct btrfs_fs_info *info,
 				    struct btrfs_key *first_key,
 				    u64 start, u64 len, int level)
diff --git a/repair.h b/repair.h
index 3fc0e8b..355bbf2 100644
--- a/repair.h
+++ b/repair.h
@@ -21,6 +21,8 @@
 
 #include "ctree.h"
 
+extern int repair; /* repair mode */
+
 struct btrfs_corrupt_block {
 	struct cache_extent cache;
 	struct btrfs_key key;
-- 
2.1.4

