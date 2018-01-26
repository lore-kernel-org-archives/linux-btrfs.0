Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:42199 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeAZSlu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:50 -0500
Received: by mail-pf0-f195.google.com with SMTP id b25so816681pfd.9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:49 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 26/26] btrfs-progs: use libbtrfsutil for subvolume list
Date: Fri, 26 Jan 2018 10:41:14 -0800
Message-Id: <dede2b9d3a8c65b2023d4a52c10eb60f9c4a7bce.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is the most involved conversion because it replaces the libbtrfs
implementation entirely. I took care to preserve the existing behavior
in all cases, warts and all.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 btrfs-list.c | 953 +++++++++++++++++------------------------------------------
 btrfs-list.h |   7 +-
 2 files changed, 268 insertions(+), 692 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 267aef98..d9aef8fc 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <inttypes.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include <stdio.h>
@@ -32,18 +33,20 @@
 #include "ioctl.h"
 #include <uuid/uuid.h>
 #include "btrfs-list.h"
-#include "rbtree-utils.h"
 
 #include <btrfsutil.h>
 
 #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
 #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
 
-/* we store all the roots we find in an rbtree so that we can
- * search for them later.
- */
-struct root_lookup {
-	struct rb_root root;
+struct listed_subvol {
+	struct btrfs_util_subvolume_info info;
+	char *path;
+};
+
+struct subvol_list {
+	size_t num;
+	struct listed_subvol subvols[];
 };
 
 static struct {
@@ -126,15 +129,15 @@ void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
 		btrfs_list_columns[i].need_print = 1;
 }
 
-static int comp_entry_with_rootid(struct root_info *entry1,
-				  struct root_info *entry2,
+static int comp_entry_with_rootid(const struct listed_subvol *entry1,
+				  const struct listed_subvol *entry2,
 				  int is_descending)
 {
 	int ret;
 
-	if (entry1->root_id > entry2->root_id)
+	if (entry1->info.id > entry2->info.id)
 		ret = 1;
-	else if (entry1->root_id < entry2->root_id)
+	else if (entry1->info.id < entry2->info.id)
 		ret = -1;
 	else
 		ret = 0;
@@ -142,15 +145,15 @@ static int comp_entry_with_rootid(struct root_info *entry1,
 	return is_descending ? -ret : ret;
 }
 
-static int comp_entry_with_gen(struct root_info *entry1,
-			       struct root_info *entry2,
+static int comp_entry_with_gen(const struct listed_subvol *entry1,
+			       const struct listed_subvol *entry2,
 			       int is_descending)
 {
 	int ret;
 
-	if (entry1->gen > entry2->gen)
+	if (entry1->info.generation > entry2->info.generation)
 		ret = 1;
-	else if (entry1->gen < entry2->gen)
+	else if (entry1->info.generation < entry2->info.generation)
 		ret = -1;
 	else
 		ret = 0;
@@ -158,15 +161,15 @@ static int comp_entry_with_gen(struct root_info *entry1,
 	return is_descending ? -ret : ret;
 }
 
-static int comp_entry_with_ogen(struct root_info *entry1,
-				struct root_info *entry2,
+static int comp_entry_with_ogen(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
 				int is_descending)
 {
 	int ret;
 
-	if (entry1->ogen > entry2->ogen)
+	if (entry1->info.otransid > entry2->info.otransid)
 		ret = 1;
-	else if (entry1->ogen < entry2->ogen)
+	else if (entry1->info.otransid < entry2->info.otransid)
 		ret = -1;
 	else
 		ret = 0;
@@ -174,15 +177,15 @@ static int comp_entry_with_ogen(struct root_info *entry1,
 	return is_descending ? -ret : ret;
 }
 
-static int comp_entry_with_path(struct root_info *entry1,
-				struct root_info *entry2,
+static int comp_entry_with_path(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
 				int is_descending)
 {
 	int ret;
 
-	if (strcmp(entry1->full_path, entry2->full_path) > 0)
+	if (strcmp(entry1->path, entry2->path) > 0)
 		ret = 1;
-	else if (strcmp(entry1->full_path, entry2->full_path) < 0)
+	else if (strcmp(entry1->path, entry2->path) < 0)
 		ret = -1;
 	else
 		ret = 0;
@@ -272,16 +275,14 @@ static int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 	return 0;
 }
 
-static int sort_comp(struct root_info *entry1, struct root_info *entry2,
-		     struct btrfs_list_comparer_set *set)
+static int subvol_comp(const void *entry1, const void *entry2, void *arg)
 {
+	const struct btrfs_list_comparer_set * const set = arg;
 	int rootid_compared = 0;
-	int i, ret = 0;
-
-	if (!set || !set->ncomps)
-		return comp_entry_with_rootid(entry1, entry2, 0);
+	int ret;
+	int i;
 
-	for (i = 0; i < set->ncomps; i++) {
+	for (i = 0; set && i < set->ncomps; i++) {
 		if (!set->comps[i].comp_func)
 			break;
 
@@ -295,383 +296,16 @@ static int sort_comp(struct root_info *entry1, struct root_info *entry2,
 	}
 
 	if (!rootid_compared)
-		ret = comp_entry_with_rootid(entry1, entry2, 0);
-
-	return ret;
-}
-
-static int sort_tree_insert(struct root_lookup *sort_tree,
-			    struct root_info *ins,
-			    struct btrfs_list_comparer_set *comp_set)
-{
-	struct rb_node **p = &sort_tree->root.rb_node;
-	struct rb_node *parent = NULL;
-	struct root_info *curr;
-	int ret;
-
-	while (*p) {
-		parent = *p;
-		curr = rb_entry(parent, struct root_info, sort_node);
-
-		ret = sort_comp(ins, curr, comp_set);
-		if (ret < 0)
-			p = &(*p)->rb_left;
-		else if (ret > 0)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
-
-	rb_link_node(&ins->sort_node, parent, p);
-	rb_insert_color(&ins->sort_node, &sort_tree->root);
-	return 0;
-}
-
-/*
- * insert a new root into the tree.  returns the existing root entry
- * if one is already there.  Both root_id and ref_tree are used
- * as the key
- */
-static int root_tree_insert(struct root_lookup *root_tree,
-			    struct root_info *ins)
-{
-	struct rb_node **p = &root_tree->root.rb_node;
-	struct rb_node * parent = NULL;
-	struct root_info *curr;
-	int ret;
-
-	while(*p) {
-		parent = *p;
-		curr = rb_entry(parent, struct root_info, rb_node);
-
-		ret = comp_entry_with_rootid(ins, curr, 0);
-		if (ret < 0)
-			p = &(*p)->rb_left;
-		else if (ret > 0)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
-
-	rb_link_node(&ins->rb_node, parent, p);
-	rb_insert_color(&ins->rb_node, &root_tree->root);
-	return 0;
-}
-
-/*
- * find a given root id in the tree.  We return the smallest one,
- * rb_next can be used to move forward looking for more if required
- */
-static struct root_info *root_tree_search(struct root_lookup *root_tree,
-					  u64 root_id)
-{
-	struct rb_node *n = root_tree->root.rb_node;
-	struct root_info *entry;
-	struct root_info tmp;
-	int ret;
-
-	tmp.root_id = root_id;
-
-	while(n) {
-		entry = rb_entry(n, struct root_info, rb_node);
-
-		ret = comp_entry_with_rootid(&tmp, entry, 0);
-		if (ret < 0)
-			n = n->rb_left;
-		else if (ret > 0)
-			n = n->rb_right;
-		else
-			return entry;
-	}
-	return NULL;
-}
-
-static int update_root(struct root_lookup *root_lookup,
-		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
-		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		       time_t otime, u8 *uuid, u8 *puuid, u8 *ruuid)
-{
-	struct root_info *ri;
-
-	ri = root_tree_search(root_lookup, root_id);
-	if (!ri || ri->root_id != root_id)
-		return -ENOENT;
-	if (name && name_len > 0) {
-		free(ri->name);
-
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
-		strncpy(ri->name, name, name_len);
-		ri->name[name_len] = 0;
-	}
-	if (ref_tree)
-		ri->ref_tree = ref_tree;
-	if (root_offset)
-		ri->root_offset = root_offset;
-	if (flags)
-		ri->flags = flags;
-	if (dir_id)
-		ri->dir_id = dir_id;
-	if (gen)
-		ri->gen = gen;
-	if (ogen)
-		ri->ogen = ogen;
-	if (!ri->ogen && root_offset)
-		ri->ogen = root_offset;
-	if (otime)
-		ri->otime = otime;
-	if (uuid)
-		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-	if (puuid)
-		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
-	if (ruuid)
-		memcpy(&ri->ruuid, ruuid, BTRFS_UUID_SIZE);
-
-	return 0;
-}
-
-/*
- * add_root - update the existed root, or allocate a new root and insert it
- *	      into the lookup tree.
- * root_id: object id of the root
- * ref_tree: object id of the referring root.
- * root_offset: offset value of the root'key
- * dir_id: inode id of the directory in ref_tree where this root can be found.
- * name: the name of root_id in that directory
- * name_len: the length of name
- * ogen: the original generation of the root
- * gen: the current generation of the root
- * otime: the original time (creation time) of the root
- * uuid: uuid of the root
- * puuid: uuid of the root parent if any
- * ruuid: uuid of the received subvol, if any
- */
-static int add_root(struct root_lookup *root_lookup,
-		    u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
-		    u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		    time_t otime, u8 *uuid, u8 *puuid, u8 *ruuid)
-{
-	struct root_info *ri;
-	int ret;
-
-	ret = update_root(root_lookup, root_id, ref_tree, root_offset, flags,
-			  dir_id, name, name_len, ogen, gen, otime,
-			  uuid, puuid, ruuid);
-	if (!ret)
-		return 0;
-
-	ri = calloc(1, sizeof(*ri));
-	if (!ri) {
-		printf("memory allocation failed\n");
-		exit(1);
-	}
-	ri->root_id = root_id;
-
-	if (name && name_len > 0) {
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
-		strncpy(ri->name, name, name_len);
-		ri->name[name_len] = 0;
-	}
-	if (ref_tree)
-		ri->ref_tree = ref_tree;
-	if (dir_id)
-		ri->dir_id = dir_id;
-	if (root_offset)
-		ri->root_offset = root_offset;
-	if (flags)
-		ri->flags = flags;
-	if (gen)
-		ri->gen = gen;
-	if (ogen)
-		ri->ogen = ogen;
-	if (!ri->ogen && root_offset)
-		ri->ogen = root_offset;
-	if (otime)
-		ri->otime = otime;
-
-	if (uuid)
-		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-
-	if (puuid)
-		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
-
-	if (ruuid)
-		memcpy(&ri->ruuid, ruuid, BTRFS_UUID_SIZE);
-
-	ret = root_tree_insert(root_lookup, ri);
-	if (ret < 0) {
-		error("failed to insert subvolume %llu to tree: %s",
-				(unsigned long long)root_id, strerror(-ret));
-		exit(1);
-	}
-	return 0;
-}
-
-/*
- * Simplified add_root for back references, omits the uuid and original info
- * parameters, root offset and flags.
- */
-static int add_root_backref(struct root_lookup *root_lookup, u64 root_id,
-		u64 ref_tree, u64 dir_id, char *name, int name_len)
-{
-	return add_root(root_lookup, root_id, ref_tree, 0, 0, dir_id, name,
-			name_len, 0, 0, 0, NULL, NULL, NULL);
-}
-
-
-static void free_root_info(struct rb_node *node)
-{
-	struct root_info *ri;
-
-	ri = rb_entry(node, struct root_info, rb_node);
-	free(ri->name);
-	free(ri->path);
-	free(ri->full_path);
-	free(ri);
-}
-
-/*
- * for a given root_info, search through the root_lookup tree to construct
- * the full path name to it.
- *
- * This can't be called until all the root_info->path fields are filled
- * in by lookup_ino_path
- */
-static int resolve_root(struct root_lookup *rl, struct root_info *ri,
-		       u64 top_id)
-{
-	char *full_path = NULL;
-	int len = 0;
-	struct root_info *found;
-
-	/*
-	 * we go backwards from the root_info object and add pathnames
-	 * from parent directories as we go.
-	 */
-	found = ri;
-	while (1) {
-		char *tmp;
-		u64 next;
-		int add_len;
-
-		/*
-		 * ref_tree = 0 indicates the subvolume
-		 * has been deleted.
-		 */
-		if (!found->ref_tree) {
-			free(full_path);
-			return -ENOENT;
-		}
-
-		add_len = strlen(found->path);
-
-		if (full_path) {
-			/* room for / and for null */
-			tmp = malloc(add_len + 2 + len);
-			if (!tmp) {
-				perror("malloc failed");
-				exit(1);
-			}
-			memcpy(tmp + add_len + 1, full_path, len);
-			tmp[add_len] = '/';
-			memcpy(tmp, found->path, add_len);
-			tmp [add_len + len + 1] = '\0';
-			free(full_path);
-			full_path = tmp;
-			len += add_len + 1;
-		} else {
-			full_path = strdup(found->path);
-			len = add_len;
-		}
-		if (!ri->top_id)
-			ri->top_id = found->ref_tree;
-
-		next = found->ref_tree;
-		if (next == top_id)
-			break;
-		/*
-		* if the ref_tree = BTRFS_FS_TREE_OBJECTID,
-		* we are at the top
-		*/
-		if (next == BTRFS_FS_TREE_OBJECTID)
-			break;
-		/*
-		* if the ref_tree wasn't in our tree of roots, the
-		* subvolume was deleted.
-		*/
-		found = root_tree_search(rl, next);
-		if (!found) {
-			free(full_path);
-			return -ENOENT;
-		}
-	}
-
-	ri->full_path = full_path;
+		return comp_entry_with_rootid(entry1, entry2, 0);
 
 	return 0;
 }
 
-/*
- * for a single root_info, ask the kernel to give us a path name
- * inside it's ref_root for the dir_id where it lives.
- *
- * This fills in root_info->path with the path to the directory and and
- * appends this root's name.
- */
-static int lookup_ino_path(int fd, struct root_info *ri)
+static void sort_subvols(struct btrfs_list_comparer_set *comp_set,
+			 struct subvol_list *subvols)
 {
-	struct btrfs_ioctl_ino_lookup_args args;
-	int ret;
-
-	if (ri->path)
-		return 0;
-
-	if (!ri->ref_tree)
-		return -ENOENT;
-
-	memset(&args, 0, sizeof(args));
-	args.treeid = ri->ref_tree;
-	args.objectid = ri->dir_id;
-
-	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
-	if (ret < 0) {
-		if (errno == ENOENT) {
-			ri->ref_tree = 0;
-			return -ENOENT;
-		}
-		error("failed to lookup path for root %llu: %s",
-			(unsigned long long)ri->ref_tree, strerror(errno));
-		return ret;
-	}
-
-	if (args.name[0]) {
-		/*
-		 * we're in a subdirectory of ref_tree, the kernel ioctl
-		 * puts a / in there for us
-		 */
-		ri->path = malloc(strlen(ri->name) + strlen(args.name) + 1);
-		if (!ri->path) {
-			perror("malloc failed");
-			exit(1);
-		}
-		strcpy(ri->path, args.name);
-		strcat(ri->path, ri->name);
-	} else {
-		/* we're at the root of ref_tree */
-		ri->path = strdup(ri->name);
-		if (!ri->path) {
-			perror("strdup failed");
-			exit(1);
-		}
-	}
-	return 0;
+	qsort_r(subvols->subvols, subvols->num, sizeof(subvols->subvols[0]),
+		subvol_comp, comp_set);
 }
 
 /* finding the generation for a given path is a two step process.
@@ -920,198 +554,83 @@ int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
 	return 0;
 }
 
-static int list_subvol_search(int fd, struct root_lookup *root_lookup)
+static int filter_by_rootid(struct listed_subvol *subvol, uint64_t data)
 {
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header sh;
-	struct btrfs_root_ref *ref;
-	struct btrfs_root_item *ri;
-	unsigned long off;
-	int name_len;
-	char *name;
-	u64 dir_id;
-	u64 gen = 0;
-	u64 ogen;
-	u64 flags;
-	int i;
-
-	root_lookup->root.rb_node = NULL;
-	memset(&args, 0, sizeof(args));
-
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	/* Search both live and deleted subvolumes */
-	sk->min_type = BTRFS_ROOT_ITEM_KEY;
-	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
-	sk->min_objectid = BTRFS_FS_TREE_OBJECTID;
-	sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
-	sk->max_offset = (u64)-1;
-	sk->max_transid = (u64)-1;
-
-	while(1) {
-		sk->nr_items = 4096;
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		if (ret < 0)
-			return ret;
-		if (sk->nr_items == 0)
-			break;
-
-		off = 0;
-
-		/*
-		 * for each item, pull the key out of the header and then
-		 * read the root_ref item it contains
-		 */
-		for (i = 0; i < sk->nr_items; i++) {
-			memcpy(&sh, args.buf + off, sizeof(sh));
-			off += sizeof(sh);
-			if (sh.type == BTRFS_ROOT_BACKREF_KEY) {
-				ref = (struct btrfs_root_ref *)(args.buf + off);
-				name_len = btrfs_stack_root_ref_name_len(ref);
-				name = (char *)(ref + 1);
-				dir_id = btrfs_stack_root_ref_dirid(ref);
-
-				add_root_backref(root_lookup, sh.objectid,
-						sh.offset, dir_id, name,
-						name_len);
-			} else if (sh.type == BTRFS_ROOT_ITEM_KEY &&
-				   (sh.objectid >= BTRFS_FIRST_FREE_OBJECTID ||
-				    sh.objectid == BTRFS_FS_TREE_OBJECTID)) {
-				time_t otime;
-				u8 uuid[BTRFS_UUID_SIZE];
-				u8 puuid[BTRFS_UUID_SIZE];
-				u8 ruuid[BTRFS_UUID_SIZE];
-
-				ri = (struct btrfs_root_item *)(args.buf + off);
-				gen = btrfs_root_generation(ri);
-				flags = btrfs_root_flags(ri);
-				if(sh.len >
-				   sizeof(struct btrfs_root_item_v0)) {
-					otime = btrfs_stack_timespec_sec(&ri->otime);
-					ogen = btrfs_root_otransid(ri);
-					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
-					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
-					memcpy(ruuid, ri->received_uuid, BTRFS_UUID_SIZE);
-				} else {
-					otime = 0;
-					ogen = 0;
-					memset(uuid, 0, BTRFS_UUID_SIZE);
-					memset(puuid, 0, BTRFS_UUID_SIZE);
-					memset(ruuid, 0, BTRFS_UUID_SIZE);
-				}
-
-				add_root(root_lookup, sh.objectid, 0,
-					 sh.offset, flags, 0, NULL, 0, ogen,
-					 gen, otime, uuid, puuid, ruuid);
-			}
-
-			off += sh.len;
-
-			sk->min_objectid = sh.objectid;
-			sk->min_type = sh.type;
-			sk->min_offset = sh.offset;
-		}
-		sk->min_offset++;
-		if (!sk->min_offset)
-			sk->min_type++;
-		else
-			continue;
-
-		if (sk->min_type > BTRFS_ROOT_BACKREF_KEY) {
-			sk->min_type = BTRFS_ROOT_ITEM_KEY;
-			sk->min_objectid++;
-		} else
-			continue;
-
-		if (sk->min_objectid > sk->max_objectid)
-			break;
-	}
-
-	return 0;
+	return subvol->info.id == data;
 }
 
-static int filter_by_rootid(struct root_info *ri, u64 data)
+static int filter_snapshot(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->root_id == data;
+	return !uuid_is_null(subvol->info.parent_uuid);
 }
 
-static int filter_snapshot(struct root_info *ri, u64 data)
+static int filter_flags(struct listed_subvol *subvol, uint64_t data)
 {
-	return !!ri->root_offset;
+	return subvol->info.flags & data;
 }
 
-static int filter_flags(struct root_info *ri, u64 flags)
+static int filter_gen_more(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->flags & flags;
+	return subvol->info.generation >= data;
 }
 
-static int filter_gen_more(struct root_info *ri, u64 data)
+static int filter_gen_less(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->gen >= data;
+	return subvol->info.generation <= data;
 }
 
-static int filter_gen_less(struct root_info *ri, u64 data)
+static int filter_gen_equal(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->gen <= data;
+	return subvol->info.generation == data;
 }
 
-static int filter_gen_equal(struct root_info  *ri, u64 data)
+static int filter_cgen_more(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->gen == data;
+	return subvol->info.otransid >= data;
 }
 
-static int filter_cgen_more(struct root_info *ri, u64 data)
+static int filter_cgen_less(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->ogen >= data;
+	return subvol->info.otransid <= data;
 }
 
-static int filter_cgen_less(struct root_info *ri, u64 data)
+static int filter_cgen_equal(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->ogen <= data;
+	return subvol->info.otransid == data;
 }
 
-static int filter_cgen_equal(struct root_info *ri, u64 data)
+static int filter_topid_equal(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->ogen == data;
+	/* See the comment in print_subvolume_column() about top level. */
+	return subvol->info.parent_id == data;
 }
 
-static int filter_topid_equal(struct root_info *ri, u64 data)
+static int filter_full_path(struct listed_subvol *subvol, uint64_t data)
 {
-	return ri->top_id == data;
-}
-
-static int filter_full_path(struct root_info *ri, u64 data)
-{
-	if (ri->full_path && ri->top_id != data) {
+	/*
+	 * This implements the same behavior as before the conversion to
+	 * libbtrfsutil, which is mostly nonsensical.
+	 */
+	if (subvol->info.parent_id != data) {
 		char *tmp;
-		char p[] = "<FS_TREE>";
-		int add_len = strlen(p);
-		int len = strlen(ri->full_path);
+		int ret;
 
-		tmp = malloc(len + add_len + 2);
-		if (!tmp) {
-			fprintf(stderr, "memory allocation failed\n");
+		ret = asprintf(&tmp, "<FS_TREE>/%s", subvol->path);
+		if (ret == -1) {
+			error("out of memory");
 			exit(1);
 		}
-		memcpy(tmp + add_len + 1, ri->full_path, len);
-		tmp[len + add_len + 1] = '\0';
-		tmp[add_len] = '/';
-		memcpy(tmp, p, add_len);
-		free(ri->full_path);
-		ri->full_path = tmp;
+
+		free(subvol->path);
+		subvol->path = tmp;
 	}
 	return 1;
 }
 
-static int filter_by_parent(struct root_info *ri, u64 data)
+static int filter_by_parent(struct listed_subvol *subvol, uint64_t data)
 {
-	return !uuid_compare(ri->puuid, (u8 *)(unsigned long)data);
-}
-
-static int filter_deleted(struct root_info *ri, u64 data)
-{
-	return ri->deleted;
+	return !uuid_compare(subvol->info.parent_uuid,
+			     (u8 *)(unsigned long)data);
 }
 
 static btrfs_list_filter_func all_filter_funcs[] = {
@@ -1127,7 +646,6 @@ static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
 	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
 	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
-	[BTRFS_LIST_FILTER_DELETED]		= filter_deleted,
 };
 
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
@@ -1184,95 +702,34 @@ void btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 
 	ASSERT(set->filters[set->nfilters].filter_func == NULL);
 
-	if (filter == BTRFS_LIST_FILTER_DELETED)
+	if (filter == BTRFS_LIST_FILTER_DELETED) {
 		set->only_deleted = 1;
-
-	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
-	set->filters[set->nfilters].data = data;
-	set->nfilters++;
+	} else {
+		set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
+		set->filters[set->nfilters].data = data;
+		set->nfilters++;
+	}
 }
 
-static int filter_root(struct root_info *ri,
-		       struct btrfs_list_filter_set *set)
+static int filters_match(struct listed_subvol *subvol,
+			 struct btrfs_list_filter_set *set)
 {
 	int i, ret;
 
 	if (!set)
 		return 1;
 
-	if (set->only_deleted && !ri->deleted)
-		return 0;
-
-	if (!set->only_deleted && ri->deleted)
-		return 0;
-
 	for (i = 0; i < set->nfilters; i++) {
 		if (!set->filters[i].filter_func)
 			break;
-		ret = set->filters[i].filter_func(ri, set->filters[i].data);
+		ret = set->filters[i].filter_func(subvol, set->filters[i].data);
 		if (!ret)
 			return 0;
 	}
 	return 1;
 }
 
-static void filter_and_sort_subvol(struct root_lookup *all_subvols,
-				    struct root_lookup *sort_tree,
-				    struct btrfs_list_filter_set *filter_set,
-				    struct btrfs_list_comparer_set *comp_set,
-				    u64 top_id)
-{
-	struct rb_node *n;
-	struct root_info *entry;
-	int ret;
-
-	sort_tree->root.rb_node = NULL;
-
-	n = rb_last(&all_subvols->root);
-	while (n) {
-		entry = rb_entry(n, struct root_info, rb_node);
-
-		ret = resolve_root(all_subvols, entry, top_id);
-		if (ret == -ENOENT) {
-			if (entry->root_id != BTRFS_FS_TREE_OBJECTID) {
-				entry->full_path = strdup("DELETED");
-				entry->deleted = 1;
-			} else {
-				/*
-				 * The full path is not supposed to be printed,
-				 * but we don't want to print an empty string,
-				 * in case it appears somewhere.
-				 */
-				entry->full_path = strdup("TOPLEVEL");
-				entry->deleted = 0;
-			}
-		}
-		ret = filter_root(entry, filter_set);
-		if (ret)
-			sort_tree_insert(sort_tree, entry, comp_set);
-		n = rb_prev(n);
-	}
-}
-
-static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
-{
-	struct rb_node *n;
-
-	n = rb_first(&root_lookup->root);
-	while (n) {
-		struct root_info *entry;
-		int ret;
-		entry = rb_entry(n, struct root_info, rb_node);
-		ret = lookup_ino_path(fd, entry);
-		if (ret && ret != -ENOENT)
-			return ret;
-		n = rb_next(n);
-	}
-
-	return 0;
-}
-
-static void print_subvolume_column(struct root_info *subv,
+static void print_subvolume_column(struct listed_subvol *subvol,
 				   enum btrfs_list_column_enum column)
 {
 	char tstr[256];
@@ -1282,62 +739,65 @@ static void print_subvolume_column(struct root_info *subv,
 
 	switch (column) {
 	case BTRFS_LIST_OBJECTID:
-		printf("%llu", subv->root_id);
+		printf("%" PRIu64, subvol->info.id);
 		break;
 	case BTRFS_LIST_GENERATION:
-		printf("%llu", subv->gen);
+		printf("%" PRIu64, subvol->info.generation);
 		break;
 	case BTRFS_LIST_OGENERATION:
-		printf("%llu", subv->ogen);
+		printf("%" PRIu64, subvol->info.otransid);
 		break;
 	case BTRFS_LIST_PARENT:
-		printf("%llu", subv->ref_tree);
-		break;
+	/*
+	 * Top level used to mean something else, but since 4f5ebb3ef553
+	 * ("Btrfs-progs: fix to make list specified directory's subvolumes
+	 * work") it was always set to the parent ID. See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html.
+	 */
 	case BTRFS_LIST_TOP_LEVEL:
-		printf("%llu", subv->top_id);
+		printf("%" PRIu64, subvol->info.parent_id);
 		break;
 	case BTRFS_LIST_OTIME:
-		if (subv->otime) {
+		if (subvol->info.otime.tv_sec) {
 			struct tm tm;
 
-			localtime_r(&subv->otime, &tm);
-			strftime(tstr, 256, "%Y-%m-%d %X", &tm);
+			localtime_r(&subvol->info.otime.tv_sec, &tm);
+			strftime(tstr, sizeof(tstr), "%Y-%m-%d %X", &tm);
 		} else
 			strcpy(tstr, "-");
 		printf("%s", tstr);
 		break;
 	case BTRFS_LIST_UUID:
-		if (uuid_is_null(subv->uuid))
+		if (uuid_is_null(subvol->info.uuid))
 			strcpy(uuidparse, "-");
 		else
-			uuid_unparse(subv->uuid, uuidparse);
+			uuid_unparse(subvol->info.uuid, uuidparse);
 		printf("%-36s", uuidparse);
 		break;
 	case BTRFS_LIST_PUUID:
-		if (uuid_is_null(subv->puuid))
+		if (uuid_is_null(subvol->info.parent_uuid))
 			strcpy(uuidparse, "-");
 		else
-			uuid_unparse(subv->puuid, uuidparse);
+			uuid_unparse(subvol->info.parent_uuid, uuidparse);
 		printf("%-36s", uuidparse);
 		break;
 	case BTRFS_LIST_RUUID:
-		if (uuid_is_null(subv->ruuid))
+		if (uuid_is_null(subvol->info.received_uuid))
 			strcpy(uuidparse, "-");
 		else
-			uuid_unparse(subv->ruuid, uuidparse);
+			uuid_unparse(subvol->info.received_uuid, uuidparse);
 		printf("%-36s", uuidparse);
 		break;
 	case BTRFS_LIST_PATH:
-		BUG_ON(!subv->full_path);
-		printf("%s", subv->full_path);
+		printf("%s", subvol->path);
 		break;
 	default:
 		break;
 	}
 }
 
-static void print_one_subvol_info_raw(struct root_info *subv,
-		const char *raw_prefix)
+static void print_one_subvol_info_raw(struct listed_subvol *subvol,
+				      const char *raw_prefix)
 {
 	int i;
 
@@ -1348,12 +808,12 @@ static void print_one_subvol_info_raw(struct root_info *subv,
 		if (raw_prefix)
 			printf("%s",raw_prefix);
 
-		print_subvolume_column(subv, i);
+		print_subvolume_column(subvol, i);
 	}
 	printf("\n");
 }
 
-static void print_one_subvol_info_table(struct root_info *subv)
+static void print_one_subvol_info_table(struct listed_subvol *subvol)
 {
 	int i;
 
@@ -1361,7 +821,7 @@ static void print_one_subvol_info_table(struct root_info *subv)
 		if (!btrfs_list_columns[i].need_print)
 			continue;
 
-		print_subvolume_column(subv, i);
+		print_subvolume_column(subvol, i);
 
 		if (i != BTRFS_LIST_PATH)
 			printf("\t");
@@ -1372,7 +832,7 @@ static void print_one_subvol_info_table(struct root_info *subv)
 	printf("\n");
 }
 
-static void print_one_subvol_info_default(struct root_info *subv)
+static void print_one_subvol_info_default(struct listed_subvol *subvol)
 {
 	int i;
 
@@ -1381,7 +841,7 @@ static void print_one_subvol_info_default(struct root_info *subv)
 			continue;
 
 		printf("%s ", btrfs_list_columns[i].name);
-		print_subvolume_column(subv, i);
+		print_subvolume_column(subvol, i);
 
 		if (i != BTRFS_LIST_PATH)
 			printf(" ");
@@ -1418,66 +878,174 @@ static void print_all_subvol_info_tab_head(void)
 	}
 }
 
-static void print_all_subvol_info(struct root_lookup *sorted_tree,
-		  enum btrfs_list_layout layout, const char *raw_prefix)
+static void print_all_subvol_info(struct subvol_list *subvols,
+				  enum btrfs_list_layout layout,
+				  const char *raw_prefix)
 {
-	struct rb_node *n;
-	struct root_info *entry;
+	size_t i;
 
 	if (layout == BTRFS_LIST_LAYOUT_TABLE)
 		print_all_subvol_info_tab_head();
 
-	n = rb_first(&sorted_tree->root);
-	while (n) {
-		entry = rb_entry(n, struct root_info, sort_node);
-
-		/* The toplevel subvolume is not listed by default */
-		if (entry->root_id == BTRFS_FS_TREE_OBJECTID)
-			goto next;
+	for (i = 0; i < subvols->num; i++) {
+		struct listed_subvol *subvol = &subvols->subvols[i];
 
 		switch (layout) {
 		case BTRFS_LIST_LAYOUT_DEFAULT:
-			print_one_subvol_info_default(entry);
+			print_one_subvol_info_default(subvol);
 			break;
 		case BTRFS_LIST_LAYOUT_TABLE:
-			print_one_subvol_info_table(entry);
+			print_one_subvol_info_table(subvol);
 			break;
 		case BTRFS_LIST_LAYOUT_RAW:
-			print_one_subvol_info_raw(entry, raw_prefix);
+			print_one_subvol_info_raw(subvol, raw_prefix);
 			break;
 		}
-next:
-		n = rb_next(n);
 	}
 }
 
-static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
+static void free_subvol_list(struct subvol_list *subvols)
 {
-	int ret;
+	size_t i;
+
+	if (subvols) {
+		for (i = 0; i < subvols->num; i++)
+			free(subvols->subvols[i].path);
+		free(subvols);
+	}
+}
 
-	ret = list_subvol_search(fd, root_lookup);
+static struct subvol_list *btrfs_list_deleted_subvols(int fd,
+						      struct btrfs_list_filter_set *filter_set)
+{
+	struct subvol_list *subvols = NULL;
+	uint64_t *ids = NULL;
+	size_t i, n;
+	enum btrfs_util_error err;
+	int ret = -1;
+
+	err = btrfs_util_f_deleted_subvolumes(fd, &ids, &n);
+	if (err) {
+		error_btrfs_util(err);
+		return NULL;
+	}
+
+	subvols = malloc(sizeof(*subvols) + n * sizeof(subvols->subvols[0]));
+	if (!subvols) {
+		error("out of memory");
+		goto out;
+	}
+
+	subvols->num = 0;
+	for (i = 0; i < n; i++) {
+		struct listed_subvol *subvol = &subvols->subvols[subvols->num];
+
+		err = btrfs_util_f_subvolume_info(fd, ids[i], &subvol->info);
+		if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		subvol->path = strdup("DELETED");
+		if (!subvol->path)
+			goto out;
+
+		if (!filters_match(subvol, filter_set)) {
+			free(subvol->path);
+			continue;
+		}
+
+		subvols->num++;
+	}
+
+	ret = 0;
+out:
 	if (ret) {
-		error("can't perform the search: %s", strerror(errno));
-		return ret;
+		free_subvol_list(subvols);
+		subvols = NULL;
+		free(ids);
 	}
+	return subvols;
+}
 
-	/*
-	 * now we have an rbtree full of root_info objects, but we need to fill
-	 * in their path names within the subvol that is referencing each one.
-	 */
-	ret = list_subvol_fill_paths(fd, root_lookup);
-	return ret;
+static struct subvol_list *btrfs_list_subvols(int fd,
+					      struct btrfs_list_filter_set *filter_set)
+{
+	struct subvol_list *subvols;
+	size_t capacity = 0;
+	struct btrfs_util_subvolume_iterator *iter;
+	enum btrfs_util_error err;
+	int ret = -1;
+
+	subvols = malloc(sizeof(*subvols));
+	if (!subvols) {
+		error("out of memory");
+		return NULL;
+	}
+	subvols->num = 0;
+
+	err = btrfs_util_f_create_subvolume_iterator(fd, BTRFS_FS_TREE_OBJECTID,
+						     0, &iter);
+	if (err) {
+		iter = NULL;
+		error_btrfs_util(err);
+		goto out;
+	}
+
+	for (;;) {
+		struct listed_subvol subvol;
+
+		err = btrfs_util_subvolume_iterator_next_info(iter,
+							      &subvol.path,
+							      &subvol.info);
+		if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+			break;
+		} else if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		if (!filters_match(&subvol, filter_set)) {
+			free(subvol.path);
+			continue;
+		}
+
+		if (subvols->num >= capacity) {
+			struct subvol_list *new_subvols;
+			size_t new_capacity = max_t(size_t, 1, capacity * 2);
+
+			new_subvols = realloc(subvols,
+					      sizeof(*new_subvols) +
+					      new_capacity *
+					      sizeof(new_subvols->subvols[0]));
+			if (!new_subvols) {
+				error("out of memory");
+				goto out;
+			}
+
+			subvols = new_subvols;
+			capacity = new_capacity;
+		}
+
+		subvols->subvols[subvols->num] = subvol;
+		subvols->num++;
+	}
+
+	ret = 0;
+out:
+	if (iter)
+		btrfs_util_destroy_subvolume_iterator(iter);
+	if (ret)
+		free_subvol_list(subvols);
+	return subvols;
 }
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set,
-		       enum btrfs_list_layout layout, int full_path,
-		       const char *raw_prefix)
+			     struct btrfs_list_comparer_set *comp_set,
+			     enum btrfs_list_layout layout, int full_path,
+			     const char *raw_prefix)
 {
-	struct root_lookup root_lookup;
-	struct root_lookup root_sort;
-	int ret = 0;
-	u64 top_id = 0;
+	struct subvol_list *subvols;
 
 	/*
 	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
@@ -1485,14 +1053,19 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
 	 */
 
-	ret = btrfs_list_subvols(fd, &root_lookup);
-	if (ret)
-		return ret;
-	filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
-				 comp_set, top_id);
+	if (filter_set->only_deleted) {
+		subvols = btrfs_list_deleted_subvols(fd, filter_set);
+	} else {
+		subvols = btrfs_list_subvols(fd, filter_set);
+	}
+	if (!subvols)
+		return -1;
+
+	sort_subvols(comp_set, subvols);
+
+	print_all_subvol_info(subvols, layout, raw_prefix);
 
-	print_all_subvol_info(&root_sort, layout, raw_prefix);
-	rb_free_nodes(&root_lookup.root, free_root_info);
+	free_subvol_list(subvols);
 
 	return 0;
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index 317b8cf7..4780bfc2 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -87,8 +87,11 @@ struct root_info {
 	int deleted;
 };
 
-typedef int (*btrfs_list_filter_func)(struct root_info *, u64);
-typedef int (*btrfs_list_comp_func)(struct root_info *, struct root_info *,
+struct listed_subvol;
+
+typedef int (*btrfs_list_filter_func)(struct listed_subvol *, uint64_t);
+typedef int (*btrfs_list_comp_func)(const struct listed_subvol *,
+				    const struct listed_subvol *,
 				    int);
 
 struct btrfs_list_filter {
-- 
2.16.1

