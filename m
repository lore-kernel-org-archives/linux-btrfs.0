Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947446AbeCBSrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:16 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7A64AE89
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:14 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 5/8] btrfs-progs: qgroups: introduce and use info and limit structures
Date: Fri,  2 Mar 2018 13:47:01 -0500
Message-Id: <20180302184704.22399-6-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We use structures to pass the info and limit from the kernel as items
but store the individual values separately in btrfs_qgroup.  We already
have a btrfs_qgroup_limit structure that's used for setting the limit.

This patch introduces a btrfs_qgroup_info structure and uses that and
btrfs_qgroup_limit in btrfs_qgroup.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 qgroup.c | 73 +++++++++++++++++++++++++++++++---------------------------------
 qgroup.h |  8 +++++++
 2 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 83918134..b1be3311 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -46,20 +46,12 @@ struct btrfs_qgroup {
 	/*
 	 * info_item
 	 */
-	u64 generation;
-	u64 rfer;	/*referenced*/
-	u64 rfer_cmpr;	/*referenced compressed*/
-	u64 excl;	/*exclusive*/
-	u64 excl_cmpr;	/*exclusive compressed*/
+	struct btrfs_qgroup_info info;
 
 	/*
 	 *limit_item
 	 */
-	u64 flags;	/*which limits are set*/
-	u64 max_rfer;
-	u64 max_excl;
-	u64 rsv_rfer;
-	u64 rsv_excl;
+	struct btrfs_qgroup_limit limit;
 
 	/*qgroups this group is member of*/
 	struct list_head qgroups;
@@ -272,24 +264,24 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->rfer, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(qgroup->info.referenced, unit_mode));
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->excl, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(qgroup->info.exclusive, unit_mode));
 		break;
 	case BTRFS_QGROUP_PARENT:
 		len = print_parent_column(qgroup);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
-			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
+		if (qgroup->limit.flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
+			len = printf("%*s", max_len, pretty_size_mode(qgroup->limit.max_referenced, unit_mode));
 		else
 			len = printf("%*s", max_len, "none");
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
-			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
+		if (qgroup->limit.flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+			len = printf("%*s", max_len, pretty_size_mode(qgroup->limit.max_exclusive, unit_mode));
 		else
 			len = printf("%*s", max_len, "none");
 		break;
@@ -432,9 +424,9 @@ static int comp_entry_with_rfer(struct btrfs_qgroup *entry1,
 {
 	int ret;
 
-	if (entry1->rfer > entry2->rfer)
+	if (entry1->info.referenced > entry2->info.referenced)
 		ret = 1;
-	else if (entry1->rfer < entry2->rfer)
+	else if (entry1->info.referenced < entry2->info.referenced)
 		ret = -1;
 	else
 		ret = 0;
@@ -448,9 +440,9 @@ static int comp_entry_with_excl(struct btrfs_qgroup *entry1,
 {
 	int ret;
 
-	if (entry1->excl > entry2->excl)
+	if (entry1->info.exclusive > entry2->info.exclusive)
 		ret = 1;
-	else if (entry1->excl < entry2->excl)
+	else if (entry1->info.exclusive < entry2->info.exclusive)
 		ret = -1;
 	else
 		ret = 0;
@@ -464,9 +456,9 @@ static int comp_entry_with_max_rfer(struct btrfs_qgroup *entry1,
 {
 	int ret;
 
-	if (entry1->max_rfer > entry2->max_rfer)
+	if (entry1->limit.max_referenced > entry2->limit.max_referenced)
 		ret = 1;
-	else if (entry1->max_rfer < entry2->max_rfer)
+	else if (entry1->limit.max_referenced < entry2->limit.max_referenced)
 		ret = -1;
 	else
 		ret = 0;
@@ -480,9 +472,9 @@ static int comp_entry_with_max_excl(struct btrfs_qgroup *entry1,
 {
 	int ret;
 
-	if (entry1->max_excl > entry2->max_excl)
+	if (entry1->limit.max_exclusive > entry2->limit.max_exclusive)
 		ret = 1;
-	else if (entry1->max_excl < entry2->max_excl)
+	else if (entry1->limit.max_exclusive < entry2->limit.max_exclusive)
 		ret = -1;
 	else
 		ret = 0;
@@ -739,11 +731,13 @@ static int update_qgroup_info(int fd, struct qgroup_lookup *qgroup_lookup,
 	if (IS_ERR_OR_NULL(bq))
 		return PTR_ERR(bq);
 
-	bq->generation = btrfs_stack_qgroup_info_generation(info);
-	bq->rfer = btrfs_stack_qgroup_info_referenced(info);
-	bq->rfer_cmpr = btrfs_stack_qgroup_info_referenced_compressed(info);
-	bq->excl = btrfs_stack_qgroup_info_exclusive(info);
-	bq->excl_cmpr = btrfs_stack_qgroup_info_exclusive_compressed(info);
+	bq->info.generation = btrfs_stack_qgroup_info_generation(info);
+	bq->info.referenced = btrfs_stack_qgroup_info_referenced(info);
+	bq->info.referenced_compressed =
+			btrfs_stack_qgroup_info_referenced_compressed(info);
+	bq->info.exclusive = btrfs_stack_qgroup_info_exclusive(info);
+	bq->info.exclusive_compressed =
+			btrfs_stack_qgroup_info_exclusive_compressed(info);
 
 	return 0;
 }
@@ -758,11 +752,14 @@ static int update_qgroup_limit(int fd, struct qgroup_lookup *qgroup_lookup,
 	if (IS_ERR_OR_NULL(bq))
 		return PTR_ERR(bq);
 
-	bq->flags = btrfs_stack_qgroup_limit_flags(limit);
-	bq->max_rfer = btrfs_stack_qgroup_limit_max_referenced(limit);
-	bq->max_excl = btrfs_stack_qgroup_limit_max_exclusive(limit);
-	bq->rsv_rfer = btrfs_stack_qgroup_limit_rsv_referenced(limit);
-	bq->rsv_excl = btrfs_stack_qgroup_limit_rsv_exclusive(limit);
+	bq->limit.flags = btrfs_stack_qgroup_limit_flags(limit);
+	bq->limit.max_referenced =
+			btrfs_stack_qgroup_limit_max_referenced(limit);
+	bq->limit.max_exclusive =
+			btrfs_stack_qgroup_limit_max_exclusive(limit);
+	bq->limit.rsv_referenced =
+			btrfs_stack_qgroup_limit_rsv_referenced(limit);
+	bq->limit.rsv_exclusive = btrfs_stack_qgroup_limit_rsv_exclusive(limit);
 
 	return 0;
 }
@@ -1053,22 +1050,22 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = strlen(pretty_size_mode(bq->rfer, unit_mode));
+		len = strlen(pretty_size_mode(bq->info.referenced, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = strlen(pretty_size_mode(bq->excl, unit_mode));
+		len = strlen(pretty_size_mode(bq->info.exclusive, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = strlen(pretty_size_mode(bq->max_rfer, unit_mode));
+		len = strlen(pretty_size_mode(bq->limit.max_referenced, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = strlen(pretty_size_mode(bq->max_excl, unit_mode));
+		len = strlen(pretty_size_mode(bq->limit.max_exclusive, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
diff --git a/qgroup.h b/qgroup.h
index f7ab7de5..5e71349c 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -79,6 +79,14 @@ enum btrfs_qgroup_filter_enum {
 	BTRFS_QGROUP_FILTER_MAX,
 };
 
+struct btrfs_qgroup_info {
+	u64 generation;
+	u64 referenced;
+	u64 referenced_compressed;
+	u64 exclusive;
+	u64 exclusive_compressed;
+};
+
 int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-- 
2.15.1

