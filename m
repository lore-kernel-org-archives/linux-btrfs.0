Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:25596 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeCFIgQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:36:16 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7E404AC012D
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:36:08 +0900 (JST)
Received: from g01jpexchkw34.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id AFDD8BD66E3
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:36:07 +0900 (JST)
Subject: [RFC PATCH 5/7] btrfs-progs: sub list: Allow normal user to call
 "subvolume list/show"
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <eb0cf49f-90d5-dad5-699f-a5c021f283b9@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:36:04 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow normal user to call "subvolume list/show" by using 2 new
unprivileged ioctls (BTRFS_IOC_GET_SUBVOL_INFO and
BTRFS_IOC_INO_LOOKUP_USER).

Note that for root, "subvolume list" returns all the subvolume in the
filesystem by default, but for normal user, it returns subvolumes
which exist under the specified path. The specified path itself is not
needed to be a subvolume.

Also, for normal user, snapshot filed of "subvolume show" just lists
the snapshots under the specified subvolume.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c     | 243 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 cmds-subvolume.c |   6 ++
 2 files changed, 244 insertions(+), 5 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 1b49f4a1..3974a50f 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -33,6 +33,7 @@
 #include <uuid/uuid.h>
 #include "btrfs-list.h"
 #include "rbtree-utils.h"
+#include <sys/queue.h>
 
 #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
 #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
@@ -549,6 +550,9 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 	int len = 0;
 	struct root_info *found;
 
+	if (ri->full_path != NULL)
+		return 0;
+
 	/*
 	 * we go backwards from the root_info object and add pathnames
 	 * from parent directories as we go.
@@ -672,6 +676,47 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	return 0;
 }
 
+/* user version of lookup_ino_path which also cheks the access right */
+static int lookup_ino_path_user(int fd, struct root_info *ri)
+{
+	struct btrfs_ioctl_ino_lookup_user_args args;
+	int ret = 0;
+
+	if (ri->path)
+		return 0;
+	if (!ri->ref_tree)
+		return -ENOENT;
+
+	memset(&args, 0, sizeof(args));
+	args.treeid = ri->ref_tree;
+	args.dirid = ri->dir_id;
+	args.subid = ri->root_id;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP_USER, &args);
+	if (ret < 0) {
+		if (errno == ENOENT) {
+			ri->ref_tree = 0;
+			return -ENOENT;
+		}
+		if (errno != EACCES) {
+			error("failed to lookup path for root %llu: %s",
+			(unsigned long long)ri->ref_tree, strerror(errno));
+			return ret;
+		} else {
+			return -EACCES;
+		}
+	}
+
+	ri->path = malloc(strlen(args.path) + 1);
+	strcpy(ri->path, args.path);
+
+	ri->name = malloc(strlen(args.name) + 1);
+	strcpy(ri->name, args.name);
+
+	strcat(ri->path, ri->name);
+	return ret;
+}
+
 /* finding the generation for a given path is a two step process.
  * First we use the inode lookup routine to find out the root id
  *
@@ -988,7 +1033,12 @@ int check_perm_for_tree_search(int fd)
 	return 1;
 }
 
-static int list_subvol_search(int fd, struct root_lookup *root_lookup)
+/*
+ * If is_root is true, BTRFS_IOC_TREE_SEARCH is used.
+ * Otherwise BTRFS_IOC_GET_SUBVOL_INFO is used.
+ */
+static int list_subvol_search(int fd, struct root_lookup *root_lookup,
+				bool is_root)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -1004,6 +1054,12 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 	u64 ogen;
 	u64 flags;
 	int i;
+	int ioctl_num;
+
+	if (is_root)
+		ioctl_num = BTRFS_IOC_TREE_SEARCH;
+	else
+		ioctl_num = BTRFS_IOC_GET_SUBVOL_INFO;
 
 	root_lookup->root.rb_node = NULL;
 	memset(&args, 0, sizeof(args));
@@ -1019,7 +1075,7 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 	while(1) {
 		sk->nr_items = 4096;
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		ret = ioctl(fd, ioctl_num, &args);
 		if (ret < 0)
 			return ret;
 		if (sk->nr_items == 0)
@@ -1300,6 +1356,20 @@ static void filter_and_sort_subvol(struct root_lookup *all_subvols,
 	while (n) {
 		entry = rb_entry(n, struct root_info, rb_node);
 
+		/*
+		 * If list_subvol_fill_paths_user() is used, there may be
+		 * entries which have been skipped for search.
+		 * Just remove these entries here.
+		 */
+		if (!entry->path) {
+			struct rb_node *prev = rb_prev(n);
+
+			rb_erase(n, &all_subvols->root);
+			free_root_info(n);
+			n = prev;
+			continue;
+		}
+
 		ret = resolve_root(all_subvols, entry, top_id);
 		if (ret == -ENOENT) {
 			if (entry->root_id != BTRFS_FS_TREE_OBJECTID) {
@@ -1340,6 +1410,157 @@ static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
+
+static int list_subvol_fill_paths_user(int top_fd,
+					struct root_lookup *root_lookup,
+					const char *path)
+{
+	struct rb_node *n;
+	int ret = 0;
+	int fd;
+	struct root_info *ri, *parent;
+	char *fullpath;
+	u64 top_id;
+	/* fifo queue entry which holds subvolume's id */
+	struct queue_entry {
+		u64 id;
+
+		STAILQ_ENTRY(queue_entry) entries;
+	} *e, *etemp;
+
+	ret = btrfs_list_get_path_rootid(top_fd, &top_id);
+	if (ret)
+		return ret;
+
+	fullpath = realpath(path, NULL);
+	if (!fullpath)
+		return -ENOMEM;
+
+	/* Just fill the entry of top_id which is need */
+	ri = root_tree_search(root_lookup, top_id);
+	if (test_issubvolume(fullpath) && top_id != BTRFS_FS_TREE_OBJECTID) {
+		char *addr;
+
+		ri->top_id = ri->ref_tree;
+		addr = strrchr(fullpath, '/');
+		ri->name = malloc(strlen(addr+1));
+		ri->path = malloc(strlen(addr+1));
+		ri->full_path = malloc(strlen(addr+1));
+		if (!ri->name || !ri->path || !ri->full_path) {
+			free(fullpath);
+			free(ri->name);
+			free(ri->path);
+			free(ri->full_path);
+			return -ENOMEM;
+		}
+		strcpy(ri->name, addr+1);
+		strcpy(ri->path, addr+1);
+		strcpy(ri->full_path, addr+1);
+	}
+
+	/* Add top_id to the queue */
+	STAILQ_HEAD(slistead, queue_entry) head = STAILQ_HEAD_INITIALIZER(head);
+	STAILQ_INIT(&head);
+	e = malloc(sizeof(struct queue_entry));
+	if (!e) {
+		free(fullpath);
+		return -ENOMEM;
+	}
+	e->id = top_id;
+	STAILQ_INSERT_TAIL(&head, e, entries);
+
+	/*
+	 * Iterate until queue is empty:
+	 * 1. Pop the first entry
+	 * 2. Open the entry's path
+	 * 3. If path can be opened, iterate over rb_tree:
+	 * 3-1. Searth the rb_tree whose ref_tree is entry's id
+	 *    (this means searched subvolume exists under e->id's subvolume)
+	 * 3-2. Call ino_lookup ioctl
+	 * 3-3. If the call succeeds, add the subvolume id to the queue
+	 */
+	while (!STAILQ_EMPTY(&head)) {
+		e = STAILQ_FIRST(&head);
+		STAILQ_REMOVE_HEAD(&head, entries);
+
+		parent = root_tree_search(root_lookup, e->id);
+		if (e->id == top_id) {
+			fd = top_fd;
+		} else {
+			resolve_root(root_lookup, parent, top_id);
+			fd = openat(top_fd, parent->full_path, O_RDONLY);
+		}
+		if (fd == -1) {
+			if (errno == EACCES) {
+				/* skip this subvolume */
+				continue;
+			} else {
+				error("error at open %s: %m",
+						parent->full_path);
+				goto err;
+			}
+		}
+
+		n = rb_first(&root_lookup->root);
+		while (n) {
+			ri = rb_entry(n, struct root_info, rb_node);
+			if (ri->ref_tree == 0) {
+				/* BTRFS_FS_TREE_OBJECTID or deleted */
+				n = rb_next(n);
+				continue;
+			}
+
+			if (ri->ref_tree == e->id) {
+				ret = lookup_ino_path_user(fd, ri);
+				if (ret < 0 && ret != -ENOENT && ret != -EACCES)
+					goto err;
+
+				/* add ths subvol id to queue */
+				if (!ret) {
+					etemp = malloc(sizeof(struct queue_entry));
+					if (!etemp) {
+						ret = -ENOMEM;
+						goto err;
+					}
+					etemp->id = ri->root_id;
+					STAILQ_INSERT_TAIL(&head, etemp,
+					    entries);
+				}
+			}
+			n = rb_next(n);
+		}
+
+		if (fd != top_fd)
+			close(fd);
+		free(e);
+	}
+
+	/* If the specified path itself is not a subvolume, remove the entry */
+	if (!test_issubvolume(fullpath)) {
+		ri = root_tree_search(root_lookup, top_id);
+		rb_erase(&ri->rb_node, &root_lookup->root);
+		free_root_info(&ri->rb_node);
+	}
+
+	free(fullpath);
+
+	return 0;
+
+err:
+	free(fullpath);
+	if (fd != -1 && fd != top_fd)
+		close(fd);
+
+	/* free remaining entries */
+	while (!STAILQ_EMPTY(&head)) {
+		e = STAILQ_FIRST(&head);
+		STAILQ_REMOVE_HEAD(&head, entries);
+		free(e);
+	}
+
+	return ret;
+}
+
 static void print_subvolume_column(struct root_info *subv,
 				   enum btrfs_list_column_enum column)
 {
@@ -1523,8 +1744,10 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
 			const char *path)
 {
 	int ret;
+	bool is_root;
 
-	ret = list_subvol_search(fd, root_lookup);
+	is_root = check_perm_for_tree_search(fd);
+	ret = list_subvol_search(fd, root_lookup, is_root);
 	if (ret) {
 		error("can't perform the search: %m");
 		return ret;
@@ -1534,7 +1757,11 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
 	 * now we have an rbtree full of root_info objects, but we need to fill
 	 * in their path names within the subvol that is referencing each one.
 	 */
-	ret = list_subvol_fill_paths(fd, root_lookup);
+	if (is_root)
+		ret = list_subvol_fill_paths(fd, root_lookup);
+	else
+		ret = list_subvol_fill_paths_user(fd, root_lookup, path);
+
 	return ret;
 }
 
@@ -1623,6 +1850,12 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
 	rbn = rb_first(&rl.root);
 	while(rbn) {
 		ri = rb_entry(rbn, struct root_info, rb_node);
+		if (ri->root_id == BTRFS_FS_TREE_OBJECTID || !ri->path) {
+			ret = -ENOENT;
+			rbn = rb_next(rbn);
+			continue;
+		}
+
 		rr = resolve_root(&rl, ri, root_id);
 		if (rr == -ENOENT) {
 			ret = -ENOENT;
@@ -1834,7 +2067,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	if (ret)
 		return ERR_PTR(ret);
 
-	ret = list_subvol_search(fd, &root_lookup);
+	ret = list_subvol_search(fd, &root_lookup, true);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index faa10c5a..61076a9e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -596,6 +596,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (!check_perm_for_tree_search(fd) && is_list_all) {
+		ret = -1;
+		error("only root can use -a option");
+		goto out;
+	}
+
 	if (flags)
 		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
 					flags);
-- 
2.14.3

