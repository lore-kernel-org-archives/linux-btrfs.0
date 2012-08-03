Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46559 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2HCJv1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:27 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 1/9] Update ctree.h and ioctl.h for the new uuid+times for subvolumes.
Date: Fri,  3 Aug 2012 17:48:50 +0800
Message-Id: <1343987338-10612-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Alexander Block <ablock84@googlemail.com>


Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 ctree.h      |   40 ++++++++++++++++++++++++++++-
 ioctl.h      |   12 +++++++++
 print-tree.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 112 insertions(+), 19 deletions(-)

diff --git a/ctree.h b/ctree.h
index 254fb0b..07691c7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -642,6 +642,35 @@ struct btrfs_root_item {
 	struct btrfs_disk_key drop_progress;
 	u8 drop_level;
 	u8 level;
+
+	/*
+	 * The following fields appear after subvol_uuids+subvol_times
+	 * were introduced.
+	 */
+
+	/*
+	 * This generation number is used to test if the new fields are valid
+	 * and up to date while reading the root item. Everytime the root item
+	 * is written out, the "generation" field is copied into this field. If
+	 * anyone ever mounted the fs with an older kernel, we will have
+	 * mismatching generation values here and thus must invalidate the
+	 * new fields. See btrfs_update_root and btrfs_find_last_root for
+	 * details.
+	 * the offset of generation_v2 is also used as the start for the memset
+	 * when invalidating the fields.
+	 */
+	__le64 generation_v2;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u8 parent_uuid[BTRFS_UUID_SIZE];
+	u8 received_uuid[BTRFS_UUID_SIZE];
+	__le64 ctransid; /* updated when an inode changes */
+	__le64 otransid; /* trans when created */
+	__le64 stransid; /* trans when sent. non-zero for received subvol */
+	__le64 rtransid; /* trans when received. non-zero for received subvol */
+	struct btrfs_timespec ctime;
+	struct btrfs_timespec otime;
+	struct btrfs_timespec stime;
+	struct btrfs_timespec rtime;
 } __attribute__ ((__packed__));
 
 /*
@@ -1607,7 +1636,16 @@ BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
-
+BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
+			 generation_v2, 64);
+BTRFS_SETGET_STACK_FUNCS(root_ctransid, struct btrfs_root_item,
+			 ctransid, 64);
+BTRFS_SETGET_STACK_FUNCS(root_otransid, struct btrfs_root_item,
+			 otransid, 64);
+BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
+			 stransid, 64);
+BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
+			 rtransid, 64);
 
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..6b9a49c 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -20,6 +20,7 @@
 #define __IOCTL_
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include <time.h>
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
@@ -272,6 +273,15 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+struct btrfs_ioctl_received_subvol_args {
+	char	uuid[BTRFS_UUID_SIZE];	/* in */
+	__u64	stransid;		/* in */
+	__u64	rtransid;		/* out */
+	struct timespec stime;		/* in */
+	struct timespec rtime;		/* out */
+	__u64	reserved[16];
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -331,4 +341,6 @@ struct btrfs_ioctl_logical_ino_args {
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
 
+#define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
+				struct btrfs_ioctl_received_subvol_args)
 #endif
diff --git a/print-tree.c b/print-tree.c
index fc134c0..67c8982 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -276,6 +276,66 @@ static void print_root_ref(struct extent_buffer *leaf, int slot, char *tag)
 	       namelen, namebuf);
 }
 
+static int count_bytes(void *buf, int len, char b)
+{
+	int cnt = 0;
+	int i;
+	for (i = 0; i < len; i++) {
+		if (((char*)buf)[i] == b)
+			cnt++;
+	}
+	return cnt;
+}
+
+static void print_root(struct extent_buffer *leaf, int slot)
+{
+	struct btrfs_root_item *ri;
+	struct btrfs_root_item root_item;
+	int len;
+	char uuid_str[128];
+
+	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
+	len = btrfs_item_size_nr(leaf, slot);
+
+	memset(&root_item, 0, sizeof(root_item));
+	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
+
+	printf("\t\troot data bytenr %llu level %d dirid %llu refs %u gen %llu\n",
+		(unsigned long long)btrfs_root_bytenr(&root_item),
+		btrfs_root_level(&root_item),
+		(unsigned long long)btrfs_root_dirid(&root_item),
+		btrfs_root_refs(&root_item),
+		(unsigned long long)btrfs_root_generation(&root_item));
+
+	if (root_item.generation == root_item.generation_v2) {
+		uuid_unparse(root_item.uuid, uuid_str);
+		printf("\t\tuuid %s\n", uuid_str);
+		if (count_bytes(root_item.parent_uuid, BTRFS_UUID_SIZE, 0) != BTRFS_UUID_SIZE) {
+			uuid_unparse(root_item.parent_uuid, uuid_str);
+			printf("\t\tparent_uuid %s\n", uuid_str);
+		}
+		if (count_bytes(root_item.received_uuid, BTRFS_UUID_SIZE, 0) != BTRFS_UUID_SIZE) {
+			uuid_unparse(root_item.received_uuid, uuid_str);
+			printf("\t\treceived_uuid %s\n", uuid_str);
+		}
+		if (root_item.ctransid) {
+			printf("\t\tctransid %llu otransid %llu stransid %llu rtransid %llu\n",
+				btrfs_root_ctransid(&root_item),
+				btrfs_root_otransid(&root_item),
+				btrfs_root_stransid(&root_item),
+				btrfs_root_rtransid(&root_item));
+		}
+	}
+	if (btrfs_root_refs(&root_item) == 0) {
+		struct btrfs_key drop_key;
+		btrfs_disk_key_to_cpu(&drop_key,
+				      &root_item.drop_progress);
+		printf("\t\tdrop ");
+		btrfs_print_key(&root_item.drop_progress);
+		printf(" level %d\n", root_item.drop_level);
+	}
+}
+
 static void print_key_type(u8 type)
 {
 	switch (type) {
@@ -446,7 +506,6 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	int i;
 	char *str;
 	struct btrfs_item *item;
-	struct btrfs_root_item *ri;
 	struct btrfs_dir_item *di;
 	struct btrfs_inode_item *ii;
 	struct btrfs_file_extent_item *fi;
@@ -456,7 +515,6 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_inode_ref *iref;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_disk_key disk_key;
-	struct btrfs_root_item root_item;
 	struct btrfs_block_group_item bg_item;
 	struct btrfs_dir_log_item *dlog;
 	u32 nr = btrfs_header_nritems(l);
@@ -508,22 +566,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			printf("\t\torphan item\n");
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
-			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
-			read_extent_buffer(l, &root_item, (unsigned long)ri, sizeof(root_item));
-			printf("\t\troot data bytenr %llu level %d dirid %llu refs %u gen %llu\n",
-				(unsigned long long)btrfs_root_bytenr(&root_item),
-				btrfs_root_level(&root_item),
-				(unsigned long long)btrfs_root_dirid(&root_item),
-				btrfs_root_refs(&root_item),
-				(unsigned long long)btrfs_root_generation(&root_item));
-			if (btrfs_root_refs(&root_item) == 0) {
-				struct btrfs_key drop_key;
-				btrfs_disk_key_to_cpu(&drop_key,
-						      &root_item.drop_progress);
-				printf("\t\tdrop ");
-				btrfs_print_key(&root_item.drop_progress);
-				printf(" level %d\n", root_item.drop_level);
-			}
+			print_root(l, i);
 			break;
 		case BTRFS_ROOT_REF_KEY:
 			print_root_ref(l, i, "ref");
-- 
1.7.1

