Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab2IFKup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:50:45 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86AoS26019813
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:50:28 +0800
Message-ID: <50487FE6.50501@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:50:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 5/7] Btrfs-progs: restructure list_subvolumes
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

The current code of list_subvols() has very bad scalability, if we want to
add new filter conditions or new sort methods, we have to modify lots of code.

Beside that, the most code of list_snapshots() is similar to list_subvols(),

So I restructure list_subvols(), and split the subvolume filter function,
the subvolume sort function and the output function from list_subvols().
In order to implement it, we defined some importtant structures:
struct btrfs_list_filter {
	btrfs_list_filter_func filter_func;
	void *data;
};

struct btrfs_list_comparer {
	btrfs_list_comp_func comp_func;
	int is_descending;
};

struct {
	char	*name;
	char	*column_name;
	int	need_print;
} btrfs_list_columns[];

If we want to add a new filter condition, we can choose a suitable filter
function or implement a new filter function, and create a new
btrfs_list_filter object, and then pass it into list_subvols(). We also can
mix several filters (put those filters into an array, and pass the array into
list_subvols()) if the users specify two or more filter conditions.

The subvolume sort function is similar to the subvolume filter function. The
differentiation is the order of comparers in the array which is passed into
list_subvols() show us the priority of the sort methods.

Note: if we implement new filter functions or compare functions, we must add
them into the array all_filter_funcs and the array all_comp_funcs, and modify
the relative enum variants(btrfs_list_filter_enum, btrfs_list_comp_enum).

The output function is different with the above two functions, we define a
array to manage all the columns that can be outputed, and use a member variant
(->need_print) to control the output of the relative column. Some columns are
outputed by default. But we can change it according to the requirement of the
users.

After appling this patch, we needn't implement a independent list_snapshots()
function, just pass a filter function which is used to identify the snapshot
into list_subvols().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v3:
- new patch.
---
 btrfs-list.c     |  911 ++++++++++++++++++++++++++++++------------------------
 btrfs-list.h     |   61 ++++-
 cmds-inspect.c   |    2 +-
 cmds-subvolume.c |   61 +++-
 send-utils.c     |    3 +-
 5 files changed, 609 insertions(+), 429 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 2101695..38d7f9c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -49,19 +49,28 @@ struct root_lookup {
  */
 struct root_info {
 	struct rb_node rb_node;
+	struct rb_node sort_node;
 
 	/* this root's id */
 	u64 root_id;
 
+	/* equal the offset of the root's key */
+	u64 root_offset;
+
 	/* the id of the root that references this one */
 	u64 ref_tree;
 
 	/* the dir id we're in from ref_tree */
 	u64 dir_id;
 
+	u64 top_id;
+
 	/* generation when the root is created or last updated */
 	u64 gen;
 
+	/* creation generation of this root in sec*/
+	u64 ogen;
+
 	/* creation time of this root in sec*/
 	time_t otime;
 
@@ -73,35 +82,202 @@ struct root_info {
 	char *path;
 
 	/* the name of this root in the directory it lives in */
-	char name[];
+	char *name;
+
+	char *full_path;
 };
 
+struct {
+	char	*name;
+	char	*column_name;
+	int	need_print;
+} btrfs_list_columns[] = {
+	{
+		.name		= "ID",
+		.column_name	= "ID",
+		.need_print	= 1,
+	},
+	{
+		.name		= "gen",
+		.column_name	= "Gen",
+		.need_print	= 1,
+	},
+	{
+		.name		= "cgen",
+		.column_name	= "CGen",
+		.need_print	= 0,
+	},
+	{
+		.name		= "parent",
+		.column_name	= "Parent",
+		.need_print	= 0,
+	},
+	{
+		.name		= "top level",
+		.column_name	= "Top Level",
+		.need_print	= 1,
+	},
+	{
+		.name		= "otime",
+		.column_name	= "OTime",
+		.need_print	= 0,
+	},
+	{
+		.name		= "uuid",
+		.column_name	= "UUID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "path",
+		.column_name	= "Path",
+		.need_print	= 1,
+	},
+	{
+		.name		= NULL,
+		.column_name	= NULL,
+		.need_print	= 0,
+	},
+};
+
+static btrfs_list_filter_func all_filter_funcs[];
+static btrfs_list_comp_func all_comp_funcs[];
+
+void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
+{
+	int i;
+
+	BUG_ON(column < 0 || column > BTRFS_LIST_ALL);
+
+	if (column < BTRFS_LIST_ALL) {
+		btrfs_list_columns[column].need_print = 1;
+		return;
+	}
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++)
+		btrfs_list_columns[i].need_print = 1;
+}
+
 static void root_lookup_init(struct root_lookup *tree)
 {
 	tree->root.rb_node = NULL;
 }
 
-static int comp_entry(struct root_info *entry, u64 root_id, u64 ref_tree)
+static int comp_entry_with_rootid(struct root_info *entry1,
+				  struct root_info *entry2,
+				  int is_descending)
 {
-	if (entry->root_id > root_id)
-		return 1;
-	if (entry->root_id < root_id)
-		return -1;
-	if (entry->ref_tree > ref_tree)
-		return 1;
-	if (entry->ref_tree < ref_tree)
-		return -1;
-	return 0;
+	int ret;
+
+	if (entry1->root_id > entry2->root_id)
+		ret = 1;
+	else if (entry1->root_id < entry2->root_id)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
 }
 
-static int comp_entry_with_gen(struct root_info *entry, u64 root_id,
-			       u64 ref_tree, u64 gen)
+static int comp_entry_with_gen(struct root_info *entry1,
+			       struct root_info *entry2,
+			       int is_descending)
 {
-	if (entry->gen < gen)
-		return 1;
-	if (entry->gen > gen)
-		return -1;
-	return comp_entry(entry, root_id, ref_tree);
+	int ret;
+
+	if (entry1->gen > entry2->gen)
+		ret = 1;
+	if (entry1->gen < entry2->gen)
+		ret = -1;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_ogen(struct root_info *entry1,
+				struct root_info *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->ogen > entry2->ogen)
+		ret = 1;
+	if (entry1->ogen < entry2->ogen)
+		ret = -1;
+
+	return is_descending ? -ret : ret;
+}
+
+static btrfs_list_comp_func all_comp_funcs[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid,
+	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen,
+	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen,
+};
+
+void btrfs_list_init_comparers(struct btrfs_list_comparer comps[], int ncomps)
+{
+	memset(comps, 0, sizeof(struct btrfs_list_comparer) * ncomps);
+}
+
+void btrfs_list_setup_comparer(struct btrfs_list_comparer comparers[],
+			       int max_ncomps, int index,
+			       enum btrfs_list_comp_enum comparer,
+			       int is_descending)
+{
+	BUG_ON(index >= max_ncomps);
+	BUG_ON(comparers[index].comp_func);
+
+	comparers[index].comp_func = all_comp_funcs[comparer];
+	comparers[index].is_descending = is_descending;
+}
+
+static int sort_comp(struct root_info *entry1, struct root_info *entry2,
+		     struct btrfs_list_comparer comps[], int ncomps)
+{
+	int rootid_compared = 0;
+	int i, ret = 0;
+
+	for (i = 0; i < ncomps; i++) {
+		if (!comps[i].comp_func)
+			break;
+
+		ret = comps[i].comp_func(entry1, entry2,
+					 comps[i].is_descending);
+		if (ret)
+			return ret;
+
+		if (comps[i].comp_func == comp_entry_with_rootid)
+			rootid_compared = 1;
+	}
+
+	if (!rootid_compared)
+		ret = comp_entry_with_rootid(entry1, entry2, 0);
+	return ret;
+}
+
+static int sort_tree_insert(struct root_lookup *sort_tree,
+			    struct root_info *ins,
+			    struct btrfs_list_comparer comps[], int ncomps)
+{
+	struct rb_node **p = &sort_tree->root.rb_node;
+	struct rb_node *parent = NULL;
+	struct root_info *curr;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		curr = rb_entry(parent, struct root_info, sort_node);
+
+		ret = sort_comp(ins, curr, comps, ncomps);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&ins->sort_node, parent, p);
+	rb_insert_color(&ins->sort_node, &sort_tree->root);
+	return 0;
 }
 
 /*
@@ -109,118 +285,165 @@ static int comp_entry_with_gen(struct root_info *entry, u64 root_id,
  * if one is already there.  Both root_id and ref_tree are used
  * as the key
  */
-static struct rb_node *tree_insert(struct rb_root *root, u64 root_id,
-				   u64 ref_tree, u64 *gen, struct rb_node *node)
+static int root_tree_insert(struct root_lookup *root_tree,
+			    struct root_info *ins)
 {
-	struct rb_node ** p = &root->rb_node;
+	struct rb_node **p = &root_tree->root.rb_node;
 	struct rb_node * parent = NULL;
-	struct root_info *entry;
-	int comp;
+	struct root_info *curr;
+	int ret;
 
 	while(*p) {
 		parent = *p;
-		entry = rb_entry(parent, struct root_info, rb_node);
-
-		if (!gen)
-			comp = comp_entry(entry, root_id, ref_tree);
-		else
-			comp = comp_entry_with_gen(entry, root_id, ref_tree,
-						   *gen);
+		curr = rb_entry(parent, struct root_info, rb_node);
 
-		if (comp < 0)
+		ret = comp_entry_with_rootid(ins, curr, 0);
+		if (ret < 0)
 			p = &(*p)->rb_left;
-		else if (comp > 0)
+		else if (ret > 0)
 			p = &(*p)->rb_right;
 		else
-			return parent;
+			return -EEXIST;
 	}
 
-	entry = rb_entry(parent, struct root_info, rb_node);
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
+	rb_link_node(&ins->rb_node, parent, p);
+	rb_insert_color(&ins->rb_node, &root_tree->root);
+	return 0;
 }
 
 /*
  * find a given root id in the tree.  We return the smallest one,
  * rb_next can be used to move forward looking for more if required
  */
-static struct root_info *tree_search(struct rb_root *root, u64 root_id)
+static struct root_info *root_tree_search(struct root_lookup *root_tree,
+					  u64 root_id)
 {
-	struct rb_node * n = root->rb_node;
+	struct rb_node *n = root_tree->root.rb_node;
 	struct root_info *entry;
+	struct root_info tmp;
+	int ret;
+
+	tmp.root_id = root_id;
 
 	while(n) {
 		entry = rb_entry(n, struct root_info, rb_node);
 
-		if (entry->root_id < root_id)
+		ret = comp_entry_with_rootid(&tmp, entry, 0);
+		if (ret < 0)
 			n = n->rb_left;
-		else if (entry->root_id > root_id)
+		else if (ret > 0)
 			n = n->rb_right;
-		else {
-			struct root_info *prev;
-			struct rb_node *prev_n;
-			while (1) {
-				prev_n = rb_prev(n);
-				if (!prev_n)
-					break;
-				prev = rb_entry(prev_n, struct root_info,
-						      rb_node);
-				if (prev->root_id != root_id)
-					break;
-				entry = prev;
-				n = prev_n;
-			}
+		else
 			return entry;
-		}
 	}
 	return NULL;
 }
 
+static int update_root(struct root_lookup *root_lookup,
+		       u64 root_id, u64 ref_tree, u64 root_offset, u64 dir_id,
+		       char *name, int name_len, u64 ogen, u64 gen, time_t ot,
+		       void *uuid)
+{
+	struct root_info *ri;
+
+	ri = root_tree_search(root_lookup, root_id);
+	if (!ri || ri->root_id != root_id)
+		return -ENOENT;
+	if (name && name_len > 0) {
+		if (ri->name)
+			free(ri->name);
+
+		ri->name = malloc(name_len + 1);
+		if (!ri->name) {
+			fprintf(stderr, "memory allocation failed\n");
+			exit(1);
+		}
+		strncpy(ri->name, name, name_len);
+		ri->name[name_len] = 0;
+	}
+	if (ref_tree)
+		ri->ref_tree = ref_tree;
+	if (root_offset)
+		ri->root_offset = root_offset;
+	if (dir_id)
+		ri->dir_id = dir_id;
+	if (gen)
+		ri->gen = gen;
+	if (ogen)
+		ri->ogen = ogen;
+	if (!ri->ogen && root_offset)
+		ri->ogen = root_offset;
+	if (ot)
+		ri->otime = ot;
+	if (uuid)
+		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
+
+	return 0;
+}
+
 /*
- * this allocates a new root in the lookup tree.
- *
- * root_id should be the object id of the root
- *
- * ref_tree is the objectid of the referring root.
- *
- * dir_id is the directory in ref_tree where this root_id can be found.
- *
- * name is the name of root_id in that directory
- *
- * name_len is the length of name
+ * add_root - update the existed root, or allocate a new root and insert it
+ * 	      into the lookup tree.
+ * root_id: object id of the root
+ * ref_tree: object id of the referring root.
+ * root_offset: offset value of the root'key
+ * dir_id: inode id of the directory in ref_tree where this root can be found.
+ * name: the name of root_id in that directory
+ * name_len: the length of name
+ * ogen: the original generation of the root
+ * gen: the current generation of the root
+ * ot: the original time(create time) of the root
+ * uuid: uuid of the root
  */
 static int add_root(struct root_lookup *root_lookup,
-		    u64 root_id, u64 ref_tree, u64 dir_id, char *name,
-		    int name_len, u64 *gen, time_t ot, void *uuid)
+		    u64 root_id, u64 ref_tree, u64 root_offset, u64 dir_id,
+		    char *name, int name_len, u64 ogen, u64 gen, time_t ot,
+		    void *uuid)
 {
 	struct root_info *ri;
-	struct rb_node *ret;
-	ri = malloc(sizeof(*ri) + name_len + 1);
+	int ret;
+
+	ret = update_root(root_lookup, root_id, ref_tree, root_offset, dir_id,
+			  name, name_len, ogen, gen, ot, uuid);
+	if (!ret)
+		return 0;
+
+	ri = malloc(sizeof(*ri));
 	if (!ri) {
 		printf("memory allocation failed\n");
 		exit(1);
 	}
-	memset(ri, 0, sizeof(*ri) + name_len + 1);
-	ri->path = NULL;
-	ri->dir_id = dir_id;
+	memset(ri, 0, sizeof(*ri));
 	ri->root_id = root_id;
-	ri->ref_tree = ref_tree;
-	if (name)
+
+	if (name && name_len > 0) {
+		ri->name = malloc(name_len + 1);
+		if (!ri->name) {
+			fprintf(stderr, "memory allocation failed\n");
+			exit(1);
+		}
 		strncpy(ri->name, name, name_len);
-	if (name_len > 0)
 		ri->name[name_len] = 0;
+	}
+	if (ref_tree)
+		ri->ref_tree = ref_tree;
+	if (dir_id)
+		ri->dir_id = dir_id;
+	if (root_offset)
+		ri->root_offset = root_offset;
 	if (gen)
-		ri->gen = *gen;
-	ri->otime = ot;
+		ri->gen = gen;
+	if (ogen)
+		ri->ogen = ogen;
+	if (!ri->ogen && root_offset)
+		ri->ogen = root_offset;
+	if (ot)
+		ri->otime = ot;
 
 	if (uuid) 
 		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-	else
-		memset(&ri->uuid, 0, BTRFS_UUID_SIZE);
 
-	ret = tree_insert(&root_lookup->root, root_id, ref_tree, gen,
-			  &ri->rb_node);
+	ret = root_tree_insert(root_lookup, ri);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
 		exit(1);
@@ -228,24 +451,33 @@ static int add_root(struct root_lookup *root_lookup,
 	return 0;
 }
 
-static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen,
-			time_t ot, void *uuid)
+void __free_root_info(struct root_info *ri)
 {
-	struct root_info *ri;
+	if (ri->name)
+		free(ri->name);
 
-	ri = tree_search(&root_lookup->root, root_id);
-	if (!ri || ri->root_id != root_id) {
-		fprintf(stderr, "could not find subvol %llu\n", root_id);
-		return -ENOENT;
-	}
-	ri->gen = gen;
-	ri->otime = ot;
-	if (uuid)
-		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-	else
-		memset(&ri->uuid, 0, BTRFS_UUID_SIZE);
+	if (ri->path)
+		free(ri->path);
 
-	return 0;
+	if (ri->full_path)
+		free(ri->full_path);
+
+	free(ri);
+}
+
+void __free_all_subvolumn(struct root_lookup *root_tree)
+{
+	struct root_info *entry;
+	struct rb_node *n;
+
+	n = rb_first(&root_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, rb_node);
+		rb_erase(n, &root_tree->root);
+		__free_root_info(entry);
+
+		n = rb_first(&root_tree->root);
+	}
 }
 
 /*
@@ -255,8 +487,7 @@ static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen,
  * This can't be called until all the root_info->path fields are filled
  * in by lookup_ino_path
  */
-static int resolve_root(struct root_lookup *rl, struct root_info *ri,
-			u64 *parent_id, u64 *top_id, char **path)
+static int resolve_root(struct root_lookup *rl, struct root_info *ri)
 {
 	char *full_path = NULL;
 	int len = 0;
@@ -266,7 +497,6 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 	 * we go backwards from the root_info object and add pathnames
 	 * from parent directories as we go.
 	 */
-	*parent_id = 0;
 	found = ri;
 	while (1) {
 		char *tmp;
@@ -275,6 +505,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 
 		/* room for / and for null */
 		tmp = malloc(add_len + 2 + len);
+		if (!tmp) {
+			perror("malloc failed");
+			exit(1);
+		}
 		if (full_path) {
 			memcpy(tmp + add_len + 1, full_path, len);
 			tmp[add_len] = '/';
@@ -289,13 +523,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		}
 
 		next = found->ref_tree;
-		/* record the first parent */
-		if (*parent_id == 0)
-			*parent_id = next;
 
 		/* if the ref_tree refers to ourselves, we're at the top */
 		if (next == found->root_id) {
-			*top_id = next;
+			ri->top_id = next;
 			break;
 		}
 
@@ -303,14 +534,14 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		 * if the ref_tree wasn't in our tree of roots, we're
 		 * at the top
 		 */
-		found = tree_search(&rl->root, next);
+		found = root_tree_search(rl, next);
 		if (!found) {
-			*top_id = next;
+			ri->top_id = next;
 			break;
 		}
 	}
 
-	*path = full_path;
+	ri->full_path = full_path;
 
 	return 0;
 }
@@ -608,7 +839,7 @@ build:
 	return full;
 }
 
-static int get_default_subvolid(int fd, u64 *default_id)
+int btrfs_list_get_default_subvolume(int fd, u64 *default_id)
 {
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
@@ -674,10 +905,9 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int name_len;
 	char *name;
 	u64 dir_id;
-	u8 type;
 	u64 gen = 0;
+	u64 ogen;
 	int i;
-	int get_gen = 0;
 	time_t t;
 	u8 uuid[BTRFS_UUID_SIZE];
 
@@ -692,7 +922,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	 * only send back this type of key now.
 	 */
 	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
-	sk->min_type = BTRFS_ROOT_BACKREF_KEY;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
 
 	sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
 
@@ -704,7 +934,6 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	sk->max_offset = (u64)-1;
 	sk->max_transid = (u64)-1;
 
-again:
 	/* just a big number, doesn't matter much */
 	sk->nr_items = 4096;
 
@@ -726,27 +955,31 @@ again:
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
 			off += sizeof(*sh);
-			if (!get_gen && sh->type == BTRFS_ROOT_BACKREF_KEY) {
+			if (sh->type == BTRFS_ROOT_BACKREF_KEY) {
 				ref = (struct btrfs_root_ref *)(args.buf + off);
 				name_len = btrfs_stack_root_ref_name_len(ref);
 				name = (char *)(ref + 1);
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh->objectid, sh->offset,
-					 dir_id, name, name_len, NULL, 0, NULL);
-			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
+					 0, dir_id, name, name_len, 0, 0, 0,
+					 NULL);
+			} else if (sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
 				if(sh->len == sizeof(struct btrfs_root_item)) {
 					t = ri->otime.sec;
+					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 				} else {
 					t = 0;
+					ogen = 0;
 					memset(uuid, 0, BTRFS_UUID_SIZE);
 				}
 
-				update_root(root_lookup, sh->objectid, gen, t,
-					uuid);
+				add_root(root_lookup, sh->objectid, 0,
+					 sh->offset, 0, NULL, 0, ogen, gen, t,
+					 uuid);
 			}
 
 			off += sh->len;
@@ -760,127 +993,99 @@ again:
 			sk->min_offset = sh->offset;
 		}
 		sk->nr_items = 4096;
-		/* this iteration is done, step forward one root for the next
-		 * ioctl
-		 */
-		if (get_gen)
-			type = BTRFS_ROOT_ITEM_KEY;
+		sk->min_offset++;
+		if (!sk->min_offset)	/* overflow */
+			sk->min_type++;
 		else
-			type = BTRFS_ROOT_BACKREF_KEY;
+			continue;
 
-		if (sk->min_type < type) {
-			sk->min_type = type;
-			sk->min_offset = 0;
-		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
+		if (sk->min_type > BTRFS_ROOT_BACKREF_KEY) {
+			sk->min_type = BTRFS_ROOT_ITEM_KEY;
 			sk->min_objectid++;
-			sk->min_type = type;
-			sk->min_offset = 0;
 		} else
+			continue;
+
+		if (sk->min_objectid > sk->max_objectid)
 			break;
 	}
 
-	if (!get_gen) {
-		memset(&args, 0, sizeof(args));
+	return 0;
+}
 
-		sk->tree_id = 1;
-		sk->max_type = BTRFS_ROOT_ITEM_KEY;
-		sk->min_type = BTRFS_ROOT_ITEM_KEY;
+static int filter_by_rootid(struct root_info *ri, void *arg)
+{
+	u64 default_root_id = *((u64 *)arg);
 
-		sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+	return ri->root_id == default_root_id;
+}
 
-		sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
-		sk->max_offset = (u64)-1;
-		sk->max_transid = (u64)-1;
+static int filter_snapshot(struct root_info *ri, void *arg)
+{
+	return !!ri->root_offset;
+}
 
-		get_gen = 1;
-		goto again;
-	}
-	return 0;
+static btrfs_list_filter_func all_filter_funcs[] = {
+	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
+	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
+};
+
+void btrfs_list_init_filters(struct btrfs_list_filter filters[], int nfilters)
+{
+	memset(filters, 0, sizeof(struct btrfs_list_filter) * nfilters);
 }
 
-static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
+void btrfs_list_setup_filter(struct btrfs_list_filter filters[],
+			     int max_nfilters, int index,
+			     enum btrfs_list_filter_enum filter, void *data)
 {
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
-	unsigned long off = 0;
-	u64 gen = 0;
-	int i;
+	BUG_ON(index >= max_nfilters);
+	BUG_ON(filters[index].filter_func);
 
-	root_lookup_init(root_lookup);
-	memset(&args, 0, sizeof(args));
+	filters[index].filter_func = all_filter_funcs[filter];
+	filters[index].data = data;
+}
 
-	sk->tree_id = 1;
-	sk->max_type = BTRFS_ROOT_ITEM_KEY;
-	sk->min_type = BTRFS_ROOT_ITEM_KEY;
-	sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
-	sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
-	sk->max_offset = (u64)-1;
-	sk->max_transid = (u64)-1;
-	sk->nr_items = 4096;
+static int filter_root(struct root_info *ri,
+		       struct btrfs_list_filter filters[], int nfilters)
+{
+	int i, ret;
 
-	while (1) {
-		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		if (ret < 0)
-			return ret;
-		/* the ioctl returns the number of item it found in nr_items */
-		if (sk->nr_items == 0)
-			break;
+	if (!filters || !nfilters)
+		return 1;
 
-		off = 0;
+	for (i = 0; i < nfilters; i++) {
+		if (!filters[i].filter_func)
+			break;
+		ret = filters[i].filter_func(ri, filters[i].data);
+		if (!ret)
+			return 0;
+	}
+	return 1;
+}
 
-		/*
-		 * for each item, pull the key out of the header and then
-		 * read the root_ref item it contains
-		 */
-		for (i = 0; i < sk->nr_items; i++) {
-			struct btrfs_root_item *item;
-			time_t  t;
-			u8 uuid[BTRFS_UUID_SIZE];
+static void __filter_and_sort_subvol(struct root_lookup *all_subvols,
+				    struct root_lookup *sort_tree,
+				    struct btrfs_list_filter filters[],
+				    int nfilters,
+				    struct btrfs_list_comparer comps[],
+				    int ncomps)
+{
+	struct rb_node *n;
+	struct root_info *entry;
+	int ret;
 
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
-			off += sizeof(*sh);
-			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
-				item = (struct btrfs_root_item *)(args.buf + off);
-				if(sh->len == sizeof(struct btrfs_root_item)) {
-					t = item->otime.sec;
-					memcpy(uuid, item->uuid, BTRFS_UUID_SIZE);
-				} else {
-					t = 0;
-					memset(uuid, 0, BTRFS_UUID_SIZE);
-				}
-				gen = sh->offset;
+	root_lookup_init(sort_tree);
 
-				add_root(root_lookup, sh->objectid, 0,
-					 0, NULL, 0, &gen, t, uuid);
-			}
-			off += sh->len;
+	n = rb_last(&all_subvols->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, rb_node);
 
-			/*
-			 * record the mins in sk so we can make sure the
-			 * next search doesn't repeat this root
-			 */
-			sk->min_objectid = sh->objectid;
-			sk->min_type = sh->type;
-			sk->min_offset = sh->offset;
-		}
-		sk->nr_items = 4096;
-		/* this iteration is done, step forward one root for the next
-		 * ioctl
-		 */
-		if (sk->min_type < BTRFS_ROOT_ITEM_KEY) {
-			sk->min_type = BTRFS_ROOT_ITEM_KEY;
-			sk->min_offset = 0;
-		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
-			sk->min_objectid++;
-			sk->min_type = BTRFS_ROOT_ITEM_KEY;
-			sk->min_offset = 0;
-		} else
-			break;
+		resolve_root(all_subvols, entry);
+		ret = filter_root(entry, filters, nfilters);
+		if (ret)
+			sort_tree_insert(sort_tree, entry, comps, ncomps);
+		n = rb_prev(n);
 	}
-	return 0;
 }
 
 static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
@@ -901,128 +1106,91 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent, int get_default, int print_uuid)
+static void print_subvolume_column(struct root_info *subv,
+				   enum btrfs_list_column_enum column)
 {
-	struct root_lookup root_lookup;
-	struct rb_node *n;
-	u64 default_id;
-	int ret;
+	char tstr[256];
 	char uuidparse[37];
 
-	if (get_default) {
-		ret = get_default_subvolid(fd, &default_id);
-		if (ret) {
-			fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(errno));
-			return ret;
-		}
-		if (default_id == 0) {
-			fprintf(stderr, "ERROR: 'default' dir item not found\n");
-			return ret;
-		}
-
-		/* no need to resolve roots if FS_TREE is default */
-		if (default_id == BTRFS_FS_TREE_OBJECTID) {
-			printf("ID 5 (FS_TREE)\n");
-			return ret;
-		}
-	}
-
-	ret = __list_subvol_search(fd, &root_lookup);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(errno));
-		return ret;
+	BUG_ON(column >= BTRFS_LIST_ALL || column < 0);
+
+	switch (column) {
+	case BTRFS_LIST_OBJECTID:
+		printf("%llu", subv->root_id);
+		break;
+	case BTRFS_LIST_GENERATION:
+		printf("%llu", subv->gen);
+		break;
+	case BTRFS_LIST_OGENERATION:
+		printf("%llu", subv->ogen);
+		break;
+	case BTRFS_LIST_PARENT:
+		printf("%llu", subv->ref_tree);
+		break;
+	case BTRFS_LIST_TOP_LEVEL:
+		printf("%llu", subv->top_id);
+		break;
+	case BTRFS_LIST_OTIME:
+		if (subv->otime)
+			strftime(tstr, 256, "%Y-%m-%d %X",
+				 localtime(&subv->otime));
+		else
+			strcpy(tstr, "-");
+		printf("%s", tstr);
+		break;
+	case BTRFS_LIST_UUID:
+		if (uuid_is_null(subv->uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subv->uuid, uuidparse);
+		printf("%s", uuidparse);
+		break;
+	case BTRFS_LIST_PATH:
+		BUG_ON(!subv->full_path);
+		printf("%s", subv->full_path);
+		break;
+	default:
+		break;
 	}
+}
 
-	/*
-	 * now we have an rbtree full of root_info objects, but we need to fill
-	 * in their path names within the subvol that is referencing each one.
-	 */
-	ret = __list_subvol_fill_paths(fd, &root_lookup);
-	if (ret < 0)
-		return ret;
-
-	/* now that we have all the subvol-relative paths filled in,
-	 * we have to string the subvols together so that we can get
-	 * a path all the way back to the FS root
-	 */
-	n = rb_last(&root_lookup.root);
-	while (n) {
-		struct root_info *entry;
-		u64 level;
-		u64 parent_id;
-		char *path;
+static void print_single_volume_info_default(struct root_info *subv)
+{
+	int i;
 
-		entry = rb_entry(n, struct root_info, rb_node);
-		if (get_default && entry->root_id != default_id) {
-			n = rb_prev(n);
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
 			continue;
-		}
 
-		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
-		if (print_parent) {
-			if (print_uuid) {
-				if (uuid_is_null(entry->uuid))
-					strcpy(uuidparse, "-");
-				else
-					uuid_unparse(entry->uuid, uuidparse);
-				printf("ID %llu gen %llu parent %llu top level %llu"
-					" uuid %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)parent_id,
-					(unsigned long long)level,
-					uuidparse, path);
-			} else {
-				printf("ID %llu gen %llu parent %llu top level"
-					" %llu path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)parent_id,
-					(unsigned long long)level, path);
-			}
-		} else {
-			if (print_uuid) {
-				if (uuid_is_null(entry->uuid))
-					strcpy(uuidparse, "-");
-				else
-					uuid_unparse(entry->uuid, uuidparse);
-				printf("ID %llu gen %llu top level %llu"
-					" uuid %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)level,
-					uuidparse, path);
-			} else {
-				printf("ID %llu gen %llu top level %llu path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)level, path);
-			}
-		}
+		printf("%s ", btrfs_list_columns[i].name);
+		print_subvolume_column(subv, i);
 
-		free(path);
-		n = rb_prev(n);
+		if (i != BTRFS_LIST_PATH)
+			printf(" ");
 	}
+	printf("\n");
+}
 
-	return ret;
+static void print_all_volume_info_default(struct root_lookup *sorted_tree)
+{
+	struct rb_node *n;
+	struct root_info *entry;
+
+	n = rb_first(&sorted_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, sort_node);
+		print_single_volume_info_default(entry);
+		n = rb_next(n);
+	}
 }
 
-int list_snapshots(int fd, int print_parent, int order, int print_uuid)
+int btrfs_list_subvols(int fd, struct btrfs_list_filter filters[], int nfilters,
+		       struct btrfs_list_comparer comps[], int ncomps)
 {
 	struct root_lookup root_lookup;
-	struct root_lookup root_lookup_snap;
-	struct rb_node *n;
+	struct root_lookup root_sort;
 	int ret;
 
-	ret = __list_snapshot_search(fd, &root_lookup_snap);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(errno));
-		return ret;
-	}
-	
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret) {
 		fprintf(stderr, "ERROR: can't perform the search - %s\n",
@@ -1038,86 +1206,11 @@ int list_snapshots(int fd, int print_parent, int order, int print_uuid)
 	if (ret < 0)
 		return ret;
 
-	/* now that we have all the subvol-relative paths filled in,
-	 * we have to string the subvols together so that we can get
-	 * a path all the way back to the FS root
-	 */
-	if (!order)
-		n = rb_last(&root_lookup_snap.root);
-	else
-		n = rb_first(&root_lookup_snap.root);
-	while (n) {
-		struct root_info *entry_snap;
-		struct root_info *entry;
-		u64 level;
-		u64 parent_id;
-		char *path;
-		time_t t;
-		char tstr[256];
-		char uuidparse[37];
-
-		entry_snap = rb_entry(n, struct root_info, rb_node);
-		entry = tree_search(&root_lookup.root, entry_snap->root_id);
-
-		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
-		t = entry->otime;
-		if(t)
-			strftime(tstr,256,"%Y-%m-%d %X",localtime(&t));
-		else
-			strcpy(tstr,"-");
-		if (print_parent) {
-			if (print_uuid) {
-				if (uuid_is_null(entry->uuid))
-					strcpy(uuidparse, "-");
-				else
-					uuid_unparse(entry->uuid, uuidparse);
-				printf("ID %llu gen %llu cgen %llu parent %llu"
-					" top level %llu otime %s uuid %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)entry_snap->gen,
-					(unsigned long long)parent_id,
-					(unsigned long long)level,
-					tstr, uuidparse, path);
-			} else {
-				printf("ID %llu gen %llu cgen %llu parent %llu"
-					" top level %llu otime %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)entry_snap->gen,
-					(unsigned long long)parent_id,
-					(unsigned long long)level, tstr, path);
-			}
-		} else {
-			if (print_uuid) {
-				if (uuid_is_null(entry->uuid))
-					strcpy(uuidparse, "-");
-				else
-					uuid_unparse(entry->uuid, uuidparse);
-				printf("ID %llu gen %llu cgen %llu top level %llu "
-					"otime %s uuid %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)entry_snap->gen,
-					(unsigned long long)level,
-					tstr, uuidparse, path);
-			} else {
-				printf("ID %llu gen %llu cgen %llu top level %llu "
-					"otime %s path %s\n",
-					(unsigned long long)entry->root_id,
-					(unsigned long long)entry->gen,
-					(unsigned long long)entry_snap->gen,
-					(unsigned long long)level, tstr, path);
-			}
-		}
-
-		free(path);
-		if (!order)
-			n = rb_prev(n);
-		else
-			n = rb_next(n);
-	}
+	__filter_and_sort_subvol(&root_lookup, &root_sort, filters, nfilters,
+				 comps, ncomps);
 
+	print_all_volume_info_default(&root_sort);
+	__free_all_subvolumn(&root_lookup);
 	return ret;
 }
 
@@ -1200,7 +1293,7 @@ static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 	return 0;
 }
 
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
+int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -1301,7 +1394,7 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	return ret;
 }
 
-char *path_for_root(int fd, u64 root)
+char *btrfs_list_path_for_root(int fd, u64 root)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -1319,19 +1412,17 @@ char *path_for_root(int fd, u64 root)
 	n = rb_last(&root_lookup.root);
 	while (n) {
 		struct root_info *entry;
-		u64 parent_id;
-		u64 level;
-		char *path;
 
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
-		if (entry->root_id == root)
-			ret_path = path;
-		else
-			free(path);
+		resolve_root(&root_lookup, entry);
+		if (entry->root_id == root) {
+			ret_path = entry->full_path;
+			entry->full_path = NULL;
+		}
 
 		n = rb_prev(n);
 	}
+	__free_all_subvolumn(&root_lookup);
 
 	return ret_path;
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index b4a7f30..56d6a26 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -16,7 +16,60 @@
  * Boston, MA 021110-1307, USA.
  */
 
-int list_subvols(int fd, int print_parent, int get_default, int print_uuid);
-int list_snapshots(int fd, int print_parent, int order, int print_uuid);
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
-char *path_for_root(int fd, u64 root);
+struct root_info;
+
+typedef int (*btrfs_list_filter_func)(struct root_info *, void *);
+typedef int (*btrfs_list_comp_func)(struct root_info *, struct root_info *,
+				    int);
+
+struct btrfs_list_filter {
+	btrfs_list_filter_func filter_func;
+	void *data;
+};
+
+struct btrfs_list_comparer {
+	btrfs_list_comp_func comp_func;
+	int is_descending;
+};
+
+enum btrfs_list_column_enum {
+	BTRFS_LIST_OBJECTID,
+	BTRFS_LIST_GENERATION,
+	BTRFS_LIST_OGENERATION,
+	BTRFS_LIST_PARENT,
+	BTRFS_LIST_TOP_LEVEL,
+	BTRFS_LIST_OTIME,
+	BTRFS_LIST_UUID,
+	BTRFS_LIST_PATH,
+	BTRFS_LIST_ALL,
+};
+
+enum btrfs_list_filter_enum {
+	BTRFS_LIST_FILTER_ROOTID,
+	BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
+	BTRFS_LIST_FILTER_MAX,
+};
+
+enum btrfs_list_comp_enum {
+	BTRFS_LIST_COMP_ROOTID,
+	BTRFS_LIST_COMP_OGEN,
+	BTRFS_LIST_COMP_GEN,
+	BTRFS_LIST_COMP_MAX,
+};
+
+void btrfs_list_setup_print_column(enum btrfs_list_column_enum column);
+void btrfs_list_init_filters(struct btrfs_list_filter filters[], int nfilters);
+void btrfs_list_setup_filter(struct btrfs_list_filter filters[],
+			     int max_nfilters, int index,
+			     enum btrfs_list_filter_enum filter, void *data);
+void btrfs_list_init_comparers(struct btrfs_list_comparer comps[], int ncomps);
+void btrfs_list_setup_comparer(struct btrfs_list_comparer comparers[],
+			       int max_ncomps, int index,
+			       enum btrfs_list_comp_enum comparer,
+			       int is_descending);
+
+int btrfs_list_subvols(int fd, struct btrfs_list_filter filters[], int nfilters,
+		       struct btrfs_list_comparer comps[], int ncomps);
+int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
+char *btrfs_list_path_for_root(int fd, u64 root);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index f943ed9..376fab2 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -194,7 +194,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 		char *name;
 
 		if (getpath) {
-			name = path_for_root(fd, root);
+			name = btrfs_list_path_for_root(fd, root);
 			if (IS_ERR(name))
 				return PTR_ERR(name);
 			if (!name) {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index cd4b5a7..f29894c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -28,6 +28,7 @@
 #include "ioctl.h"
 #include "qgroup.h"
 
+#include "ctree.h"
 #include "commands.h"
 #include "btrfs-list.h"
 
@@ -270,13 +271,16 @@ static const char * const cmd_subvol_list_usage[] = {
 
 static int cmd_subvol_list(int argc, char **argv)
 {
+	struct btrfs_list_filter filters[BTRFS_LIST_FILTER_MAX];
+	struct btrfs_list_comparer comps[BTRFS_LIST_COMP_MAX];
 	int fd;
 	int ret;
-	int print_parent = 0;
-	int print_snap_only = 0;
-	int order = 0;
+	int order;
+	int filter_index = 0, comp_index = 0;
 	char *subvol;
-	int print_uuid = 0;
+
+	btrfs_list_init_filters(filters, BTRFS_LIST_FILTER_MAX);
+	btrfs_list_init_comparers(comps, BTRFS_LIST_COMP_MAX);
 
 	optind = 1;
 	while(1) {
@@ -286,14 +290,22 @@ static int cmd_subvol_list(int argc, char **argv)
 
 		switch(c) {
 		case 'p':
-			print_parent = 1;
+			btrfs_list_setup_print_column(BTRFS_LIST_PARENT);
 			break;
 		case 's':
-			print_snap_only = 1;
 			order = atoi(optarg);
+			btrfs_list_setup_filter(filters, BTRFS_LIST_FILTER_MAX,
+						filter_index++,
+						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
+						NULL);
+			btrfs_list_setup_comparer(comps, BTRFS_LIST_COMP_MAX,
+						  comp_index++,
+						  BTRFS_LIST_COMP_OGEN, !order);
+			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
+			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
 			break;
 		case 'u':
-			print_uuid =1;
+			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
 			break;
 		default:
 			usage(cmd_subvol_list_usage);
@@ -320,10 +332,8 @@ static int cmd_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	if (!print_snap_only)
-		ret = list_subvols(fd, print_parent, 0, print_uuid);
-	else
-		ret = list_snapshots(fd, print_parent, order, print_uuid);
+
+	ret = btrfs_list_subvols(fd, filters, filter_index, comps, comp_index);
 	if (ret)
 		return 19;
 	return 0;
@@ -483,6 +493,8 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	int fd;
 	int ret;
 	char *subvol;
+	struct btrfs_list_filter filters[1];
+	u64 default_id;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_get_default_usage);
@@ -504,7 +516,30 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1, 0);
+
+	ret = btrfs_list_get_default_subvolume(fd, &default_id);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+			strerror(errno));
+		return ret;
+	}
+
+	if (default_id == 0) {
+		fprintf(stderr, "ERROR: 'default' dir item not found\n");
+		return ret;
+	}
+
+	/* no need to resolve roots if FS_TREE is default */
+	if (default_id == BTRFS_FS_TREE_OBJECTID) {
+		printf("ID 5 (FS_TREE)\n");
+		return ret;
+	}
+
+	btrfs_list_init_filters(filters, 1);
+	btrfs_list_setup_filter(filters, 1, 0, BTRFS_LIST_FILTER_ROOTID,
+				(void *)&default_id);
+
+	ret = btrfs_list_subvols(fd, filters, 1, NULL, 0);
 	if (ret)
 		return 19;
 	return 0;
@@ -585,7 +620,7 @@ static int cmd_find_new(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = find_updated_files(fd, 0, last_gen);
+	ret = btrfs_list_find_updated_files(fd, 0, last_gen);
 	if (ret)
 		return 19;
 	return 0;
diff --git a/send-utils.c b/send-utils.c
index 096fa02..fcde5c2 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -244,7 +244,8 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				if (!root_item_valid)
 					goto skip;
 
-				path = path_for_root(mnt_fd, sh->objectid);
+				path = btrfs_list_path_for_root(mnt_fd,
+								sh->objectid);
 				if (!path)
 					path = strdup("");
 				if (IS_ERR(path)) {
-- 
1.7.6.5
