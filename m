Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:56257 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3DKOqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 10:46:21 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.26 OK)
	with ESMTP id 603adbp3BDAoco for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 16:46:18 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: enhance 'btrfs subvolume list'
Date: Thu, 11 Apr 2013 16:46:18 +0200
Message-Id: <d7e3915c875e3f6a597125ab577939aea956cef5.1365691027.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs subvolume list" gets a new option "--fields=..." which allows
to specify which pieces of information about subvolumes shall be
printed. This is necessary because this commit also adds all the so
far missing items from the root_item like the received UUID, all
generation values and all time values.

The parameters to the "--fields" option is a list of items to print:
--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,
  stime,rtime,path,rootid,parent,topid,all

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c     | 418 ++++++++++++++++++++++++++++++++++++-------------------
 btrfs-list.h     |  40 +++++-
 cmds-subvolume.c |  57 +++-----
 man/btrfs.8.in   |  19 +--
 4 files changed, 339 insertions(+), 195 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 1246a25..b0d8d13 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -50,62 +50,151 @@ struct {
 	char	*name;
 	char	*column_name;
 	int	need_print;
+	int	width;
 } btrfs_list_columns[] = {
 	{
 		.name		= "ID",
 		.column_name	= "ID",
 		.need_print	= 0,
+		.width		= 6,
 	},
 	{
 		.name		= "gen",
 		.column_name	= "Gen",
 		.need_print	= 0,
+		.width		= 6,
 	},
 	{
 		.name		= "cgen",
 		.column_name	= "CGen",
 		.need_print	= 0,
+		.width		= 6,
+	},
+	{
+		.name		= "ogen",
+		.column_name	= "OGen",
+		.need_print	= 0,
+		.width		= 6,
+	},
+	{
+		.name		= "sgen",
+		.column_name	= "SGen",
+		.need_print	= 0,
+		.width		= 6,
+	},
+	{
+		.name		= "rgen",
+		.column_name	= "RGen",
+		.need_print	= 0,
+		.width		= 6,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
 		.need_print	= 0,
+		.width		= 7,
 	},
 	{
 		.name		= "top level",
 		.column_name	= "Top Level",
 		.need_print	= 0,
+		.width		= 10,
+	},
+	{
+		.name		= "ctime",
+		.column_name	= "CTime",
+		.need_print	= 0,
+		.width		= 21,
 	},
 	{
 		.name		= "otime",
 		.column_name	= "OTime",
 		.need_print	= 0,
+		.width		= 21,
+	},
+	{
+		.name		= "stime",
+		.column_name	= "STime",
+		.need_print	= 0,
+		.width		= 21,
 	},
 	{
-		.name		= "parent_uuid",
-		.column_name	= "Parent UUID",
+		.name		= "rtime",
+		.column_name	= "RTime",
 		.need_print	= 0,
+		.width		= 21,
 	},
 	{
 		.name		= "uuid",
 		.column_name	= "UUID",
 		.need_print	= 0,
+		.width		= 38,
+	},
+	{
+		.name		= "puuid",
+		.column_name	= "PUUID",
+		.need_print	= 0,
+		.width		= 38,
+	},
+	{
+		.name		= "ruuid",
+		.column_name	= "RUUID",
+		.need_print	= 0,
+		.width		= 38,
+	},
+	{
+		.name		= "dirid",
+		.column_name	= "DirID",
+		.need_print	= 0,
+		.width		= 6,
 	},
 	{
 		.name		= "path",
 		.column_name	= "Path",
 		.need_print	= 0,
+		.width		= 0,
 	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
+		.width		= 0,
 	},
 };
 
+static char *all_field_items[] = {
+	[BTRFS_LIST_OBJECTID]		= "rootid",
+	[BTRFS_LIST_GENERATION]		= "gen",
+	[BTRFS_LIST_CGENERATION]	= "cgen",
+	[BTRFS_LIST_OGENERATION]	= "ogen",
+	[BTRFS_LIST_SGENERATION]	= "sgen",
+	[BTRFS_LIST_RGENERATION]	= "rgen",
+	[BTRFS_LIST_PARENT]		= "parent",
+	[BTRFS_LIST_TOP_LEVEL]		= "topid",
+	[BTRFS_LIST_CTIME]		= "ctime",
+	[BTRFS_LIST_OTIME]		= "otime",
+	[BTRFS_LIST_STIME]		= "stime",
+	[BTRFS_LIST_RTIME]		= "rtime",
+	[BTRFS_LIST_UUID]		= "uuid",
+	[BTRFS_LIST_PUUID]		= "puuid",
+	[BTRFS_LIST_RUUID]		= "ruuid",
+	[BTRFS_LIST_DIRID]		= "dirid",
+	[BTRFS_LIST_PATH]		= "path",
+	[BTRFS_LIST_ALL]		= "all",
+	[BTRFS_LIST_MAX]		= NULL,
+};
+
 static btrfs_list_filter_func all_filter_funcs[];
 static btrfs_list_comp_func all_comp_funcs[];
 
+void btrfs_list_clear_all_print_columns(void)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++)
+		btrfs_list_columns[i].need_print = 0;
+}
+
 void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
 {
 	int i;
@@ -216,6 +305,16 @@ static int  btrfs_list_get_sort_item(char *sort_name)
 	return -1;
 }
 
+static int btrfs_list_get_field_item(char *field_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_MAX; i++)
+		if (strcmp(field_name, all_field_items[i]) == 0)
+			return i;
+	return -1;
+}
+
 struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
 {
 	struct btrfs_list_comparer_set *set;
@@ -391,52 +490,70 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 	return NULL;
 }
 
-static int update_root(struct root_lookup *root_lookup,
-		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
-		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		       time_t ot, void *uuid, void *puuid)
+static int set_root_info(struct root_info *rinfo, u64 ref_tree, u64 root_offset,
+			 u64 dir_id, char *name, int name_len,
+			 struct btrfs_root_item *ritem, u32 ritem_len)
 {
-	struct root_info *ri;
+	int is_v0 = (ritem_len <= sizeof(struct btrfs_root_item_v0));
 
-	ri = root_tree_search(root_lookup, root_id);
-	if (!ri || ri->root_id != root_id)
-		return -ENOENT;
-	if (name && name_len > 0) {
-		if (ri->name)
-			free(ri->name);
+	if (root_offset)
+		rinfo->root_offset = root_offset;
+	if (ref_tree)
+		rinfo->ref_tree = ref_tree;
+	if (dir_id)
+		rinfo->dir_id = dir_id;
 
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
+	if (ritem) {
+		rinfo->gen = btrfs_root_generation(ritem);
+		rinfo->flags = btrfs_root_flags(ritem);
+	}
+
+	if (ritem && !is_v0) {
+		rinfo->cgen = btrfs_root_ctransid(ritem);
+		rinfo->ogen = btrfs_root_otransid(ritem);
+		rinfo->sgen = btrfs_root_stransid(ritem);
+		rinfo->rgen = btrfs_root_rtransid(ritem);
+		rinfo->ctime = btrfs_stack_timespec_sec(&ritem->ctime);
+		rinfo->otime = btrfs_stack_timespec_sec(&ritem->otime);
+		rinfo->stime = btrfs_stack_timespec_sec(&ritem->stime);
+		rinfo->rtime = btrfs_stack_timespec_sec(&ritem->rtime);
+		memcpy(rinfo->uuid, ritem->uuid, BTRFS_UUID_SIZE);
+		memcpy(rinfo->puuid, ritem->parent_uuid, BTRFS_UUID_SIZE);
+		memcpy(rinfo->ruuid, ritem->received_uuid, BTRFS_UUID_SIZE);
+	}
+
+	/* TODO: this is copied from the old code, what is it good for? */
+	if ((!ritem || !btrfs_root_otransid(ritem)) && root_offset)
+		rinfo->ogen = root_offset;
+
+	if (name && name_len > 0) {
+		rinfo->name = malloc(name_len + 1);
+		if (!rinfo->name) {
 			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
+			return -1;
 		}
-		strncpy(ri->name, name, name_len);
-		ri->name[name_len] = 0;
+		strncpy(rinfo->name, name, name_len);
+		rinfo->name[name_len] = 0;
 	}
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
-	if (ot)
-		ri->otime = ot;
-	if (uuid)
-		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-	if (puuid)
-		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
 
 	return 0;
 }
 
+static int update_root(struct root_lookup *root_lookup, u64 root_id,
+		       u64 ref_tree, u64 root_offset, u64 dir_id, char *name,
+		       int name_len, struct btrfs_root_item *ritem,
+		       u32 ritem_len)
+{
+	struct root_info *rinfo;
+
+	rinfo = root_tree_search(root_lookup, root_id);
+	if (!rinfo || rinfo->root_id != root_id)
+		return -ENOENT;
+
+	return set_root_info(rinfo, ref_tree, root_offset, dir_id, name,
+			     name_len, ritem, ritem_len);
+}
+
 /*
  * add_root - update the existed root, or allocate a new root and insert it
  *	      into the lookup tree.
@@ -446,66 +563,36 @@ static int update_root(struct root_lookup *root_lookup,
  * dir_id: inode id of the directory in ref_tree where this root can be found.
  * name: the name of root_id in that directory
  * name_len: the length of name
- * ogen: the original generation of the root
- * gen: the current generation of the root
- * ot: the original time(create time) of the root
- * uuid: uuid of the root
- * puuid: uuid of the root parent if any
+ * ritem: root_item
+ * ritem_len: root_item length
  */
-static int add_root(struct root_lookup *root_lookup,
-		    u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
-		    u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		    time_t ot, void *uuid, void *puuid)
+static int add_root(struct root_lookup *root_lookup, u64 root_id, u64 ref_tree,
+		    u64 root_offset, u64 dir_id, char *name, int name_len,
+		    struct btrfs_root_item *ritem, u32 ritem_len)
 {
-	struct root_info *ri;
+	struct root_info *rinfo;
 	int ret;
 
-	ret = update_root(root_lookup, root_id, ref_tree, root_offset, flags,
-			  dir_id, name, name_len, ogen, gen, ot, uuid, puuid);
+	ret = update_root(root_lookup, root_id, ref_tree, root_offset, dir_id,
+			  name, name_len, ritem, ritem_len);
 	if (!ret)
 		return 0;
 
-	ri = malloc(sizeof(*ri));
-	if (!ri) {
+	rinfo = malloc(sizeof(*rinfo));
+	if (!rinfo) {
 		printf("memory allocation failed\n");
 		exit(1);
 	}
-	memset(ri, 0, sizeof(*ri));
-	ri->root_id = root_id;
 
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
-	if (ot)
-		ri->otime = ot;
-
-	if (uuid)
-		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
-
-	if (puuid)
-		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
-
-	ret = root_tree_insert(root_lookup, ri);
+	memset(rinfo, 0, sizeof(*rinfo));
+	rinfo->root_id = root_id;
+
+	ret = set_root_info(rinfo, ref_tree, root_offset, dir_id, name,
+			    name_len, ritem, ritem_len);
+	if (ret)
+		exit(1);
+
+	ret = root_tree_insert(root_lookup, rinfo);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
 		exit(1);
@@ -993,13 +1080,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int name_len;
 	char *name;
 	u64 dir_id;
-	u64 gen = 0;
-	u64 ogen;
-	u64 flags;
 	int i;
-	time_t t;
-	u8 uuid[BTRFS_UUID_SIZE];
-	u8 puuid[BTRFS_UUID_SIZE];
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -1051,28 +1132,11 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh.objectid, sh.offset,
-					 0, 0, dir_id, name, name_len, 0, 0, 0,
-					 NULL, NULL);
+					 0, dir_id, name, name_len, NULL, 0);
 			} else if (sh.type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
-				gen = btrfs_root_generation(ri);
-				flags = btrfs_root_flags(ri);
-				if(sh.len >
-				   sizeof(struct btrfs_root_item_v0)) {
-					t = ri->otime.sec;
-					ogen = btrfs_root_otransid(ri);
-					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
-					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
-				} else {
-					t = 0;
-					ogen = 0;
-					memset(uuid, 0, BTRFS_UUID_SIZE);
-					memset(puuid, 0, BTRFS_UUID_SIZE);
-				}
-
 				add_root(root_lookup, sh.objectid, 0,
-					 sh.offset, flags, 0, NULL, 0, ogen,
-					 gen, t, uuid, puuid);
+					 sh.offset, 0, NULL, 0, ri, sh.len);
 			}
 
 			off += sh.len;
@@ -1319,29 +1383,47 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-static void print_subvolume_column(struct root_info *subv,
-				   enum btrfs_list_column_enum column)
+static int print_subvolume_column(struct root_info *subv,
+				  enum btrfs_list_column_enum column)
 {
 	char tstr[256];
 	char uuidparse[37];
+	int width;
 
 	BUG_ON(column >= BTRFS_LIST_ALL || column < 0);
 
 	switch (column) {
 	case BTRFS_LIST_OBJECTID:
-		printf("%llu", subv->root_id);
+		width = printf("%llu", subv->root_id);
 		break;
 	case BTRFS_LIST_GENERATION:
-		printf("%llu", subv->gen);
+		width = printf("%llu", subv->gen);
+		break;
+	case BTRFS_LIST_CGENERATION:
+		width = printf("%llu", subv->cgen);
 		break;
 	case BTRFS_LIST_OGENERATION:
-		printf("%llu", subv->ogen);
+		width = printf("%llu", subv->ogen);
+		break;
+	case BTRFS_LIST_SGENERATION:
+		width = printf("%llu", subv->sgen);
+		break;
+	case BTRFS_LIST_RGENERATION:
+		width = printf("%llu", subv->rgen);
 		break;
 	case BTRFS_LIST_PARENT:
-		printf("%llu", subv->ref_tree);
+		width = printf("%llu", subv->ref_tree);
 		break;
 	case BTRFS_LIST_TOP_LEVEL:
-		printf("%llu", subv->top_id);
+		width = printf("%llu", subv->top_id);
+		break;
+	case BTRFS_LIST_CTIME:
+		if (subv->ctime)
+			strftime(tstr, 256, "%Y-%m-%d %X",
+				 localtime(&subv->ctime));
+		else
+			strcpy(tstr, "-");
+		width = printf("%s", tstr);
 		break;
 	case BTRFS_LIST_OTIME:
 		if (subv->otime)
@@ -1349,29 +1431,60 @@ static void print_subvolume_column(struct root_info *subv,
 				 localtime(&subv->otime));
 		else
 			strcpy(tstr, "-");
-		printf("%s", tstr);
+		width = printf("%s", tstr);
+		break;
+	case BTRFS_LIST_STIME:
+		if (subv->stime)
+			strftime(tstr, 256, "%Y-%m-%d %X",
+				 localtime(&subv->stime));
+		else
+			strcpy(tstr, "-");
+		width = printf("%s", tstr);
+		break;
+	case BTRFS_LIST_RTIME:
+		if (subv->rtime)
+			strftime(tstr, 256, "%Y-%m-%d %X",
+				 localtime(&subv->rtime));
+		else
+			strcpy(tstr, "-");
+		width = printf("%s", tstr);
 		break;
 	case BTRFS_LIST_UUID:
 		if (uuid_is_null(subv->uuid))
 			strcpy(uuidparse, "-");
 		else
 			uuid_unparse(subv->uuid, uuidparse);
-		printf("%s", uuidparse);
+		width = printf("%s", uuidparse);
+		break;
+	case BTRFS_LIST_RUUID:
+		if (uuid_is_null(subv->ruuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subv->ruuid, uuidparse);
+		width = printf("%s", uuidparse);
 		break;
 	case BTRFS_LIST_PUUID:
 		if (uuid_is_null(subv->puuid))
 			strcpy(uuidparse, "-");
 		else
 			uuid_unparse(subv->puuid, uuidparse);
-		printf("%s", uuidparse);
+		width = printf("%s", uuidparse);
 		break;
 	case BTRFS_LIST_PATH:
 		BUG_ON(!subv->full_path);
-		printf("%s", subv->full_path);
+		width = printf("%s", subv->full_path);
+		break;
+	case BTRFS_LIST_DIRID:
+		width = printf("%llu", subv->dir_id);
 		break;
 	default:
+		width = 0;
 		break;
 	}
+
+	if (width < 0)
+		width = 0;
+	return width;
 }
 
 static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefix)
@@ -1393,18 +1506,15 @@ static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefi
 static void print_single_volume_info_table(struct root_info *subv)
 {
 	int i;
+	int width;
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
 		if (!btrfs_list_columns[i].need_print)
 			continue;
 
-		print_subvolume_column(subv, i);
-
-		if (i != BTRFS_LIST_PATH)
-			printf("\t");
-
-		if (i == BTRFS_LIST_TOP_LEVEL)
-			printf("\t");
+		width = print_subvolume_column(subv, i);
+		while (width++ < btrfs_list_columns[i].width)
+			printf(" ");
 	}
 	printf("\n");
 }
@@ -1420,7 +1530,7 @@ static void print_single_volume_info_default(struct root_info *subv)
 		printf("%s ", btrfs_list_columns[i].name);
 		print_subvolume_column(subv, i);
 
-		if (i != BTRFS_LIST_PATH)
+		if (i != BTRFS_LIST_ALL - 1)
 			printf(" ");
 	}
 	printf("\n");
@@ -1429,30 +1539,30 @@ static void print_single_volume_info_default(struct root_info *subv)
 static void print_all_volume_info_tab_head()
 {
 	int i;
-	int len;
-	char barrier[20];
+	int width;
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (btrfs_list_columns[i].need_print)
-			printf("%s\t", btrfs_list_columns[i].name);
+		if (!btrfs_list_columns[i].need_print)
+			continue;
 
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
+		width = printf("%s", btrfs_list_columns[i].column_name);
+		while (width++ < btrfs_list_columns[i].width)
+			printf(" ");
 	}
+	printf("\n");
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		memset(barrier, 0, sizeof(barrier));
-
 		if (btrfs_list_columns[i].need_print) {
-			len = strlen(btrfs_list_columns[i].name);
-			while (len--)
-				strcat(barrier, "-");
+			width = strlen(btrfs_list_columns[i].column_name);
+			while (width--)
+				printf("-");
 
-			printf("%s\t", barrier);
+			width = strlen(btrfs_list_columns[i].column_name);
+			while (width++ < btrfs_list_columns[i].width)
+				printf(" ");
 		}
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
 	}
+	printf("\n");
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
@@ -1845,6 +1955,24 @@ int btrfs_list_parse_sort_string(char *optarg,
 	return 0;
 }
 
+int btrfs_list_parse_fields_string(char *optarg)
+{
+	char *p;
+	int column;
+
+	btrfs_list_clear_all_print_columns();
+
+	while ((p = strtok(optarg, ",")) != NULL) {
+		column = btrfs_list_get_field_item(p);
+		if (column < 0)
+			return -1;
+		btrfs_list_setup_print_column(column);
+		optarg = NULL;
+	}
+
+	return 0;
+}
+
 /*
  * This function is used to parse the argument of filter condition.
  *
diff --git a/btrfs-list.h b/btrfs-list.h
index d3fd9e2..7e03948 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -53,15 +53,39 @@ struct root_info {
 	/* generation when the root is created or last updated */
 	u64 gen;
 
-	/* creation generation of this root in sec*/
+	/* updated when an inode changes */
+	u64 cgen;
+
+	/* creation generation of this root */
 	u64 ogen;
 
-	/* creation time of this root in sec*/
+	/* trans when sent. non-zero for received subvol */
+	u64 sgen;
+
+	/* trans when received. non-zero for received subvol */
+	u64 rgen;
+
+	/* time of last inode change in sec */
+	time_t ctime;
+
+	/* creation time of this root in sec */
 	time_t otime;
 
+	/* time in sec of send operation */
+	time_t stime;
+
+	/* time in sec of receive operation */
+	time_t rtime;
+
+	/* subvolume UUID */
 	u8 uuid[BTRFS_UUID_SIZE];
+
+	/* parent UUID */
 	u8 puuid[BTRFS_UUID_SIZE];
 
+	/* received UUID */
+	u8 ruuid[BTRFS_UUID_SIZE];
+
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
 	 */
@@ -102,14 +126,23 @@ struct btrfs_list_comparer_set {
 enum btrfs_list_column_enum {
 	BTRFS_LIST_OBJECTID,
 	BTRFS_LIST_GENERATION,
+	BTRFS_LIST_CGENERATION,
 	BTRFS_LIST_OGENERATION,
+	BTRFS_LIST_SGENERATION,
+	BTRFS_LIST_RGENERATION,
 	BTRFS_LIST_PARENT,
 	BTRFS_LIST_TOP_LEVEL,
+	BTRFS_LIST_CTIME,
 	BTRFS_LIST_OTIME,
-	BTRFS_LIST_PUUID,
+	BTRFS_LIST_STIME,
+	BTRFS_LIST_RTIME,
 	BTRFS_LIST_UUID,
+	BTRFS_LIST_PUUID,
+	BTRFS_LIST_RUUID,
+	BTRFS_LIST_DIRID,
 	BTRFS_LIST_PATH,
 	BTRFS_LIST_ALL,
+	BTRFS_LIST_MAX,
 };
 
 enum btrfs_list_filter_enum {
@@ -140,6 +173,7 @@ enum btrfs_list_comp_enum {
 
 int btrfs_list_parse_sort_string(char *optarg,
 				 struct btrfs_list_comparer_set **comps);
+int btrfs_list_parse_fields_string(char *optarg);
 int btrfs_list_parse_filter_string(char *optarg,
 				   struct btrfs_list_filter_set **filters,
 				   enum btrfs_list_filter_enum type);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e97297a..add655e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -282,19 +282,16 @@ out:
  * - lowercase for enabling specific items in the output
  */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-agopurts] [-G [+|-]value] [-C [+|-]value] "
-	"[--sort=gen,ogen,rootid,path] <path>",
+	"btrfs subvolume list [-roast] [-G [+|-]value] [-C [+|-]value] "
+	"[--sort=gen,ogen,rootid,path] "
+	"[--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,"
+	"otime,stime,rtime,path,rootid,parent,topid,all] <path>",
 	"List subvolumes (and snapshots)",
 	"",
-	"-p           print parent ID",
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
 	"             to the given <path>",
-	"-c           print the ogeneration of the subvolume",
-	"-g           print the generation of the subvolume",
 	"-o           print only subvolumes bellow specified path",
-	"-u           print the uuid of subvolumes (and snapshots)",
-	"-q           print the parent uuid of the snapshots",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -308,6 +305,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             list the subvolume in order of gen, ogen, rootid or path",
 	"             you also can add '+' or '-' in front of each items.",
 	"             (+:ascending, -:descending, ascending default)",
+	"--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,",
+	"         stime,rtime,path,rootid,parent,topid,all",
+	"             explicitly specify the fields to print",
 	NULL,
 };
 
@@ -326,32 +326,30 @@ static int cmd_subvol_list(int argc, char **argv)
 	int is_only_in_path = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
+		{"fields", 1, NULL, 'F'},
 		{0, 0, 0, 0}
 	};
 
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
 
+	/* by default we shall print the following columns*/
+	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
+	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
+	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "acgopqsurG:C:t", long_options, NULL);
+				    "roastG:C:", long_options, NULL);
 		if (c < 0)
 			break;
 
 		switch(c) {
-		case 'p':
-			btrfs_list_setup_print_column(BTRFS_LIST_PARENT);
-			break;
 		case 'a':
 			is_list_all = 1;
 			break;
-		case 'c':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			break;
-		case 'g':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-			break;
 		case 'o':
 			is_only_in_path = 1;
 			break;
@@ -362,20 +360,11 @@ static int cmd_subvol_list(int argc, char **argv)
 			btrfs_list_setup_filter(&filter_set,
 						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
 						0);
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
-			break;
-		case 'u':
-			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
-			break;
-		case 'q':
-			btrfs_list_setup_print_column(BTRFS_LIST_PUUID);
 			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
 		case 'G':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_GEN);
@@ -384,9 +373,7 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
-
 		case 'C':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_CGEN);
@@ -403,7 +390,13 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
-
+		case 'F':
+			ret = btrfs_list_parse_fields_string(optarg);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
+			break;
 		default:
 			uerr = 1;
 			goto out;
@@ -454,12 +447,6 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
-	/* by default we shall print the following columns*/
-	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
-	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
-	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
-
 	if (is_tab_result)
 		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
 				BTRFS_LIST_LAYOUT_TABLE,
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..d9af323 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-roast] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] [--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -130,7 +130,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fR
+\fBsubvolume list\fP\fI [-roast] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] [--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all] <path>\fP
 .RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -140,21 +140,13 @@ subvolume.
 
 The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
 at mount time via the \fIsubvolid=\fR option.
-If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
-and top level. The parent's ID may be used at mount time via the
-\fIsubvolrootid=\fR option.
+The parent's ID may be used at mount time via the \fIsubvolrootid=\fR option.
 
 \fB-t\fP print the result as a table.
 
 \fB-a\fP print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
 
-\fB-c\fP print the ogeneration of the subvolume, aliases: ogen or origin generation
-
-\fB-g\fP print the generation of the subvolume
-
-\fB-u\fP print the UUID of the subvolume
-
 \fB-o\fP print only subvolumes bellow specified <path>.
 
 \fB-r\fP only readonly subvolumes in the filesystem will be listed.
@@ -170,7 +162,10 @@ neither '+' nor '-', it means = value.
 list subvolumes in the filesystem that its ogeneration is
 >=, <= or = value. The usage is the same to '-g' option.
 
-\fB--sort=rootid,gen,ogen,path\fP
+\fB--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all\fP
+explicitly specify the fields to print.
+
+\fB--sort=gen,ogen,path,rootid\fP
 list subvolumes in order by specified items.
 you can add '+' or '-' in front of each items, '+' means ascending, '-'
 means descending. The default is ascending.
-- 
1.8.2.1

