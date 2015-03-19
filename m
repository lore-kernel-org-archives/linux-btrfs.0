Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbbCSGEw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:52 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs-progs: qgroup: add incompatability feature for QGROUP_TYPE.
Date: Thu, 19 Mar 2015 14:00:54 +0800
Message-ID: <1426744864-7031-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch splits info and limits from qgroup.

    btrfs_qgroup:                                     |-------------|
    -----------------                                 |rfer         |
    |data_info      |--------------->btrfs_qgroup_info|rfer_cmpr    |
    |metadata_info  |                                 |excl         |
    |               |                                 |excl_cmpr    |
    |data_limits    |                                 ---------------
    |metadata_limits|
    |mixed_limits   |--------------->btrfs_qgroup_limits|-------------
    |-------------- |                                   |lim_flags  |
                                                        |max_rfer   |
                                                        |max_excl   |
                                                        |rsv_rfer   |
                                                        |rsv_excl   |
                                                        ------------

And the objectid for each items are changed:
    ------------------------------------              ------------------------------------------------
    |0 |BTRFS_QGROUP_INFO_KEY |qgroupid| ------------>|TYPE_OBJECTID |BTRFS_QGROUP_INFO_KEY |qgroupid|
    ------------------------------------              ------------------------------------------------

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 ctree.h  |  20 ++++++-
 mkfs.c   |   2 +
 qgroup.c | 184 +++++++++++++++++++++++++++++++++++++++++++--------------------
 3 files changed, 147 insertions(+), 59 deletions(-)

diff --git a/ctree.h b/ctree.h
index 2d2988b..85d4992 100644
--- a/ctree.h
+++ b/ctree.h
@@ -125,6 +125,22 @@ struct btrfs_free_space_ctl;
 #define BTRFS_DEV_ITEMS_OBJECTID 1ULL
 
 /*
+ *  * the items for qgroup info.
+ *   */
+#define BTRFS_QGROUP_DATA_INFO_OBJECTID 1ULL
+
+#define BTRFS_QGROUP_METADATA_INFO_OBJECTID 2ULL
+
+/*
+ *  * the items for qgroup limits.
+ *   */
+#define BTRFS_QGROUP_DATA_LIMIT_OBJECTID 1ULL
+
+#define BTRFS_QGROUP_METADATA_LIMIT_OBJECTID 2ULL
+
+#define BTRFS_QGROUP_MIXED_LIMIT_OBJECTID 3ULL
+
+/*
  * the max metadata block size.  This limit is somewhat artificial,
  * but the memmove costs go through the roof for larger blocks.
  */
@@ -473,6 +489,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE	(1ULL << 10)
 
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
@@ -486,7 +503,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/mkfs.c b/mkfs.c
index f83554d..de7612b 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1143,6 +1143,8 @@ static const struct btrfs_fs_feature {
 		"reduced-size metadata extent refs" },
 	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
 		"no explicit hole extents for files" },
+	{ "qgroup-type", BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE,
+		"account data and metadata separately" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/qgroup.c b/qgroup.c
index 5a4e393..91e25ea 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -30,6 +30,26 @@ struct qgroup_lookup {
 	struct rb_root root;
 };
 
+struct btrfs_qgroup_info {
+        u64 rfer;       /* referenced */
+        u64 rfer_cmpr;  /* referenced compressed */
+        u64 excl;       /* exclusive */
+        u64 excl_cmpr;  /* exclusive compressed */
+
+        /*
+	 * reservation tracking
+	 */
+        u64 reserved;
+};
+
+struct btrfs_qgroup_limits {
+        u64 flags;  /* which limits are set */
+        u64 max_rfer;
+        u64 max_excl;
+        u64 rsv_rfer;
+        u64 rsv_excl;
+};
+
 struct btrfs_qgroup {
 	struct rb_node rb_node;
 	struct rb_node sort_node;
@@ -40,23 +60,20 @@ struct btrfs_qgroup {
 	struct rb_node all_parent_node;
 	u64 qgroupid;
 
+	u64 generation;
+
 	/*
 	 * info_item
 	 */
-	u64 generation;
-	u64 rfer;	/*referenced*/
-	u64 rfer_cmpr;	/*referenced compressed*/
-	u64 excl;	/*exclusive*/
-	u64 excl_cmpr;	/*exclusive compressed*/
+	struct btrfs_qgroup_info        data_info;
+	struct btrfs_qgroup_info        metadata_info;
 
 	/*
 	 *limit_item
 	 */
-	u64 flags;	/*which limits are set*/
-	u64 max_rfer;
-	u64 max_excl;
-	u64 rsv_rfer;
-	u64 rsv_excl;
+	struct btrfs_qgroup_limits      data_limits;
+	struct btrfs_qgroup_limits      metadata_limits;
+	struct btrfs_qgroup_limits      mixed_limits;
 
 	/*qgroups this group is member of*/
 	struct list_head qgroups;
@@ -215,6 +232,8 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	int len;
 	int unit_mode = btrfs_qgroup_columns[column].unit_mode;
 	int max_len = btrfs_qgroup_columns[column].max_len;
+	struct btrfs_qgroup_info *info = &qgroup->data_info;
+	struct btrfs_qgroup_limits *limits = &qgroup->mixed_limits;
 
 	switch (column) {
 
@@ -224,20 +243,20 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->rfer, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(info->rfer, unit_mode));
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->excl, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(info->excl, unit_mode));
 		break;
 	case BTRFS_QGROUP_PARENT:
 		len = print_parent_column(qgroup);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(limits->max_rfer, unit_mode));
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
+		len = printf("%*s", max_len, pretty_size_mode(limits->max_excl, unit_mode));
 		break;
 	case BTRFS_QGROUP_CHILD:
 		len = print_child_column(qgroup);
@@ -333,10 +352,12 @@ static int comp_entry_with_rfer(struct btrfs_qgroup *entry1,
 				int is_descending)
 {
 	int ret;
+	struct btrfs_qgroup_info *info1 = &entry1->data_info;
+	struct btrfs_qgroup_info *info2 = &entry2->data_info;
 
-	if (entry1->rfer > entry2->rfer)
+	if (info1->rfer > info2->rfer)
 		ret = 1;
-	else if (entry1->rfer < entry2->rfer)
+	else if (info1->rfer < info2->rfer)
 		ret = -1;
 	else
 		ret = 0;
@@ -349,10 +370,12 @@ static int comp_entry_with_excl(struct btrfs_qgroup *entry1,
 				int is_descending)
 {
 	int ret;
+	struct btrfs_qgroup_info *info1 = &entry1->data_info;
+	struct btrfs_qgroup_info *info2 = &entry2->data_info;
 
-	if (entry1->excl > entry2->excl)
+	if (info1->excl > info2->excl)
 		ret = 1;
-	else if (entry1->excl < entry2->excl)
+	else if (info1->excl < info2->excl)
 		ret = -1;
 	else
 		ret = 0;
@@ -365,10 +388,12 @@ static int comp_entry_with_max_rfer(struct btrfs_qgroup *entry1,
 				    int is_descending)
 {
 	int ret;
+	struct btrfs_qgroup_limits *limits1 = &entry1->mixed_limits;
+	struct btrfs_qgroup_limits *limits2 = &entry2->mixed_limits;
 
-	if (entry1->max_rfer > entry2->max_rfer)
+	if (limits1->max_rfer > limits2->max_rfer)
 		ret = 1;
-	else if (entry1->max_rfer < entry2->max_rfer)
+	else if (limits1->max_rfer < limits2->max_rfer)
 		ret = -1;
 	else
 		ret = 0;
@@ -381,10 +406,12 @@ static int comp_entry_with_max_excl(struct btrfs_qgroup *entry1,
 				    int is_descending)
 {
 	int ret;
+	struct btrfs_qgroup_limits *limits1 = &entry1->mixed_limits;
+	struct btrfs_qgroup_limits *limits2 = &entry2->mixed_limits;
 
-	if (entry1->max_excl > entry2->max_excl)
+	if (limits1->max_excl > limits2->max_excl)
 		ret = 1;
-	else if (entry1->max_excl < entry2->max_excl)
+	else if (limits1->max_excl < limits2->max_excl)
 		ret = -1;
 	else
 		ret = 0;
@@ -571,12 +598,14 @@ static struct btrfs_qgroup *qgroup_tree_search(struct qgroup_lookup *root_tree,
 }
 
 static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-			 u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-			 u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
-			 u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *pa,
-			 struct btrfs_qgroup *child)
+			 u64 generation, u64 info_id, u64 rfer, u64 rfer_cmpr,
+			 u64 excl, u64 excl_cmpr, u64 limit_id, u64 flags,
+			 u64 max_rfer, u64 max_excl, u64 rsv_rfer, u64 rsv_excl,
+			 struct btrfs_qgroup *pa, struct btrfs_qgroup *child)
 {
 	struct btrfs_qgroup *bq;
+	struct btrfs_qgroup_info *info;
+	struct btrfs_qgroup_limits *limits;
 	struct btrfs_qgroup_list *list;
 
 	bq = qgroup_tree_search(qgroup_lookup, qgroupid);
@@ -585,22 +614,32 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 
 	if (generation)
 		bq->generation = generation;
+	if (info_id == BTRFS_QGROUP_DATA_INFO_OBJECTID)
+		info = &bq->data_info;
+	else
+		info = &bq->metadata_info;
 	if (rfer)
-		bq->rfer = rfer;
+		info->rfer = rfer;
 	if (rfer_cmpr)
-		bq->rfer_cmpr = rfer_cmpr;
+		info->rfer_cmpr = rfer_cmpr;
 	if (excl)
-		bq->excl = excl;
+		info->excl = excl;
 	if (excl_cmpr)
-		bq->excl_cmpr = excl_cmpr;
+		info->excl_cmpr = excl_cmpr;
+	if (limit_id == BTRFS_QGROUP_DATA_LIMIT_OBJECTID)
+		limits = &bq->data_limits;
+	else if (limit_id == BTRFS_QGROUP_METADATA_LIMIT_OBJECTID)
+		limits = &bq->metadata_limits;
+	else
+		limits = &bq->mixed_limits;
 	if (flags)
-		bq->flags = flags;
+		limits->flags = flags;
 	if (max_rfer)
-		bq->max_rfer = max_rfer;
+		limits->max_rfer = max_rfer;
 	if (max_excl)
-		bq->max_excl = max_excl;
+		limits->max_excl = max_excl;
 	if (rsv_rfer)
-		bq->rsv_rfer = rsv_rfer;
+		limits->rsv_rfer = rsv_rfer;
 	if (pa && child) {
 		list = malloc(sizeof(*list));
 		if (!list) {
@@ -616,17 +655,19 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 }
 
 static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-		      u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-		      u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
-		      u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *parent,
-		      struct btrfs_qgroup *child)
+		      u64 generation, u64 info_id, u64 rfer, u64 rfer_cmpr,
+		      u64 excl, u64 excl_cmpr, u64 limit_id, u64 flags,
+		      u64 max_rfer, u64 max_excl, u64 rsv_rfer, u64 rsv_excl,
+		      struct btrfs_qgroup *parent, struct btrfs_qgroup *child)
 {
 	struct btrfs_qgroup *bq;
+	struct btrfs_qgroup_info *info;
+	struct btrfs_qgroup_limits *limits;
 	struct btrfs_qgroup_list *list;
 	int ret;
 
-	ret = update_qgroup(qgroup_lookup, qgroupid, generation, rfer,
-			    rfer_cmpr, excl, excl_cmpr, flags, max_rfer,
+	ret = update_qgroup(qgroup_lookup, qgroupid, generation, info_id, rfer,
+			    rfer_cmpr, excl, excl_cmpr, limit_id, flags, max_rfer,
 			    max_excl, rsv_rfer, rsv_excl, parent, child);
 	if (!ret)
 		return 0;
@@ -644,22 +685,32 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	}
 	if (generation)
 		bq->generation = generation;
+	if (info_id == BTRFS_QGROUP_DATA_INFO_OBJECTID)
+		info = &bq->data_info;
+	else
+		info = &bq->metadata_info;
 	if (rfer)
-		bq->rfer = rfer;
+		info->rfer = rfer;
 	if (rfer_cmpr)
-		bq->rfer_cmpr = rfer_cmpr;
+		info->rfer_cmpr = rfer_cmpr;
 	if (excl)
-		bq->excl = excl;
+		info->excl = excl;
 	if (excl_cmpr)
-		bq->excl_cmpr = excl_cmpr;
+		info->excl_cmpr = excl_cmpr;
+	if (limit_id == BTRFS_QGROUP_DATA_LIMIT_OBJECTID)
+		limits = &bq->data_limits;
+	else if (limit_id == BTRFS_QGROUP_METADATA_LIMIT_OBJECTID)
+		limits = &bq->metadata_limits;
+	else
+		limits = &bq->mixed_limits;
 	if (flags)
-		bq->flags = flags;
+		limits->flags = flags;
 	if (max_rfer)
-		bq->max_rfer = max_rfer;
+		limits->max_rfer = max_rfer;
 	if (max_excl)
-		bq->max_excl = max_excl;
+		limits->max_excl = max_excl;
 	if (rsv_rfer)
-		bq->rsv_rfer = rsv_rfer;
+		limits->rsv_rfer = rsv_rfer;
 	if (parent && child) {
 		list = malloc(sizeof(*list));
 		if (!list) {
@@ -917,6 +968,8 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 	char tmp[100];
 	int len;
 	unsigned unit_mode = btrfs_qgroup_columns[column].unit_mode;
+	struct btrfs_qgroup_info *info = &bq->data_info;
+	struct btrfs_qgroup_limits *limits = &bq->mixed_limits;
 
 	switch (column) {
 
@@ -928,22 +981,22 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = strlen(pretty_size_mode(bq->rfer, unit_mode));
+		len = strlen(pretty_size_mode(info->rfer, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = strlen(pretty_size_mode(bq->excl, unit_mode));
+		len = strlen(pretty_size_mode(info->excl, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = strlen(pretty_size_mode(bq->max_rfer, unit_mode));
+		len = strlen(pretty_size_mode(limits->max_rfer, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = strlen(pretty_size_mode(bq->max_excl, unit_mode));
+		len = strlen(pretty_size_mode(limits->max_excl, unit_mode));
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
@@ -1063,6 +1116,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 		 * read the root_ref item it contains
 		 */
 		for (i = 0; i < sk->nr_items; i++) {
+			u64 objectid = 0;
+
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
 			off += sizeof(*sh);
@@ -1079,8 +1134,15 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				a5 =
 				  btrfs_stack_qgroup_info_exclusive_compressed
 				  (info);
-				add_qgroup(qgroup_lookup, sh->offset, a1, a2,
-					   a3, a4, a5, 0, 0, 0, 0, 0, 0, 0);
+
+				objectid = BTRFS_QGROUP_DATA_INFO_OBJECTID;
+				/*
+				 * Check incompatability of qgroup->type.
+				 */
+				if (sh->objectid != 0)
+					objectid = sh->objectid;
+				add_qgroup(qgroup_lookup, sh->offset, a1, objectid,
+					   a2, a3, a4, a5, 0, 0, 0, 0, 0, 0, 0, 0);
 			} else if (sh->type == BTRFS_QGROUP_LIMIT_KEY) {
 				limit = (struct btrfs_qgroup_limit_item *)
 				    (args.buf + off);
@@ -1094,8 +1156,14 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				     (limit);
 				a5 = btrfs_stack_qgroup_limit_rsv_exclusive
 				     (limit);
-				add_qgroup(qgroup_lookup, sh->offset, 0, 0,
-					   0, 0, 0, a1, a2, a3, a4, a5, 0, 0);
+				objectid = BTRFS_QGROUP_MIXED_LIMIT_OBJECTID;
+				/*
+				 * Check incompatability of qgroup->type.
+				 */
+				if (sh->objectid != 0)
+					objectid = sh->objectid;
+				add_qgroup(qgroup_lookup, sh->offset, 0, 0, 0,
+					   0, 0, 0, objectid, a1, a2, a3, a4, a5, 0, 0);
 			} else if (sh->type == BTRFS_QGROUP_RELATION_KEY) {
 				if (sh->offset < sh->objectid)
 					goto skip;
@@ -1107,8 +1175,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 							 sh->objectid);
 				if (!bq1)
 					goto skip;
-				add_qgroup(qgroup_lookup, sh->offset, 0, 0,
-					   0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
+				add_qgroup(qgroup_lookup, sh->offset, 0, 0, 0,
+					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
 			} else
 				goto done;
 skip:
-- 
1.8.4.2

