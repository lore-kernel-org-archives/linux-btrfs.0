Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47235 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JHQYJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 12:24:09 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so9128931pad.14
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Oct 2013 09:24:08 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 9/12 ] Btrfs-progs: enhance btrfs qgroup to print the result as a table
Date: Wed,  9 Oct 2013 00:24:02 +0800
Message-Id: <1381249442-30868-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch enhance to print the result as a table.

You can use it like:
	btrfs qgroup show <path>
However, to table the result better, we make '-p' and '-c' not present
at the same time.

For example:

	btrfs qgroup show -pr <path>
The result will output as the follow format:

qgroupid rfer       excl       max_excl       parent
-------- ----       ----       --------       ------
0/265    1289752576 1289752576 0              ---
1/0      0          0          10999511627776 2/0,3/0
2/0      0          0          0              ---
3/0      0          0          0              ---

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v4:
	fix a copying error(thanks to Daivd)
---
 qgroup.c | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 170 insertions(+), 22 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 84f5fc1..1c68046 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -80,40 +80,48 @@ struct {
 	char *name;
 	char *column_name;
 	int need_print;
+	int max_len;
 } btrfs_qgroup_columns[] = {
 	{
 		.name		= "qgroupid",
 		.column_name	= "Qgroupid",
 		.need_print	= 1,
+		.max_len	= 8,
 	},
 	{
 		.name		= "rfer",
 		.column_name	= "Rfer",
 		.need_print	= 1,
+		.max_len	= 4,
 	},
 	{
 		.name		= "excl",
 		.column_name	= "Excl",
 		.need_print	= 1,
+		.max_len	= 4,
 	},
 	{	.name		= "max_rfer",
 		.column_name	= "Max_rfer",
 		.need_print	= 0,
+		.max_len	= 8,
 	},
 	{
 		.name		= "max_excl",
 		.column_name	= "Max_excl",
 		.need_print	= 0,
+		.max_len	= 8,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
 		.need_print	= 0,
+		.max_len	= 7,
 	},
 	{
 		.name		= "child",
 		.column_name	= "Child",
 		.need_print	= 0,
+		.max_len	= 5,
 	},
 	{
 		.name		= NULL,
@@ -139,69 +147,91 @@ void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 		btrfs_qgroup_columns[i].need_print = 1;
 }
 
-static void print_parent_column(struct btrfs_qgroup *qgroup)
+static int print_parent_column(struct btrfs_qgroup *qgroup)
 {
 	struct btrfs_qgroup_list *list = NULL;
+	int len = 0;
 
 	list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
-		printf("%llu/%llu", (list->qgroup)->qgroupid >> 48,
-		      ((1ll << 48) - 1) & (list->qgroup)->qgroupid);
+		len += printf("%llu/%llu", (list->qgroup)->qgroupid >> 48,
+			((1ll << 48) - 1) & (list->qgroup)->qgroupid);
 		if (!list_is_last(&list->next_qgroup, &qgroup->qgroups))
-			printf(",");
+			len += printf(",");
 	}
 	if (list_empty(&qgroup->qgroups))
-		printf("---");
+		len += printf("---");
+
+	return len;
 }
 
-static void print_child_column(struct btrfs_qgroup *qgroup)
+static int print_child_column(struct btrfs_qgroup *qgroup)
 {
 	struct btrfs_qgroup_list *list = NULL;
+	int len = 0;
 
 	list_for_each_entry(list, &qgroup->members, next_member) {
-		printf("%llu/%llu", (list->member)->qgroupid >> 48,
-		      ((1ll << 48) - 1) & (list->member)->qgroupid);
+		len += printf("%llu/%llu", (list->member)->qgroupid >> 48,
+				((1ll << 48) - 1) & (list->member)->qgroupid);
 		if (!list_is_last(&list->next_member, &qgroup->members))
-			printf(",");
+			len += printf(",");
 	}
 	if (list_empty(&qgroup->members))
-		printf("---");
+		len += printf("---");
+
+	return len;
+}
+
+static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
+					  int len)
+{
+	len = btrfs_qgroup_columns[column].max_len - len;
+	while (len--)
+		printf(" ");
 }
 
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 				enum btrfs_qgroup_column_enum column)
 {
 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
+	int len;
 
 	switch (column) {
 
 	case BTRFS_QGROUP_QGROUPID:
-		printf("%llu/%llu", qgroup->qgroupid >> 48,
-		       ((1ll << 48) - 1) & qgroup->qgroupid);
+		len = printf("%llu/%llu", qgroup->qgroupid >> 48,
+				((1ll << 48) - 1) & qgroup->qgroupid);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		printf("%lld", qgroup->rfer);
+		len = printf("%lld", qgroup->rfer);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		printf("%lld", qgroup->excl);
+		len = printf("%lld", qgroup->excl);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
 		break;
 	case BTRFS_QGROUP_PARENT:
-		print_parent_column(qgroup);
+		len = print_parent_column(qgroup);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		printf("%llu", qgroup->max_rfer);
+		len = printf("%llu", qgroup->max_rfer);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		printf("%llu", qgroup->max_excl);
+		len = printf("%llu", qgroup->max_excl);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL, len);
 		break;
 	case BTRFS_QGROUP_CHILD:
-		print_child_column(qgroup);
+		len = print_child_column(qgroup);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
 		break;
 	default:
 		break;
 	}
 }
 
-static void print_single_qgroup_default(struct btrfs_qgroup *qgroup)
+static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
 {
 	int i;
 
@@ -210,7 +240,39 @@ static void print_single_qgroup_default(struct btrfs_qgroup *qgroup)
 			continue;
 		print_qgroup_column(qgroup, i);
 
-		if (i != BTRFS_QGROUP_ALL - 1)
+		if (i != BTRFS_QGROUP_CHILD)
+			printf(" ");
+	}
+	printf("\n");
+}
+
+static void print_table_head()
+{
+	int i;
+	int len;
+
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+		printf("%s", btrfs_qgroup_columns[i].name);
+		len = btrfs_qgroup_columns[i].max_len -
+		      strlen(btrfs_qgroup_columns[i].name);
+		while (len--)
+			printf(" ");
+		printf(" ");
+	}
+	printf("\n");
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+
+		len = strlen(btrfs_qgroup_columns[i].name);
+		while (len--)
+			printf("-");
+		len = btrfs_qgroup_columns[i].max_len -
+		      strlen(btrfs_qgroup_columns[i].name);
+		printf(" ");
+		while (len--)
 			printf(" ");
 	}
 	printf("\n");
@@ -819,6 +881,88 @@ static int sort_tree_insert(struct qgroup_lookup *sort_tree,
 	return 0;
 }
 
+static void __update_columns_max_len(struct btrfs_qgroup *bq,
+				     enum btrfs_qgroup_column_enum column)
+{
+	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
+	struct btrfs_qgroup_list *list = NULL;
+	char tmp[100];
+	int len;
+
+	switch (column) {
+
+	case BTRFS_QGROUP_QGROUPID:
+		sprintf(tmp, "%llu/%llu", (bq->qgroupid >> 48),
+			bq->qgroupid & ((1ll << 48) - 1));
+		len = strlen(tmp);
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_RFER:
+		sprintf(tmp, "%llu", bq->rfer);
+		len = strlen(tmp);
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_EXCL:
+		sprintf(tmp, "%llu", bq->excl);
+		len = strlen(tmp);
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_MAX_RFER:
+		sprintf(tmp, "%llu", bq->max_rfer);
+		len = strlen(tmp);
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_MAX_EXCL:
+		sprintf(tmp, "%llu", bq->max_excl);
+		len = strlen(tmp);
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_PARENT:
+		len = 0;
+		list_for_each_entry(list, &bq->qgroups, next_qgroup) {
+			len += sprintf(tmp, "%llu/%llu",
+				(list->qgroup)->qgroupid >> 48,
+				((1ll << 48) - 1) & (list->qgroup)->qgroupid);
+			if (!list_is_last(&list->next_qgroup, &bq->qgroups))
+				len += 1;
+		}
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	case BTRFS_QGROUP_CHILD:
+		len = 0;
+		list_for_each_entry(list, &bq->members, next_member) {
+			len += sprintf(tmp, "%llu/%llu",
+				(list->member)->qgroupid >> 48,
+				((1ll << 48) - 1) & (list->member)->qgroupid);
+			if (!list_is_last(&list->next_member, &bq->members))
+				len += 1;
+		}
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
+	default:
+		break;
+	}
+
+}
+
+static void update_columns_max_len(struct btrfs_qgroup *bq)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+		__update_columns_max_len(bq, i);
+	}
+}
+
 static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 				 struct qgroup_lookup *sort_tree,
 				 struct btrfs_qgroup_filter_set *filter_set,
@@ -836,9 +980,11 @@ static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 		entry = rb_entry(n, struct btrfs_qgroup, rb_node);
 
 		ret = filter_qgroup(entry, filter_set);
-		if (ret)
+		if (ret) {
 			sort_tree_insert(sort_tree, entry, comp_set);
 
+			update_columns_max_len(entry);
+		}
 		n = rb_prev(n);
 	}
 }
@@ -972,10 +1118,12 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 	struct rb_node *n;
 	struct btrfs_qgroup *entry;
 
+	print_table_head();
+
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_default(entry);
+		print_single_qgroup_table(entry);
 		n = rb_next(n);
 	}
 }
-- 
1.7.11.7

