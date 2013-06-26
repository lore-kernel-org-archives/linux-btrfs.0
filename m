Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:57148 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3FZPSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:18:00 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.28 OK)
	with ESMTP id g011bfp5PIqX0G for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Jun 2013 17:17:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/5] Btrfs-progs: Support UUID tree and UUID items in btrfs-debug-tree
Date: Wed, 26 Jun 2013 17:17:55 +0200
Message-Id: <77b49265b89b9c37e6f806c8513d9226306e217d.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Support printing these things.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 ctree.h      | 15 +++++++++++++++
 print-tree.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3fe14b0..f959573 100644
--- a/ctree.h
+++ b/ctree.h
@@ -71,6 +71,8 @@ struct btrfs_free_space_ctl;
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
+/* for storing items that use the BTRFS_UUID_KEY* */
+#define BTRFS_UUID_TREE_OBJECTID 9ULL
 
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
@@ -1107,6 +1109,19 @@ struct btrfs_root {
 #define BTRFS_DEV_REPLACE_KEY	250
 
 /*
+ * Stores items that allow to quickly map UUIDs to something else.
+ * These items are part of the filesystem UUID tree.
+ * The key is built like this:
+ * (UUID_upper_64_bits, BTRFS_UUID_KEY*, UUID_lower_64_bits).
+ */
+#if BTRFS_UUID_SIZE != 16
+#error "UUID items require BTRFS_UUID_SIZE == 16!"
+#endif
+#define BTRFS_UUID_KEY_SUBVOL	251	/* for UUIDs assigned to subvols */
+#define BTRFS_UUID_KEY_RECEIVED_SUBVOL	252	/* for UUIDs assigned to
+						 * received subvols */
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
diff --git a/print-tree.c b/print-tree.c
index aae47a9..c1032cb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -509,6 +509,12 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_DEV_STATS_KEY:
 		printf("DEV_STATS_ITEM");
 		break;
+	case BTRFS_UUID_KEY_SUBVOL:
+		printf("BTRFS_UUID_KEY_SUBVOL");
+		break;
+	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+		printf("BTRFS_UUID_KEY_RECEIVED_SUBVOL");
+		break;
 	default:
 		printf("UNKNOWN.%d", type);
 	};
@@ -516,15 +522,18 @@ static void print_key_type(u64 objectid, u8 type)
 
 static void print_objectid(u64 objectid, u8 type)
 {
-	if (type == BTRFS_DEV_EXTENT_KEY) {
+	switch (type) {
+	case BTRFS_DEV_EXTENT_KEY:
 		printf("%llu", (unsigned long long)objectid); /* device id */
 		return;
-	}
-	switch (type) {
 	case BTRFS_QGROUP_RELATION_KEY:
 		printf("%llu/%llu", objectid >> 48,
 			objectid & ((1ll << 48) - 1));
 		return;
+	case BTRFS_UUID_KEY_SUBVOL:
+	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+		printf("0x%016llx", (unsigned long long)objectid);
+		return;
 	}
 
 	switch (objectid) {
@@ -582,6 +591,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_QUOTA_TREE_OBJECTID:
 		printf("QUOTA_TREE");
 		break;
+	case BTRFS_UUID_TREE_OBJECTID:
+		printf("UUID_TREE");
+		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
@@ -616,6 +628,10 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 		printf(" %llu/%llu)", (unsigned long long)(offset >> 48),
 			(unsigned long long)(offset & ((1ll << 48) - 1)));
 		break;
+	case BTRFS_UUID_KEY_SUBVOL:
+	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+		printf(" 0x%016llx)", (unsigned long long)offset);
+		break;
 	default:
 		if (offset == (u64)-1)
 			printf(" -1)");
@@ -625,6 +641,25 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	}
 }
 
+static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
+			    u32 item_size)
+{
+	if (item_size & (sizeof(u64) - 1)) {
+		printf("btrfs: uuid item with illegal size %lu!\n",
+		       (unsigned long)item_size);
+		return;
+	}
+	while (item_size) {
+		u64 subvol_id;
+
+		read_extent_buffer(l, &subvol_id, offset, sizeof(u64));
+		subvol_id = le64_to_cpu(subvol_id);
+		printf("\t\tsubvol_id %llu\n", (unsigned long long)subvol_id);
+		item_size -= sizeof(u64);
+		offset += sizeof(u64);
+	}
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -841,6 +876,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (long long)
 			       btrfs_qgroup_limit_rsv_exclusive(l, qg_limit));
 			break;
+		case BTRFS_UUID_KEY_SUBVOL:
+		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+			print_uuid_item(l, btrfs_item_ptr_offset(l, i),
+					btrfs_item_size_nr(l, i));
+			break;
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
-- 
1.8.3

