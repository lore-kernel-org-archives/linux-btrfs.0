Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34969 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHLVFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 17:05:50 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1XHIbD-0005cg-Fe
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 20:23:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: Add -R to list UUIDs of original received subvolume
Date: Tue, 12 Aug 2014 21:22:52 +0100
Message-Id: <1407874973-24502-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using send/receive, it it useful to be able to match up source
subvols on the send side (as, say, for -p or -c clone sources) with their
corresponding copies on the receive side. This patch adds a -R option to
btrfs sub list to show the received subvolume UUID on the receive side,
allowing the user to perform that matching correctly.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs-list.c     | 32 +++++++++++++++++++++++++++-----
 btrfs-list.h     |  2 ++
 cmds-subvolume.c |  6 +++++-
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 542dfe0..01ccca9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -85,6 +85,11 @@ static struct {
 		.need_print	= 0,
 	},
 	{
+		.name		= "received_uuid",
+		.column_name	= "Received UUID",
+		.need_print	= 0,
+	},
+	{
 		.name		= "uuid",
 		.column_name	= "UUID",
 		.need_print	= 0,
@@ -391,7 +396,7 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 static int update_root(struct root_lookup *root_lookup,
 		       u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
 		       u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		       time_t ot, void *uuid, void *puuid)
+		       time_t ot, void *uuid, void *puuid, void *ruuid)
 {
 	struct root_info *ri;
 
@@ -429,6 +434,8 @@ static int update_root(struct root_lookup *root_lookup,
 		memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
 	if (puuid)
 		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
+	if (ruuid)
+		memcpy(&ri->ruuid, ruuid, BTRFS_UUID_SIZE);
 
 	return 0;
 }
@@ -447,17 +454,19 @@ static int update_root(struct root_lookup *root_lookup,
  * ot: the original time(create time) of the root
  * uuid: uuid of the root
  * puuid: uuid of the root parent if any
+ * ruuid: uuid of the received subvol, if any
  */
 static int add_root(struct root_lookup *root_lookup,
 		    u64 root_id, u64 ref_tree, u64 root_offset, u64 flags,
 		    u64 dir_id, char *name, int name_len, u64 ogen, u64 gen,
-		    time_t ot, void *uuid, void *puuid)
+		    time_t ot, void *uuid, void *puuid, void *ruuid)
 {
 	struct root_info *ri;
 	int ret;
 
 	ret = update_root(root_lookup, root_id, ref_tree, root_offset, flags,
-			  dir_id, name, name_len, ogen, gen, ot, uuid, puuid);
+			  dir_id, name, name_len, ogen, gen, ot,
+			  uuid, puuid, ruuid);
 	if (!ret)
 		return 0;
 
@@ -501,6 +510,9 @@ static int add_root(struct root_lookup *root_lookup,
 	if (puuid)
 		memcpy(&ri->puuid, puuid, BTRFS_UUID_SIZE);
 
+	if (ruuid)
+		memcpy(&ri->ruuid, ruuid, BTRFS_UUID_SIZE);
+
 	ret = root_tree_insert(root_lookup, ri);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
@@ -978,6 +990,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	time_t t;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 puuid[BTRFS_UUID_SIZE];
+	u8 ruuid[BTRFS_UUID_SIZE];
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -1030,7 +1043,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 				add_root(root_lookup, sh.objectid, sh.offset,
 					 0, 0, dir_id, name, name_len, 0, 0, 0,
-					 NULL, NULL);
+					 NULL, NULL, NULL);
 			} else if (sh.type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
@@ -1041,16 +1054,18 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
+					memcpy(ruuid, ri->received_uuid, BTRFS_UUID_SIZE);
 				} else {
 					t = 0;
 					ogen = 0;
 					memset(uuid, 0, BTRFS_UUID_SIZE);
 					memset(puuid, 0, BTRFS_UUID_SIZE);
+					memset(ruuid, 0, BTRFS_UUID_SIZE);
 				}
 
 				add_root(root_lookup, sh.objectid, 0,
 					 sh.offset, flags, 0, NULL, 0, ogen,
-					 gen, t, uuid, puuid);
+					 gen, t, uuid, puuid, ruuid);
 			}
 
 			off += sh.len;
@@ -1361,6 +1376,13 @@ static void print_subvolume_column(struct root_info *subv,
 			uuid_unparse(subv->puuid, uuidparse);
 		printf("%s", uuidparse);
 		break;
+	case BTRFS_LIST_RUUID:
+		if (uuid_is_null(subv->ruuid))
+			strcpy(uuidparse, "-");
+		else
+			uuid_unparse(subv->ruuid, uuidparse);
+		printf("%s", uuidparse);
+		break;
 	case BTRFS_LIST_PATH:
 		BUG_ON(!subv->full_path);
 		printf("%s", subv->full_path);
diff --git a/btrfs-list.h b/btrfs-list.h
index 8ead9da..ee2aea5 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -61,6 +61,7 @@ struct root_info {
 
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 puuid[BTRFS_UUID_SIZE];
+	u8 ruuid[BTRFS_UUID_SIZE];
 
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
@@ -110,6 +111,7 @@ enum btrfs_list_column_enum {
 	BTRFS_LIST_TOP_LEVEL,
 	BTRFS_LIST_OTIME,
 	BTRFS_LIST_PUUID,
+	BTRFS_LIST_RUUID,
 	BTRFS_LIST_UUID,
 	BTRFS_LIST_PATH,
 	BTRFS_LIST_ALL,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5e821c7..5216e53 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -393,6 +393,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-o           print only subvolumes bellow specified path",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-q           print the parent uuid of the snapshots",
+	"-R           print the uuid of the received snapshots",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -435,7 +436,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "acdgopqsurG:C:t", long_options, NULL);
+				    "acdgopqsurRG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -476,6 +477,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'q':
 			btrfs_list_setup_print_column(BTRFS_LIST_PUUID);
 			break;
+		case 'R':
+			btrfs_list_setup_print_column(BTRFS_LIST_RUUID);
+			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
-- 
2.0.1

