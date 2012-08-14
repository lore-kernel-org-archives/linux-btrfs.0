Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34698 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2HNGDQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 02:03:16 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7E63EXW017423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 06:03:15 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7E63DYI014587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 06:03:13 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7E63DSF029499
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 01:03:13 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] add -u to show subvol uuid
Date: Tue, 14 Aug 2012 14:04:06 +0800
Message-Id: <1344924246-24192-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1344924246-24192-1-git-send-email-Anand.Jain@oracle.com>
References: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
 <1344924246-24192-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Applications would need to know the uuid to manage the configurations
associated with the subvol and snapshots

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |  148 ++++++++++++++++++++++++++++++++++++++++++------------
 cmds-subvolume.c |   14 +++--
 2 files changed, 124 insertions(+), 38 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 6e83b31..d6b22a1 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,7 @@
 #include "ctree.h"
 #include "transaction.h"
 #include "utils.h"
+#include <uuid/uuid.h>
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
@@ -63,6 +64,8 @@ struct root_info {
 	/* creation time of this root in sec*/
 	time_t otime;
 
+	u8 uuid[BTRFS_UUID_SIZE];
+
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
 	 */
@@ -188,7 +191,7 @@ static struct root_info *tree_search(struct rb_root *root, u64 root_id)
  */
 static int add_root(struct root_lookup *root_lookup,
 		    u64 root_id, u64 ref_tree, u64 dir_id, char *name,
-		    int name_len, u64 *gen, time_t ot)
+		    int name_len, u64 *gen, time_t ot, void *uuid)
 {
 	struct root_info *ri;
 	struct rb_node *ret;
@@ -210,6 +213,11 @@ static int add_root(struct root_lookup *root_lookup,
 		ri->gen = *gen;
 	ri->otime = ot;
 
+	if (uuid) 
+		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
+	else
+		memset(&ri->uuid, 0, BTRFS_UUID_SIZE);
+
 	ret = tree_insert(&root_lookup->root, root_id, ref_tree, gen,
 			  &ri->rb_node);
 	if (ret) {
@@ -220,7 +228,7 @@ static int add_root(struct root_lookup *root_lookup,
 }
 
 static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen,
-			time_t ot)
+			time_t ot, void *uuid)
 {
 	struct root_info *ri;
 
@@ -231,6 +239,11 @@ static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen,
 	}
 	ri->gen = gen;
 	ri->otime = ot;
+	if (uuid)
+		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
+	else
+		memset(&ri->uuid, 0, BTRFS_UUID_SIZE);
+
 	return 0;
 }
 
@@ -665,6 +678,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int i;
 	int get_gen = 0;
 	time_t t;
+	u8 uuid[BTRFS_UUID_SIZE];
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -718,16 +732,20 @@ again:
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh->objectid, sh->offset,
-					 dir_id, name, name_len, NULL, 0);
+					 dir_id, name, name_len, NULL, 0, NULL);
 			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
-				if(ri->generation == ri->generation_v2)
+				if(ri->generation == ri->generation_v2) {
 					t = ri->otime.sec;
-				else
+					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
+				} else {
 					t = 0;
+					memset(uuid, 0, BTRFS_UUID_SIZE);
+				}
 
-				update_root(root_lookup, sh->objectid, gen, t);
+				update_root(root_lookup, sh->objectid, gen, t,
+					uuid);
 			}
 
 			off += sh->len;
@@ -818,19 +836,24 @@ static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
 		for (i = 0; i < sk->nr_items; i++) {
 			struct btrfs_root_item *item;
 			time_t  t;
+			u8 uuid[BTRFS_UUID_SIZE];
+
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
 			off += sizeof(*sh);
 			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
 				item = (struct btrfs_root_item *)(args.buf + off);
-				if(item->generation == item->generation_v2)
+				if(item->generation == item->generation_v2) {
 					t = item->otime.sec;
-				else
+					memcpy(uuid, item->uuid, BTRFS_UUID_SIZE);
+				} else {
 					t = 0;
+					memset(uuid, 0, BTRFS_UUID_SIZE);
+				}
 				gen = sh->offset;
 
 				add_root(root_lookup, sh->objectid, 0,
-					 0, NULL, 0, &gen, t);
+					 0, NULL, 0, &gen, t, uuid);
 			}
 			off += sh->len;
 
@@ -877,12 +900,13 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent, int get_default)
+int list_subvols(int fd, int print_parent, int get_default, int print_uuid)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
 	u64 default_id;
 	int ret;
+	char uuidparse[37];
 
 	if (get_default) {
 		ret = get_default_subvolid(fd, &default_id);
@@ -937,16 +961,44 @@ int list_subvols(int fd, int print_parent, int get_default)
 
 		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
 		if (print_parent) {
-			printf("ID %llu gen %llu parent %llu top level %llu path %s\n",
-				(unsigned long long)entry->root_id,
-				(unsigned long long)entry->gen,
-				(unsigned long long)parent_id,
-				(unsigned long long)level, path);
+			if (print_uuid) {
+				if (uuid_is_null(entry->uuid))
+					strcpy(uuidparse, "-");
+				else
+					uuid_unparse(entry->uuid, uuidparse);
+				printf("ID %llu gen %llu parent %llu top level %llu"
+					" uuid %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)parent_id,
+					(unsigned long long)level,
+					uuidparse, path);
+			} else {
+				printf("ID %llu gen %llu parent %llu top level"
+					" %llu path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)parent_id,
+					(unsigned long long)level, path);
+			}
 		} else {
-			printf("ID %llu gen %llu top level %llu path %s\n",
-				(unsigned long long)entry->root_id,
-				(unsigned long long)entry->gen,
-				(unsigned long long)level, path);
+			if (print_uuid) {
+				if (uuid_is_null(entry->uuid))
+					strcpy(uuidparse, "-");
+				else
+					uuid_unparse(entry->uuid, uuidparse);
+				printf("ID %llu gen %llu top level %llu"
+					" uuid %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)level,
+					uuidparse, path);
+			} else {
+				printf("ID %llu gen %llu top level %llu path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)level, path);
+			}
 		}
 
 		free(path);
@@ -956,7 +1008,7 @@ int list_subvols(int fd, int print_parent, int get_default)
 	return ret;
 }
 
-int list_snapshots(int fd, int print_parent, int order)
+int list_snapshots(int fd, int print_parent, int order, int print_uuid)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_lookup_snap;
@@ -1001,6 +1053,7 @@ int list_snapshots(int fd, int print_parent, int order)
 		char *path;
 		time_t t;
 		char tstr[256];
+		char uuidparse[37];
 
 		entry_snap = rb_entry(n, struct root_info, rb_node);
 		entry = tree_search(&root_lookup.root, entry_snap->root_id);
@@ -1012,20 +1065,49 @@ int list_snapshots(int fd, int print_parent, int order)
 		else
 			strcpy(tstr,"-");
 		if (print_parent) {
-			printf("ID %llu gen %llu cgen %llu parent %llu top level %llu "
-				"otime %s path %s\n",
-				(unsigned long long)entry->root_id,
-				(unsigned long long)entry->gen,
-				(unsigned long long)entry_snap->gen,
-				(unsigned long long)parent_id,
-				(unsigned long long)level, tstr, path);
+			if (print_uuid) {
+				if (uuid_is_null(entry->uuid))
+					strcpy(uuidparse, "-");
+				else
+					uuid_unparse(entry->uuid, uuidparse);
+				printf("ID %llu gen %llu cgen %llu parent %llu"
+					" top level %llu otime %s uuid %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)entry_snap->gen,
+					(unsigned long long)parent_id,
+					(unsigned long long)level,
+					tstr, uuidparse, path);
+			} else {
+				printf("ID %llu gen %llu cgen %llu parent %llu"
+					" top level %llu otime %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)entry_snap->gen,
+					(unsigned long long)parent_id,
+					(unsigned long long)level, tstr, path);
+			}
 		} else {
-			printf("ID %llu gen %llu cgen %llu top level %llu "
-				"otime %s path %s\n",
-				(unsigned long long)entry->root_id,
-				(unsigned long long)entry->gen,
-				(unsigned long long)entry_snap->gen,
-				(unsigned long long)level, tstr, path);
+			if (print_uuid) {
+				if (uuid_is_null(entry->uuid))
+					strcpy(uuidparse, "-");
+				else
+					uuid_unparse(entry->uuid, uuidparse);
+				printf("ID %llu gen %llu cgen %llu top level %llu "
+					"otime %s uuid %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)entry_snap->gen,
+					(unsigned long long)level,
+					tstr, uuidparse, path);
+			} else {
+				printf("ID %llu gen %llu cgen %llu top level %llu "
+					"otime %s path %s\n",
+					(unsigned long long)entry->root_id,
+					(unsigned long long)entry->gen,
+					(unsigned long long)entry_snap->gen,
+					(unsigned long long)level, tstr, path);
+			}
 		}
 
 		free(path);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 9c75b47..dea8f43 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -30,7 +30,7 @@
 #include "commands.h"
 
 /* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int get_default);
+int list_subvols(int fd, int print_parent, int print_uuid, int get_default);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 
 static const char * const subvolume_cmd_group_usage[] = {
@@ -236,10 +236,11 @@ static int cmd_subvol_list(int argc, char **argv)
 	int print_snap_only = 0;
 	int order = 0;
 	char *subvol;
+	int print_uuid = 0;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "ps:");
+		int c = getopt(argc, argv, "ps:u");
 		if (c < 0)
 			break;
 
@@ -251,6 +252,9 @@ static int cmd_subvol_list(int argc, char **argv)
 			print_snap_only = 1;
 			order = atoi(optarg);
 			break;
+		case 'u':
+			print_uuid =1;
+			break;
 		default:
 			usage(cmd_subvol_list_usage);
 		}
@@ -277,9 +281,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		return 12;
 	}
 	if (!print_snap_only)
-		ret = list_subvols(fd, print_parent, 0);
+		ret = list_subvols(fd, print_parent, 0, print_uuid);
 	else
-		ret = list_snapshots(fd, print_parent, order);
+		ret = list_snapshots(fd, print_parent, order, print_uuid);
 	if (ret)
 		return 19;
 	return 0;
@@ -439,7 +443,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1);
+	ret = list_subvols(fd, 0, 1, 0);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

