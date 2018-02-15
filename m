Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45670 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167178AbeBOTF5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:57 -0500
Received: by mail-pl0-f66.google.com with SMTP id p5so339229plo.12
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:57 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 27/27] btrfs-progs: deprecate libbtrfs helpers
Date: Thu, 15 Feb 2018 11:05:12 -0800
Message-Id: <1fc27a8f9bf2446eec0785b39cdb85c294eabe45.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The old libbtrfs defines some helpers which do the same thing as some
libbtrfsutil helpers. Update btrfs-progs to use the libbtrfsutil APIs
and mark the libbtrfs versions as deprecated, which we could ideally get
rid of eventually.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 btrfs-list.c     |  6 ++++++
 btrfs-list.h     | 15 ++++++++++-----
 cmds-inspect.c   | 10 ++++++----
 cmds-receive.c   | 13 +++++++++----
 cmds-subvolume.c | 10 +++++++---
 send-utils.c     | 25 +++++++++++++++++--------
 utils.h          |  1 -
 7 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index a2fdb3f9..56aa2455 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,12 @@
 #include "btrfs-list.h"
 #include "rbtree-utils.h"
 
+/*
+ * The deprecated functions in this file depend on each other, so silence the
+ * warnings.
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
  */
diff --git a/btrfs-list.h b/btrfs-list.h
index 54e1888f..774bcece 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -82,10 +82,15 @@ struct root_info {
 };
 
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
-int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
-char *btrfs_list_path_for_root(int fd, u64 root);
-int btrfs_list_get_path_rootid(int fd, u64 *treeid);
-int btrfs_get_subvol(int fd, struct root_info *the_ri);
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
+int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
+	__attribute__((deprecated("use btrfs_util_get_default_subvolume_fd()")));
+char *btrfs_list_path_for_root(int fd, u64 root)
+	__attribute__((deprecated("use btrfs_util_subvolume_path_fd()")));
+int btrfs_list_get_path_rootid(int fd, u64 *treeid)
+	__attribute__((deprecated("use btrfs_util_subvolume_id_fd()")));
+int btrfs_get_subvol(int fd, struct root_info *the_ri)
+	__attribute__((deprecated("use btrfs_util_subvolume_info_fd() and btrfs_util_subvolume_path_fd()")));
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+	__attribute__((deprecated("use btrfs_util_subvolume_info_fd() and btrfs_util_subvolume_path_fd()")));
 
 #endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index afd7fe48..77585a23 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -23,6 +23,8 @@
 #include <getopt.h>
 #include <limits.h>
 
+#include <btrfsutil.h>
+
 #include "kerncompat.h"
 #include "ioctl.h"
 #include "utils.h"
@@ -30,7 +32,6 @@
 #include "send-utils.h"
 #include "disk-io.h"
 #include "commands.h"
-#include "btrfs-list.h"
 #include "help.h"
 
 static const char * const inspect_cmd_group_usage[] = {
@@ -147,6 +148,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	char full_path[PATH_MAX];
 	char *path_ptr;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c = getopt(argc, argv, "Pvs:");
@@ -219,9 +221,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 		DIR *dirs = NULL;
 
 		if (getpath) {
-			name = btrfs_list_path_for_root(fd, root);
-			if (IS_ERR(name)) {
-				ret = PTR_ERR(name);
+			err = btrfs_util_subvolume_path_fd(fd, root, &name);
+			if (err) {
+				ret = -errno;
 				goto out;
 			}
 			if (!name) {
diff --git a/cmds-receive.c b/cmds-receive.c
index 68123a31..cd880ee7 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -39,12 +39,13 @@
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "ioctl.h"
 #include "commands.h"
 #include "utils.h"
 #include "list.h"
-#include "btrfs-list.h"
 
 #include "send.h"
 #include "send-stream.h"
@@ -1086,12 +1087,13 @@ static struct btrfs_send_ops send_ops = {
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 		      char *realmnt, int r_fd, u64 max_errors)
 {
-	u64 subvol_id;
+	uint64_t subvol_id;
 	int ret;
 	char *dest_dir_full_path;
 	char root_subvol_path[PATH_MAX];
 	int end = 0;
 	int iterations = 0;
+	enum btrfs_util_error err;
 
 	dest_dir_full_path = realpath(tomnt, NULL);
 	if (!dest_dir_full_path) {
@@ -1136,9 +1138,12 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 	 * subvolume we're sitting in so that we can adjust the paths of any
 	 * subvols we want to receive in.
 	 */
-	ret = btrfs_list_get_path_rootid(rctx->mnt_fd, &subvol_id);
-	if (ret)
+	err = btrfs_util_subvolume_id_fd(rctx->mnt_fd, &subvol_id);
+	if (err) {
+		error_btrfs_util(err);
+		ret = -1;
 		goto out;
+	}
 
 	root_subvol_path[0] = 0;
 	ret = btrfs_subvolid_resolve(rctx->mnt_fd, root_subvol_path,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 392e4660..fad6ffcb 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1370,13 +1370,14 @@ static int cmd_subvol_list(int argc, char **argv)
 	struct btrfs_list_comparer_set *comparer_set;
 	u64 flags = 0;
 	int fd = -1;
-	u64 top_id;
+	uint64_t top_id;
 	int ret = -1, uerr = 0;
 	char *subvol;
 	int is_list_all = 0;
 	int is_only_in_path = 0;
 	DIR *dirstream = NULL;
 	enum btrfs_list_layout layout = BTRFS_LIST_LAYOUT_DEFAULT;
+	enum btrfs_util_error err;
 
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
@@ -1489,9 +1490,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
 					flags);
 
-	ret = btrfs_list_get_path_rootid(fd, &top_id);
-	if (ret)
+	err = btrfs_util_subvolume_id_fd(fd, &top_id);
+	if (err) {
+		error_btrfs_util(err);
+		ret = 1;
 		goto out;
+	}
 
 	if (is_list_all)
 		btrfs_list_setup_filter(&filter_set,
diff --git a/send-utils.c b/send-utils.c
index b5289e76..1d6e2da7 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -23,10 +23,11 @@
 #include <limits.h>
 #include <errno.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "send-utils.h"
 #include "ioctl.h"
-#include "btrfs-list.h"
 
 static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 				      u64 subvol_id);
@@ -36,6 +37,8 @@ static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
 {
 	int ret;
 	int subvol_fd;
+	uint64_t id;
+	enum btrfs_util_error err;
 
 	subvol_fd = openat(mnt_fd, sub_path, O_RDONLY);
 	if (subvol_fd < 0) {
@@ -45,7 +48,13 @@ static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
 		return ret;
 	}
 
-	ret = btrfs_list_get_path_rootid(subvol_fd, root_id);
+	err = btrfs_util_subvolume_id_fd(subvol_fd, &id);
+	if (err) {
+		ret = -errno;
+	} else {
+		*root_id = id;
+		ret = 0;
+	}
 	close(subvol_fd);
 	return ret;
 }
@@ -574,6 +583,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	unsigned long off = 0;
 	int i;
 	char *path;
+	enum btrfs_util_error err;
 
 	s->mnt_fd = mnt_fd;
 
@@ -646,12 +656,11 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				if (!root_item_valid)
 					goto skip;
 
-				path = btrfs_list_path_for_root(mnt_fd,
-					btrfs_search_header_objectid(sh));
-				if (!path)
-					path = strdup("");
-				if (IS_ERR(path)) {
-					ret = PTR_ERR(path);
+				err = btrfs_util_subvolume_path_fd(mnt_fd,
+								   btrfs_search_header_objectid(sh),
+								   &path);
+				if (err) {
+					ret = -errno;
 					fprintf(stderr, "ERROR: unable to "
 							"resolve path "
 							"for root %llu\n",
diff --git a/utils.h b/utils.h
index 403de481..d5cf7edb 100644
--- a/utils.h
+++ b/utils.h
@@ -25,7 +25,6 @@
 #include <stdarg.h>
 #include "common-defs.h"
 #include "internal.h"
-#include "btrfs-list.h"
 #include "sizes.h"
 #include "messages.h"
 #include "ioctl.h"
-- 
2.16.1

