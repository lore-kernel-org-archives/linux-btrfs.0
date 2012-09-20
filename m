Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2ITLYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:24:48 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8KBOjCn022967
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 19:24:45 +0800
Message-ID: <505AFCFE.2010503@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 19:24:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs-progs: introduce '-t' option into subvolume list
 command
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-t' option into subvolume list command. By this
option, we can output the result as a table.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on patchset:
[PATCH V4 0/7] Btrfs-progs: enhance btrfs subvol list only to show read-only snapshots
---
 btrfs-list.c     |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 btrfs-list.h     |    3 +-
 cmds-subvolume.c |   14 ++++++++---
 man/btrfs.8.in   |    2 +
 4 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c6d9a18..d605871 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1334,6 +1334,25 @@ static void print_subvolume_column(struct root_info *subv,
 	}
 }
 
+static void print_single_volume_info_table(struct root_info *subv)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		print_subvolume_column(subv, i);
+
+		if (i != BTRFS_LIST_PATH)
+			printf("\t");
+
+		if (i == BTRFS_LIST_TOP_LEVEL)
+			printf("\t");
+	}
+	printf("\n");
+}
+
 static void print_single_volume_info_default(struct root_info *subv)
 {
 	int i;
@@ -1351,21 +1370,58 @@ static void print_single_volume_info_default(struct root_info *subv)
 	printf("\n");
 }
 
-static void print_all_volume_info_default(struct root_lookup *sorted_tree)
+static void print_all_volume_info_tab_head()
+{
+	int i;
+	int len;
+	char barrier[20];
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (btrfs_list_columns[i].need_print)
+			printf("%s\t", btrfs_list_columns[i].name);
+
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		memset(barrier, 0, sizeof(barrier));
+
+		if (btrfs_list_columns[i].need_print) {
+			len = strlen(btrfs_list_columns[i].name);
+			while (len--)
+				strcat(barrier, "-");
+
+			printf("%s\t", barrier);
+		}
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+}
+
+static void print_all_volume_info(struct root_lookup *sorted_tree,
+				  int is_tab_result)
 {
 	struct rb_node *n;
 	struct root_info *entry;
 
+	if (is_tab_result)
+		print_all_volume_info_tab_head();
+
 	n = rb_first(&sorted_tree->root);
 	while (n) {
 		entry = rb_entry(n, struct root_info, sort_node);
-		print_single_volume_info_default(entry);
+		if (is_tab_result)
+			print_single_volume_info_table(entry);
+		else
+			print_single_volume_info_default(entry);
 		n = rb_next(n);
 	}
 }
 
 int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set)
+		       struct btrfs_list_comparer_set *comp_set,
+		       int is_tab_result)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1389,7 +1445,7 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set);
 
-	print_all_volume_info_default(&root_sort);
+	print_all_volume_info(&root_sort, is_tab_result);
 	__free_all_subvolumn(&root_lookup);
 	return ret;
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index 26a5c17..9d3687e 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -98,7 +98,8 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 			      int is_descending);
 
 int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set);
+		       struct btrfs_list_comparer_set *comp_set,
+			int is_tab_result);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f5da022..8399e72 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -260,12 +260,13 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-pur] [-s 0|1] [-g [+|-]value] [-c [+|-]value] "
+	"btrfs subvolume list [-purt] [-s 0|1] [-g [+|-]value] [-c [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p           print parent ID",
 	"-u           print the uuid of subvolumes (and snapshots)",
+	"-t           print the result as a table",
 	"-s value     list snapshots with generation in ascending/descending order",
 	"             (1: ascending, 0: descending)",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -292,6 +293,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int order;
 	int c;
 	char *subvol;
+	int is_tab_result = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
 		{0, 0, 0, 0}
@@ -303,7 +305,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "ps:urg:c:", long_options, NULL);
+				    "ps:urg:c:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -311,6 +313,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'p':
 			btrfs_list_setup_print_column(BTRFS_LIST_PARENT);
 			break;
+		case 't':
+			is_tab_result = 1;
+			break;
 		case 's':
 			order = atoi(optarg);
 			btrfs_list_setup_filter(&filter_set,
@@ -382,7 +387,8 @@ static int cmd_subvol_list(int argc, char **argv)
 		return 12;
 	}
 
-	ret = btrfs_list_subvols(fd, filter_set, comparer_set);
+	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
+				is_tab_result);
 	if (ret)
 		return 19;
 	return 0;
@@ -588,7 +594,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
 				default_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, NULL);
+	ret = btrfs_list_subvols(fd, filter_set, NULL, 0);
 	if (ret)
 		return 19;
 	return 0;
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 5c95ccc..3f7765d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -122,6 +122,8 @@ If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
 and top level. The parent's ID may be used at mount time via the
 \fIsubvolrootid=\fR option.
 
+\fB-t\fP print the result as a table.
+
 \fB-r\fP only readonly subvolumes in the filesystem wille be listed.
 
 \fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
-- 
1.7.6.5
