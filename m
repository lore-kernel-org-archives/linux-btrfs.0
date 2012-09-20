Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2ITLW6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:22:58 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8KBMsBE022904
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 19:22:54 +0800
Message-ID: <505AFC8F.3050304@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 19:22:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs-progs: introduce -g -c --sort options into btrfs
 subvol list command
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

This patch introduces '-g' '-c' '--sort' options

The option '-g' can help you filter the subvolumes by the generation, you may
use it just like:

	btrfs subvol list -g +/-value <path>

'+' means the generation of the subvolumes should >= the value you specified.
'-' means the generation should <= the value
If you don't input either '+' nor '-', this command will list the subvolumes
that their generation equals to the value.

However if you want to find gengeration between value1 and value2
you may use the above like:

        btrfs sub list -g -value1 -g +value2 <path>

The option '-c' can help you filter the subvolumes by the ogeneration, you may
use it just like:

	btrfs subvol list -c +/-value <path>

The usage is the same to '-g'

You might want to list subvolumes in order of some items, such as root id, gen
and so on, you can use '--sort'. Now you can sort the subvolumes by root id,
gen, ogen and path.

For example:
If you want to list subvolumes in order of rootid, you can use the option like
that:

	btrfs sub list --sort=+/-rooid <path>

Here, '+' means the result is sorted by ascending order. '-' is by descending
order. If you don't specify either '+' nor '-', the result is sorted by
default - ascending order.

If you want to combine sort items, you do it like that:

	btrfs sub list --sort=-rootid,+path,ogen,gen <path>

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on patchset:
[PATCH V4 0/7 ] Btrfs-progs: enhance btrfs subvol list only to show read-only snapshots
---
 btrfs-list.c     |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-list.h     |   14 +++++
 cmds-subvolume.c |   50 +++++++++++++++-
 man/btrfs.8.in   |   29 ++++++++-
 4 files changed, 254 insertions(+), 7 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 201f378..c6d9a18 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -215,12 +215,48 @@ static int comp_entry_with_ogen(struct root_info *entry1,
 	return is_descending ? -ret : ret;
 }
 
+static int comp_entry_with_path(struct root_info *entry1,
+				struct root_info *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (strcmp(entry1->full_path, entry2->full_path) > 0)
+		ret = 1;
+	else if (strcmp(entry1->full_path, entry2->full_path) < 0)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
 static btrfs_list_comp_func all_comp_funcs[] = {
 	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid,
 	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen,
 	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen,
+	[BTRFS_LIST_COMP_PATH]		= comp_entry_with_path,
 };
 
+static char *all_sort_items[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= "rootid",
+	[BTRFS_LIST_COMP_OGEN]		= "ogen",
+	[BTRFS_LIST_COMP_GEN]		= "gen",
+	[BTRFS_LIST_COMP_PATH]		= "path",
+	[BTRFS_LIST_COMP_MAX]		= NULL,
+};
+
+static int  btrfs_list_get_sort_item(char *sort_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_COMP_MAX; i++) {
+		if (strcmp(sort_name, all_sort_items[i]) == 0)
+			return i;
+	}
+	return -1;
+}
+
 struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
 {
 	struct btrfs_list_comparer_set *set;
@@ -1091,10 +1127,46 @@ static int filter_flags(struct root_info *ri, u64 flags)
 	return ri->flags & flags;
 }
 
+static int filter_gen_more(struct root_info *ri, u64 data)
+{
+	return ri->gen >= data;
+}
+
+static int filter_gen_less(struct root_info *ri, u64 data)
+{
+	return ri->gen <= data;
+}
+
+static int filter_gen_equal(struct root_info  *ri, u64 data)
+{
+	return ri->gen == data;
+}
+
+static int filter_cgen_more(struct root_info *ri, u64 data)
+{
+	return ri->ogen >= data;
+}
+
+static int filter_cgen_less(struct root_info *ri, u64 data)
+{
+	return ri->ogen <= data;
+}
+
+static int filter_cgen_equal(struct root_info *ri, u64 data)
+{
+	return ri->ogen == data;
+}
+
 static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
 	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
 	[BTRFS_LIST_FILTER_FLAGS]		= filter_flags,
+	[BTRFS_LIST_FILTER_GEN_MORE]		= filter_gen_more,
+	[BTRFS_LIST_FILTER_GEN_LESS]		= filter_gen_less,
+	[BTRFS_LIST_FILTER_GEN_EQUAL]           = filter_gen_equal,
+	[BTRFS_LIST_FILTER_CGEN_MORE]		= filter_cgen_more,
+	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
+	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
 };
 
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
@@ -1534,3 +1606,99 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 
 	return ret_path;
 }
+
+int btrfs_list_parse_sort_string(char *optarg,
+				 struct btrfs_list_comparer_set **comps)
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
+			what_to_sort = btrfs_list_get_sort_item(p);
+			btrfs_list_setup_comparer(comps, what_to_sort, order);
+		}
+		optarg = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * This function is used to parse the argument of filter condition.
+ *
+ * type is the filter object.
+ */
+int btrfs_list_parse_filter_string(char *optarg,
+				   struct btrfs_list_filter_set **filters,
+				   enum btrfs_list_filter_enum type)
+{
+
+	u64 arg;
+	char *ptr_parse_end = NULL;
+	char *ptr_optarg_end = optarg + strlen(optarg);
+
+	switch (*(optarg++)) {
+	case '+':
+		arg = (u64)strtol(optarg, &ptr_parse_end, 10);
+		type += 2;
+		if (ptr_parse_end != ptr_optarg_end)
+			return -1;
+
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	case '-':
+		arg = (u64)strtoll(optarg, &ptr_parse_end, 10);
+		type += 1;
+		if (ptr_parse_end != ptr_optarg_end)
+			return -1;
+
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	default:
+		optarg--;
+		arg = (u64)strtoll(optarg, &ptr_parse_end, 10);
+
+		if (ptr_parse_end != ptr_optarg_end)
+			return -1;
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	}
+
+	return 0;
+}
+
diff --git a/btrfs-list.h b/btrfs-list.h
index 21d0fdc..26a5c17 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -62,6 +62,14 @@ enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_ROOTID,
 	BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
 	BTRFS_LIST_FILTER_FLAGS,
+	BTRFS_LIST_FILTER_GEN,
+	BTRFS_LIST_FILTER_GEN_EQUAL	=	BTRFS_LIST_FILTER_GEN,
+	BTRFS_LIST_FILTER_GEN_LESS,
+	BTRFS_LIST_FILTER_GEN_MORE,
+	BTRFS_LIST_FILTER_CGEN,
+	BTRFS_LIST_FILTER_CGEN_EQUAL	=	BTRFS_LIST_FILTER_CGEN,
+	BTRFS_LIST_FILTER_CGEN_LESS,
+	BTRFS_LIST_FILTER_CGEN_MORE,
 	BTRFS_LIST_FILTER_MAX,
 };
 
@@ -69,9 +77,15 @@ enum btrfs_list_comp_enum {
 	BTRFS_LIST_COMP_ROOTID,
 	BTRFS_LIST_COMP_OGEN,
 	BTRFS_LIST_COMP_GEN,
+	BTRFS_LIST_COMP_PATH,
 	BTRFS_LIST_COMP_MAX,
 };
 
+int btrfs_list_parse_sort_string(char *optarg,
+				 struct btrfs_list_comparer_set **comps);
+int btrfs_list_parse_filter_string(char *optarg,
+				   struct btrfs_list_filter_set **filters,
+				   enum btrfs_list_filter_enum type);
 void btrfs_list_setup_print_column(enum btrfs_list_column_enum column);
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void);
 void btrfs_list_free_filter_set(struct btrfs_list_filter_set *filter_set);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f385816..f5da022 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -23,6 +23,7 @@
 #include <sys/stat.h>
 #include <libgen.h>
 #include <limits.h>
+#include <getopt.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -259,7 +260,8 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-pur] [-s 0|1] <path>",
+	"btrfs subvolume list [-pur] [-s 0|1] [-g [+|-]value] [-c [+|-]value] "
+	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p           print parent ID",
@@ -267,7 +269,17 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-s value     list snapshots with generation in ascending/descending order",
 	"             (1: ascending, 0: descending)",
 	"-r           list readonly subvolumes (including snapshots)",
-	NULL
+	"-g [+|-]value",
+	"             filter the subvolumes by generation",
+	"             (+value: >= value; -value: <= value; value: = value)",
+	"-c [+|-]value",
+	"             filter the subvolumes by ogeneration",
+	"             (+value: >= value; -value: <= value; value: = value)",
+	"--sort=gen,ogen,rootid,path",
+	"             list the subvolume in order of gen, ogen, rootid or path",
+	"             you also can add '+' or '-' in front of each items.",
+	"             (+:ascending, -:descending, ascending default)",
+	NULL,
 };
 
 static int cmd_subvol_list(int argc, char **argv)
@@ -278,14 +290,20 @@ static int cmd_subvol_list(int argc, char **argv)
 	int fd;
 	int ret;
 	int order;
+	int c;
 	char *subvol;
+	struct option long_options[] = {
+		{"sort", 1, NULL, 'S'},
+		{0, 0, 0, 0}
+	};
 
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "ps:ur");
+		c = getopt_long(argc, argv,
+				    "ps:urg:c:", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -303,13 +321,37 @@ static int cmd_subvol_list(int argc, char **argv)
 						  !order);
 			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
-			break;
+
 		case 'u':
 			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
 			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
+		case 'g':
+			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+			ret = btrfs_list_parse_filter_string(optarg,
+							&filter_set,
+							BTRFS_LIST_FILTER_GEN);
+			if (ret)
+				usage(cmd_subvol_list_usage);
+			break;
+
+		case 'c':
+			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
+			ret = btrfs_list_parse_filter_string(optarg,
+							&filter_set,
+							BTRFS_LIST_FILTER_CGEN);
+			if (ret)
+				usage(cmd_subvol_list_usage);
+			break;
+		case 'S':
+			ret = btrfs_list_parse_sort_string(optarg,
+							   &comparer_set);
+			if (ret)
+				usage(cmd_subvol_list_usage);
+			break;
+
 		default:
 			usage(cmd_subvol_list_usage);
 		}
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 0845b4d..5c95ccc 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-pr] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-pr] [-s 0|1] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -108,18 +108,41 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-pr] <path>\fR
+\fBsubvolume list\fR\fI [-pr][-s 0|1] [-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
+.RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
 ID <ID> top level <ID> path <path>
 where path is the relative path of the subvolume to the \fItop level\fR
 subvolume.
+
 The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
 at mount time via the \fIsubvol=\fR option.
 If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
 and top level. The parent's ID may be used at mount time via the
 \fIsubvolrootid=\fR option.
-If \fI-r\fR is given, only readonly subvolumes in the filesystem will be listed.
+
+\fB-r\fP only readonly subvolumes in the filesystem wille be listed.
+
+\fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
+
+\fB-g [+|-]value\fP
+list subvolumes in the filesystem that its generation is
+>=, <= or = value. '+' means >= value, '-' means <= value, If there is
+neither '+' nor '-', it means = value.
+
+\fB-c [+|-]value\fP
+list subvolumes in the filesystem that its ogeneration is
+>=, <= or = value. The usage is the same to '-g' option.
+
+\fB--sort=gen,ogen,path,rootid\fP
+list subvolumes in order by specified items.
+you can add '+' or '-' in front of each items, '+' means ascending,'-'
+means descending. The default is ascending.
+
+for \fB--sort\fP you can combine some items together by ',', just like
+\f--sort=+ogen,-gen,path,rootid\fR.
+.RE
 .TP
 
 \fBsubvolume set-default\fR\fI <id> <path>\fR
-- 
1.7.6.5
