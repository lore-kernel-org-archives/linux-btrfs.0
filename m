Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32890 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3A1EEb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 23:04:31 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 03/10] Btrfs-progs: add parent uuid for snapshots
Date: Mon, 28 Jan 2013 12:10:21 +0800
Message-Id: <1359346228-24804-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359346228-24804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359346228-24804-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     | 34 ++++++++++++++++++++++++++++------
 btrfs-list.h     |  1 +
 cmds-subvolume.c |  6 +++++-
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b404e1d..13a365d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -80,6 +80,7 @@ struct root_info {
 	time_t otime;
 
 	u8 uuid[BTRFS_UUID_SIZE];
+	u8 puuid[BTRFS_UUID_SIZE];
 
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
@@ -128,6 +129,11 @@ struct {
 		.need_print	= 0,
 	},
 	{
+		.name		= "parent_uuid",
+		.column_name	= "Parent UUID",
+		.need_print	= 0,
+	},
+	{
 		.name		= "uuid",
 		.column_name	= "UUID",
 		.need_print	= 0,
@@ -435,7 +441,7 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 static int update_root(struct root_lookup *root_lookup,
 		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
 		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		       time_t ot, void *uuid)
+		       time_t ot, void *uuid, void *puuid)
 {
 	struct root_info *ri;
 
@@ -472,6 +478,8 @@ static int update_root(struct root_lookup *root_lookup,
 		ri->otime = ot;
 	if (uuid)
 		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
+	if (puuid)
+		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
 
 	return 0;
 }
@@ -489,17 +497,18 @@ static int update_root(struct root_lookup *root_lookup,
  * gen: the current generation of the root
  * ot: the original time(create time) of the root
  * uuid: uuid of the root
+ * puuid: uuid of the root parent if any
  */
 static int add_root(struct root_lookup *root_lookup,
 		    u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
 		    u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		    time_t ot, void *uuid)
+		    time_t ot, void *uuid, void *puuid)
 {
 	struct root_info *ri;
 	int ret;
 
 	ret = update_root(root_lookup, root_id, ref_tree, root_offset, flags,
-			  dir_id, name, name_len, ogen, gen, ot, uuid);
+			  dir_id, name, name_len, ogen, gen, ot, uuid, puuid);
 	if (!ret)
 		return 0;
 
@@ -537,9 +546,12 @@ static int add_root(struct root_lookup *root_lookup,
 	if (ot)
 		ri->otime = ot;
 
-	if (uuid) 
+	if (uuid)
 		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
 
+	if (puuid)
+		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
+
 	ret = root_tree_insert(root_lookup, ri);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
@@ -1021,6 +1033,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int i;
 	time_t t;
 	u8 uuid[BTRFS_UUID_SIZE];
+	u8 puuid[BTRFS_UUID_SIZE];
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -1073,7 +1086,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 				add_root(root_lookup, sh.objectid, sh.offset,
 					 0, 0, dir_id, name, name_len, 0, 0, 0,
-					 NULL);
+					 NULL, NULL);
 			} else if (sh.type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
@@ -1083,15 +1096,17 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 					t = ri->otime.sec;
 					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
+					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
 				} else {
 					t = 0;
 					ogen = 0;
 					memset(uuid, 0, BTRFS_UUID_SIZE);
+					memset(puuid, 0, BTRFS_UUID_SIZE);
 				}
 
 				add_root(root_lookup, sh.objectid, 0,
 					 sh.offset, flags, 0, NULL, 0, ogen,
-					 gen, t, uuid);
+					 gen, t, uuid, puuid);
 			}
 
 			off += sh.len;
@@ -1345,6 +1360,13 @@ static void print_subvolume_column(struct root_info *subv,
 			uuid_unparse(subv->uuid, uuidparse);
 		printf("%s", uuidparse);
 		break;
+	case BTRFS_LIST_PUUID:
+		if (uuid_is_null(subv->puuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subv->puuid, uuidparse);
+		printf("%s", uuidparse);
+		break;
 	case BTRFS_LIST_PATH:
 		BUG_ON(!subv->full_path);
 		printf("%s", subv->full_path);
diff --git a/btrfs-list.h b/btrfs-list.h
index 71fe0f3..855e73d 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -53,6 +53,7 @@ enum btrfs_list_column_enum {
 	BTRFS_LIST_PARENT,
 	BTRFS_LIST_TOP_LEVEL,
 	BTRFS_LIST_OTIME,
+	BTRFS_LIST_PUUID,
 	BTRFS_LIST_UUID,
 	BTRFS_LIST_PATH,
 	BTRFS_LIST_ALL,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c35dff7..a1e6893 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -280,6 +280,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-p           print parent ID",
 	"-a           print all the subvolumes in the filesystem.",
 	"-u           print the uuid of subvolumes (and snapshots)",
+	"-q           print the parent uuid of the snapshots",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -319,7 +320,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "apsurg:c:t", long_options, NULL);
+				    "apsuqrg:c:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -343,6 +344,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'u':
 			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
 			break;
+		case 'q':
+			btrfs_list_setup_print_column(BTRFS_LIST_PUUID);
+			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
-- 
1.8.1.227.g44fe835

