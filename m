Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43734 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167132AbeBOTF5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:57 -0500
Received: by mail-pg0-f65.google.com with SMTP id f6so492214pgs.10
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:57 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 26/27] btrfs-progs: use libbtrfsutil for subvolume list
Date: Thu, 15 Feb 2018 11:05:11 -0800
Message-Id: <6492726d6e89bf792627e4431f7ba7691f09c3d2.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is the most involved conversion because it replaces the libbtrfs
implementation entirely. I took care to preserve the existing behavior
in all cases, warts and all.

This also moves the list printing code from libbtrfs to
cmds-subvolume.c. This is an ABI break, but it avoids adding a
libbtrfsutil dependency to libbtrfs. A search online didn't turn up any
projects which use this interface.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 btrfs-list.c     | 806 +---------------------------------------------
 btrfs-list.h     |  89 ------
 cmds-subvolume.c | 948 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 956 insertions(+), 887 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e01c5899..a2fdb3f9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,9 +34,6 @@
 #include "btrfs-list.h"
 #include "rbtree-utils.h"
 
-#define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
-#define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
-
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
  */
@@ -44,285 +41,14 @@ struct root_lookup {
 	struct rb_root root;
 };
 
-static struct {
-	char	*name;
-	char	*column_name;
-	int	need_print;
-} btrfs_list_columns[] = {
-	{
-		.name		= "ID",
-		.column_name	= "ID",
-		.need_print	= 0,
-	},
-	{
-		.name		= "gen",
-		.column_name	= "Gen",
-		.need_print	= 0,
-	},
-	{
-		.name		= "cgen",
-		.column_name	= "CGen",
-		.need_print	= 0,
-	},
-	{
-		.name		= "parent",
-		.column_name	= "Parent",
-		.need_print	= 0,
-	},
-	{
-		.name		= "top level",
-		.column_name	= "Top Level",
-		.need_print	= 0,
-	},
-	{
-		.name		= "otime",
-		.column_name	= "OTime",
-		.need_print	= 0,
-	},
-	{
-		.name		= "parent_uuid",
-		.column_name	= "Parent UUID",
-		.need_print	= 0,
-	},
-	{
-		.name		= "received_uuid",
-		.column_name	= "Received UUID",
-		.need_print	= 0,
-	},
-	{
-		.name		= "uuid",
-		.column_name	= "UUID",
-		.need_print	= 0,
-	},
-	{
-		.name		= "path",
-		.column_name	= "Path",
-		.need_print	= 0,
-	},
-	{
-		.name		= NULL,
-		.column_name	= NULL,
-		.need_print	= 0,
-	},
-};
-
-static btrfs_list_filter_func all_filter_funcs[];
-static btrfs_list_comp_func all_comp_funcs[];
-
-void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
+static int comp_rootid(struct root_info *entry1, struct root_info *entry2)
 {
-	int i;
-
-	ASSERT(0 <= column && column <= BTRFS_LIST_ALL);
-
-	if (column < BTRFS_LIST_ALL) {
-		btrfs_list_columns[column].need_print = 1;
-		return;
-	}
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++)
-		btrfs_list_columns[i].need_print = 1;
-}
-
-static int comp_entry_with_rootid(struct root_info *entry1,
-				  struct root_info *entry2,
-				  int is_descending)
-{
-	int ret;
-
 	if (entry1->root_id > entry2->root_id)
-		ret = 1;
+		return 1;
 	else if (entry1->root_id < entry2->root_id)
-		ret = -1;
-	else
-		ret = 0;
-
-	return is_descending ? -ret : ret;
-}
-
-static int comp_entry_with_gen(struct root_info *entry1,
-			       struct root_info *entry2,
-			       int is_descending)
-{
-	int ret;
-
-	if (entry1->gen > entry2->gen)
-		ret = 1;
-	else if (entry1->gen < entry2->gen)
-		ret = -1;
-	else
-		ret = 0;
-
-	return is_descending ? -ret : ret;
-}
-
-static int comp_entry_with_ogen(struct root_info *entry1,
-				struct root_info *entry2,
-				int is_descending)
-{
-	int ret;
-
-	if (entry1->ogen > entry2->ogen)
-		ret = 1;
-	else if (entry1->ogen < entry2->ogen)
-		ret = -1;
+		return -1;
 	else
-		ret = 0;
-
-	return is_descending ? -ret : ret;
-}
-
-static int comp_entry_with_path(struct root_info *entry1,
-				struct root_info *entry2,
-				int is_descending)
-{
-	int ret;
-
-	if (strcmp(entry1->full_path, entry2->full_path) > 0)
-		ret = 1;
-	else if (strcmp(entry1->full_path, entry2->full_path) < 0)
-		ret = -1;
-	else
-		ret = 0;
-
-	return is_descending ? -ret : ret;
-}
-
-static btrfs_list_comp_func all_comp_funcs[] = {
-	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid,
-	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen,
-	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen,
-	[BTRFS_LIST_COMP_PATH]		= comp_entry_with_path,
-};
-
-static char *all_sort_items[] = {
-	[BTRFS_LIST_COMP_ROOTID]	= "rootid",
-	[BTRFS_LIST_COMP_OGEN]		= "ogen",
-	[BTRFS_LIST_COMP_GEN]		= "gen",
-	[BTRFS_LIST_COMP_PATH]		= "path",
-	[BTRFS_LIST_COMP_MAX]		= NULL,
-};
-
-static int  btrfs_list_get_sort_item(char *sort_name)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_LIST_COMP_MAX; i++) {
-		if (strcmp(sort_name, all_sort_items[i]) == 0)
-			return i;
-	}
-	return -1;
-}
-
-struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
-{
-	struct btrfs_list_comparer_set *set;
-	int size;
-
-	size = sizeof(struct btrfs_list_comparer_set) +
-	       BTRFS_LIST_NCOMPS_INCREASE * sizeof(struct btrfs_list_comparer);
-	set = calloc(1, size);
-	if (!set) {
-		fprintf(stderr, "memory allocation failed\n");
-		exit(1);
-	}
-
-	set->total = BTRFS_LIST_NCOMPS_INCREASE;
-
-	return set;
-}
-
-static int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
-		enum btrfs_list_comp_enum comparer, int is_descending)
-{
-	struct btrfs_list_comparer_set *set = *comp_set;
-	int size;
-
-	ASSERT(set != NULL);
-	ASSERT(comparer < BTRFS_LIST_COMP_MAX);
-	ASSERT(set->ncomps <= set->total);
-
-	if (set->ncomps == set->total) {
-		void *tmp;
-
-		size = set->total + BTRFS_LIST_NCOMPS_INCREASE;
-		size = sizeof(*set) + size * sizeof(struct btrfs_list_comparer);
-		tmp = set;
-		set = realloc(set, size);
-		if (!set) {
-			fprintf(stderr, "memory allocation failed\n");
-			free(tmp);
-			exit(1);
-		}
-
-		memset(&set->comps[set->total], 0,
-		       BTRFS_LIST_NCOMPS_INCREASE *
-		       sizeof(struct btrfs_list_comparer));
-		set->total += BTRFS_LIST_NCOMPS_INCREASE;
-		*comp_set = set;
-	}
-
-	ASSERT(set->comps[set->ncomps].comp_func == NULL);
-
-	set->comps[set->ncomps].comp_func = all_comp_funcs[comparer];
-	set->comps[set->ncomps].is_descending = is_descending;
-	set->ncomps++;
-	return 0;
-}
-
-static int sort_comp(struct root_info *entry1, struct root_info *entry2,
-		     struct btrfs_list_comparer_set *set)
-{
-	int rootid_compared = 0;
-	int i, ret = 0;
-
-	if (!set || !set->ncomps)
-		return comp_entry_with_rootid(entry1, entry2, 0);
-
-	for (i = 0; i < set->ncomps; i++) {
-		if (!set->comps[i].comp_func)
-			break;
-
-		ret = set->comps[i].comp_func(entry1, entry2,
-					      set->comps[i].is_descending);
-		if (ret)
-			return ret;
-
-		if (set->comps[i].comp_func == comp_entry_with_rootid)
-			rootid_compared = 1;
-	}
-
-	if (!rootid_compared)
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
+		return 0;
 }
 
 /*
@@ -342,7 +68,7 @@ static int root_tree_insert(struct root_lookup *root_tree,
 		parent = *p;
 		curr = rb_entry(parent, struct root_info, rb_node);
 
-		ret = comp_entry_with_rootid(ins, curr, 0);
+		ret = comp_rootid(ins, curr);
 		if (ret < 0)
 			p = &(*p)->rb_left;
 		else if (ret > 0)
@@ -373,7 +99,7 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 	while(n) {
 		entry = rb_entry(n, struct root_info, rb_node);
 
-		ret = comp_entry_with_rootid(&tmp, entry, 0);
+		ret = comp_rootid(&tmp, entry);
 		if (ret < 0)
 			n = n->rb_left;
 		else if (ret > 0)
@@ -1069,229 +795,6 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-static int filter_by_rootid(struct root_info *ri, u64 data)
-{
-	return ri->root_id == data;
-}
-
-static int filter_snapshot(struct root_info *ri, u64 data)
-{
-	return !!ri->root_offset;
-}
-
-static int filter_flags(struct root_info *ri, u64 flags)
-{
-	return ri->flags & flags;
-}
-
-static int filter_gen_more(struct root_info *ri, u64 data)
-{
-	return ri->gen >= data;
-}
-
-static int filter_gen_less(struct root_info *ri, u64 data)
-{
-	return ri->gen <= data;
-}
-
-static int filter_gen_equal(struct root_info  *ri, u64 data)
-{
-	return ri->gen == data;
-}
-
-static int filter_cgen_more(struct root_info *ri, u64 data)
-{
-	return ri->ogen >= data;
-}
-
-static int filter_cgen_less(struct root_info *ri, u64 data)
-{
-	return ri->ogen <= data;
-}
-
-static int filter_cgen_equal(struct root_info *ri, u64 data)
-{
-	return ri->ogen == data;
-}
-
-static int filter_topid_equal(struct root_info *ri, u64 data)
-{
-	return ri->top_id == data;
-}
-
-static int filter_full_path(struct root_info *ri, u64 data)
-{
-	if (ri->full_path && ri->top_id != data) {
-		char *tmp;
-		char p[] = "<FS_TREE>";
-		int add_len = strlen(p);
-		int len = strlen(ri->full_path);
-
-		tmp = malloc(len + add_len + 2);
-		if (!tmp) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
-		memcpy(tmp + add_len + 1, ri->full_path, len);
-		tmp[len + add_len + 1] = '\0';
-		tmp[add_len] = '/';
-		memcpy(tmp, p, add_len);
-		free(ri->full_path);
-		ri->full_path = tmp;
-	}
-	return 1;
-}
-
-static int filter_by_parent(struct root_info *ri, u64 data)
-{
-	return !uuid_compare(ri->puuid, (u8 *)(unsigned long)data);
-}
-
-static int filter_deleted(struct root_info *ri, u64 data)
-{
-	return ri->deleted;
-}
-
-static btrfs_list_filter_func all_filter_funcs[] = {
-	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
-	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
-	[BTRFS_LIST_FILTER_FLAGS]		= filter_flags,
-	[BTRFS_LIST_FILTER_GEN_MORE]		= filter_gen_more,
-	[BTRFS_LIST_FILTER_GEN_LESS]		= filter_gen_less,
-	[BTRFS_LIST_FILTER_GEN_EQUAL]           = filter_gen_equal,
-	[BTRFS_LIST_FILTER_CGEN_MORE]		= filter_cgen_more,
-	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
-	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
-	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
-	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
-	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
-	[BTRFS_LIST_FILTER_DELETED]		= filter_deleted,
-};
-
-struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
-{
-	struct btrfs_list_filter_set *set;
-	int size;
-
-	size = sizeof(struct btrfs_list_filter_set) +
-	       BTRFS_LIST_NFILTERS_INCREASE * sizeof(struct btrfs_list_filter);
-	set = calloc(1, size);
-	if (!set) {
-		fprintf(stderr, "memory allocation failed\n");
-		exit(1);
-	}
-
-	set->total = BTRFS_LIST_NFILTERS_INCREASE;
-
-	return set;
-}
-
-/*
- * Setup list filters. Exit if there's not enough memory, as we can't continue
- * without the structures set up properly.
- */
-void btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
-			    enum btrfs_list_filter_enum filter, u64 data)
-{
-	struct btrfs_list_filter_set *set = *filter_set;
-	int size;
-
-	ASSERT(set != NULL);
-	ASSERT(filter < BTRFS_LIST_FILTER_MAX);
-	ASSERT(set->nfilters <= set->total);
-
-	if (set->nfilters == set->total) {
-		void *tmp;
-
-		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
-		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
-		tmp = set;
-		set = realloc(set, size);
-		if (!set) {
-			fprintf(stderr, "memory allocation failed\n");
-			free(tmp);
-			exit(1);
-		}
-
-		memset(&set->filters[set->total], 0,
-		       BTRFS_LIST_NFILTERS_INCREASE *
-		       sizeof(struct btrfs_list_filter));
-		set->total += BTRFS_LIST_NFILTERS_INCREASE;
-		*filter_set = set;
-	}
-
-	ASSERT(set->filters[set->nfilters].filter_func == NULL);
-
-	if (filter == BTRFS_LIST_FILTER_DELETED)
-		set->only_deleted = 1;
-
-	set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
-	set->filters[set->nfilters].data = data;
-	set->nfilters++;
-}
-
-static int filter_root(struct root_info *ri,
-		       struct btrfs_list_filter_set *set)
-{
-	int i, ret;
-
-	if (!set)
-		return 1;
-
-	if (set->only_deleted && !ri->deleted)
-		return 0;
-
-	if (!set->only_deleted && ri->deleted)
-		return 0;
-
-	for (i = 0; i < set->nfilters; i++) {
-		if (!set->filters[i].filter_func)
-			break;
-		ret = set->filters[i].filter_func(ri, set->filters[i].data);
-		if (!ret)
-			return 0;
-	}
-	return 1;
-}
-
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
 static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 {
 	struct rb_node *n;
@@ -1310,185 +813,6 @@ static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-static void print_subvolume_column(struct root_info *subv,
-				   enum btrfs_list_column_enum column)
-{
-	char tstr[256];
-	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
-
-	ASSERT(0 <= column && column < BTRFS_LIST_ALL);
-
-	switch (column) {
-	case BTRFS_LIST_OBJECTID:
-		printf("%llu", subv->root_id);
-		break;
-	case BTRFS_LIST_GENERATION:
-		printf("%llu", subv->gen);
-		break;
-	case BTRFS_LIST_OGENERATION:
-		printf("%llu", subv->ogen);
-		break;
-	case BTRFS_LIST_PARENT:
-		printf("%llu", subv->ref_tree);
-		break;
-	case BTRFS_LIST_TOP_LEVEL:
-		printf("%llu", subv->top_id);
-		break;
-	case BTRFS_LIST_OTIME:
-		if (subv->otime) {
-			struct tm tm;
-
-			localtime_r(&subv->otime, &tm);
-			strftime(tstr, 256, "%Y-%m-%d %X", &tm);
-		} else
-			strcpy(tstr, "-");
-		printf("%s", tstr);
-		break;
-	case BTRFS_LIST_UUID:
-		if (uuid_is_null(subv->uuid))
-			strcpy(uuidparse, "-");
-		else
-			uuid_unparse(subv->uuid, uuidparse);
-		printf("%-36s", uuidparse);
-		break;
-	case BTRFS_LIST_PUUID:
-		if (uuid_is_null(subv->puuid))
-			strcpy(uuidparse, "-");
-		else
-			uuid_unparse(subv->puuid, uuidparse);
-		printf("%-36s", uuidparse);
-		break;
-	case BTRFS_LIST_RUUID:
-		if (uuid_is_null(subv->ruuid))
-			strcpy(uuidparse, "-");
-		else
-			uuid_unparse(subv->ruuid, uuidparse);
-		printf("%-36s", uuidparse);
-		break;
-	case BTRFS_LIST_PATH:
-		BUG_ON(!subv->full_path);
-		printf("%s", subv->full_path);
-		break;
-	default:
-		break;
-	}
-}
-
-static void print_one_subvol_info_raw(struct root_info *subv,
-		const char *raw_prefix)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (!btrfs_list_columns[i].need_print)
-			continue;
-
-		if (raw_prefix)
-			printf("%s",raw_prefix);
-
-		print_subvolume_column(subv, i);
-	}
-	printf("\n");
-}
-
-static void print_one_subvol_info_table(struct root_info *subv)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (!btrfs_list_columns[i].need_print)
-			continue;
-
-		print_subvolume_column(subv, i);
-
-		if (i != BTRFS_LIST_PATH)
-			printf("\t");
-
-		if (i == BTRFS_LIST_TOP_LEVEL)
-			printf("\t");
-	}
-	printf("\n");
-}
-
-static void print_one_subvol_info_default(struct root_info *subv)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (!btrfs_list_columns[i].need_print)
-			continue;
-
-		printf("%s ", btrfs_list_columns[i].name);
-		print_subvolume_column(subv, i);
-
-		if (i != BTRFS_LIST_PATH)
-			printf(" ");
-	}
-	printf("\n");
-}
-
-static void print_all_subvol_info_tab_head(void)
-{
-	int i;
-	int len;
-	char barrier[20];
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (btrfs_list_columns[i].need_print)
-			printf("%s\t", btrfs_list_columns[i].name);
-
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
-	}
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		memset(barrier, 0, sizeof(barrier));
-
-		if (btrfs_list_columns[i].need_print) {
-			len = strlen(btrfs_list_columns[i].name);
-			while (len--)
-				strcat(barrier, "-");
-
-			printf("%s\t", barrier);
-		}
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
-	}
-}
-
-static void print_all_subvol_info(struct root_lookup *sorted_tree,
-		  enum btrfs_list_layout layout, const char *raw_prefix)
-{
-	struct rb_node *n;
-	struct root_info *entry;
-
-	if (layout == BTRFS_LIST_LAYOUT_TABLE)
-		print_all_subvol_info_tab_head();
-
-	n = rb_first(&sorted_tree->root);
-	while (n) {
-		entry = rb_entry(n, struct root_info, sort_node);
-
-		/* The toplevel subvolume is not listed by default */
-		if (entry->root_id == BTRFS_FS_TREE_OBJECTID)
-			goto next;
-
-		switch (layout) {
-		case BTRFS_LIST_LAYOUT_DEFAULT:
-			print_one_subvol_info_default(entry);
-			break;
-		case BTRFS_LIST_LAYOUT_TABLE:
-			print_one_subvol_info_table(entry);
-			break;
-		case BTRFS_LIST_LAYOUT_RAW:
-			print_one_subvol_info_raw(entry, raw_prefix);
-			break;
-		}
-next:
-		n = rb_next(n);
-	}
-}
-
 static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 {
 	int ret;
@@ -1507,33 +831,6 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 	return ret;
 }
 
-int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set,
-		       enum btrfs_list_layout layout, int full_path,
-		       const char *raw_prefix)
-{
-	struct root_lookup root_lookup;
-	struct root_lookup root_sort;
-	int ret = 0;
-	u64 top_id = 0;
-
-	if (full_path)
-		ret = btrfs_list_get_path_rootid(fd, &top_id);
-	if (ret)
-		return ret;
-
-	ret = btrfs_list_subvols(fd, &root_lookup);
-	if (ret)
-		return ret;
-	filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
-				 comp_set, top_id);
-
-	print_all_subvol_info(&root_sort, layout, raw_prefix);
-	rb_free_nodes(&root_lookup.root, free_root_info);
-
-	return 0;
-}
-
 static char *strdup_or_null(const char *s)
 {
 	if (!s)
@@ -1598,8 +895,8 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 			continue;
 		}
 
-		if (!comp_entry_with_rootid(the_ri, ri, 0) ||
-			!uuid_compare(the_ri->uuid, ri->uuid)) {
+		if (!comp_rootid(the_ri, ri) ||
+		    !uuid_compare(the_ri->uuid, ri->uuid)) {
 			memcpy(the_ri, ri, offsetof(struct root_info, path));
 			the_ri->path = strdup_or_null(ri->path);
 			the_ri->name = strdup_or_null(ri->name);
@@ -1832,93 +1129,6 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	return ret_path;
 }
 
-int btrfs_list_parse_sort_string(char *opt_arg,
-				 struct btrfs_list_comparer_set **comps)
-{
-	int order;
-	int flag;
-	char *p;
-	char **ptr_argv;
-	int what_to_sort;
-
-	while ((p = strtok(opt_arg, ",")) != NULL) {
-		flag = 0;
-		ptr_argv = all_sort_items;
-
-		while (*ptr_argv) {
-			if (strcmp(*ptr_argv, p) == 0) {
-				flag = 1;
-				break;
-			} else {
-				p++;
-				if (strcmp(*ptr_argv, p) == 0) {
-					flag = 1;
-					p--;
-					break;
-				}
-				p--;
-			}
-			ptr_argv++;
-		}
-
-		if (flag == 0)
-			return -1;
-
-		else {
-			if (*p == '+') {
-				order = 0;
-				p++;
-			} else if (*p == '-') {
-				order = 1;
-				p++;
-			} else
-				order = 0;
-
-			what_to_sort = btrfs_list_get_sort_item(p);
-			btrfs_list_setup_comparer(comps, what_to_sort, order);
-		}
-		opt_arg = NULL;
-	}
-
-	return 0;
-}
-
-/*
- * This function is used to parse the argument of filter condition.
- *
- * type is the filter object.
- */
-int btrfs_list_parse_filter_string(char *opt_arg,
-				   struct btrfs_list_filter_set **filters,
-				   enum btrfs_list_filter_enum type)
-{
-
-	u64 arg;
-
-	switch (*(opt_arg++)) {
-	case '+':
-		arg = arg_strtou64(opt_arg);
-		type += 2;
-
-		btrfs_list_setup_filter(filters, type, arg);
-		break;
-	case '-':
-		arg = arg_strtou64(opt_arg);
-		type += 1;
-
-		btrfs_list_setup_filter(filters, type, arg);
-		break;
-	default:
-		opt_arg--;
-		arg = arg_strtou64(opt_arg);
-
-		btrfs_list_setup_filter(filters, type, arg);
-		break;
-	}
-
-	return 0;
-}
-
 int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 {
 	int ret;
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..54e1888f 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -31,12 +31,6 @@
 
 #include <time.h>
 
-enum btrfs_list_layout {
-	BTRFS_LIST_LAYOUT_DEFAULT = 0,
-	BTRFS_LIST_LAYOUT_TABLE,
-	BTRFS_LIST_LAYOUT_RAW
-};
-
 /*
  * one of these for each root we find.
  */
@@ -87,89 +81,6 @@ struct root_info {
 	int deleted;
 };
 
-typedef int (*btrfs_list_filter_func)(struct root_info *, u64);
-typedef int (*btrfs_list_comp_func)(struct root_info *, struct root_info *,
-				    int);
-
-struct btrfs_list_filter {
-	btrfs_list_filter_func filter_func;
-	u64 data;
-};
-
-struct btrfs_list_comparer {
-	btrfs_list_comp_func comp_func;
-	int is_descending;
-};
-
-struct btrfs_list_filter_set {
-	int total;
-	int nfilters;
-	int only_deleted;
-	struct btrfs_list_filter filters[0];
-};
-
-struct btrfs_list_comparer_set {
-	int total;
-	int ncomps;
-	struct btrfs_list_comparer comps[0];
-};
-
-enum btrfs_list_column_enum {
-	BTRFS_LIST_OBJECTID,
-	BTRFS_LIST_GENERATION,
-	BTRFS_LIST_OGENERATION,
-	BTRFS_LIST_PARENT,
-	BTRFS_LIST_TOP_LEVEL,
-	BTRFS_LIST_OTIME,
-	BTRFS_LIST_PUUID,
-	BTRFS_LIST_RUUID,
-	BTRFS_LIST_UUID,
-	BTRFS_LIST_PATH,
-	BTRFS_LIST_ALL,
-};
-
-enum btrfs_list_filter_enum {
-	BTRFS_LIST_FILTER_ROOTID,
-	BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
-	BTRFS_LIST_FILTER_FLAGS,
-	BTRFS_LIST_FILTER_GEN,
-	BTRFS_LIST_FILTER_GEN_EQUAL	=	BTRFS_LIST_FILTER_GEN,
-	BTRFS_LIST_FILTER_GEN_LESS,
-	BTRFS_LIST_FILTER_GEN_MORE,
-	BTRFS_LIST_FILTER_CGEN,
-	BTRFS_LIST_FILTER_CGEN_EQUAL	=	BTRFS_LIST_FILTER_CGEN,
-	BTRFS_LIST_FILTER_CGEN_LESS,
-	BTRFS_LIST_FILTER_CGEN_MORE,
-	BTRFS_LIST_FILTER_TOPID_EQUAL,
-	BTRFS_LIST_FILTER_FULL_PATH,
-	BTRFS_LIST_FILTER_BY_PARENT,
-	BTRFS_LIST_FILTER_DELETED,
-	BTRFS_LIST_FILTER_MAX,
-};
-
-enum btrfs_list_comp_enum {
-	BTRFS_LIST_COMP_ROOTID,
-	BTRFS_LIST_COMP_OGEN,
-	BTRFS_LIST_COMP_GEN,
-	BTRFS_LIST_COMP_PATH,
-	BTRFS_LIST_COMP_MAX,
-};
-
-int btrfs_list_parse_sort_string(char *optarg,
-				 struct btrfs_list_comparer_set **comps);
-int btrfs_list_parse_filter_string(char *optarg,
-				   struct btrfs_list_filter_set **filters,
-				   enum btrfs_list_filter_enum type);
-void btrfs_list_setup_print_column(enum btrfs_list_column_enum column);
-struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void);
-void btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
-			    enum btrfs_list_filter_enum filter, u64 data);
-struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void);
-
-int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set,
-		       enum btrfs_list_layout layot, int full_path,
-		       const char *raw_prefix);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 101ba4ca..392e4660 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -371,6 +371,954 @@ keep_fd:
 	return ret;
 }
 
+enum btrfs_list_layout {
+	BTRFS_LIST_LAYOUT_DEFAULT = 0,
+	BTRFS_LIST_LAYOUT_TABLE,
+	BTRFS_LIST_LAYOUT_RAW
+};
+
+enum btrfs_list_column_enum {
+	BTRFS_LIST_OBJECTID,
+	BTRFS_LIST_GENERATION,
+	BTRFS_LIST_OGENERATION,
+	BTRFS_LIST_PARENT,
+	BTRFS_LIST_TOP_LEVEL,
+	BTRFS_LIST_OTIME,
+	BTRFS_LIST_PUUID,
+	BTRFS_LIST_RUUID,
+	BTRFS_LIST_UUID,
+	BTRFS_LIST_PATH,
+	BTRFS_LIST_ALL,
+};
+
+enum btrfs_list_filter_enum {
+	BTRFS_LIST_FILTER_ROOTID,
+	BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
+	BTRFS_LIST_FILTER_FLAGS,
+	BTRFS_LIST_FILTER_GEN,
+	BTRFS_LIST_FILTER_GEN_EQUAL	=	BTRFS_LIST_FILTER_GEN,
+	BTRFS_LIST_FILTER_GEN_LESS,
+	BTRFS_LIST_FILTER_GEN_MORE,
+	BTRFS_LIST_FILTER_CGEN,
+	BTRFS_LIST_FILTER_CGEN_EQUAL	=	BTRFS_LIST_FILTER_CGEN,
+	BTRFS_LIST_FILTER_CGEN_LESS,
+	BTRFS_LIST_FILTER_CGEN_MORE,
+	BTRFS_LIST_FILTER_TOPID_EQUAL,
+	BTRFS_LIST_FILTER_FULL_PATH,
+	BTRFS_LIST_FILTER_BY_PARENT,
+	BTRFS_LIST_FILTER_DELETED,
+	BTRFS_LIST_FILTER_MAX,
+};
+
+enum btrfs_list_comp_enum {
+	BTRFS_LIST_COMP_ROOTID,
+	BTRFS_LIST_COMP_OGEN,
+	BTRFS_LIST_COMP_GEN,
+	BTRFS_LIST_COMP_PATH,
+	BTRFS_LIST_COMP_MAX,
+};
+
+#define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
+#define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
+
+struct listed_subvol {
+	struct btrfs_util_subvolume_info info;
+	char *path;
+};
+
+struct subvol_list {
+	size_t num;
+	struct listed_subvol subvols[];
+};
+
+typedef int (*btrfs_list_filter_func)(struct listed_subvol *, uint64_t);
+typedef int (*btrfs_list_comp_func)(const struct listed_subvol *,
+				    const struct listed_subvol *,
+				    int);
+
+struct btrfs_list_filter {
+	btrfs_list_filter_func filter_func;
+	u64 data;
+};
+
+struct btrfs_list_comparer {
+	btrfs_list_comp_func comp_func;
+	int is_descending;
+};
+
+struct btrfs_list_filter_set {
+	int total;
+	int nfilters;
+	int only_deleted;
+	struct btrfs_list_filter filters[0];
+};
+
+struct btrfs_list_comparer_set {
+	int total;
+	int ncomps;
+	struct btrfs_list_comparer comps[0];
+};
+
+static struct {
+	char	*name;
+	char	*column_name;
+	int	need_print;
+} btrfs_list_columns[] = {
+	{
+		.name		= "ID",
+		.column_name	= "ID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "gen",
+		.column_name	= "Gen",
+		.need_print	= 0,
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
+		.need_print	= 0,
+	},
+	{
+		.name		= "otime",
+		.column_name	= "OTime",
+		.need_print	= 0,
+	},
+	{
+		.name		= "parent_uuid",
+		.column_name	= "Parent UUID",
+		.need_print	= 0,
+	},
+	{
+		.name		= "received_uuid",
+		.column_name	= "Received UUID",
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
+		.need_print	= 0,
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
+static void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
+{
+	int i;
+
+	ASSERT(0 <= column && column <= BTRFS_LIST_ALL);
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
+static int comp_entry_with_rootid(const struct listed_subvol *entry1,
+				  const struct listed_subvol *entry2,
+				  int is_descending)
+{
+	int ret;
+
+	if (entry1->info.id > entry2->info.id)
+		ret = 1;
+	else if (entry1->info.id < entry2->info.id)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_gen(const struct listed_subvol *entry1,
+			       const struct listed_subvol *entry2,
+			       int is_descending)
+{
+	int ret;
+
+	if (entry1->info.generation > entry2->info.generation)
+		ret = 1;
+	else if (entry1->info.generation < entry2->info.generation)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_ogen(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (entry1->info.otransid > entry2->info.otransid)
+		ret = 1;
+	else if (entry1->info.otransid < entry2->info.otransid)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static int comp_entry_with_path(const struct listed_subvol *entry1,
+				const struct listed_subvol *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (strcmp(entry1->path, entry2->path) > 0)
+		ret = 1;
+	else if (strcmp(entry1->path, entry2->path) < 0)
+		ret = -1;
+	else
+		ret = 0;
+
+	return is_descending ? -ret : ret;
+}
+
+static btrfs_list_comp_func all_comp_funcs[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= comp_entry_with_rootid,
+	[BTRFS_LIST_COMP_OGEN]		= comp_entry_with_ogen,
+	[BTRFS_LIST_COMP_GEN]		= comp_entry_with_gen,
+	[BTRFS_LIST_COMP_PATH]		= comp_entry_with_path,
+};
+
+static char *all_sort_items[] = {
+	[BTRFS_LIST_COMP_ROOTID]	= "rootid",
+	[BTRFS_LIST_COMP_OGEN]		= "ogen",
+	[BTRFS_LIST_COMP_GEN]		= "gen",
+	[BTRFS_LIST_COMP_PATH]		= "path",
+	[BTRFS_LIST_COMP_MAX]		= NULL,
+};
+
+static int btrfs_list_get_sort_item(char *sort_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_COMP_MAX; i++) {
+		if (strcmp(sort_name, all_sort_items[i]) == 0)
+			return i;
+	}
+	return -1;
+}
+
+static struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
+{
+	struct btrfs_list_comparer_set *set;
+	int size;
+
+	size = sizeof(struct btrfs_list_comparer_set) +
+	       BTRFS_LIST_NCOMPS_INCREASE * sizeof(struct btrfs_list_comparer);
+	set = calloc(1, size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	set->total = BTRFS_LIST_NCOMPS_INCREASE;
+
+	return set;
+}
+
+static int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
+				     enum btrfs_list_comp_enum comparer,
+				     int is_descending)
+{
+	struct btrfs_list_comparer_set *set = *comp_set;
+	int size;
+
+	ASSERT(set != NULL);
+	ASSERT(comparer < BTRFS_LIST_COMP_MAX);
+	ASSERT(set->ncomps <= set->total);
+
+	if (set->ncomps == set->total) {
+		void *tmp;
+
+		size = set->total + BTRFS_LIST_NCOMPS_INCREASE;
+		size = sizeof(*set) + size * sizeof(struct btrfs_list_comparer);
+		tmp = set;
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
+			exit(1);
+		}
+
+		memset(&set->comps[set->total], 0,
+		       BTRFS_LIST_NCOMPS_INCREASE *
+		       sizeof(struct btrfs_list_comparer));
+		set->total += BTRFS_LIST_NCOMPS_INCREASE;
+		*comp_set = set;
+	}
+
+	ASSERT(set->comps[set->ncomps].comp_func == NULL);
+
+	set->comps[set->ncomps].comp_func = all_comp_funcs[comparer];
+	set->comps[set->ncomps].is_descending = is_descending;
+	set->ncomps++;
+	return 0;
+}
+
+static int subvol_comp(const void *entry1, const void *entry2, void *arg)
+{
+	const struct btrfs_list_comparer_set * const set = arg;
+	int rootid_compared = 0;
+	int ret;
+	int i;
+
+	for (i = 0; set && i < set->ncomps; i++) {
+		if (!set->comps[i].comp_func)
+			break;
+
+		ret = set->comps[i].comp_func(entry1, entry2,
+					      set->comps[i].is_descending);
+		if (ret)
+			return ret;
+
+		if (set->comps[i].comp_func == comp_entry_with_rootid)
+			rootid_compared = 1;
+	}
+
+	if (!rootid_compared)
+		return comp_entry_with_rootid(entry1, entry2, 0);
+
+	return 0;
+}
+
+static void sort_subvols(struct btrfs_list_comparer_set *comp_set,
+			 struct subvol_list *subvols)
+{
+	qsort_r(subvols->subvols, subvols->num, sizeof(subvols->subvols[0]),
+		subvol_comp, comp_set);
+}
+
+static int filter_by_rootid(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.id == data;
+}
+
+static int filter_snapshot(struct listed_subvol *subvol, uint64_t data)
+{
+	return !uuid_is_null(subvol->info.parent_uuid);
+}
+
+static int filter_flags(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.flags & data;
+}
+
+static int filter_gen_more(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation >= data;
+}
+
+static int filter_gen_less(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation <= data;
+}
+
+static int filter_gen_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.generation == data;
+}
+
+static int filter_cgen_more(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid >= data;
+}
+
+static int filter_cgen_less(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid <= data;
+}
+
+static int filter_cgen_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	return subvol->info.otransid == data;
+}
+
+static int filter_topid_equal(struct listed_subvol *subvol, uint64_t data)
+{
+	/* See the comment in print_subvolume_column() about top level. */
+	return subvol->info.parent_id == data;
+}
+
+static int filter_full_path(struct listed_subvol *subvol, uint64_t data)
+{
+	/*
+	 * This implements the same behavior as before the conversion to
+	 * libbtrfsutil, which is mostly nonsensical.
+	 */
+	if (subvol->info.parent_id != data) {
+		char *tmp;
+		int ret;
+
+		ret = asprintf(&tmp, "<FS_TREE>/%s", subvol->path);
+		if (ret == -1) {
+			error("out of memory");
+			exit(1);
+		}
+
+		free(subvol->path);
+		subvol->path = tmp;
+	}
+	return 1;
+}
+
+static int filter_by_parent(struct listed_subvol *subvol, uint64_t data)
+{
+	return !uuid_compare(subvol->info.parent_uuid,
+			     (u8 *)(unsigned long)data);
+}
+
+static btrfs_list_filter_func all_filter_funcs[] = {
+	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
+	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
+	[BTRFS_LIST_FILTER_FLAGS]		= filter_flags,
+	[BTRFS_LIST_FILTER_GEN_MORE]		= filter_gen_more,
+	[BTRFS_LIST_FILTER_GEN_LESS]		= filter_gen_less,
+	[BTRFS_LIST_FILTER_GEN_EQUAL]           = filter_gen_equal,
+	[BTRFS_LIST_FILTER_CGEN_MORE]		= filter_cgen_more,
+	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
+	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
+	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
+	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
+	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
+};
+
+static struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
+{
+	struct btrfs_list_filter_set *set;
+	int size;
+
+	size = sizeof(struct btrfs_list_filter_set) +
+	       BTRFS_LIST_NFILTERS_INCREASE * sizeof(struct btrfs_list_filter);
+	set = calloc(1, size);
+	if (!set) {
+		fprintf(stderr, "memory allocation failed\n");
+		exit(1);
+	}
+
+	set->total = BTRFS_LIST_NFILTERS_INCREASE;
+
+	return set;
+}
+
+/*
+ * Setup list filters. Exit if there's not enough memory, as we can't continue
+ * without the structures set up properly.
+ */
+static void btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
+				    enum btrfs_list_filter_enum filter,
+				    u64 data)
+{
+	struct btrfs_list_filter_set *set = *filter_set;
+	int size;
+
+	ASSERT(set != NULL);
+	ASSERT(filter < BTRFS_LIST_FILTER_MAX);
+	ASSERT(set->nfilters <= set->total);
+
+	if (set->nfilters == set->total) {
+		void *tmp;
+
+		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
+		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
+		tmp = set;
+		set = realloc(set, size);
+		if (!set) {
+			fprintf(stderr, "memory allocation failed\n");
+			free(tmp);
+			exit(1);
+		}
+
+		memset(&set->filters[set->total], 0,
+		       BTRFS_LIST_NFILTERS_INCREASE *
+		       sizeof(struct btrfs_list_filter));
+		set->total += BTRFS_LIST_NFILTERS_INCREASE;
+		*filter_set = set;
+	}
+
+	ASSERT(set->filters[set->nfilters].filter_func == NULL);
+
+	if (filter == BTRFS_LIST_FILTER_DELETED) {
+		set->only_deleted = 1;
+	} else {
+		set->filters[set->nfilters].filter_func = all_filter_funcs[filter];
+		set->filters[set->nfilters].data = data;
+		set->nfilters++;
+	}
+}
+
+static int filters_match(struct listed_subvol *subvol,
+			 struct btrfs_list_filter_set *set)
+{
+	int i, ret;
+
+	if (!set)
+		return 1;
+
+	for (i = 0; i < set->nfilters; i++) {
+		if (!set->filters[i].filter_func)
+			break;
+		ret = set->filters[i].filter_func(subvol, set->filters[i].data);
+		if (!ret)
+			return 0;
+	}
+	return 1;
+}
+
+static void print_subvolume_column(struct listed_subvol *subvol,
+				   enum btrfs_list_column_enum column)
+{
+	char tstr[256];
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
+
+	ASSERT(0 <= column && column < BTRFS_LIST_ALL);
+
+	switch (column) {
+	case BTRFS_LIST_OBJECTID:
+		printf("%" PRIu64, subvol->info.id);
+		break;
+	case BTRFS_LIST_GENERATION:
+		printf("%" PRIu64, subvol->info.generation);
+		break;
+	case BTRFS_LIST_OGENERATION:
+		printf("%" PRIu64, subvol->info.otransid);
+		break;
+	case BTRFS_LIST_PARENT:
+	/*
+	 * Top level used to mean something else, but since 4f5ebb3ef553
+	 * ("Btrfs-progs: fix to make list specified directory's subvolumes
+	 * work") it was always set to the parent ID. See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html.
+	 */
+	case BTRFS_LIST_TOP_LEVEL:
+		printf("%" PRIu64, subvol->info.parent_id);
+		break;
+	case BTRFS_LIST_OTIME:
+		if (subvol->info.otime.tv_sec) {
+			struct tm tm;
+
+			localtime_r(&subvol->info.otime.tv_sec, &tm);
+			strftime(tstr, sizeof(tstr), "%Y-%m-%d %X", &tm);
+		} else
+			strcpy(tstr, "-");
+		printf("%s", tstr);
+		break;
+	case BTRFS_LIST_UUID:
+		if (uuid_is_null(subvol->info.uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_PUUID:
+		if (uuid_is_null(subvol->info.parent_uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.parent_uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_RUUID:
+		if (uuid_is_null(subvol->info.received_uuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subvol->info.received_uuid, uuidparse);
+		printf("%-36s", uuidparse);
+		break;
+	case BTRFS_LIST_PATH:
+		printf("%s", subvol->path);
+		break;
+	default:
+		break;
+	}
+}
+
+static void print_one_subvol_info_raw(struct listed_subvol *subvol,
+				      const char *raw_prefix)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		if (raw_prefix)
+			printf("%s",raw_prefix);
+
+		print_subvolume_column(subvol, i);
+	}
+	printf("\n");
+}
+
+static void print_one_subvol_info_table(struct listed_subvol *subvol)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		print_subvolume_column(subvol, i);
+
+		if (i != BTRFS_LIST_PATH)
+			printf("\t");
+
+		if (i == BTRFS_LIST_TOP_LEVEL)
+			printf("\t");
+	}
+	printf("\n");
+}
+
+static void print_one_subvol_info_default(struct listed_subvol *subvol)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (!btrfs_list_columns[i].need_print)
+			continue;
+
+		printf("%s ", btrfs_list_columns[i].name);
+		print_subvolume_column(subvol, i);
+
+		if (i != BTRFS_LIST_PATH)
+			printf(" ");
+	}
+	printf("\n");
+}
+
+static void print_all_subvol_info_tab_head(void)
+{
+	int i;
+	int len;
+	char barrier[20];
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		if (btrfs_list_columns[i].need_print)
+			printf("%s\t", btrfs_list_columns[i].name);
+
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++) {
+		memset(barrier, 0, sizeof(barrier));
+
+		if (btrfs_list_columns[i].need_print) {
+			len = strlen(btrfs_list_columns[i].name);
+			while (len--)
+				strcat(barrier, "-");
+
+			printf("%s\t", barrier);
+		}
+		if (i == BTRFS_LIST_ALL-1)
+			printf("\n");
+	}
+}
+
+static void print_all_subvol_info(struct subvol_list *subvols,
+				  enum btrfs_list_layout layout,
+				  const char *raw_prefix)
+{
+	size_t i;
+
+	if (layout == BTRFS_LIST_LAYOUT_TABLE)
+		print_all_subvol_info_tab_head();
+
+	for (i = 0; i < subvols->num; i++) {
+		struct listed_subvol *subvol = &subvols->subvols[i];
+
+		switch (layout) {
+		case BTRFS_LIST_LAYOUT_DEFAULT:
+			print_one_subvol_info_default(subvol);
+			break;
+		case BTRFS_LIST_LAYOUT_TABLE:
+			print_one_subvol_info_table(subvol);
+			break;
+		case BTRFS_LIST_LAYOUT_RAW:
+			print_one_subvol_info_raw(subvol, raw_prefix);
+			break;
+		}
+	}
+}
+
+static void free_subvol_list(struct subvol_list *subvols)
+{
+	size_t i;
+
+	if (subvols) {
+		for (i = 0; i < subvols->num; i++)
+			free(subvols->subvols[i].path);
+		free(subvols);
+	}
+}
+
+static struct subvol_list *btrfs_list_deleted_subvols(int fd,
+						      struct btrfs_list_filter_set *filter_set)
+{
+	struct subvol_list *subvols = NULL;
+	uint64_t *ids = NULL;
+	size_t i, n;
+	enum btrfs_util_error err;
+	int ret = -1;
+
+	err = btrfs_util_deleted_subvolumes_fd(fd, &ids, &n);
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
+		err = btrfs_util_subvolume_info_fd(fd, ids[i], &subvol->info);
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
+	if (ret) {
+		free_subvol_list(subvols);
+		subvols = NULL;
+		free(ids);
+	}
+	return subvols;
+}
+
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
+	err = btrfs_util_create_subvolume_iterator_fd(fd,
+						      BTRFS_FS_TREE_OBJECTID, 0,
+						      &iter);
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
+}
+
+static int btrfs_list_subvols_print(int fd,
+				    struct btrfs_list_filter_set *filter_set,
+				    struct btrfs_list_comparer_set *comp_set,
+				    enum btrfs_list_layout layout,
+				    int full_path, const char *raw_prefix)
+{
+	struct subvol_list *subvols;
+
+	/*
+	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
+	 * to make list specified directory's subvolumes work"). See
+	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
+	 */
+
+	if (filter_set->only_deleted)
+		subvols = btrfs_list_deleted_subvols(fd, filter_set);
+	else
+		subvols = btrfs_list_subvols(fd, filter_set);
+	if (!subvols)
+		return -1;
+
+	sort_subvols(comp_set, subvols);
+
+	print_all_subvol_info(subvols, layout, raw_prefix);
+
+	free_subvol_list(subvols);
+
+	return 0;
+}
+
+static int btrfs_list_parse_sort_string(char *opt_arg,
+					struct btrfs_list_comparer_set **comps)
+{
+	int order;
+	int flag;
+	char *p;
+	char **ptr_argv;
+	int what_to_sort;
+
+	while ((p = strtok(opt_arg, ",")) != NULL) {
+		flag = 0;
+		ptr_argv = all_sort_items;
+
+		while (*ptr_argv) {
+			if (strcmp(*ptr_argv, p) == 0) {
+				flag = 1;
+				break;
+			} else {
+				p++;
+				if (strcmp(*ptr_argv, p) == 0) {
+					flag = 1;
+					p--;
+					break;
+				}
+				p--;
+			}
+			ptr_argv++;
+		}
+
+		if (flag == 0)
+			return -1;
+
+		else {
+			if (*p == '+') {
+				order = 0;
+				p++;
+			} else if (*p == '-') {
+				order = 1;
+				p++;
+			} else
+				order = 0;
+
+			what_to_sort = btrfs_list_get_sort_item(p);
+			btrfs_list_setup_comparer(comps, what_to_sort, order);
+		}
+		opt_arg = NULL;
+	}
+
+	return 0;
+}
+
+static int btrfs_list_parse_filter_string(char *opt_arg,
+					  struct btrfs_list_filter_set **filters,
+					  enum btrfs_list_filter_enum type)
+{
+
+	u64 arg;
+
+	switch (*(opt_arg++)) {
+	case '+':
+		arg = arg_strtou64(opt_arg);
+		type += 2;
+
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	case '-':
+		arg = arg_strtou64(opt_arg);
+		type += 1;
+
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	default:
+		opt_arg--;
+		arg = arg_strtou64(opt_arg);
+
+		btrfs_list_setup_filter(filters, type, arg);
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * Naming of options:
  * - uppercase for filters and sort options
-- 
2.16.1

