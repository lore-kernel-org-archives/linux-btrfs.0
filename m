Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab2LFJvT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:51:19 -0500
Message-ID: <50C06AAD.5030700@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:51:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 9/9] Btrfs-progs: enhance btrfs qgroup to print the result
 as a table
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduce '-t' option which can help you print the result
as a table.

You can use it like:
	btrfs qgroup show -t <path>
However, to table the result better, we make '-p' and '-c' not present
at the same time.If you still want to show both of them at the same time,
you may print the result without '-t' option.

For example:

	btrfs qgroup show -tpl <path>
The result will output as the follow format:

qgroupid rfer       excl       max_excl       parent
-------- ----       ----       --------       ------
0/265    1289752576 1289752576 0              ---
1/0      0          0          10999511627776 2/0,3/0
2/0      0          0          0              ---
3/0      0          0          0              ---

Signed-off-by: Wang shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |  20 ++++++-
 qgroup.c      | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 qgroup.h      |   3 +-
 3 files changed, 191 insertions(+), 11 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index dd74366..1cba305 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -199,13 +199,14 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcleF "
+	"btrfs qgroup show -pcleFt "
 	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
 	"Show subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
 	"-l		print max referenced size of qgroup",
 	"-e		print max exclusive size of qgroup",
+	"-t		print the result as a table",
 	"-F		list all qgroups which impact the given path"
 	"(include ancestral qgroups)",
 	"-f		list all qgroups which impact the given path"
@@ -226,6 +227,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int c;
 	u64 qgroupid;
 	int filter_flag = 0;
+	int is_table_result = 0;
+	int table_better = 0;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -239,17 +242,19 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt_long(argc, argv, "pcleFf",
+		c = getopt_long(argc, argv, "pcleFft",
 				long_options, NULL);
 		if (c < 0)
 			break;
 
 		switch (c) {
 		case 'p':
+			table_better |= 0x1;
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_PARENT);
 			break;
 		case 'c':
+			table_better |= 0x2;
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_CHILD);
 			break;
@@ -261,6 +266,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 						BTRFS_QGROUP_MAX_EXCL);
 			break;
+		case 't':
+			is_table_result = 1;
+			break;
 		case 'F':
 			filter_flag |= 0x1;
 			break;
@@ -297,7 +305,13 @@ static int cmd_qgroup_show(int argc, char **argv)
 					  BTRFS_QGROUP_FILTER_PARENT,
 					  qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
+	if (is_table_result && table_better == 3) {
+		fprintf(stderr, "ERROR: '-p' and '-c' can't used "
+			"at the same time\n");
+		exit(1);
+	}
+	ret = btrfs_show_qgroups(fd, filter_set, comparer_set,
+				 is_table_result);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: can't list qgroups\n");
 		return 30;
diff --git a/qgroup.c b/qgroup.c
index fba675c..f1218eb 100644
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
@@ -167,8 +175,27 @@ static void print_child_column(struct btrfs_qgroup *qgroup)
 		printf("---");
 }
 
+static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
+					  u64 value)
+{
+	char tmp[100];
+	int len;
+
+	if (column == BTRFS_QGROUP_QGROUPID) {
+		sprintf(tmp, "%llu/%llu", value >> 48,
+			((1ll << 48) - 1) & value);
+	} else
+		sprintf(tmp, "%llu", value);
+	len = btrfs_qgroup_columns[column].max_len - strlen(tmp);
+	memset(tmp, 0, sizeof(tmp));
+	while (len--)
+		strcat(tmp, " ");
+	printf("%s", tmp);
+}
+
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
-				enum btrfs_qgroup_column_enum column)
+				enum btrfs_qgroup_column_enum column,
+				int is_table_result)
 {
 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
 
@@ -177,18 +204,33 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	case BTRFS_QGROUP_QGROUPID:
 		printf("%llu/%llu", qgroup->qgroupid >> 48,
 		       ((1ll << 48) - 1) & qgroup->qgroupid);
+		if (is_table_result)
+			print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID,
+						      qgroup->qgroupid);
 		break;
 	case BTRFS_QGROUP_RFER:
 		printf("%llu", qgroup->rfer);
+		if (is_table_result)
+			print_qgroup_column_add_blank(BTRFS_QGROUP_RFER,
+						      qgroup->rfer);
 		break;
 	case BTRFS_QGROUP_EXCL:
 		printf("%llu", qgroup->excl);
+		if (is_table_result)
+			print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL,
+						      qgroup->excl);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
 		printf("%llu", qgroup->max_rfer);
+		if (is_table_result)
+			print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER,
+						      qgroup->max_rfer);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
 		printf("%llu", qgroup->max_excl);
+		if (is_table_result)
+			print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL,
+						      qgroup->max_excl);
 		break;
 	case BTRFS_QGROUP_PARENT:
 		print_parent_column(qgroup);
@@ -208,7 +250,7 @@ static void print_single_qgroup_default(struct btrfs_qgroup *qgroup)
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
-		print_qgroup_column(qgroup, i);
+		print_qgroup_column(qgroup, i, 0);
 
 		if (i != BTRFS_QGROUP_ALL - 1)
 			printf(" ");
@@ -216,6 +258,58 @@ static void print_single_qgroup_default(struct btrfs_qgroup *qgroup)
 	printf("\n");
 }
 
+static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+		print_qgroup_column(qgroup, i, 1);
+
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
+	char barrier[20];
+
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+		printf("%s", btrfs_qgroup_columns[i].name);
+		len = btrfs_qgroup_columns[i].max_len -
+		      strlen(btrfs_qgroup_columns[i].name);
+		memset(barrier, 0, sizeof(barrier));
+		while (len--)
+			strcat(barrier, " ");
+		printf("%s ", barrier);
+	}
+	printf("\n");
+	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
+		if (!btrfs_qgroup_columns[i].need_print)
+			continue;
+
+		len = strlen(btrfs_qgroup_columns[i].name);
+		memset(barrier, 0, sizeof(barrier));
+		while (len--)
+			strcat(barrier, "-");
+		printf("%s", barrier);
+		len = btrfs_qgroup_columns[i].max_len -
+		      strlen(btrfs_qgroup_columns[i].name);
+		memset(barrier, 0, sizeof(barrier));
+		while (len--)
+			strcat(barrier, " ");
+		printf("%s ", barrier);
+	}
+	printf("\n");
+}
+
 static void qgroup_lookup_init(struct qgroup_lookup *tree)
 {
 	tree->root.rb_node = NULL;
@@ -819,6 +913,67 @@ static int sort_tree_insert(struct qgroup_lookup *sort_tree,
 	return 0;
 }
 
+static void __update_columns_max_len(struct btrfs_qgroup *bq,
+				     enum btrfs_qgroup_column_enum column)
+{
+	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
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
+		break;
+	case BTRFS_QGROUP_CHILD:
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
@@ -836,9 +991,11 @@ static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
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
@@ -966,23 +1123,31 @@ done:
 	return ret;
 }
 
-static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
+static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup,
+			      int is_table_result)
 {
 
 	struct rb_node *n;
 	struct btrfs_qgroup *entry;
 
+	if (is_table_result)
+		print_table_head();
+
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_default(entry);
+		if (!is_table_result)
+			print_single_qgroup_default(entry);
+		else
+			print_single_qgroup_table(entry);
 		n = rb_next(n);
 	}
 }
 
 int btrfs_show_qgroups(int fd,
 		       struct btrfs_qgroup_filter_set *filter_set,
-		       struct btrfs_qgroup_comparer_set *comp_set)
+		       struct btrfs_qgroup_comparer_set *comp_set,
+		       int is_table_result)
 {
 
 	struct qgroup_lookup qgroup_lookup;
@@ -994,7 +1159,7 @@ int btrfs_show_qgroups(int fd,
 		return ret;
 	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
 				  filter_set, comp_set);
-	print_all_qgroups(&sort_tree);
+	print_all_qgroups(&sort_tree, is_table_result);
 
 	__free_all_qgroups(&qgroup_lookup);
 	btrfs_qgroup_free_filter_set(filter_set);
diff --git a/qgroup.h b/qgroup.h
index 032ceda..64984a6 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -81,7 +81,8 @@ int btrfs_qgroup_parse_sort_string(char *optarg,
 				   struct btrfs_qgroup_comparer_set **comps);
 u64 btrfs_get_path_rootid(int fd);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-		       struct btrfs_qgroup_comparer_set *);
+		       struct btrfs_qgroup_comparer_set *,
+		       int is_table_result);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
 void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
-- 
1.7.11.7

