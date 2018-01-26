Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36385 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbeAZSls (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:48 -0500
Received: by mail-pg0-f68.google.com with SMTP id k68so793278pga.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:48 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 25/26] btrfs-progs: deprecate libbtrfs helpers with libbtrfsutil equivalents
Date: Fri, 26 Jan 2018 10:41:13 -0800
Message-Id: <8f43201c315567b1379dd4edaaed3a114332d431.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The old libbtrfs defines some helpers which do the same thing as some
libbtrfsutil helpers. Reimplement the libbtrfs helpers in terms of the
libbtrfsutil APIs and mark the libbtrfs versions as deprecated, which we
could ideally get rid of eventually.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile         |   4 +-
 btrfs-list.c     | 252 +++++++++++++++++++++----------------------------------
 btrfs-list.h     |  15 ++--
 cmds-inspect.c   |   9 +-
 cmds-receive.c   |  12 ++-
 cmds-subvolume.c |  10 ++-
 send-utils.c     |  25 ++++--
 7 files changed, 146 insertions(+), 181 deletions(-)

diff --git a/Makefile b/Makefile
index 8bbe1c5e..b37d1ae9 100644
--- a/Makefile
+++ b/Makefile
@@ -372,10 +372,10 @@ kernel-lib/tables.c:
 	@echo "    [TABLE]  $@"
 	$(Q)./mktables > $@ || ($(RM) -f $@ && exit 1)
 
-libbtrfs.so.0.1: $(libbtrfs_objects)
+libbtrfs.so.0.1: $(libbtrfs_objects) libbtrfsutil.so
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) $^ $(LDFLAGS) $(LIBBTRFS_LIBS) \
-		-shared -Wl,-soname,libbtrfs.so.0 -o $@
+		-shared -Wl,-soname,libbtrfs.so.0 -o $@ -L. -lbtrfsutil
 
 libbtrfs.a: $(libbtrfs_objects)
 	@echo "    [AR]     $@"
diff --git a/btrfs-list.c b/btrfs-list.c
index b6d76585..267aef98 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,8 @@
 #include "btrfs-list.h"
 #include "rbtree-utils.h"
 
+#include <btrfsutil.h>
+
 #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
 #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
 
@@ -907,55 +909,14 @@ build:
 
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
 {
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
-	u64 found = 0;
-	int ret;
-
-	memset(&args, 0, sizeof(args));
-
-	/*
-	 * search for a dir item with a name 'default' in the tree of
-	 * tree roots, it should point us to a default root
-	 */
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-
-	/* don't worry about ancient format and request only one item */
-	sk->nr_items = 1;
-
-	sk->max_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
-	sk->min_objectid = BTRFS_ROOT_TREE_DIR_OBJECTID;
-	sk->max_type = BTRFS_DIR_ITEM_KEY;
-	sk->min_type = BTRFS_DIR_ITEM_KEY;
-	sk->max_offset = (u64)-1;
-	sk->max_transid = (u64)-1;
-
-	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-	if (ret < 0)
-		return ret;
-
-	/* the ioctl returns the number of items it found in nr_items */
-	if (sk->nr_items == 0)
-		goto out;
+	enum btrfs_util_error err;
+	uint64_t id;
 
-	sh = (struct btrfs_ioctl_search_header *)args.buf;
+	err = btrfs_util_f_get_default_subvolume(fd, &id);
+	if (err)
+		return -1;
 
-	if (btrfs_search_header_type(sh) == BTRFS_DIR_ITEM_KEY) {
-		struct btrfs_dir_item *di;
-		int name_len;
-		char *name;
-
-		di = (struct btrfs_dir_item *)(sh + 1);
-		name_len = btrfs_stack_dir_name_len(di);
-		name = (char *)(di + 1);
-
-		if (!strncmp("default", name, name_len))
-			found = btrfs_disk_key_objectid(&di->location);
-	}
-
-out:
-	*default_id = found;
+	*default_id = id;
 	return 0;
 }
 
@@ -1518,10 +1479,11 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	int ret = 0;
 	u64 top_id = 0;
 
-	if (full_path)
-		ret = btrfs_list_get_path_rootid(fd, &top_id);
-	if (ret)
-		return ret;
+	/*
+	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
+	 * to make list specified directory's subvolumes work"). See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
+	 */
 
 	ret = btrfs_list_subvols(fd, &root_lookup);
 	if (ret)
@@ -1535,83 +1497,84 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	return 0;
 }
 
-static char *strdup_or_null(const char *s)
+static void ri_from_subvolume_info(struct root_info *ri,
+				   const struct btrfs_util_subvolume_info *subvol)
 {
-	if (!s)
-		return NULL;
-	return strdup(s);
+	ri->root_id = subvol->id;
+	/*
+	 * struct btrfs_util_subvolume_info doesn't have the root item key
+	 * offset, but it is equal to otransid for snapshots and zero otherwise.
+	 */
+	if (uuid_is_null(subvol->parent_uuid))
+		ri->root_offset = 0;
+	else
+		ri->root_offset = subvol->otransid;
+	ri->flags = subvol->flags;
+	ri->ref_tree = subvol->parent_id;
+	ri->dir_id = subvol->dir_id;
+	ri->top_id = subvol->parent_id;
+	ri->gen = subvol->generation;
+	ri->ogen = subvol->otransid;
+	ri->otime = subvol->otime.tv_sec;
+	memcpy(ri->uuid, subvol->uuid, BTRFS_UUID_SIZE);
+	memcpy(ri->puuid, subvol->parent_uuid, BTRFS_UUID_SIZE);
+	memcpy(ri->ruuid, subvol->received_uuid, BTRFS_UUID_SIZE);
+	ri->deleted = 0;
 }
 
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_toplevel_subvol(int fd, struct root_info *ri)
 {
-	int ret;
-	struct root_lookup rl;
-	struct rb_node *rbn;
-	struct root_info *ri;
-	u64 root_id;
+	struct btrfs_util_subvolume_info subvol;
+	enum btrfs_util_error err;
 
-	ret = btrfs_list_get_path_rootid(fd, &root_id);
-	if (ret)
-		return ret;
-
-	ret = btrfs_list_subvols(fd, &rl);
-	if (ret)
-		return ret;
-
-	rbn = rb_first(&rl.root);
-	ri = rb_entry(rbn, struct root_info, rb_node);
+	err = btrfs_util_f_subvolume_info(fd, BTRFS_FS_TREE_OBJECTID, &subvol);
+	if (err)
+		return -1;
 
-	if (ri->root_id != BTRFS_FS_TREE_OBJECTID)
-		return -ENOENT;
+	ri_from_subvolume_info(ri, &subvol);
 
-	memcpy(the_ri, ri, offsetof(struct root_info, path));
-	the_ri->path = strdup_or_null("/");
-	the_ri->name = strdup_or_null("<FS_TREE>");
-	the_ri->full_path = strdup_or_null("/");
-	rb_free_nodes(&rl.root, free_root_info);
+	ri->path = strdup("/");
+	ri->name = strdup("<FS_TREE>");
+	ri->full_path = strdup("/");
+	if (!ri->path || !ri->name || !ri->full_path) {
+		free(ri->path);
+		free(ri->name);
+		free(ri->full_path);
+		return -1;
+	}
 
-	return ret;
+	return 0;
 }
 
-int btrfs_get_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_subvol(int fd, struct root_info *ri)
 {
-	int ret, rr;
-	struct root_lookup rl;
-	struct rb_node *rbn;
-	struct root_info *ri;
-	u64 root_id;
-
-	ret = btrfs_list_get_path_rootid(fd, &root_id);
-	if (ret)
-		return ret;
-
-	ret = btrfs_list_subvols(fd, &rl);
-	if (ret)
-		return ret;
-
-	rbn = rb_first(&rl.root);
-	while(rbn) {
-		ri = rb_entry(rbn, struct root_info, rb_node);
-		rr = resolve_root(&rl, ri, root_id);
-		if (rr == -ENOENT) {
-			ret = -ENOENT;
-			rbn = rb_next(rbn);
-			continue;
-		}
-
-		if (!comp_entry_with_rootid(the_ri, ri, 0) ||
-			!uuid_compare(the_ri->uuid, ri->uuid)) {
-			memcpy(the_ri, ri, offsetof(struct root_info, path));
-			the_ri->path = strdup_or_null(ri->path);
-			the_ri->name = strdup_or_null(ri->name);
-			the_ri->full_path = strdup_or_null(ri->full_path);
-			ret = 0;
-			break;
-		}
-		rbn = rb_next(rbn);
+	struct btrfs_util_subvolume_info subvol;
+	enum btrfs_util_error err;
+	char *slash;
+
+	err = btrfs_util_f_subvolume_info(fd, 0, &subvol);
+	if (err)
+		return -1;
+
+	ri_from_subvolume_info(ri, &subvol);
+
+	err = btrfs_util_f_subvolume_path(fd, 0, &ri->path);
+	if (err)
+		return -1;
+	slash = strrchr(ri->path, '/');
+	if (slash)
+		ri->name = strdup(slash + 1);
+	else
+		ri->name = strdup(ri->path);
+	ri->full_path = strdup(ri->path);
+	if (!!ri->name || !ri->full_path) {
+		free(ri->path);
+		free(ri->name);
+		free(ri->full_path);
+		return -1;
 	}
-	rb_free_nodes(&rl.root, free_root_info);
-	return ret;
+
+	return 0;
 }
 
 static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
@@ -1793,44 +1756,14 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 
 char *btrfs_list_path_for_root(int fd, u64 root)
 {
-	struct root_lookup root_lookup;
-	struct rb_node *n;
-	char *ret_path = NULL;
-	int ret;
-	u64 top_id;
-
-	ret = btrfs_list_get_path_rootid(fd, &top_id);
-	if (ret)
-		return ERR_PTR(ret);
-
-	ret = list_subvol_search(fd, &root_lookup);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
-	ret = list_subvol_fill_paths(fd, &root_lookup);
-	if (ret < 0)
-		return ERR_PTR(ret);
+	enum btrfs_util_error err;
+	char *ret;
 
-	n = rb_last(&root_lookup.root);
-	while (n) {
-		struct root_info *entry;
+	err = btrfs_util_f_subvolume_path(fd, root, &ret);
+	if (err)
+		return ERR_PTR(-errno);
 
-		entry = rb_entry(n, struct root_info, rb_node);
-		ret = resolve_root(&root_lookup, entry, top_id);
-		if (ret == -ENOENT && entry->root_id == root) {
-			ret_path = NULL;
-			break;
-		}
-		if (entry->root_id == root) {
-			ret_path = entry->full_path;
-			entry->full_path = NULL;
-		}
-
-		n = rb_prev(n);
-	}
-	rb_free_nodes(&root_lookup.root, free_root_info);
-
-	return ret_path;
+	return ret;
 }
 
 int btrfs_list_parse_sort_string(char *opt_arg,
@@ -1922,12 +1855,15 @@ int btrfs_list_parse_filter_string(char *opt_arg,
 
 int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 {
-	int ret;
+	enum btrfs_util_error err;
+	uint64_t id;
 
-	ret = lookup_path_rootid(fd, treeid);
-	if (ret < 0)
-		error("cannot resolve rootid for path: %s",
-			strerror(errno));
+	err = btrfs_util_f_subvolume_id(fd, &id);
+	if (err) {
+		error_btrfs_util(err);
+		return -1;
+	}
 
-	return ret;
+	*treeid = id;
+	return 0;
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..317b8cf7 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -171,10 +171,15 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       enum btrfs_list_layout layot, int full_path,
 		       const char *raw_prefix);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
-int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
-char *btrfs_list_path_for_root(int fd, u64 root);
-int btrfs_list_get_path_rootid(int fd, u64 *treeid);
-int btrfs_get_subvol(int fd, struct root_info *the_ri);
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
+int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
+	__attribute__((deprecated("use btrfs_util_f_get_default_subvolume()")));
+char *btrfs_list_path_for_root(int fd, u64 root)
+	__attribute__((deprecated("use btrfs_util_f_subvolume_path()")));
+int btrfs_list_get_path_rootid(int fd, u64 *treeid)
+	__attribute__((deprecated("use btrfs_util_f_subvolume_id()")));
+int btrfs_get_subvol(int fd, struct root_info *the_ri)
+	__attribute__((deprecated("use btrfs_util_f_subvolume_info() and btrfs_util_f_subvolume_path()")));
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+	__attribute__((deprecated("use btrfs_util_f_subvolume_info() and btrfs_util_f_subvolume_path()")));
 
 #endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 885f3abe..40ddd0d7 100644
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
@@ -147,6 +149,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	char full_path[PATH_MAX];
 	char *path_ptr;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c = getopt(argc, argv, "Pvs:");
@@ -219,9 +222,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 		DIR *dirs = NULL;
 
 		if (getpath) {
-			name = btrfs_list_path_for_root(fd, root);
-			if (IS_ERR(name)) {
-				ret = PTR_ERR(name);
+			err = btrfs_util_f_subvolume_path(fd, root, &name);
+			if (err) {
+				ret = -errno;
 				goto out;
 			}
 			if (!name) {
diff --git a/cmds-receive.c b/cmds-receive.c
index e584cef0..f8f65ec5 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -39,6 +39,8 @@
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "ioctl.h"
 #include "commands.h"
@@ -1086,12 +1088,13 @@ static struct btrfs_send_ops send_ops = {
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
@@ -1136,9 +1139,12 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
 	 * subvolume we're sitting in so that we can adjust the paths of any
 	 * subvols we want to receive in.
 	 */
-	ret = btrfs_list_get_path_rootid(rctx->mnt_fd, &subvol_id);
-	if (ret)
+	err = btrfs_util_f_subvolume_id(rctx->mnt_fd, &subvol_id);
+	if (err) {
+		error_btrfs_util(err);
+		ret = -1;
 		goto out;
+	}
 
 	root_subvol_path[0] = 0;
 	ret = btrfs_subvolid_resolve(rctx->mnt_fd, root_subvol_path,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3521e7b7..7788ed9e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -424,13 +424,14 @@ static int cmd_subvol_list(int argc, char **argv)
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
@@ -543,9 +544,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
 					flags);
 
-	ret = btrfs_list_get_path_rootid(fd, &top_id);
-	if (ret)
+	err = btrfs_util_f_subvolume_id(fd, &top_id);
+	if (err) {
+		error_btrfs_util(err);
+		ret = 1;
 		goto out;
+	}
 
 	if (is_list_all)
 		btrfs_list_setup_filter(&filter_set,
diff --git a/send-utils.c b/send-utils.c
index 384cc5b7..7913c501 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -23,6 +23,8 @@
 #include <limits.h>
 #include <errno.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "send-utils.h"
 #include "ioctl.h"
@@ -36,6 +38,8 @@ static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
 {
 	int ret;
 	int subvol_fd;
+	uint64_t id;
+	enum btrfs_util_error err;
 
 	subvol_fd = openat(mnt_fd, sub_path, O_RDONLY);
 	if (subvol_fd < 0) {
@@ -45,11 +49,18 @@ static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
 		return ret;
 	}
 
-	ret = btrfs_list_get_path_rootid(subvol_fd, root_id);
+	err = btrfs_util_f_subvolume_id(subvol_fd, &id);
+	if (err) {
+		ret = -errno;
+	} else {
+		*root_id = id;
+		ret = 0;
+	}
 	close(subvol_fd);
 	return ret;
 }
 
+
 static int btrfs_read_root_item_raw(int mnt_fd, u64 root_id, size_t buf_len,
 				    u32 *read_len, void *buf)
 {
@@ -575,6 +586,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	unsigned long off = 0;
 	int i;
 	char *path;
+	enum btrfs_util_error err;
 
 	s->mnt_fd = mnt_fd;
 
@@ -649,12 +661,11 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				if (!root_item_valid)
 					goto skip;
 
-				path = btrfs_list_path_for_root(mnt_fd,
-					btrfs_search_header_objectid(sh));
-				if (!path)
-					path = strdup("");
-				if (IS_ERR(path)) {
-					ret = PTR_ERR(path);
+				err = btrfs_util_f_subvolume_path(mnt_fd,
+								  btrfs_search_header_objectid(sh),
+								  &path);
+				if (err) {
+					ret = -errno;
 					fprintf(stderr, "ERROR: unable to "
 							"resolve path "
 							"for root %llu\n",
-- 
2.16.1

