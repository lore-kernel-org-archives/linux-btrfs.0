Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbcCVHVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 03:21:55 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id EF6BF4056408
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 15:21:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 7/8] btrfs-progs: debug-tree: Add dedupe tree support
Date: Tue, 22 Mar 2016 15:19:20 +0800
Message-Id: <1458631161-19036-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add dedupe tree support for btrfs-debug-tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-inspect-dump-tree.c |   4 ++
 ctree.h                  |   7 ++++
 print-tree.c             | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 43c8b67..0c75a3c 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -496,6 +496,10 @@ again:
 					printf("multiple");
 				}
 				break;
+			case BTRFS_DEDUPE_TREE_OBJECTID:
+				if (!skip)
+					printf("dedupe");
+				break;
 			default:
 				if (!skip) {
 					printf("file");
diff --git a/ctree.h b/ctree.h
index d251f65..45acd52 100644
--- a/ctree.h
+++ b/ctree.h
@@ -79,6 +79,9 @@ struct btrfs_free_space_ctl;
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* on-disk dedupe tree (EXPERIMENTAL) */
+#define BTRFS_DEDUPE_TREE_OBJECTID 11ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -1219,6 +1222,10 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_DEDUPE_STATUS_ITEM_KEY	230
+#define BTRFS_DEDUPE_HASH_ITEM_KEY	231
+#define BTRFS_DEDUPE_BYTENR_ITEM_KEY	232
+
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
diff --git a/print-tree.c b/print-tree.c
index d0f37a5..72b9ed6 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -25,6 +25,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "utils.h"
+#include "dedupe.h"
 
 
 static void print_dir_item_type(struct extent_buffer *eb,
@@ -687,11 +688,31 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf("UUID_KEY_RECEIVED_SUBVOL");
 		break;
+	case BTRFS_DEDUPE_STATUS_ITEM_KEY:
+		printf("DEDUPE_STATUS_ITEM");
+		break;
+	case BTRFS_DEDUPE_HASH_ITEM_KEY:
+		printf("DEDUPE_HASH_ITEM");
+		break;
+	case BTRFS_DEDUPE_BYTENR_ITEM_KEY:
+		printf("DEDUPE_BYTENR_ITEM");
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
@@ -706,6 +727,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf("0x%016llx", (unsigned long long)objectid);
 		return;
+	case BTRFS_DEDUPE_HASH_ITEM_KEY:
+		print_64bit_hash(objectid);
+		return;
 	}
 
 	switch (objectid) {
@@ -772,6 +796,9 @@ static void print_objectid(u64 objectid, u8 type)
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
+	case BTRFS_DEDUPE_TREE_OBJECTID:
+		printf("DEDUPE_TREE");
+		break;
 	case (u64)-1:
 		printf("-1");
 		break;
@@ -807,6 +834,9 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf(" 0x%016llx)", (unsigned long long)offset);
 		break;
+	case BTRFS_DEDUPE_BYTENR_ITEM_KEY:
+		print_64bit_hash(offset);
+		break;
 	default:
 		if (offset == (u64)-1)
 			printf(" -1)");
@@ -835,6 +865,71 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
+static void print_dedupe_status(struct extent_buffer *node, int slot)
+{
+	struct btrfs_dedupe_status_item *status_item;
+	u64 blocksize;
+	u64 limit;
+	u16 hash_type;
+	u16 backend;
+
+	status_item = btrfs_item_ptr(node, slot,
+			struct btrfs_dedupe_status_item);
+	blocksize = btrfs_dedupe_status_blocksize(node, status_item);
+	limit = btrfs_dedupe_status_limit(node, status_item);
+	hash_type = btrfs_dedupe_status_hash_type(node, status_item);
+	backend = btrfs_dedupe_status_backend(node, status_item);
+
+	printf("\t\tdedupe status item ");
+	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		printf("backend: inmemory\n");
+	else if (backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		printf("backend: ondisk\n");
+	else
+		printf("backend: Unrecognized(%u)\n", backend);
+
+	if (hash_type == BTRFS_DEDUPE_HASH_SHA256)
+		printf("\t\thash algorithm: SHA-256 ");
+	else
+		printf("\t\thash algorithm: Unrecognized(%u) ", hash_type);
+
+	printf("blocksize: %llu limit: %llu\n", blocksize, limit);
+}
+
+static void print_dedupe_hash(struct extent_buffer *eb, unsigned long offset)
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
+static void print_dedupe_hash_item(struct extent_buffer *eb, int slot)
+{
+	struct btrfs_dedupe_hash_item *hash_item;
+	char compress_str[16];
+
+	hash_item = btrfs_item_ptr(eb, slot,
+			struct btrfs_dedupe_hash_item);
+	compress_type_to_str(btrfs_dedupe_hash_compression(eb, hash_item),
+			     compress_str);
+
+	printf("\t\tdedupe hash item num_bytes: %u disk_num_bytes: %u\n",
+		btrfs_dedupe_hash_len(eb, hash_item),
+		btrfs_dedupe_hash_disk_len(eb, hash_item));
+	printf("\t\tdedupe hash compression %s\n", compress_str);
+	print_dedupe_hash(eb, (unsigned long)(hash_item + 1));
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -856,6 +951,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_qgroup_info_item *qg_info;
 	struct btrfs_qgroup_limit_item *qg_limit;
 	struct btrfs_qgroup_status_item *qg_status;
+
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
@@ -1090,6 +1186,15 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_STATS_KEY:
 			printf("\t\tdevice stats\n");
 			break;
+		case BTRFS_DEDUPE_STATUS_ITEM_KEY:
+			print_dedupe_status(l, i);
+			break;
+		case BTRFS_DEDUPE_HASH_ITEM_KEY:
+			print_dedupe_hash_item(l, i);
+			break;
+		case BTRFS_DEDUPE_BYTENR_ITEM_KEY:
+			print_dedupe_hash(l, btrfs_item_ptr_offset(l, i));
+			break;
 		};
 		fflush(stdout);
 	}
-- 
2.7.4



