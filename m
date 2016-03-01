Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbcCAQIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:08:42 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [RFC PATCH 1/2] btrfs-progs: subvolume functions reorg
Date: Wed,  2 Mar 2016 00:08:11 +0800
Message-Id: <1456848492-4814-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make few subvol related functions usable outside of
subvol command set.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile.in      |   2 +-
 cmds-qgroup.c    |   1 +
 cmds-send.c      |  12 +----
 cmds-subvolume.c | 102 +++++++------------------------------
 subvolume.c      | 152 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 subvolume.h      |  20 ++++++++
 6 files changed, 193 insertions(+), 96 deletions(-)
 create mode 100644 subvolume.c
 create mode 100644 subvolume.h

diff --git a/Makefile.in b/Makefile.in
index 918478968be8..6faf94dedf90 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -70,7 +70,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o
+	  inode.o file.o find-root.o free-space-tree.o help.o subvolume.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index db5ee21a83bf..6921226acb26 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -26,6 +26,7 @@
 #include "commands.h"
 #include "qgroup.h"
 #include "utils.h"
+#include "subvolume.h"
 
 static const char * const qgroup_cmd_group_usage[] = {
 	"btrfs qgroup <command> [options] <path>",
diff --git a/cmds-send.c b/cmds-send.c
index 3e34d75bb834..000fd5638039 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -43,6 +43,7 @@
 
 #include "send.h"
 #include "send-utils.h"
+#include "subvolume.h"
 
 static int g_verbose = 0;
 
@@ -335,17 +336,6 @@ out:
 	return ret;
 }
 
-char *get_subvol_name(char *mnt, char *full_path)
-{
-	int len = strlen(mnt);
-	if (!len)
-		return full_path;
-	if (mnt[len - 1] != '/')
-		len += 1;
-
-	return full_path + len;
-}
-
 static int init_root_path(struct btrfs_send *s, const char *subvol)
 {
 	int ret = 0;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 9d9b0af71d38..f9953ab7adb7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -37,6 +37,7 @@
 #include "utils.h"
 #include "btrfs-list.h"
 #include "utils.h"
+#include "subvolume.h"
 
 static int is_subvolume_cleaned(int fd, u64 subvolid)
 {
@@ -224,33 +225,6 @@ out:
 	return retval;
 }
 
-/*
- * Test if path is a subvolume
- * Returns:
- *   0 - path exists but it is not a subvolume
- *   1 - path exists and it is  a subvolume
- * < 0 - error
- */
-int test_issubvolume(const char *path)
-{
-	struct stat	st;
-	struct statfs stfs;
-	int		res;
-
-	res = stat(path, &st);
-	if (res < 0)
-		return -errno;
-
-	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode))
-		return 0;
-
-	res = statfs(path, &stfs);
-	if (res < 0)
-		return -errno;
-
-	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
-}
-
 static int wait_for_commit(int fd)
 {
 	int ret;
@@ -932,12 +906,11 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct btrfs_list_filter_set *filter_set;
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
 
@@ -951,57 +924,14 @@ static int cmd_subvol_show(int argc, char **argv)
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
+	ret = btrfs_get_subvol_info(fullpath, &get_ri);
 	if (ret) {
-		error("can't get rootid for '%s'", fullpath);
-		goto out;
-	}
-
-	mntfd = btrfs_open_dir(mnt, &dirstream2, 1);
-	if (mntfd < 0)
-		goto out;
-
-	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
-		printf("%s is toplevel subvolume\n", fullpath);
-		goto out;
-	}
-
-	memset(&get_ri, 0, sizeof(get_ri));
-	get_ri.root_id = sv_id;
-
-	ret = btrfs_get_subvol(mntfd, &get_ri);
-	if (ret) {
-		error("can't find '%s'", svpath);
-		goto out;
+		ret < 0 ?
+			fprintf(stderr, "Failed to get subvol info %s: %s\n",
+							fullpath, strerror(ret)):
+			fprintf(stderr, "Failed to get subvol info %s: %d\n",
+							fullpath, ret);
+		return ret;
 	}
 
 	/* print the info */
@@ -1052,19 +982,23 @@ static int cmd_subvol_show(int argc, char **argv)
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
diff --git a/subvolume.c b/subvolume.c
new file mode 100644
index 000000000000..866285e02611
--- /dev/null
+++ b/subvolume.c
@@ -0,0 +1,152 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <libgen.h>
+#include <limits.h>
+#include <getopt.h>
+#include <uuid/uuid.h>
+#include <linux/magic.h>
+#include <sys/vfs.h>
+
+#include "kerncompat.h"
+#include "ioctl.h"
+#include "qgroup.h"
+
+#include "ctree.h"
+#include "commands.h"
+#include "utils.h"
+#include "btrfs-list.h"
+#include "utils.h"
+#include "subvolume.h"
+
+/*
+ * Test if path is a subvolume
+ * Returns:
+ *   0 - path exists but it is not a subvolume
+ *   1 - path exists and it is  a subvolume
+ * < 0 - error
+ */
+int test_issubvolume(const char *path)
+{
+	struct stat	st;
+	struct statfs stfs;
+	int		res;
+
+	res = stat(path, &st);
+	if (res < 0)
+		return -errno;
+
+	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode))
+		return 0;
+
+	res = statfs(path, &stfs);
+	if (res < 0)
+		return -errno;
+
+	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
+}
+
+char *get_subvol_name(char *mnt, char *full_path)
+{
+	int len = strlen(mnt);
+	if (!len)
+		return full_path;
+
+	if (mnt[len - 1] != '/')
+		len += 1;
+
+	return full_path + len;
+}
+
+/*
+ * fixme: remove the error being printed here, move it to the
+ * leaf function
+ */
+int btrfs_get_subvol_info(char *fullpath, struct root_info *get_ri)
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
+	if (ret < 0) {
+		error("cannot access subvolume %s: %s", fullpath,
+			strerror(-ret));
+		goto out;
+	}
+	if (!ret) {
+		error("not a subvolume: %s", fullpath);
+		ret = 1;
+		goto out;
+	}
+
+	ret = find_mount_root(fullpath, &mnt);
+	if (ret < 0) {
+		error("find_mount_root failed on '%s': %s",
+			fullpath, strerror(-ret));
+		goto out;
+	}
+	if (ret > 0) {
+		error("%s doesn't belong to btrfs mount point", fullpath);
+		goto out;
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
+		printf("%s is toplevel subvolume\n", fullpath);
+		goto out;
+	}
+
+	memset(get_ri, 0, sizeof(*get_ri));
+	get_ri->root_id = sv_id;
+
+	ret = btrfs_get_subvol(mntfd, get_ri);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't find '%s'\n",
+			svpath);
+		goto out;
+	}
+
+out:
+	return ret;
+}
diff --git a/subvolume.h b/subvolume.h
new file mode 100644
index 000000000000..ceacf603e01c
--- /dev/null
+++ b/subvolume.h
@@ -0,0 +1,20 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#include "btrfs-list.h"
+
+int btrfs_get_subvol_info(char *fullpath, struct root_info *get_ri);
+int test_issubvolume(const char *path);
+char *get_subvol_name(char *mnt, char *full_path);
-- 
2.7.0

