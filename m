Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2FGXEE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:04 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/3] [PATCH] btrfs-progs: Basic support for extended inode refs
Date: Thu,  7 Jun 2012 16:00:54 -0700
Message-Id: <1339110056-21484-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
References: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This patch syncs the extended inode ref definitions from kernels ctree.h and
adds support in btrfs-debug-tree for visualizing the state of extended refs
on disk.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 ctree.h      |   27 ++++++++++++++++++++++++++-
 print-tree.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/ctree.h b/ctree.h
index 6545c50..ebf38fe 100644
--- a/ctree.h
+++ b/ctree.h
@@ -115,6 +115,13 @@ struct btrfs_trans_handle;
  */
 #define BTRFS_NAME_LEN 255
 
+/*
+ * Theoretical limit is larger, but we keep this down to a sane
+ * value. That should limit greatly the possibility of collisions on
+ * inode ref items.
+ */
+#define	BTRFS_LINK_MAX	65535U
+
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
 
@@ -412,6 +419,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
+
 /*
  * some patches floated around with a second compression method
  * lets save that incompat here for when they do get in
@@ -426,6 +434,7 @@ struct btrfs_super_block {
  */
 #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
 
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF   (1ULL << 6)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -434,7 +443,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
-	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -573,6 +583,13 @@ struct btrfs_inode_ref {
 	/* name goes here */
 } __attribute__ ((__packed__));
 
+struct btrfs_inode_extref {
+	__le64 parent_objectid;
+	__le64 index;
+	__le16 name_len;
+	__u8   name[0]; /* name goes here */
+} __attribute__ ((__packed__));
+
 struct btrfs_timespec {
 	__le64 sec;
 	__le32 nsec;
@@ -866,6 +883,7 @@ struct btrfs_root {
  */
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		12
+#define BTRFS_INODE_EXTREF_KEY		13
 #define BTRFS_XATTR_ITEM_KEY		24
 #define BTRFS_ORPHAN_ITEM_KEY		48
 
@@ -1145,6 +1163,13 @@ BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 
+/* struct btrfs_inode_extref */
+BTRFS_SETGET_FUNCS(inode_extref_parent, struct btrfs_inode_extref,
+		   parent_objectid, 64);
+BTRFS_SETGET_FUNCS(inode_extref_name_len, struct btrfs_inode_extref,
+		   name_len, 16);
+BTRFS_SETGET_FUNCS(inode_extref_index, struct btrfs_inode_extref, index, 64);
+
 /* struct btrfs_inode_item */
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_FUNCS(inode_sequence, struct btrfs_inode_item, sequence, 64);
diff --git a/print-tree.c b/print-tree.c
index fc134c0..6012df8 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -55,6 +55,42 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	return 0;
 }
 
+static int print_inode_extref_item(struct extent_buffer *eb,
+				   struct btrfs_item *item,
+				   struct btrfs_inode_extref *extref)
+{
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len = 0;
+	u64 index = 0;
+	u64 parent_objid;
+	char namebuf[BTRFS_NAME_LEN];
+
+	total = btrfs_item_size(eb, item);
+
+	while (cur < total) {
+		index = btrfs_inode_extref_index(eb, extref);
+		name_len = btrfs_inode_extref_name_len(eb, extref);
+		parent_objid = btrfs_inode_extref_parent(eb, extref);
+
+		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
+
+		read_extent_buffer(eb, namebuf, (unsigned long)(extref->name), len);
+
+		printf("\t\tinode extref index %llu parent %llu namelen %u "
+		       "name: %.*s\n",
+		       (unsigned long long)index,
+		       (unsigned long long)parent_objid,
+		       name_len, len, namebuf);
+
+		len = sizeof(*extref) + name_len;
+		extref = (struct btrfs_inode_extref *)((char *)extref + len);
+		cur += len;
+	}
+	return 0;
+}
+
 static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
 				struct btrfs_inode_ref *ref)
 {
@@ -285,6 +321,9 @@ static void print_key_type(u8 type)
 	case BTRFS_INODE_REF_KEY:
 		printf("INODE_REF");
 		break;
+	case BTRFS_INODE_EXTREF_KEY:
+		printf("INODE_EXTREF");
+		break;
 	case BTRFS_DIR_ITEM_KEY:
 		printf("DIR_ITEM");
 		break;
@@ -454,6 +493,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
 	struct btrfs_inode_ref *iref;
+	struct btrfs_inode_extref *iref2;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_root_item root_item;
@@ -492,6 +532,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			iref = btrfs_item_ptr(l, i, struct btrfs_inode_ref);
 			print_inode_ref_item(l, item, iref);
 			break;
+		case BTRFS_INODE_EXTREF_KEY:
+			iref2 = btrfs_item_ptr(l, i, struct btrfs_inode_extref);
+			print_inode_extref_item(l, item, iref2);
+			break;
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
 		case BTRFS_XATTR_ITEM_KEY:
-- 
1.7.7

