Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab2IFKum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:50:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86AodXc019818
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:50:39 +0800
Message-ID: <50487FF1.1070204@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:50:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 6/7] Btrfs-progs: enhance btrfs subvol list only to show
 read-only snapshots
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

We want 'btrfs subvolume list' only to list readonly subvolumes, this patch set
introduces a new option 'r' to implement it.

You can use the command like that:

        btrfs subvolume list -r <path>

Original-Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v2 -> v3:
- re-implement this function based on the new list_subvols()

Changelog v1 -> v2:
- change the changelog of the patches and make them more elaborate
---
 btrfs-list.c     |   39 ++++++++++++++++++++++++++++-----------
 btrfs-list.h     |    1 +
 cmds-subvolume.c |   15 +++++++++++++--
 ctree.h          |    2 ++
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 38d7f9c..ce20593 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -57,6 +57,9 @@ struct root_info {
 	/* equal the offset of the root's key */
 	u64 root_offset;
 
+	/* flags of the root */
+	u64 flags;
+
 	/* the id of the root that references this one */
 	u64 ref_tree;
 
@@ -340,9 +343,9 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 }
 
 static int update_root(struct root_lookup *root_lookup,
-		       u64 root_id, u64 ref_tree, u64 root_offset, u64 dir_id,
-		       char *name, int name_len, u64 ogen, u64 gen, time_t ot,
-		       void *uuid)
+		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
+		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
+		       time_t ot, void *uuid)
 {
 	struct root_info *ri;
 
@@ -365,6 +368,8 @@ static int update_root(struct root_lookup *root_lookup,
 		ri->ref_tree = ref_tree;
 	if (root_offset)
 		ri->root_offset = root_offset;
+	if (flags)
+		ri->flags = flags;
 	if (dir_id)
 		ri->dir_id = dir_id;
 	if (gen)
@@ -396,15 +401,15 @@ static int update_root(struct root_lookup *root_lookup,
  * uuid: uuid of the root
  */
 static int add_root(struct root_lookup *root_lookup,
-		    u64 root_id, u64 ref_tree, u64 root_offset, u64 dir_id,
-		    char *name, int name_len, u64 ogen, u64 gen, time_t ot,
-		    void *uuid)
+		    u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
+		    u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
+		    time_t ot, void *uuid)
 {
 	struct root_info *ri;
 	int ret;
 
-	ret = update_root(root_lookup, root_id, ref_tree, root_offset, dir_id,
-			  name, name_len, ogen, gen, ot, uuid);
+	ret = update_root(root_lookup, root_id, ref_tree, root_offset, flags,
+			  dir_id, name, name_len, ogen, gen, ot, uuid);
 	if (!ret)
 		return 0;
 
@@ -431,6 +436,8 @@ static int add_root(struct root_lookup *root_lookup,
 		ri->dir_id = dir_id;
 	if (root_offset)
 		ri->root_offset = root_offset;
+	if (flags)
+		ri->flags = flags;
 	if (gen)
 		ri->gen = gen;
 	if (ogen)
@@ -907,6 +914,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	u64 dir_id;
 	u64 gen = 0;
 	u64 ogen;
+	u64 flags;
 	int i;
 	time_t t;
 	u8 uuid[BTRFS_UUID_SIZE];
@@ -962,11 +970,12 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh->objectid, sh->offset,
-					 0, dir_id, name, name_len, 0, 0, 0,
+					 0, 0, dir_id, name, name_len, 0, 0, 0,
 					 NULL);
 			} else if (sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
+				flags = btrfs_root_flags(ri);
 				if(sh->len == sizeof(struct btrfs_root_item)) {
 					t = ri->otime.sec;
 					ogen = btrfs_root_otransid(ri);
@@ -978,8 +987,8 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				}
 
 				add_root(root_lookup, sh->objectid, 0,
-					 sh->offset, 0, NULL, 0, ogen, gen, t,
-					 uuid);
+					 sh->offset, flags, 0, NULL, 0, ogen,
+					 gen, t, uuid);
 			}
 
 			off += sh->len;
@@ -1024,9 +1033,17 @@ static int filter_snapshot(struct root_info *ri, void *arg)
 	return !!ri->root_offset;
 }
 
+static int filter_flags(struct root_info *ri, void *arg)
+{
+	u64 flags = *((u64 *)arg);
+
+	return ri->flags & flags;
+}
+
 static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
 	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
+	[BTRFS_LIST_FILTER_FLAGS]		= filter_flags,
 };
 
 void btrfs_list_init_filters(struct btrfs_list_filter filters[], int nfilters)
diff --git a/btrfs-list.h b/btrfs-list.h
index 56d6a26..5eedfc3 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -47,6 +47,7 @@ enum btrfs_list_column_enum {
 enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_ROOTID,
 	BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
+	BTRFS_LIST_FILTER_FLAGS,
 	BTRFS_LIST_FILTER_MAX,
 };
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f29894c..19e7275 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -259,13 +259,14 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-pu] [-s 0|1] <path>",
+	"btrfs subvolume list [-pur] [-s 0|1] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p           print parent ID",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-s value     list snapshots with generation in ascending/descending order",
 	"             (1: ascending, 0: descending)",
+	"-r           list readonly subvolumes(including snapshots)",
 	NULL
 };
 
@@ -273,6 +274,7 @@ static int cmd_subvol_list(int argc, char **argv)
 {
 	struct btrfs_list_filter filters[BTRFS_LIST_FILTER_MAX];
 	struct btrfs_list_comparer comps[BTRFS_LIST_COMP_MAX];
+	u64 flags = 0;
 	int fd;
 	int ret;
 	int order;
@@ -284,7 +286,7 @@ static int cmd_subvol_list(int argc, char **argv)
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "ps:u");
+		int c = getopt(argc, argv, "ps:ur");
 		if (c < 0)
 			break;
 
@@ -307,11 +309,20 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'u':
 			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
 			break;
+		case 'r':
+			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
+			break;
 		default:
 			usage(cmd_subvol_list_usage);
 		}
 	}
 
+	if (flags)
+		btrfs_list_setup_filter(filters, BTRFS_LIST_FILTER_MAX,
+					filter_index++,
+					BTRFS_LIST_FILTER_FLAGS,
+					(void *)&flags);
+
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_list_usage);
 
diff --git a/ctree.h b/ctree.h
index 7f55229..ac31efe 100644
--- a/ctree.h
+++ b/ctree.h
@@ -139,6 +139,8 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 #define BTRFS_FT_XATTR		8
 #define BTRFS_FT_MAX		9
 
+#define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
  * block layout.  objectid corresonds to the inode number.  The flags
-- 
1.7.6.5
