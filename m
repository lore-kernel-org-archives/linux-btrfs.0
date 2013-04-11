Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:28990 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab3DKQWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:22:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.26 OK)
	with ESMTP id p03acep3BCj0dN for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 18:22:08 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] Btrfs-progs: add more subvol fields to btrfs-list
Date: Thu, 11 Apr 2013 18:22:07 +0200
Message-Id: <97d6694fd9f0b7c14156934fc2215a50bb83a8bc.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The parent UUID, all generation values and all timestamps that
are available in the root_item are added.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c | 273 +++++++++++++++++++++++++++++++++++------------------------
 btrfs-list.h |  39 ++++++++-
 2 files changed, 197 insertions(+), 115 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 70da9a3..2d53290 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -68,6 +68,21 @@ static struct {
 		.width		= 6,
 	},
 	{
+		.name		= "ogen",
+		.column_name	= "OGen",
+		.width		= 6,
+	},
+	{
+		.name		= "sgen",
+		.column_name	= "SGen",
+		.width		= 6,
+	},
+	{
+		.name		= "rgen",
+		.column_name	= "RGen",
+		.width		= 6,
+	},
+	{
 		.name		= "parent",
 		.column_name	= "Parent",
 		.width		= 7,
@@ -78,13 +93,24 @@ static struct {
 		.width		= 10,
 	},
 	{
+		.name		= "ctime",
+		.column_name	= "CTime",
+		.width		= 21,
+	},
+	{
 		.name		= "otime",
 		.column_name	= "OTime",
 		.width		= 21,
 	},
 	{
-		.name		= "parent_uuid",
-		.column_name	= "Parent UUID",
+		.name		= "stime",
+		.column_name	= "STime",
+		.width		= 21,
+	},
+	{
+		.name		= "rtime",
+		.column_name	= "RTime",
+		.width		= 21,
 	},
 	{
 		.name		= "uuid",
@@ -92,6 +118,21 @@ static struct {
 		.width		= 38,
 	},
 	{
+		.name		= "puuid",
+		.column_name	= "PUUID",
+		.width		= 38,
+	},
+	{
+		.name		= "ruuid",
+		.column_name	= "RUUID",
+		.width		= 38,
+	},
+	{
+		.name		= "dirid",
+		.column_name	= "DirID",
+		.width		= 6,
+	},
+	{
 		.name		= "path",
 		.column_name	= "Path",
 		.width		= 0,
@@ -391,52 +432,70 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
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
+
+	if (ritem) {
+		rinfo->gen = btrfs_root_generation(ritem);
+		rinfo->flags = btrfs_root_flags(ritem);
+	}
 
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
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
@@ -446,66 +505,36 @@ static int update_root(struct root_lookup *root_lookup,
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
@@ -993,13 +1022,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
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
@@ -1051,28 +1074,11 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
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
@@ -1335,15 +1341,32 @@ static int print_subvolume_column(struct root_info *subv,
 	case BTRFS_LIST_GENERATION:
 		width = printf("%llu", subv->gen);
 		break;
+	case BTRFS_LIST_CGENERATION:
+		width = printf("%llu", subv->cgen);
+		break;
 	case BTRFS_LIST_OGENERATION:
 		width = printf("%llu", subv->ogen);
 		break;
+	case BTRFS_LIST_SGENERATION:
+		width = printf("%llu", subv->sgen);
+		break;
+	case BTRFS_LIST_RGENERATION:
+		width = printf("%llu", subv->rgen);
+		break;
 	case BTRFS_LIST_PARENT:
 		width = printf("%llu", subv->ref_tree);
 		break;
 	case BTRFS_LIST_TOP_LEVEL:
 		width = printf("%llu", subv->top_id);
 		break;
+	case BTRFS_LIST_CTIME:
+		if (subv->ctime)
+			strftime(tstr, 256, "%Y-%m-%d %X",
+				 localtime(&subv->ctime));
+		else
+			strcpy(tstr, "-");
+		width = printf("%s", tstr);
+		break;
 	case BTRFS_LIST_OTIME:
 		if (subv->otime)
 			strftime(tstr, 256, "%Y-%m-%d %X",
@@ -1352,6 +1375,22 @@ static int print_subvolume_column(struct root_info *subv,
 			strcpy(tstr, "-");
 		width = printf("%s", tstr);
 		break;
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
+		break;
 	case BTRFS_LIST_UUID:
 		if (uuid_is_null(subv->uuid))
 			strcpy(uuidparse, "-");
@@ -1359,6 +1398,13 @@ static int print_subvolume_column(struct root_info *subv,
 			uuid_unparse(subv->uuid, uuidparse);
 		width = printf("%s", uuidparse);
 		break;
+	case BTRFS_LIST_RUUID:
+		if (uuid_is_null(subv->ruuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subv->ruuid, uuidparse);
+		width = printf("%s", uuidparse);
+		break;
 	case BTRFS_LIST_PUUID:
 		if (uuid_is_null(subv->puuid))
 			strcpy(uuidparse, "-");
@@ -1370,6 +1416,9 @@ static int print_subvolume_column(struct root_info *subv,
 		BUG_ON(!subv->full_path);
 		width = printf("%s", subv->full_path);
 		break;
+	case BTRFS_LIST_DIRID:
+		width = printf("%llu", subv->dir_id);
+		break;
 	default:
 		width = 0;
 		break;
diff --git a/btrfs-list.h b/btrfs-list.h
index d3fd9e2..27be3b1 100644
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
-- 
1.8.2.1

