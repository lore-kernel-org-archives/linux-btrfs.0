Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35653 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161145AbeBOTFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:49 -0500
Received: by mail-pg0-f65.google.com with SMTP id l131so509661pga.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:49 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 19/27] btrfs-progs: use libbtrfsutil for get-default
Date: Thu, 15 Feb 2018 11:05:04 -0800
Message-Id: <f49b907be05d2236c5a72e241f9d871db02447ce.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The only thing of note here is the "top level" column. This used to mean
something else, but for a long time it has been equal to the parent ID.
I preserved this for backwards compatability.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 54 ++++++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 700e822c..42cc30ce 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -14,6 +14,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -785,31 +786,25 @@ static const char * const cmd_subvol_get_default_usage[] = {
 static int cmd_subvol_get_default(int argc, char **argv)
 {
 	int fd = -1;
-	int ret;
-	char *subvol;
-	struct btrfs_list_filter_set *filter_set;
-	u64 default_id;
+	int ret = 1;
+	uint64_t default_id;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
+	struct btrfs_util_subvolume_info subvol;
+	char *path;
 
 	clean_args_no_options(argc, argv, cmd_subvol_get_default_usage);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_get_default_usage);
 
-	subvol = argv[1];
-	fd = btrfs_open_dir(subvol, &dirstream, 1);
+	fd = btrfs_open_dir(argv[1], &dirstream, 1);
 	if (fd < 0)
 		return 1;
 
-	ret = btrfs_list_get_default_subvolume(fd, &default_id);
-	if (ret) {
-		error("failed to look up default subvolume: %m");
-		goto out;
-	}
-
-	ret = 1;
-	if (default_id == 0) {
-		error("'default' dir item not found");
+	err = btrfs_util_get_default_subvolume_fd(fd, &default_id);
+	if (err) {
+		error_btrfs_util(err);
 		goto out;
 	}
 
@@ -820,24 +815,27 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		goto out;
 	}
 
-	filter_set = btrfs_list_alloc_filter_set();
-	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
-				default_id);
+	err = btrfs_util_subvolume_info_fd(fd, default_id, &subvol);
+	if (err) {
+		error_btrfs_util(err);
+		goto out;
+	}
 
-	/* by default we shall print the following columns*/
-	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
-	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
-	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+	err = btrfs_util_subvolume_path_fd(fd, default_id, &path);
+	if (err) {
+		error_btrfs_util(err);
+		goto out;
+	}
 
-	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
-		BTRFS_LIST_LAYOUT_DEFAULT, 1, NULL);
+	printf("ID %" PRIu64 " gen %" PRIu64 " top level %" PRIu64 " path %s\n",
+	       subvol.id, subvol.generation, subvol.parent_id, path);
 
-	if (filter_set)
-		free(filter_set);
+	free(path);
+
+	ret = 0;
 out:
 	close_file_or_dir(fd, dirstream);
-	return !!ret;
+	return ret;
 }
 
 static const char * const cmd_subvol_set_default_usage[] = {
-- 
2.16.1

