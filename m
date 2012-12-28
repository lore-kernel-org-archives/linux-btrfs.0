Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2L1DGz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:55 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36sqV021085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:54 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36r3g013284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:54 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36rEI023091
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:53 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] Btrfs-progs: add parent uuid for snapshots
Date: Fri, 28 Dec 2012 11:12:57 +0800
Message-Id: <1356664382-24423-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   32 +++++++++++++++++++++++++++-----
 btrfs-list.h     |    1 +
 cmds-subvolume.c |    6 +++++-
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b656286..cc065e9 100644
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
+		.name		= "parent UUID",
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
 
@@ -540,6 +549,9 @@ static int add_root(struct root_lookup *root_lookup,
 	if (uuid) 
 		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
 
+	if (puuid)
+		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
+
 	ret = root_tree_insert(root_lookup, ri);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
@@ -1022,6 +1034,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	int i;
 	time_t t;
 	u8 uuid[BTRFS_UUID_SIZE];
+	u8 puuid[BTRFS_UUID_SIZE];
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -1075,7 +1088,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 				add_root(root_lookup, sh->objectid, sh->offset,
 					 0, 0, dir_id, name, name_len, 0, 0, 0,
-					 NULL);
+					 NULL, NULL);
 			} else if (sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
@@ -1085,15 +1098,17 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
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
 
 				add_root(root_lookup, sh->objectid, 0,
 					 sh->offset, flags, 0, NULL, 0, ogen,
-					 gen, t, uuid);
+					 gen, t, uuid, puuid);
 			}
 
 			off += sh->len;
@@ -1347,6 +1362,13 @@ static void print_subvolume_column(struct root_info *subv,
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
index c35dff7..ee36463 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -280,6 +280,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-p           print parent ID",
 	"-a           print all the subvolumes in the filesystem.",
 	"-u           print the uuid of subvolumes (and snapshots)",
+	"-q           print the parent uuid of snapshots",
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
1.7.1

