Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3IWGUI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 02:20:08 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8N6K3T8012949
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 14:20:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/9] Btrfs-progs: list all qgroups impact given path(include ancestral qgroups)
Date: Mon, 23 Sep 2013 14:17:25 +0800
Message-Id: <1379917048-9720-7-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-F' option which can help you filter the qgroups
by the path name, you may use it like:

	btrfs qgroup show -F <path>
For example:

                         qgroupid(2/0)
                          /     \
                         /       \
                        qgroupid(1/0)
                        /         \
                       /           \
                      /             \
                  qgroupid(0/1)   qgroupid(0/2)
                  sub1              sub2
                  /  \
                 /    \
		dir1  file1

If we use the command:
	btrfs qgroup show -F sub1/dir1
The result will output
	0/1	--	--
	1/0	--	--
	2/0	--	--

'-F' option help you list all qgroups impact given path.
(include ancestral qgroups).

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |  24 +++++-
 qgroup.c      | 239 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 qgroup.h      |  28 ++++++-
 3 files changed, 281 insertions(+), 10 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 0bfca33..5480d2a 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -202,12 +202,14 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcle <path>",
-	"Show all subvolume quota groups.",
+	"btrfs qgroup show -pcleF <path>",
+	"Show subvolume quota groups.",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
 	"-l		print max referenced size of qgroup",
 	"-e		print max exclusive size of qgroup",
+	"-F		list all qgroups which impact the given path"
+	"(include ancestral qgroups)",
 	NULL
 };
 
@@ -219,10 +221,15 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int e;
 	DIR *dirstream = NULL;
 	int c;
+	u64 qgroupid;
+	int filter_flag = 0;
+
+	struct btrfs_qgroup_filter_set *filter_set;
+	filter_set = btrfs_qgroup_alloc_filter_set();
 
 	optind = 1;
 	while (1) {
-		c = getopt(argc, argv, "pcle");
+		c = getopt(argc, argv, "pcleF");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -242,6 +249,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_MAX_EXCL);
 			break;
+		case 'F':
+			filter_flag |= 0x1;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -256,7 +266,13 @@ static int cmd_qgroup_show(int argc, char **argv)
 		return 1;
 	}
 
-	ret = btrfs_show_qgroups(fd);
+	if (filter_flag) {
+		qgroupid = btrfs_get_path_rootid(fd);
+		btrfs_qgroup_setup_filter(&filter_set,
+				BTRFS_QGROUP_FILTER_ALL_PARENT,
+				qgroupid);
+	}
+	ret = btrfs_show_qgroups(fd, filter_set);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0)
diff --git a/qgroup.c b/qgroup.c
index 2cd37b1..306b638 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -21,12 +21,20 @@
 #include "ctree.h"
 #include "ioctl.h"
 
+#define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
+
 struct qgroup_lookup {
 	struct rb_root root;
 };
 
 struct btrfs_qgroup {
 	struct rb_node rb_node;
+	struct rb_node sort_node;
+	/*
+	 *all_parent_node is used to
+	 *filter a qgroup's all parent
+	 */
+	struct rb_node all_parent_node;
 	u64 qgroupid;
 
 	/*
@@ -113,6 +121,8 @@ struct {
 	},
 };
 
+static btrfs_qgroup_filter_func all_filter_funcs[];
+
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 {
 	int i;
@@ -433,6 +443,205 @@ void __free_all_qgroups(struct qgroup_lookup *root_tree)
 	}
 }
 
+static int filter_all_parent_insert(struct qgroup_lookup *sort_tree,
+				    struct btrfs_qgroup *bq)
+{
+	struct rb_node **p = &sort_tree->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_qgroup *curr;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		curr = rb_entry(parent, struct btrfs_qgroup, all_parent_node);
+
+		ret = comp_entry_with_qgroupid(bq, curr, 0);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+	rb_link_node(&bq->all_parent_node, parent, p);
+	rb_insert_color(&bq->all_parent_node, &sort_tree->root);
+	return 0;
+}
+
+static int filter_by_all_parent(struct btrfs_qgroup *bq, u64 data)
+{
+	struct qgroup_lookup lookup;
+	struct qgroup_lookup *ql = &lookup;
+	struct btrfs_qgroup_list *list;
+	struct rb_node *n;
+	struct btrfs_qgroup *qgroup =
+			 (struct btrfs_qgroup *)(unsigned long)data;
+
+	if (data == 0)
+		return 0;
+	if (bq->qgroupid == qgroup->qgroupid)
+		return 1;
+
+	qgroup_lookup_init(ql);
+	filter_all_parent_insert(ql, qgroup);
+	n = rb_first(&ql->root);
+	while (n) {
+		qgroup = rb_entry(n, struct btrfs_qgroup, all_parent_node);
+		if (!list_empty(&qgroup->qgroups)) {
+			list_for_each_entry(list, &qgroup->qgroups,
+					    next_qgroup) {
+				if ((list->qgroup)->qgroupid == bq->qgroupid)
+					return 1;
+				filter_all_parent_insert(ql, list->qgroup);
+			}
+		}
+		rb_erase(n, &ql->root);
+		n = rb_first(&ql->root);
+	}
+	return 0;
+}
+
+static btrfs_qgroup_filter_func all_filter_funcs[] = {
+	[BTRFS_QGROUP_FILTER_ALL_PARENT]	= filter_by_all_parent,
+};
+
+struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void)
+{
+	struct btrfs_qgroup_filter_set *set;
+	int size;
+
+	size = sizeof(struct btrfs_qgroup_filter_set) +
+	       BTRFS_QGROUP_NFILTERS_INCREASE *
+	       sizeof(struct btrfs_qgroup_filter);
+	set = malloc(size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+	memset(set, 0, size);
+	set->total = BTRFS_QGROUP_NFILTERS_INCREASE;
+
+	return set;
+}
+
+void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set)
+{
+	free(filter_set);
+}
+
+int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
+			      enum btrfs_qgroup_filter_enum filter, u64 data)
+{
+	struct btrfs_qgroup_filter_set *set = *filter_set;
+	int size;
+
+	BUG_ON(!set);
+	BUG_ON(filter >= BTRFS_QGROUP_FILTER_MAX);
+	BUG_ON(set->nfilters > set->total);
+
+	if (set->nfilters == set->total) {
+		size = set->total + BTRFS_QGROUP_NFILTERS_INCREASE;
+		size = sizeof(*set) + size * sizeof(struct btrfs_qgroup_filter);
+
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			exit(1);
+		}
+		memset(&set->filters[set->total], 0,
+		       BTRFS_QGROUP_NFILTERS_INCREASE *
+		       sizeof(struct btrfs_qgroup_filter));
+		set->total += BTRFS_QGROUP_NFILTERS_INCREASE;
+		*filter_set = set;
+	}
+	BUG_ON(set->filters[set->nfilters].filter_func);
+	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
+	set->filters[set->nfilters].data = data;
+	set->nfilters++;
+	return 0;
+}
+
+static int filter_qgroup(struct btrfs_qgroup *bq,
+			 struct btrfs_qgroup_filter_set *set)
+{
+	int i, ret;
+
+	if (!set || !set->nfilters)
+		return 1;
+	for (i = 0; i < set->nfilters; i++) {
+		if (!set->filters[i].filter_func)
+			break;
+		ret = set->filters[i].filter_func(bq, set->filters[i].data);
+		if (!ret)
+			return 0;
+	}
+	return 1;
+}
+
+static void pre_process_filter_set(struct qgroup_lookup *lookup,
+				   struct btrfs_qgroup_filter_set *set)
+{
+	int i;
+	struct btrfs_qgroup *qgroup_for_filter = NULL;
+
+	for (i = 0; i < set->nfilters; i++) {
+
+		if (set->filters[i].filter_func == filter_by_all_parent) {
+			qgroup_for_filter = qgroup_tree_search(lookup,
+					    set->filters[i].data);
+			set->filters[i].data =
+				 (u64)(unsigned long)qgroup_for_filter;
+		}
+	}
+}
+
+static int sort_tree_insert(struct qgroup_lookup *sort_tree,
+			    struct btrfs_qgroup *bq)
+{
+	struct rb_node **p = &sort_tree->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_qgroup *curr;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		curr = rb_entry(parent, struct btrfs_qgroup, sort_node);
+
+		ret = comp_entry_with_qgroupid(bq, curr, 0);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+	rb_link_node(&bq->sort_node, parent, p);
+	rb_insert_color(&bq->sort_node, &sort_tree->root);
+	return 0;
+}
+
+static void __filter_all_qgroups(struct qgroup_lookup *all_qgroups,
+				 struct qgroup_lookup *sort_tree,
+				 struct btrfs_qgroup_filter_set *filter_set)
+{
+	struct rb_node *n;
+	struct btrfs_qgroup *entry;
+	int ret;
+
+	qgroup_lookup_init(sort_tree);
+	pre_process_filter_set(all_qgroups, filter_set);
+
+	n = rb_last(&all_qgroups->root);
+	while (n) {
+		entry = rb_entry(n, struct btrfs_qgroup, rb_node);
+
+		ret = filter_qgroup(entry, filter_set);
+		if (ret)
+			sort_tree_insert(sort_tree, entry);
+
+		n = rb_prev(n);
+	}
+}
 static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 {
 	int ret;
@@ -565,28 +774,50 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
-		entry = rb_entry(n, struct btrfs_qgroup, rb_node);
+		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
 		print_single_qgroup_default(entry);
 		n = rb_next(n);
 	}
 }
 
-int btrfs_show_qgroups(int fd)
+int btrfs_show_qgroups(int fd,
+		       struct btrfs_qgroup_filter_set *filter_set)
 {
 
 	struct qgroup_lookup qgroup_lookup;
+	struct qgroup_lookup sort_tree;
 	int ret;
 
 	ret = __qgroups_search(fd, &qgroup_lookup);
 	if (ret)
 		return ret;
+	__filter_all_qgroups(&qgroup_lookup, &sort_tree,
+			     filter_set);
+	print_all_qgroups(&sort_tree);
 
-	print_all_qgroups(&qgroup_lookup);
 	__free_all_qgroups(&qgroup_lookup);
-
+	btrfs_qgroup_free_filter_set(filter_set);
 	return ret;
 }
 
+u64 btrfs_get_path_rootid(int fd)
+{
+	int  ret;
+	struct btrfs_ioctl_ino_lookup_args args;
+
+	memset(&args, 0, sizeof(args));
+	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	if (ret < 0) {
+		fprintf(stderr,
+			"ERROR: can't perform the search -%s\n",
+			strerror(errno));
+		return ret;
+	}
+	return args.treeid;
+}
+
 u64 parse_qgroupid(char *p)
 {
 	char *s = strchr(p, '/');
diff --git a/qgroup.h b/qgroup.h
index e7a65ba..bcc2b4b 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -22,6 +22,21 @@
 #include "ioctl.h"
 #include "kerncompat.h"
 
+struct btrfs_qgroup;
+
+typedef int (*btrfs_qgroup_filter_func)(struct btrfs_qgroup *, u64);
+
+struct btrfs_qgroup_filter {
+	btrfs_qgroup_filter_func filter_func;
+	u64 data;
+};
+
+struct btrfs_qgroup_filter_set {
+	int total;
+	int nfilters;
+	struct btrfs_qgroup_filter filters[0];
+};
+
 enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_QGROUPID,
 	BTRFS_QGROUP_RFER,
@@ -33,9 +48,18 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_ALL,
 };
 
-int  btrfs_show_qgroups(int fd);
-void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
+enum btrfs_qgroup_filter_enum {
+	BTRFS_QGROUP_FILTER_ALL_PARENT,
+	BTRFS_QGROUP_FILTER_MAX,
+};
 
+u64 btrfs_get_path_rootid(int fd);
+int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *);
+void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
+struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
+void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
+int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
+			      enum btrfs_qgroup_filter_enum, u64 data);
 u64 parse_qgroupid(char *p);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
-- 
1.8.3.1

