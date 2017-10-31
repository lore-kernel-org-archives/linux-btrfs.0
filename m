Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23500 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751487AbdJaJOa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:14:30 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs-progs: qgroup: cleanup the redundant function add_qgroup
Date: Tue, 31 Oct 2017 17:13:43 +0800
Message-ID: <20171031091345.9325-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are reusable parts between update_qgroup and add_qgroup. So
introduce the function get_or_add_qgroup and use update_qgroup instead
of add_qgroup.
No functional changes.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 qgroup.c | 119 ++++++++++++++++++++++++++-------------------------------------
 1 file changed, 48 insertions(+), 71 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 7e8ef079..032e6cad 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -578,6 +578,47 @@ static struct btrfs_qgroup *qgroup_tree_search(struct qgroup_lookup *root_tree,
 	return NULL;
 }
 
+/*
+ * Lookup or insert btrfs_qgroup in the qgroup_lookup.
+ *
+ * Search a btrfs_qgroup with @qgroupid from the @qgroup_lookup. If not found,
+ * initialize a btrfs_qgroup with the given qgroupid and insert it to the
+ * @qgroup_lookup.
+ *
+ * Return the pointer to the btrfs_qgroup if found or insert successfully.
+ * Return NULL if any error occurred.
+ */
+static struct btrfs_qgroup *get_or_add_qgroup(
+		struct qgroup_lookup *qgroup_lookup, u64 qgroupid)
+{
+	struct btrfs_qgroup *bq;
+	int ret;
+
+	bq = qgroup_tree_search(qgroup_lookup, qgroupid);
+	if (bq)
+		return bq;
+
+	bq = calloc(1, sizeof(*bq));
+	if (!bq) {
+		error("memory allocation failed");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	bq->qgroupid = qgroupid;
+	INIT_LIST_HEAD(&bq->qgroups);
+	INIT_LIST_HEAD(&bq->members);
+
+	ret = qgroup_tree_insert(qgroup_lookup, bq);
+	if (ret) {
+		error("failed to insert %llu into tree: %s",
+		       (unsigned long long)bq->qgroupid, strerror(-ret));
+		free(bq);
+		return ERR_PTR(ret);
+	}
+
+	return bq;
+}
+
 static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 			 u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
 			 u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
@@ -587,9 +628,9 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	struct btrfs_qgroup *bq;
 	struct btrfs_qgroup_list *list;
 
-	bq = qgroup_tree_search(qgroup_lookup, qgroupid);
-	if (!bq || bq->qgroupid != qgroupid)
-		return -ENOENT;
+	bq = get_or_add_qgroup(qgroup_lookup, qgroupid);
+	if (IS_ERR_OR_NULL(bq))
+		return PTR_ERR(bq);
 
 	if (generation)
 		bq->generation = generation;
@@ -613,7 +654,7 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 		list = malloc(sizeof(*list));
 		if (!list) {
 			error("memory allocation failed");
-			exit(1);
+			return -ENOMEM;
 		}
 		list->qgroup = pa;
 		list->member = child;
@@ -623,70 +664,6 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	return 0;
 }
 
-static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-		      u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-		      u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
-		      u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *parent,
-		      struct btrfs_qgroup *child)
-{
-	struct btrfs_qgroup *bq;
-	struct btrfs_qgroup_list *list;
-	int ret;
-
-	ret = update_qgroup(qgroup_lookup, qgroupid, generation, rfer,
-			    rfer_cmpr, excl, excl_cmpr, flags, max_rfer,
-			    max_excl, rsv_rfer, rsv_excl, parent, child);
-	if (!ret)
-		return 0;
-
-	bq = calloc(1, sizeof(*bq));
-	if (!bq) {
-		error("memory allocation failed");
-		exit(1);
-	}
-	if (qgroupid) {
-		bq->qgroupid = qgroupid;
-		INIT_LIST_HEAD(&bq->qgroups);
-		INIT_LIST_HEAD(&bq->members);
-	}
-	if (generation)
-		bq->generation = generation;
-	if (rfer)
-		bq->rfer = rfer;
-	if (rfer_cmpr)
-		bq->rfer_cmpr = rfer_cmpr;
-	if (excl)
-		bq->excl = excl;
-	if (excl_cmpr)
-		bq->excl_cmpr = excl_cmpr;
-	if (flags)
-		bq->flags = flags;
-	if (max_rfer)
-		bq->max_rfer = max_rfer;
-	if (max_excl)
-		bq->max_excl = max_excl;
-	if (rsv_rfer)
-		bq->rsv_rfer = rsv_rfer;
-	if (parent && child) {
-		list = malloc(sizeof(*list));
-		if (!list) {
-			error("memory allocation failed");
-			exit(1);
-		}
-		list->qgroup = parent;
-		list->member = child;
-		list_add_tail(&list->next_qgroup, &child->qgroups);
-		list_add_tail(&list->next_member, &parent->members);
-	}
-	ret = qgroup_tree_insert(qgroup_lookup, bq);
-	if (ret) {
-		error("failed to insert %llu into tree: %s",
-		       (unsigned long long)bq->qgroupid, strerror(-ret));
-		exit(1);
-	}
-	return ret;
-}
-
 static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
 {
 	struct btrfs_qgroup_list *list;
@@ -1103,7 +1080,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				a5 =
 				  btrfs_stack_qgroup_info_exclusive_compressed
 				  (info);
-				add_qgroup(qgroup_lookup,
+				update_qgroup(qgroup_lookup,
 					btrfs_search_header_offset(sh), a1,
 					a2, a3, a4, a5, 0, 0, 0, 0, 0, NULL,
 					NULL);
@@ -1121,7 +1098,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				     (limit);
 				a5 = btrfs_stack_qgroup_limit_rsv_exclusive
 				     (limit);
-				add_qgroup(qgroup_lookup,
+				update_qgroup(qgroup_lookup,
 					   btrfs_search_header_offset(sh), 0,
 					   0, 0, 0, 0, a1, a2, a3, a4, a5,
 					   NULL, NULL);
@@ -1138,7 +1115,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 					 btrfs_search_header_objectid(sh));
 				if (!bq1)
 					goto skip;
-				add_qgroup(qgroup_lookup,
+				update_qgroup(qgroup_lookup,
 					   btrfs_search_header_offset(sh), 0,
 					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
 			} else
-- 
2.14.3



