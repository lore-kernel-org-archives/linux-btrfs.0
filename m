Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbcCUHVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/6] btrfs-progs: create get_subvol_info()
Date: Mon, 21 Mar 2016 15:21:04 +0800
Message-Id: <1458544865-16467-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

get_subvol_info() is useful as we are adding more features around
subvolume. This function was inline with the function
cmd_subvol_show().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 80 ++++++++++++++++++--------------------------------------
 utils.c          | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h          |  2 ++
 3 files changed, 100 insertions(+), 55 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f62ab9584ce7..2319684e1500 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -908,21 +908,21 @@ static const char * const cmd_subvol_show_usage[] = {
 static int cmd_subvol_show(int argc, char **argv)
 {
 	struct root_info get_ri;
-	struct btrfs_list_filter_set *filter_set;
+	struct btrfs_list_filter_set *filter_set = NULL;
 	char tstr[256];
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
-	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
+	char *fullpath = NULL;
 	char raw_prefix[] = "\t\t\t\t";
-	u64 sv_id;
-	int fd = -1, mntfd = -1;
+	int fd = -1;
 	int ret = 1;
-	DIR *dirstream1 = NULL, *dirstream2 = NULL;
+	DIR *dirstream1 = NULL;
 
 	clean_args_no_options(argc, argv, cmd_subvol_show_usage);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_show_usage);
 
+	memset(&get_ri, 0, sizeof(get_ri));
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
 		error("cannot find real path for '%s': %s",
@@ -930,57 +930,23 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	ret = test_issubvolume(fullpath);
-	if (ret < 0) {
-		error("cannot access subvolume %s: %s", fullpath,
-			strerror(-ret));
-		goto out;
-	}
-	if (!ret) {
-		error("not a subvolume: %s", fullpath);
-		ret = 1;
-		goto out;
-	}
-
-	ret = find_mount_root(fullpath, &mnt);
-	if (ret < 0) {
-		error("find_mount_root failed on '%s': %s",
-			fullpath, strerror(-ret));
-		goto out;
-	}
-	if (ret > 0) {
-		error("%s doesn't belong to btrfs mount point", fullpath);
-		goto out;
-	}
-	ret = 1;
-	svpath = get_subvol_name(mnt, fullpath);
-
-	fd = btrfs_open_dir(fullpath, &dirstream1, 1);
-	if (fd < 0)
-		goto out;
-
-	ret = btrfs_list_get_path_rootid(fd, &sv_id);
-	if (ret) {
-		error("can't get rootid for '%s'", fullpath);
-		goto out;
-	}
-
-	mntfd = btrfs_open_dir(mnt, &dirstream2, 1);
-	if (mntfd < 0)
-		goto out;
-
-	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
+	ret = get_subvol_info(fullpath, &get_ri);
+	if (ret == 2) {
+		/*
+		 * Since the top level btrfs was given don't
+		 * take that as error
+		 */
 		printf("%s is toplevel subvolume\n", fullpath);
+		ret = 0;
 		goto out;
 	}
-
-	memset(&get_ri, 0, sizeof(get_ri));
-	get_ri.root_id = sv_id;
-
-	ret = btrfs_get_subvol(mntfd, &get_ri);
 	if (ret) {
-		error("can't find '%s'", svpath);
-		goto out;
+		ret < 0 ?
+			error("Failed to get subvol info %s: %s\n",
+							fullpath, strerror(-ret)):
+			error("Failed to get subvol info %s: %d\n",
+							fullpath, ret);
+		return ret;
 	}
 
 	/* print the info */
@@ -1031,19 +997,23 @@ static int cmd_subvol_show(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
 				(u64)(unsigned long)get_ri.uuid);
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+
+	fd = open_file_or_dir(fullpath, &dirstream1);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
+		goto out;
+	}
 	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
 			1, raw_prefix);
 
+out:
 	/* clean up */
 	free(get_ri.path);
 	free(get_ri.name);
 	free(get_ri.full_path);
 	btrfs_list_free_filter_set(filter_set);
 
-out:
 	close_file_or_dir(fd, dirstream1);
-	close_file_or_dir(mntfd, dirstream2);
-	free(mnt);
 	free(fullpath);
 	return !!ret;
 }
diff --git a/utils.c b/utils.c
index 9aae7df04902..e66314db21ed 100644
--- a/utils.c
+++ b/utils.c
@@ -3168,3 +3168,76 @@ char *get_subvol_name(char *mnt, char *full_path)
 
 	return full_path + len;
 }
+
+/*
+ * Returns
+ * <0: Std error
+ * 0: All fine
+ * 1: Error; and error info printed to the terminal. Fixme.
+ * 2: If the fullpath is root tree instead of subvol tree
+ */
+int get_subvol_info(char *fullpath, struct root_info *get_ri)
+{
+	u64 sv_id;
+	int ret = 1;
+	int fd = -1;
+	int mntfd = -1;
+	char *mnt = NULL;
+	char *svpath = NULL;
+	DIR *dirstream1 = NULL;
+	DIR *dirstream2 = NULL;
+
+	ret = test_issubvolume(fullpath);
+	if (ret < 0)
+		return ret;
+	if (!ret) {
+		error("not a subvolume: %s", fullpath);
+		return 1;
+	}
+
+	ret = find_mount_root(fullpath, &mnt);
+	if (ret < 0)
+		return ret;
+	if (ret > 0) {
+		error("%s doesn't belong to btrfs mount point", fullpath);
+		return 1;
+	}
+	ret = 1;
+	svpath = get_subvol_name(mnt, fullpath);
+
+	fd = btrfs_open_dir(fullpath, &dirstream1, 1);
+	if (fd < 0)
+		goto out;
+
+	ret = btrfs_list_get_path_rootid(fd, &sv_id);
+	if (ret) {
+		error("can't get rootid for '%s'", fullpath);
+		goto out;
+	}
+
+	mntfd = btrfs_open_dir(mnt, &dirstream2, 1);
+	if (mntfd < 0)
+		goto out;
+
+	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
+		ret = 2;
+		/*
+		 * So that caller may decide if thats an error or just fine.
+		 */
+		goto out;
+	}
+
+	memset(get_ri, 0, sizeof(*get_ri));
+	get_ri->root_id = sv_id;
+
+	ret = btrfs_get_subvol(mntfd, get_ri);
+	if (ret)
+		error("can't find '%s': %d", svpath, ret);
+
+out:
+	close_file_or_dir(mntfd, dirstream2);
+	close_file_or_dir(mntfd, dirstream1);
+	free(mnt);
+
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 08543ff278ee..843a1f4faa52 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,7 @@
 #include <dirent.h>
 #include <stdarg.h>
 #include "internal.h"
+#include "btrfs-list.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
@@ -196,6 +197,7 @@ int test_minimum_size(const char *file, u32 leafsize);
 int test_issubvolname(const char *name);
 int test_issubvolume(const char *path);
 char *get_subvol_name(char *mnt, char *full_path);
+int get_subvol_info(char *fullpath, struct root_info *get_ri);
 int test_isdir(const char *path);
 
 /*
-- 
2.7.0

