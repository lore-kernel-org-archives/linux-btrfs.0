Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:8069 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab3DWNWE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 09:22:04 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 31.27 OK)
	with ESMTP id g07632p3NBhvSQ for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Apr 2013 15:21:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs-progs: Support UUID tree and UUID items in btrfs-debug-tree
Date: Tue, 23 Apr 2013 15:21:57 +0200
Message-Id: <dd0dc40282678386c7f4086a21441ed2e0da4091.1366722651.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1366722651.git.sbehrens@giantdisaster.de>

Support printing these things.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 ctree.h      | 29 +++++++++++++++++++
 print-tree.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/ctree.h b/ctree.h
index 4ea37ac..f25e2df 100644
--- a/ctree.h
+++ b/ctree.h
@@ -71,6 +71,8 @@ struct btrfs_free_space_ctl;
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
+/* for storing items that use the BTRFS_UUID_KEY */
+#define BTRFS_UUID_TREE_OBJECTID 9ULL
 
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
@@ -811,6 +813,16 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/* for items that use the BTRFS_UUID_KEY */
+#define BTRFS_UUID_ITEM_TYPE_SUBVOL	0 /* for UUIDs assigned to subvols */
+#define BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL	1 /* for UUIDs assigned to
+						   * received subvols */
+struct btrfs_uuid_item {
+	__le64 type;	/* refer to BTRFS_UUID_ITEM_TYPE* defines above */
+	__le64 len;	/* number of following 64bit values */
+	__le64 data[0];	/* data aligned to 64bit */
+} __attribute__ ((__packed__));
+
 /* tag for the radix tree of block groups in ram */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1107,6 +1119,17 @@ struct btrfs_root {
 #define BTRFS_DEV_REPLACE_KEY	250
 
 /*
+ * Stores items that allow to quickly map UUIDs to something else.
+ * These items are part of the filesystem UUID tree.
+ * The key is built like this:
+ * (UUID_upper_64_bits, BTRFS_UUID_KEY, UUID_lower_64_bits).
+ */
+#if BTRFS_UUID_SIZE != 16
+#error "UUID items require BTRFS_UUID_SIZE == 16!"
+#endif
+#define BTRFS_UUID_KEY	251
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -2046,6 +2069,12 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
        return btrfs_item_size(eb, e) - offset;
 }
 
+/* btrfs_uuid_item */
+BTRFS_SETGET_FUNCS(uuid_type, struct btrfs_uuid_item, type, 64);
+BTRFS_SETGET_FUNCS(uuid_len, struct btrfs_uuid_item, len, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_uuid_type, struct btrfs_uuid_item, type, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_uuid_len, struct btrfs_uuid_item, len, 64);
+
 static inline u32 btrfs_level_size(struct btrfs_root *root, int level) {
 	if (level == 0)
 		return root->leafsize;
diff --git a/print-tree.c b/print-tree.c
index aae47a9..7320a95 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -509,6 +509,9 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_DEV_STATS_KEY:
 		printf("DEV_STATS_ITEM");
 		break;
+	case BTRFS_UUID_KEY:
+		printf("BTRFS_UUID_KEY");
+		break;
 	default:
 		printf("UNKNOWN.%d", type);
 	};
@@ -516,15 +519,17 @@ static void print_key_type(u64 objectid, u8 type)
 
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
+	case BTRFS_UUID_KEY:
+		printf("0x%016llx", (unsigned long long)objectid);
+		return;
 	}
 
 	switch (objectid) {
@@ -582,6 +587,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_QUOTA_TREE_OBJECTID:
 		printf("QUOTA_TREE");
 		break;
+	case BTRFS_UUID_TREE_OBJECTID:
+		printf("UUID_TREE");
+		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
@@ -616,6 +624,9 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 		printf(" %llu/%llu)", (unsigned long long)(offset >> 48),
 			(unsigned long long)(offset & ((1ll << 48) - 1)));
 		break;
+	case BTRFS_UUID_KEY:
+		printf(" 0x%016llx)", (unsigned long long)offset);
+		break;
 	default:
 		if (offset == (u64)-1)
 			printf(" -1)");
@@ -625,6 +636,74 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	}
 }
 
+static void print_uuid_item(struct extent_buffer *l,
+			    struct btrfs_uuid_item *ptr,
+			    u64 item_size)
+{
+	do {
+		u64 sub_item_type;
+		u64 sub_item_len;
+		u64 subvol_id;
+
+		if (item_size < sizeof(*ptr)) {
+			printf("btrfs: uuid item too short!\n");
+			return;
+		}
+		sub_item_type = btrfs_uuid_type(l, ptr);
+		sub_item_len = btrfs_uuid_len(l, ptr);
+		ptr++;
+		item_size -= sizeof(*ptr);
+		if (sub_item_len * 8 > item_size) {
+			printf("btrfs: uuid item too short (%llu subitems)!\n",
+			       (unsigned long long)sub_item_len);
+			return;
+		}
+
+		item_size -= sub_item_len * 8;
+		switch (sub_item_type) {
+		case BTRFS_UUID_ITEM_TYPE_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printf("\t\tsubvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		case BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printf("\t\treceived_subvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		default:
+			printf("\t\tunknown type=%llu, len=8*%llu\n",
+			       (unsigned long long)sub_item_type,
+			       (unsigned long long)sub_item_len);
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printf("\t\tid %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		}
+	} while (item_size);
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -645,6 +724,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_qgroup_info_item *qg_info;
 	struct btrfs_qgroup_limit_item *qg_limit;
 	struct btrfs_qgroup_status_item *qg_status;
+	struct btrfs_uuid_item *uuid_item;
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
@@ -841,6 +921,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (long long)
 			       btrfs_qgroup_limit_rsv_exclusive(l, qg_limit));
 			break;
+		case BTRFS_UUID_KEY:
+			uuid_item = btrfs_item_ptr(l, i,
+						   struct btrfs_uuid_item);
+			print_uuid_item(l, uuid_item, btrfs_item_size_nr(l, i));
+			break;
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
-- 
1.8.2.1

