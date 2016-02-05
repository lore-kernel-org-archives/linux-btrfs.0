Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33020 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbcBEBZR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:25:17 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 4EBDE405640A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Feb 2016 09:25:05 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 7/8] btrfs-progs: debug-tree: Add dedup tree support
Date: Fri,  5 Feb 2016 09:23:03 +0800
Message-Id: <1454635384-10106-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635384-10106-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635384-10106-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add dedup tree support for btrfs-debug-tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add support to print hex objectid/offset for dedup hash.
  Add support to print hex hash.
---
 btrfs-debug-tree.c |  4 +++
 ctree.h            |  7 ++++
 print-tree.c       | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 266176f..ce8f76c 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -408,6 +408,10 @@ again:
 					printf("multiple");
 				}
 				break;
+			case BTRFS_DEDUP_TREE_OBJECTID:
+				if (!skip)
+					printf("dedup");
+				break;
 			default:
 				if (!skip) {
 					printf("file");
diff --git a/ctree.h b/ctree.h
index bbffd1f..1ffe084 100644
--- a/ctree.h
+++ b/ctree.h
@@ -79,6 +79,9 @@ struct btrfs_free_space_ctl;
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* on-disk dedup tree (EXPERIMENTAL) */
+#define BTRFS_DEDUP_TREE_OBJECTID 11ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -1216,6 +1219,10 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_DEDUP_STATUS_ITEM_KEY	230
+#define BTRFS_DEDUP_HASH_ITEM_KEY	231
+#define BTRFS_DEDUP_BYTENR_ITEM_KEY	232
+
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
diff --git a/print-tree.c b/print-tree.c
index 6704ff6..53a6813 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -25,6 +25,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "utils.h"
+#include "dedup.h"
 
 
 static void print_dir_item_type(struct extent_buffer *eb,
@@ -667,11 +668,31 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf("UUID_KEY_RECEIVED_SUBVOL");
 		break;
+	case BTRFS_DEDUP_STATUS_ITEM_KEY:
+		printf("DEDUP_STATUS_ITEM");
+		break;
+	case BTRFS_DEDUP_HASH_ITEM_KEY:
+		printf("DEDUP_HASH_ITEM");
+		break;
+	case BTRFS_DEDUP_BYTENR_ITEM_KEY:
+		printf("DEDUP_BYTENR_ITEM");
+		break;
 	default:
 		printf("UNKNOWN.%d", type);
 	};
 }
 
+static void print_64bit_hash(u64 hash)
+{
+	int i;
+	unsigned char buf[8];
+
+	memcpy(buf, &hash, 8);
+	printf("0x");
+	for (i = 0; i < 8; i++)
+		printf("%02x", buf[i]);
+}
+
 static void print_objectid(u64 objectid, u8 type)
 {
 	switch (type) {
@@ -686,6 +707,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf("0x%016llx", (unsigned long long)objectid);
 		return;
+	case BTRFS_DEDUP_HASH_ITEM_KEY:
+		print_64bit_hash(objectid);
+		return;
 	}
 
 	switch (objectid) {
@@ -752,6 +776,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
+	case BTRFS_DEDUP_TREE_OBJECTID:
+		printf("DEDUP_TREE");
+		break;
 	case (u64)-1:
 		printf("-1");
 		break;
@@ -787,6 +814,9 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf(" 0x%016llx)", (unsigned long long)offset);
 		break;
+	case BTRFS_DEDUP_BYTENR_ITEM_KEY:
+		print_64bit_hash(offset);
+		break;
 	default:
 		if (offset == (u64)-1)
 			printf(" -1)");
@@ -815,6 +845,54 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
+static void print_dedup_status(struct extent_buffer *node, int slot)
+{
+	struct btrfs_dedup_status_item *status_item;
+	u64 blocksize;
+	u64 limit;
+	u16 hash_type;
+	u16 backend;
+
+	status_item = btrfs_item_ptr(node, slot,
+			struct btrfs_dedup_status_item);
+	blocksize = btrfs_dedup_status_blocksize(node, status_item);
+	limit = btrfs_dedup_status_limit(node, status_item);
+	hash_type = btrfs_dedup_status_hash_type(node, status_item);
+	backend = btrfs_dedup_status_backend(node, status_item);
+
+	printf("\t\tdedup status item ");
+	if (backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		printf("backend: inmemory\n");
+	else if (backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		printf("backend: ondisk\n");
+	else
+		printf("backend: Unrecognized(%u)\n", backend);
+
+	if (hash_type == BTRFS_DEDUP_HASH_SHA256)
+		printf("\t\thash algorithm: SHA-256 ");
+	else
+		printf("\t\thash algorithm: Unrecognized(%u) ", hash_type);
+
+	printf("blocksize: %llu limit: %llu\n", blocksize, limit);
+}
+
+static void print_dedup_hash(struct extent_buffer *eb, unsigned long offset)
+{
+	u8 buf[32];
+	int i;
+
+	printf("\t\thash: ");
+	read_extent_buffer(eb, buf, offset, 32);
+	for (i = 0; i < 32; i++) {
+		if (i == 16)
+			printf("\n\t\t      ");
+		if (i == 8 || i == 24)
+			printf("-");
+		printf("%02x", buf[i]);
+	}
+	printf("\n");
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -836,6 +914,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_qgroup_info_item *qg_info;
 	struct btrfs_qgroup_limit_item *qg_limit;
 	struct btrfs_qgroup_status_item *qg_status;
+	struct btrfs_dedup_hash_item *hash_item;
+
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
@@ -1070,6 +1150,20 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_STATS_KEY:
 			printf("\t\tdevice stats\n");
 			break;
+		case BTRFS_DEDUP_STATUS_ITEM_KEY:
+			print_dedup_status(l, i);
+			break;
+		case BTRFS_DEDUP_HASH_ITEM_KEY:
+			hash_item = btrfs_item_ptr(l, i,
+					struct btrfs_dedup_hash_item);
+
+			printf("\t\tdedup hash item num_bytes: %llu\n",
+				btrfs_dedup_hash_len(l, hash_item));
+			print_dedup_hash(l, (unsigned long)(hash_item + 1));
+			break;
+		case BTRFS_DEDUP_BYTENR_ITEM_KEY:
+			print_dedup_hash(l, btrfs_item_ptr_offset(l, i));
+			break;
 		};
 		fflush(stdout);
 	}
-- 
2.7.0



