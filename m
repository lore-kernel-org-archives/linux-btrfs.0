Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64316 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3JGHZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:10 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to control print result
Date: Mon, 7 Oct 2013 15:21:46 +0800
Message-Id: <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can use it like:
	btrfs qgroup show --block-size=m <mnt>

Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 16 +++++++++---
 qgroup.c      | 78 ++++++++++++++++++++++++++++++++++++++++-------------------
 qgroup.h      |  3 ++-
 utils.c       | 50 ++++++++++++++++++++++++++++++++++++++
 utils.h       |  2 ++
 5 files changed, 120 insertions(+), 29 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 4fe776c..912cc42 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,8 +202,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcreFf "
-	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
+	"btrfs qgroup show [options] <path>",
 	"Show subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
@@ -218,6 +217,8 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"rfer,max_rfer or max_excl",
 	"		you can use '+' or '-' in front of each item.",
 	"		(+:ascending, -:descending, ascending default)",
+	"--block-size=BLOCK_SIZE",
+	"		Here BLOCK_SIZE can be k,K,m,M,g,G,t,T,p,P,e,E",
 	NULL
 };
 
@@ -231,6 +232,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int c;
 	u64 qgroupid;
 	int filter_flag = 0;
+	int block_size = 0;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -238,6 +240,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	comparer_set = btrfs_qgroup_alloc_comparer_set();
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
+		{"block-size", 1, NULL, 'B'},
 		{0, 0, 0, 0}
 	};
 
@@ -276,6 +279,13 @@ static int cmd_qgroup_show(int argc, char **argv)
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
+		case 'B':
+			block_size = parse_block_size(optarg);
+			if (block_size < 0) {
+				fprintf(stderr, "Invalid block size\n");
+				usage(cmd_qgroup_show_usage);
+			}
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -301,7 +311,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 					BTRFS_QGROUP_FILTER_PARENT,
 					qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
+	ret = btrfs_show_qgroups(fd, filter_set, comparer_set, block_size);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0)
diff --git a/qgroup.c b/qgroup.c
index fa905fa..0de6c7d 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -20,6 +20,7 @@
 #include <sys/ioctl.h>
 #include "ctree.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
 #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
@@ -190,10 +191,12 @@ static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
 }
 
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
-				enum btrfs_qgroup_column_enum column)
+				enum btrfs_qgroup_column_enum column,
+				int block_size)
 {
 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
 	int len;
+	char tmp[100];
 
 	switch (column) {
 
@@ -203,11 +206,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%lld", qgroup->rfer);
+		len = block_size_snprintf((signed long long)qgroup->rfer, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
+		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%lld", qgroup->excl);
+		len = block_size_snprintf((signed long long)qgroup->excl, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
+		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
 		break;
 	case BTRFS_QGROUP_PARENT:
@@ -215,11 +224,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = printf("%llu", qgroup->max_rfer);
+		len = block_size_snprintf(qgroup->max_rfer, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
+		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = printf("%llu", qgroup->max_excl);
+		len = block_size_snprintf(qgroup->max_excl, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
+		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL, len);
 		break;
 	case BTRFS_QGROUP_CHILD:
@@ -231,14 +246,15 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	}
 }
 
-static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
+static void print_single_qgroup_table(struct btrfs_qgroup *qgroup,
+				      int block_size)
 {
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
-		print_qgroup_column(qgroup, i);
+		print_qgroup_column(qgroup, i, block_size);
 
 		if (i != BTRFS_QGROUP_CHILD)
 			printf(" ");
@@ -882,7 +898,8 @@ static int sort_tree_insert(struct qgroup_lookup *sort_tree,
 }
 
 static void __update_columns_max_len(struct btrfs_qgroup *bq,
-				     enum btrfs_qgroup_column_enum column)
+				     enum btrfs_qgroup_column_enum column,
+				     int block_size)
 {
 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
 	struct btrfs_qgroup_list *list = NULL;
@@ -900,26 +917,30 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_RFER:
-		sprintf(tmp, "%llu", bq->rfer);
-		len = strlen(tmp);
+		len = block_size_snprintf((signed long long)bq->rfer, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_EXCL:
-		sprintf(tmp, "%llu", bq->excl);
-		len = strlen(tmp);
+		len = block_size_snprintf((signed long long)bq->excl, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		sprintf(tmp, "%llu", bq->max_rfer);
-		len = strlen(tmp);
+		len = block_size_snprintf(bq->max_rfer, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		sprintf(tmp, "%llu", bq->max_excl);
-		len = strlen(tmp);
+		len = block_size_snprintf(bq->max_excl, tmp,
+					sizeof(tmp), block_size);
+		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
@@ -971,21 +992,22 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 
 }
 
-static void update_columns_max_len(struct btrfs_qgroup *bq)
+static void update_columns_max_len(struct btrfs_qgroup *bq, int block_size)
 {
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
-		__update_columns_max_len(bq, i);
+		__update_columns_max_len(bq, i, block_size);
 	}
 }
 
 static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 				 struct qgroup_lookup *sort_tree,
 				 struct btrfs_qgroup_filter_set *filter_set,
-				 struct btrfs_qgroup_comparer_set *comp_set)
+				 struct btrfs_qgroup_comparer_set *comp_set,
+				 int block_size)
 {
 	struct rb_node *n;
 	struct btrfs_qgroup *entry;
@@ -1002,7 +1024,7 @@ static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 		if (ret) {
 			sort_tree_insert(sort_tree, entry, comp_set);
 
-			update_columns_max_len(entry);
+			update_columns_max_len(entry, block_size);
 		}
 		n = rb_prev(n);
 	}
@@ -1131,7 +1153,8 @@ done:
 	return ret;
 }
 
-static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
+static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup,
+			      int block_size)
 {
 
 	struct rb_node *n;
@@ -1142,14 +1165,15 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_table(entry);
+		print_single_qgroup_table(entry, block_size);
 		n = rb_next(n);
 	}
 }
 
 int btrfs_show_qgroups(int fd,
 		       struct btrfs_qgroup_filter_set *filter_set,
-		       struct btrfs_qgroup_comparer_set *comp_set)
+		       struct btrfs_qgroup_comparer_set *comp_set,
+		       int block_size)
 {
 
 	struct qgroup_lookup qgroup_lookup;
@@ -1159,9 +1183,13 @@ int btrfs_show_qgroups(int fd,
 	ret = __qgroups_search(fd, &qgroup_lookup);
 	if (ret)
 		return ret;
+	/*
+	 * we pass block_size here because we need it to
+	 * update max columns.
+	 */
 	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
-				  filter_set, comp_set);
-	print_all_qgroups(&sort_tree);
+				  filter_set, comp_set, block_size);
+	print_all_qgroups(&sort_tree, block_size);
 
 	__free_all_qgroups(&qgroup_lookup);
 	btrfs_qgroup_free_filter_set(filter_set);
diff --git a/qgroup.h b/qgroup.h
index 653cf1c..1113a24 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -81,7 +81,8 @@ int btrfs_qgroup_parse_sort_string(char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 u64 btrfs_get_path_rootid(int fd);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-		       struct btrfs_qgroup_comparer_set *);
+		       struct btrfs_qgroup_comparer_set *,
+		       int block_size);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
 void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
diff --git a/utils.c b/utils.c
index c6022fc..4ed7405 100644
--- a/utils.c
+++ b/utils.c
@@ -1219,6 +1219,56 @@ void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 	snprintf(str, str_bytes, "%.2f%s", fraction, size_strs[num_divs]);
 }
 
+int parse_block_size(const char *ch)
+{
+	int len = strlen(ch);
+	if (len != 1)
+		return -1;
+
+	switch (ch[0]) {
+	case 'k':
+	case 'K':
+		return 1;
+	case 'm':
+	case 'M':
+		return 2;
+	case 'g':
+	case 'G':
+		return 3;
+	case 't':
+	case 'T':
+		return 4;
+	case 'p':
+	case 'P':
+		return 5;
+	case 'e':
+	case 'E':
+		return 6;
+	default:
+		return -1;
+	}
+
+	return -1;
+}
+
+int block_size_snprintf(double size, char *str, size_t str_bytes, int format)
+{
+	double fraction = size;
+	int cnt = format;
+
+	if (str_bytes == 0)
+		return 0;
+	if (format < 0 || format >= ARRAY_SIZE(size_strs))
+		return -1;
+	if (format == 0)
+		return snprintf(str, str_bytes, "%.f", size);
+
+	while (format--)
+		fraction /= 1024;
+
+	return snprintf(str, str_bytes, "%.2f%s", fraction, size_strs[cnt]);
+}
+
 /*
  * __strncpy__null - strncpy with null termination
  * @dest:	the target array
diff --git a/utils.h b/utils.h
index 19f028f..40b662d 100644
--- a/utils.h
+++ b/utils.h
@@ -56,6 +56,8 @@ void pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 		_str;							\
 	})
 
+int parse_block_size(const char *ch);
+int block_size_snprintf(double size, char *str, size_t str_bytes, int format);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
