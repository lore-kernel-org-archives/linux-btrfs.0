Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2LFJu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:50:28 -0500
Message-ID: <50C06A7B.4030902@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:50:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 8/9] Btrfs-progs: enhance btrfs qgroup show to sort qgroups
References: <50C068D4.6020105@cn.fujitsu.com>
In-Reply-To: <50C068D4.6020105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

You might want to list qgroups in order of some items, such as 'qgroupid', 'rfer'
and so on, you can use '--sort'. Now you can sort the qgroups by 'qgroupid',
'rfer','excl','max_rfer' and 'max_excl'.

For example:
	If you want to list qgroups in order of 'qgroupid'.
You can use the option like that:

	btrfs qgroup show --sort=+/-qgroupid <path>
Here, '+' means the result is sorted by ascending order. '-' is by descending
order. If you don't specify either '+' nor '-', the result is sorted by
default - ascending order.

If you want to combine sort items, you do it like that:
	btrfs qgroup show  --sort=-qgroupid,+rfer,max_rfer,excl <path>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |  26 +++++-
 qgroup.c      | 254 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 qgroup.h      |  33 +++++++-
 3 files changed, 301 insertions(+), 12 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 9447179..dd74366 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -199,7 +199,8 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcleF <path>",
+	"btrfs qgroup show -pcleF "
+	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
 	"Show subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
@@ -209,6 +210,11 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"(include ancestral qgroups)",
 	"-f		list all qgroups which impact the given path"
 	"(exclude ancestral qgroups)",
+	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
+	"		list qgroups in order of qgroupid,rfer"
+	"rfer,max_rfer or max_excl",
+	"		you can use '+' or '-' in front of each item.",
+	"		(+:ascending, -:descending, ascending default",
 	NULL
 };
 
@@ -221,12 +227,20 @@ static int cmd_qgroup_show(int argc, char **argv)
 	u64 qgroupid;
 	int filter_flag = 0;
 
+	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
 	filter_set = btrfs_qgroup_alloc_filter_set();
 
+	comparer_set = btrfs_qgroup_alloc_comparer_set();
+	struct option long_options[] = {
+		{"sort", 1, NULL, 'S'},
+		{0, 0, 0, 0}
+	};
+
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcleFf");
+		c = getopt_long(argc, argv, "pcleFf",
+				long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -253,6 +267,12 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'f':
 			filter_flag |= 0x2;
 			break;
+		case 'S':
+			ret = btrfs_qgroup_parse_sort_string(optarg,
+							     &comparer_set);
+			if (ret)
+				usage(cmd_qgroup_show_usage);
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -277,7 +297,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 					  BTRFS_QGROUP_FILTER_PARENT,
 					  qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set);
+	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: can't list qgroups\n");
 		return 30;
diff --git a/qgroup.c b/qgroup.c
index b8640dc..fba675c 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -22,6 +22,7 @@
 #include "ioctl.h"
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
+#define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
 
 struct qgroup_lookup {
 	struct rb_root root;
@@ -122,6 +123,7 @@ struct {
 };
 
 static btrfs_qgroup_filter_func all_filter_funcs[];
+static btrfs_qgroup_comp_func all_comp_funcs[];
 
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 {
@@ -236,6 +238,188 @@ static int comp_entry_with_qgroupid(struct btrfs_qgroup *entry1,
 	return is_descending ? -ret : ret;
 }
 
+static int comp_entry_with_rfer(struct btrfs_qgroup *entry1,
+				struct btrfs_qgroup *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->rfer > entry2->rfer)
+		ret = 1;
+	else if (entry1->rfer < entry2->rfer)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_excl(struct btrfs_qgroup *entry1,
+				struct btrfs_qgroup *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->excl > entry2->excl)
+		ret = 1;
+	else if (entry1->excl < entry2->excl)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_max_rfer(struct btrfs_qgroup *entry1,
+				    struct btrfs_qgroup *entry2,
+				    int is_descending)
+{
+	int ret;
+
+	if (entry1->max_rfer > entry2->max_rfer)
+		ret = 1;
+	else if (entry1->max_rfer < entry2->max_rfer)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_max_excl(struct btrfs_qgroup *entry1,
+				    struct btrfs_qgroup *entry2,
+				    int is_descending)
+{
+	int ret;
+
+	if (entry1->max_excl > entry2->max_excl)
+		ret = 1;
+	else if (entry1->max_excl < entry2->max_excl)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static btrfs_qgroup_comp_func all_comp_funcs[] = {
+	[BTRFS_QGROUP_COMP_QGROUPID]	= comp_entry_with_qgroupid,
+	[BTRFS_QGROUP_COMP_RFER]	= comp_entry_with_rfer,
+	[BTRFS_QGROUP_COMP_EXCL]	= comp_entry_with_excl,
+	[BTRFS_QGROUP_COMP_MAX_RFER]	= comp_entry_with_max_rfer,
+	[BTRFS_QGROUP_COMP_MAX_EXCL]	= comp_entry_with_max_excl
+};
+
+static char *all_sort_items[] = {
+	[BTRFS_QGROUP_COMP_QGROUPID]	= "qgroupid",
+	[BTRFS_QGROUP_COMP_RFER]	= "rfer",
+	[BTRFS_QGROUP_COMP_EXCL]	= "excl",
+	[BTRFS_QGROUP_COMP_MAX_RFER]	= "max_rfer",
+	[BTRFS_QGROUP_COMP_MAX_EXCL]	= "max_excl",
+	[BTRFS_QGROUP_COMP_MAX]		= NULL,
+};
+
+static int  btrfs_qgroup_get_sort_item(char *sort_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_QGROUP_COMP_MAX; i++) {
+		if (strcmp(sort_name, all_sort_items[i]) == 0)
+			return i;
+	}
+	return -1;
+}
+
+struct btrfs_qgroup_comparer_set *btrfs_qgroup_alloc_comparer_set(void)
+{
+	struct btrfs_qgroup_comparer_set *set;
+	int size;
+	size = sizeof(struct btrfs_qgroup_comparer_set) +
+	       BTRFS_QGROUP_NCOMPS_INCREASE *
+	       sizeof(struct btrfs_qgroup_comparer);
+	set = malloc(size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	memset(set, 0, size);
+	set->total = BTRFS_QGROUP_NCOMPS_INCREASE;
+
+	return set;
+}
+
+void btrfs_qgroup_free_comparer_set(struct btrfs_qgroup_comparer_set *comp_set)
+{
+	free(comp_set);
+}
+
+int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set  **comp_set,
+				enum btrfs_qgroup_comp_enum comparer,
+				int is_descending)
+{
+	struct btrfs_qgroup_comparer_set *set = *comp_set;
+	int size;
+
+	BUG_ON(!set);
+	BUG_ON(comparer >= BTRFS_QGROUP_COMP_MAX);
+	BUG_ON(set->ncomps > set->total);
+
+	if (set->ncomps == set->total) {
+		size = set->total + BTRFS_QGROUP_NCOMPS_INCREASE;
+		size = sizeof(*set) +
+		       size * sizeof(struct btrfs_qgroup_comparer);
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			exit(1);
+		}
+
+		memset(&set->comps[set->total], 0,
+		       BTRFS_QGROUP_NCOMPS_INCREASE *
+		       sizeof(struct btrfs_qgroup_comparer));
+		set->total += BTRFS_QGROUP_NCOMPS_INCREASE;
+		*comp_set = set;
+	}
+
+	BUG_ON(set->comps[set->ncomps].comp_func);
+
+	set->comps[set->ncomps].comp_func = all_comp_funcs[comparer];
+	set->comps[set->ncomps].is_descending = is_descending;
+	set->ncomps++;
+	return 0;
+}
+
+static int sort_comp(struct btrfs_qgroup *entry1, struct btrfs_qgroup *entry2,
+		     struct btrfs_qgroup_comparer_set *set)
+{
+	int qgroupid_compared = 0;
+	int i, ret = 0;
+
+	if (!set || !set->ncomps)
+		goto comp_qgroupid;
+
+	for (i = 0; i < set->ncomps; i++) {
+		if (!set->comps[i].comp_func)
+			break;
+
+		ret = set->comps[i].comp_func(entry1, entry2,
+					      set->comps[i].is_descending);
+		if (ret)
+			return ret;
+
+		if (set->comps[i].comp_func == comp_entry_with_qgroupid)
+			qgroupid_compared = 1;
+	}
+
+	if (!qgroupid_compared) {
+comp_qgroupid:
+		ret = comp_entry_with_qgroupid(entry1, entry2, 0);
+	}
+
+	return ret;
+}
+
 /*
  * insert a new root into the tree.  returns the existing root entry
  * if one is already there.  qgroupid is used
@@ -610,7 +794,8 @@ static void pre_process_filter_set(struct qgroup_lookup *lookup,
 }
 
 static int sort_tree_insert(struct qgroup_lookup *sort_tree,
-			    struct btrfs_qgroup *bq)
+			    struct btrfs_qgroup *bq,
+			    struct btrfs_qgroup_comparer_set *comp_set)
 {
 	struct rb_node **p = &sort_tree->root.rb_node;
 	struct rb_node *parent = NULL;
@@ -621,7 +806,7 @@ static int sort_tree_insert(struct qgroup_lookup *sort_tree,
 		parent = *p;
 		curr = rb_entry(parent, struct btrfs_qgroup, sort_node);
 
-		ret = comp_entry_with_qgroupid(bq, curr, 0);
+		ret = sort_comp(bq, curr, comp_set);
 		if (ret < 0)
 			p = &(*p)->rb_left;
 		else if (ret > 0)
@@ -634,9 +819,10 @@ static int sort_tree_insert(struct qgroup_lookup *sort_tree,
 	return 0;
 }
 
-static void __filter_all_qgroups(struct qgroup_lookup *all_qgroups,
+static void __filter_and_sort_qgroups(struct qgroup_lookup *all_qgroups,
 				 struct qgroup_lookup *sort_tree,
-				 struct btrfs_qgroup_filter_set *filter_set)
+				 struct btrfs_qgroup_filter_set *filter_set,
+				 struct btrfs_qgroup_comparer_set *comp_set)
 {
 	struct rb_node *n;
 	struct btrfs_qgroup *entry;
@@ -651,7 +837,7 @@ static void __filter_all_qgroups(struct qgroup_lookup *all_qgroups,
 
 		ret = filter_qgroup(entry, filter_set);
 		if (ret)
-			sort_tree_insert(sort_tree, entry);
+			sort_tree_insert(sort_tree, entry, comp_set);
 
 		n = rb_prev(n);
 	}
@@ -795,7 +981,8 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 }
 
 int btrfs_show_qgroups(int fd,
-		       struct btrfs_qgroup_filter_set *filter_set)
+		       struct btrfs_qgroup_filter_set *filter_set,
+		       struct btrfs_qgroup_comparer_set *comp_set)
 {
 
 	struct qgroup_lookup qgroup_lookup;
@@ -805,8 +992,8 @@ int btrfs_show_qgroups(int fd,
 	ret = __qgroups_search(fd, &qgroup_lookup);
 	if (ret)
 		return ret;
-	__filter_all_qgroups(&qgroup_lookup, &sort_tree,
-			     filter_set);
+	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
+				  filter_set, comp_set);
 	print_all_qgroups(&sort_tree);
 
 	__free_all_qgroups(&qgroup_lookup);
@@ -832,6 +1019,57 @@ u64 btrfs_get_path_rootid(int fd)
 	return args.treeid;
 }
 
+int btrfs_qgroup_parse_sort_string(char *optarg,
+				   struct btrfs_qgroup_comparer_set **comps)
+{
+	int order;
+	int flag;
+	char *p;
+	char **ptr_argv;
+	int what_to_sort;
+
+	while ((p = strtok(optarg, ",")) != NULL) {
+		flag = 0;
+		ptr_argv = all_sort_items;
+
+		while (*ptr_argv) {
+			if (strcmp(*ptr_argv, p) == 0) {
+				flag = 1;
+				break;
+			} else {
+				p++;
+				if (strcmp(*ptr_argv, p) == 0) {
+					flag = 1;
+					p--;
+					break;
+				}
+				p--;
+			}
+			ptr_argv++;
+		}
+
+		if (flag == 0)
+			return -1;
+
+		else {
+			if (*p == '+') {
+				order = 0;
+				p++;
+			} else if (*p == '-') {
+				order = 1;
+				p++;
+			} else
+				order = 0;
+
+			what_to_sort = btrfs_qgroup_get_sort_item(p);
+			btrfs_qgroup_setup_comparer(comps, what_to_sort, order);
+		}
+		optarg = NULL;
+	}
+
+	return 0;
+}
+
 u64 parse_qgroupid(char *p)
 {
 	char *s = strchr(p, '/');
diff --git a/qgroup.h b/qgroup.h
index d1165fd..032ceda 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -25,18 +25,32 @@
 struct btrfs_qgroup;
 
 typedef int (*btrfs_qgroup_filter_func)(struct btrfs_qgroup *, u64);
+typedef int (*btrfs_qgroup_comp_func)(struct btrfs_qgroup *,
+				      struct btrfs_qgroup *, int);
+
 
 struct btrfs_qgroup_filter {
 	btrfs_qgroup_filter_func filter_func;
 	u64 data;
 };
 
+struct btrfs_qgroup_comparer {
+	btrfs_qgroup_comp_func comp_func;
+	int is_descending;
+};
+
 struct btrfs_qgroup_filter_set {
 	int total;
 	int nfilters;
 	struct btrfs_qgroup_filter filters[0];
 };
 
+struct btrfs_qgroup_comparer_set {
+	int total;
+	int ncomps;
+	struct btrfs_qgroup_comparer comps[0];
+};
+
 enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_QGROUPID,
 	BTRFS_QGROUP_RFER,
@@ -48,19 +62,36 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_ALL,
 };
 
+enum btrfs_qgroup_comp_enum {
+	BTRFS_QGROUP_COMP_QGROUPID,
+	BTRFS_QGROUP_COMP_RFER,
+	BTRFS_QGROUP_COMP_EXCL,
+	BTRFS_QGROUP_COMP_MAX_RFER,
+	BTRFS_QGROUP_COMP_MAX_EXCL,
+	BTRFS_QGROUP_COMP_MAX
+};
+
 enum btrfs_qgroup_filter_enum {
 	BTRFS_QGROUP_FILTER_PARENT,
 	BTRFS_QGROUP_FILTER_ALL_PARENT,
 	BTRFS_QGROUP_FILTER_MAX,
 };
 
+int btrfs_qgroup_parse_sort_string(char *optarg,
+				   struct btrfs_qgroup_comparer_set **comps);
 u64 btrfs_get_path_rootid(int fd);
-int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *);
+int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
+		       struct btrfs_qgroup_comparer_set *);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
 void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
 int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
 			      enum btrfs_qgroup_filter_enum, u64 data);
+struct btrfs_qgroup_comparer_set *btrfs_qgroup_alloc_comparer_set(void);
+void btrfs_qgroup_free_comparer_set(struct btrfs_qgroup_comparer_set *comp_set);
+int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
+				enum btrfs_qgroup_comp_enum comparer,
+				int is_descending);
 u64 parse_qgroupid(char *p);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit,
-- 
1.7.11.7

