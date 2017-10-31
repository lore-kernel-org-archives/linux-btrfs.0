Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:9491 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751930AbdJaJOc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:14:32 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs-progs: qgroup: split update_qgroup to reduce arguments
Date: Tue, 31 Oct 2017 17:13:44 +0800
Message-ID: <20171031091345.9325-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function update_qgroup has too many arguments that are too difficult
to use. Therefore, split it to update_qgroup_info, update_qgroup_limit,
update_qgroup_relation.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 qgroup.c | 163 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 81 insertions(+), 82 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 032e6cad..10059e71 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -619,48 +619,77 @@ static struct btrfs_qgroup *get_or_add_qgroup(
 	return bq;
 }
 
-static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-			 u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-			 u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
-			 u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *pa,
-			 struct btrfs_qgroup *child)
+static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
+			      struct btrfs_qgroup_info_item *info)
 {
 	struct btrfs_qgroup *bq;
-	struct btrfs_qgroup_list *list;
 
 	bq = get_or_add_qgroup(qgroup_lookup, qgroupid);
 	if (IS_ERR_OR_NULL(bq))
 		return PTR_ERR(bq);
 
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
-	if (pa && child) {
-		list = malloc(sizeof(*list));
-		if (!list) {
-			error("memory allocation failed");
-			return -ENOMEM;
-		}
-		list->qgroup = pa;
-		list->member = child;
-		list_add_tail(&list->next_qgroup, &child->qgroups);
-		list_add_tail(&list->next_member, &pa->members);
+	bq->generation = btrfs_stack_qgroup_info_generation(info);
+	bq->rfer = btrfs_stack_qgroup_info_referenced(info);
+	bq->rfer_cmpr = btrfs_stack_qgroup_info_referenced_compressed(info);
+	bq->excl = btrfs_stack_qgroup_info_exclusive(info);
+	bq->excl_cmpr = btrfs_stack_qgroup_info_exclusive_compressed(info);
+
+	return 0;
+}
+
+static int update_qgroup_limit(struct qgroup_lookup *qgroup_lookup,
+			       u64 qgroupid,
+			       struct btrfs_qgroup_limit_item *limit)
+{
+	struct btrfs_qgroup *bq;
+
+	bq = get_or_add_qgroup(qgroup_lookup, qgroupid);
+	if (IS_ERR_OR_NULL(bq))
+		return PTR_ERR(bq);
+
+	bq->flags = btrfs_stack_qgroup_limit_flags(limit);
+	bq->max_rfer = btrfs_stack_qgroup_limit_max_referenced(limit);
+	bq->max_excl = btrfs_stack_qgroup_limit_max_exclusive(limit);
+	bq->rsv_rfer = btrfs_stack_qgroup_limit_rsv_referenced(limit);
+	bq->rsv_excl = btrfs_stack_qgroup_limit_rsv_exclusive(limit);
+
+	return 0;
+}
+
+static int update_qgroup_relation(struct qgroup_lookup *qgroup_lookup,
+				  u64 child_id, u64 parent_id)
+{
+	struct btrfs_qgroup *child;
+	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup_list *list;
+
+	child = qgroup_tree_search(qgroup_lookup, child_id);
+	if (!child) {
+		error("cannot find the qgroup %llu/%llu",
+		      btrfs_qgroup_level(child_id),
+		      btrfs_qgroup_subvid(child_id));
+		return -ENOENT;
 	}
+
+	parent = qgroup_tree_search(qgroup_lookup, parent_id);
+	if (!parent) {
+		error("cannot find the qgroup %llu/%llu",
+		      btrfs_qgroup_level(parent_id),
+		      btrfs_qgroup_subvid(parent_id));
+		return -ENOENT;
+	}
+
+	list = malloc(sizeof(*list));
+	if (!list) {
+		error("memory allocation failed");
+		return -ENOMEM;
+	}
+
+	list->qgroup = parent;
+	list->member = child;
+	list_add_tail(&list->next_qgroup, &child->qgroups);
+	list_add_tail(&list->next_member, &parent->members);
+
 	return 0;
 }
 
@@ -1019,13 +1048,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	unsigned int i;
 	struct btrfs_qgroup_info_item *info;
 	struct btrfs_qgroup_limit_item *limit;
-	struct btrfs_qgroup *bq;
-	struct btrfs_qgroup *bq1;
-	u64 a1;
-	u64 a2;
-	u64 a3;
-	u64 a4;
-	u64 a5;
+	u64 qgroupid;
+	u64 qgroupid1;
 
 	memset(&args, 0, sizeof(args));
 
@@ -1069,55 +1093,30 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				print_status_flag_warning(flags);
 			} else if (btrfs_search_header_type(sh)
 				   == BTRFS_QGROUP_INFO_KEY) {
+				qgroupid = btrfs_search_header_offset(sh);
 				info = (struct btrfs_qgroup_info_item *)
 				       (args.buf + off);
-				a1 = btrfs_stack_qgroup_info_generation(info);
-				a2 = btrfs_stack_qgroup_info_referenced(info);
-				a3 =
-				  btrfs_stack_qgroup_info_referenced_compressed
-				  (info);
-				a4 = btrfs_stack_qgroup_info_exclusive(info);
-				a5 =
-				  btrfs_stack_qgroup_info_exclusive_compressed
-				  (info);
-				update_qgroup(qgroup_lookup,
-					btrfs_search_header_offset(sh), a1,
-					a2, a3, a4, a5, 0, 0, 0, 0, 0, NULL,
-					NULL);
+
+				update_qgroup_info(qgroup_lookup, qgroupid,
+						   info);
 			} else if (btrfs_search_header_type(sh)
 				   == BTRFS_QGROUP_LIMIT_KEY) {
+				qgroupid = btrfs_search_header_offset(sh);
 				limit = (struct btrfs_qgroup_limit_item *)
-				    (args.buf + off);
-
-				a1 = btrfs_stack_qgroup_limit_flags(limit);
-				a2 = btrfs_stack_qgroup_limit_max_referenced
-				     (limit);
-				a3 = btrfs_stack_qgroup_limit_max_exclusive
-				     (limit);
-				a4 = btrfs_stack_qgroup_limit_rsv_referenced
-				     (limit);
-				a5 = btrfs_stack_qgroup_limit_rsv_exclusive
-				     (limit);
-				update_qgroup(qgroup_lookup,
-					   btrfs_search_header_offset(sh), 0,
-					   0, 0, 0, 0, a1, a2, a3, a4, a5,
-					   NULL, NULL);
+					(args.buf + off);
+
+				update_qgroup_limit(qgroup_lookup, qgroupid,
+						    limit);
 			} else if (btrfs_search_header_type(sh)
 				   == BTRFS_QGROUP_RELATION_KEY) {
-				if (btrfs_search_header_offset(sh)
-				    < btrfs_search_header_objectid(sh))
-					goto skip;
-				bq = qgroup_tree_search(qgroup_lookup,
-					btrfs_search_header_offset(sh));
-				if (!bq)
-					goto skip;
-				bq1 = qgroup_tree_search(qgroup_lookup,
-					 btrfs_search_header_objectid(sh));
-				if (!bq1)
+				qgroupid = btrfs_search_header_offset(sh);
+				qgroupid1 = btrfs_search_header_objectid(sh);
+
+				if (qgroupid < qgroupid1)
 					goto skip;
-				update_qgroup(qgroup_lookup,
-					   btrfs_search_header_offset(sh), 0,
-					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
+
+				update_qgroup_relation(qgroup_lookup, qgroupid,
+						       qgroupid1);
 			} else
 				goto done;
 skip:
-- 
2.14.3



