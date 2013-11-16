Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58661 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3KPRJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:14 -0500
Received: by mail-wg0-f45.google.com with SMTP id a1so4748314wgh.12
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:13 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/7] Recursive btrfs sub snapshot/delete: create get_root_info() function
Date: Sat, 16 Nov 2013 18:09:01 +0100
Message-Id: <1384621747-25441-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move some code from cmd_subvol_show() to get_root_info(). This is
a preparation for the introducing of traverse_list_subvol_rec()
function.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs-list.c     | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-list.h     |  7 +++++
 cmds-subvolume.c | 71 ++++--------------------------------------
 3 files changed, 108 insertions(+), 65 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index f3618b9..66f3127 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -33,6 +33,8 @@
 #include "utils.h"
 #include <uuid/uuid.h>
 #include "btrfs-list.h"
+#include "commands.h"
+#include "utils.h"
 
 #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
 #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
@@ -1917,3 +1919,96 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 	*treeid = args.treeid;
 	return 0;
 }
+
+/*
+ * Fill the root_info struct
+ */
+int get_root_info(char *path, struct root_info *get_ri)
+{
+
+	char *svpath = NULL, *mnt = NULL, *fullpath=NULL;
+	u64 sv_id, mntid;
+	int fd = -1, mntfd = -1;
+	DIR *fddir, *mntfddir;
+	int ret = -1;
+
+	fullpath = realpath(path, 0);
+
+	ret = test_issubvolume(fullpath);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", fullpath);
+		goto out;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", fullpath);
+		ret = -1;
+		goto out;
+	}
+
+	ret = find_mount_root(fullpath, &mnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+				"%s\n", fullpath, strerror(-ret));
+		goto out;
+	}
+	ret = -1;
+	svpath = get_subvol_name(mnt, fullpath);
+
+	fd = open_file_or_dir(fullpath, &fddir);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
+		goto out;
+	}
+
+	ret = btrfs_list_get_path_rootid(fd, &sv_id);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't get rootid for '%s'\n",
+			fullpath);
+		goto out;
+	}
+
+	mntfd = open_file_or_dir(mnt, &mntfddir);
+	if (mntfd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
+		goto out;
+	}
+
+	ret = btrfs_list_get_path_rootid(mntfd, &mntid);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", mnt);
+		goto out;
+	}
+
+	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
+		printf("ERROR: %s is btrfs root\n", fullpath);
+		goto out;
+	}
+
+	memset(get_ri, 0, sizeof(*get_ri));
+	get_ri->root_id = sv_id;
+
+	if (btrfs_get_subvol(mntfd, get_ri)) {
+		fprintf(stderr, "ERROR: can't find '%s'\n",
+			svpath);
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	if (mntfd >= 0)
+		close_file_or_dir(mntfd, mntfddir);
+	if (fd >= 0)
+		close_file_or_dir(fd, fddir);
+	free(mnt);
+	free(fullpath);
+
+	return ret;
+}
+
+void free_root_info(struct root_info *ri)
+{
+	free(ri->path);
+	free(ri->name);
+	free(ri->full_path);
+}
diff --git a/btrfs-list.h b/btrfs-list.h
index 724e973..db32805 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -16,6 +16,9 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#ifndef __BTRFS_LIST__
+#define __BTRFS_LIST__
+
 #if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
 #else
@@ -163,3 +166,7 @@ int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 int btrfs_list_get_path_rootid(int fd, u64 *treeid);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
+int get_root_info(char *path, struct root_info *get_ri);
+void free_root_info(struct root_info *ri);
+
+#endif
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f57694a..477919c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -827,12 +827,11 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct btrfs_list_filter_set *filter_set;
 	char tstr[256];
 	char uuidparse[37];
-	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
+	char *fullpath = NULL;
 	char raw_prefix[] = "\t\t\t\t";
-	u64 sv_id, mntid;
-	int fd = -1, mntfd = -1;
+	int fd = -1;
 	int ret = 1;
-	DIR *dirstream1 = NULL, *dirstream2 = NULL;
+	DIR *dirstream1 = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_show_usage);
@@ -844,63 +843,15 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	ret = test_issubvolume(fullpath);
-	if (ret < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", fullpath);
-		goto out;
-	}
-	if (!ret) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", fullpath);
-		goto out;
-	}
-
-	ret = find_mount_root(fullpath, &mnt);
-	if (ret < 0) {
-		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
-				"%s\n", fullpath, strerror(-ret));
-		goto out;
-	}
-	ret = 1;
-	svpath = get_subvol_name(mnt, fullpath);
-
 	fd = open_file_or_dir(fullpath, &dirstream1);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
 		goto out;
 	}
 
-	ret = btrfs_list_get_path_rootid(fd, &sv_id);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't get rootid for '%s'\n",
-			fullpath);
-		goto out;
-	}
-
-	mntfd = open_file_or_dir(mnt, &dirstream2);
-	if (mntfd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
-		goto out;
-	}
-
-	ret = btrfs_list_get_path_rootid(mntfd, &mntid);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", mnt);
+	ret = get_root_info(fullpath, &get_ri);
+	if (ret)
 		goto out;
-	}
-
-	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
-		printf("%s is btrfs root\n", fullpath);
-		goto out;
-	}
-
-	memset(&get_ri, 0, sizeof(get_ri));
-	get_ri.root_id = sv_id;
-
-	if (btrfs_get_subvol(mntfd, &get_ri)) {
-		fprintf(stderr, "ERROR: can't find '%s'\n",
-			svpath);
-		goto out;
-	}
 
 	ret = 0;
 	/* print the info */
@@ -949,22 +900,12 @@ static int cmd_subvol_show(int argc, char **argv)
 			1, raw_prefix);
 
 	/* clean up */
-	if (get_ri.path)
-		free(get_ri.path);
-	if (get_ri.name)
-		free(get_ri.name);
-	if (get_ri.full_path)
-		free(get_ri.full_path);
+	free_root_info(&get_ri);
 	if (filter_set)
 		btrfs_list_free_filter_set(filter_set);
 
 out:
 	close_file_or_dir(fd, dirstream1);
-	close_file_or_dir(mntfd, dirstream2);
-	if (mnt)
-		free(mnt);
-	if (fullpath)
-		free(fullpath);
 	return !!ret;
 }
 
-- 
1.8.4.3

