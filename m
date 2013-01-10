Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3AJLfK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:10 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ85M030892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:09 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ8gX005631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:08 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ8ux032349
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:08 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/11] Btrfs-progs: add show to display all known parameters of the given subvol
Date: Thu, 10 Jan 2013 19:41:23 +0800
Message-Id: <1357818083-15531-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

This adds show sub-command to the btrfs subvol, which is to display
all known parameters of the given subvol or snapshot. This command
will also list out snapshots of the given subvol if there is any.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   25 ++++++++-
 btrfs-list.h     |    3 +-
 cmds-subvolume.c |  148 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/btrfs.8.in   |    6 ++
 4 files changed, 175 insertions(+), 7 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 844788b..309f99a 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1348,6 +1348,22 @@ static void print_subvolume_column(struct root_info *subv,
 	}
 }
 
+static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefix)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		if(raw_prefix);
+			printf("%s",raw_prefix);
+
+		print_subvolume_column(subv, i);
+	}
+	printf("\n");
+}
+
 static void print_single_volume_info_table(struct root_info *subv)
 {
 	int i;
@@ -1414,7 +1430,7 @@ static void print_all_volume_info_tab_head()
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
-				  int layout)
+				  int layout, char *raw_prefix)
 {
 	struct rb_node *n;
 	struct root_info *entry;
@@ -1432,6 +1448,9 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
 		case BTRFS_LIST_LAYOUT_TABLE:
 			print_single_volume_info_table(entry);
 			break;
+		case BTRFS_LIST_LAYOUT_RAW:
+			print_single_volume_info_raw(entry, raw_prefix);
+			break;
 		}
 		n = rb_next(n);
 	}
@@ -1458,7 +1477,7 @@ int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-		       int layout)
+		       int layout, char *raw_prefix)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1470,7 +1489,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
 
-	print_all_volume_info(&root_sort, layout);
+	print_all_volume_info(&root_sort, layout, raw_prefix);
 	__free_all_subvolumn(&root_lookup);
 
 	return 0;
diff --git a/btrfs-list.h b/btrfs-list.h
index 5f3febd..fee7c5b 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -20,6 +20,7 @@
 
 #define BTRFS_LIST_LAYOUT_DEFAULT	0
 #define BTRFS_LIST_LAYOUT_TABLE		1
+#define BTRFS_LIST_LAYOUT_RAW		2
 
 /*
  * one of these for each root we find.
@@ -150,7 +151,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-			int is_tab_result);
+			int layout, char *raw_prefix);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index dd677f7..808a7da 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -24,6 +24,7 @@
 #include <libgen.h>
 #include <limits.h>
 #include <getopt.h>
+#include <uuid/uuid.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -418,10 +419,10 @@ static int cmd_subvol_list(int argc, char **argv)
 
 	if (is_tab_result)
 		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-				BTRFS_LIST_LAYOUT_TABLE);
+				BTRFS_LIST_LAYOUT_TABLE, NULL);
 	else
 		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-				BTRFS_LIST_LAYOUT_DEFAULT);
+				BTRFS_LIST_LAYOUT_DEFAULT, NULL);
 	if (ret)
 		return 19;
 	return 0;
@@ -634,7 +635,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
-		BTRFS_LIST_LAYOUT_DEFAULT);
+		BTRFS_LIST_LAYOUT_DEFAULT, NULL);
 	if (ret)
 		return 19;
 	return 0;
@@ -721,6 +722,146 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_subvol_show_usage[] = {
+	"btrfs subvolume show <subvol-path>",
+	"Show more information of the subvolume",
+	NULL
+};
+
+static int cmd_subvol_show(int argc, char **argv)
+{
+	int ret, fd;
+	char *subvol, *mnt = NULL;
+	struct root_info get_ri;
+	char tstr[256];
+	char uuidparse[37];
+	struct btrfs_list_filter_set *filter_set;
+	char raw_prefix[] = "\t\t\t\t";
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_show_usage);
+
+	subvol = realpath(argv[1],0);
+	if(!subvol) {
+		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
+			argv[1], strerror(errno));
+		return 12;
+	}
+
+	ret = test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		free(subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		free(subvol);
+		return 13;
+	}
+
+	ret = find_mount_root(subvol, &mnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+				"%s\n", subvol, strerror(-ret));
+		free(subvol);
+		return 12;
+	}
+	if (!strcmp(subvol, mnt))
+		return 0;
+
+	/* this will point to after the mnt/" */
+	get_ri.full_path = subvol+strlen(mnt)+1;
+
+	if (!strcmp(get_ri.full_path, ""))
+		return 0;
+
+	fd = open_file_or_dir(mnt);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+
+	if (btrfs_get_subvol(fd, &get_ri)) {
+		fprintf(stderr, "ERROR: can't find '%s'\n",
+			get_ri.full_path);
+		close(fd);
+		return 13;
+	}
+
+	/* print the info */
+	printf("%s/%s", mnt, get_ri.full_path);
+	printf("\n");
+
+	if (uuid_is_null(get_ri.uuid))
+		strcpy(uuidparse, "-");
+	else
+		uuid_unparse(get_ri.uuid, uuidparse);
+	printf("\t");
+	printf("uuid: \t\t\t%s", uuidparse);
+	printf("\n");
+
+        if (uuid_is_null(get_ri.puuid))
+                strcpy(uuidparse, "-");
+        else
+                uuid_unparse(get_ri.puuid, uuidparse);
+	printf("\t");
+	printf("Parent uuid: \t\t%s", uuidparse);
+	printf("\n");
+
+	if (get_ri.otime)
+		strftime(tstr, 256, "%Y-%m-%d %X",
+			 localtime(&get_ri.otime));
+	else
+		strcpy(tstr, "-");
+	printf("\t");
+	printf("Creation time: \t\t%s", tstr);
+	printf("\n");
+
+	printf("\t");
+	printf("Object ID: \t\t%llu", get_ri.root_id);
+	printf("\n");
+
+	printf("\t");
+	printf("Generation (Gen): \t%llu", get_ri.gen);
+	printf("\n");
+
+	printf("\t");
+	printf("Gen at creation: \t%llu", get_ri.ogen);
+	printf("\n");
+
+	printf("\t");
+	printf("Parent: \t\t%llu", get_ri.ref_tree);
+	printf("\n");
+
+	printf("\t");
+	printf("Top Level: \t\t%llu", get_ri.top_id);
+	printf("\n");
+
+	/* print the snapshots of the given subvol if any*/
+	printf("\t");
+	printf("Snapshot(s):\n");
+	filter_set = btrfs_list_alloc_filter_set();
+	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
+				get_ri.uuid);
+	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
+			raw_prefix);
+
+	/* clean up */
+	if (get_ri.path)
+		free(get_ri.path);
+	if (get_ri.name)
+		free(get_ri.name);
+	if (get_ri.full_path)
+		free(get_ri.full_path);
+
+	close(fd);
+	free(mnt);
+	free(subvol);
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -732,6 +873,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..57c25b0 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
@@ -160,6 +162,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume show\fR\fI <path>\fR
+Show information of a given subvolume in the \fI<path>\fR.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
 [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
-- 
1.7.1

