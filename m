Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7029 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932860AbcH2IJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:09:15 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 3185B4334C72
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 16:09:06 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: Enhance and export print_objectid function
Date: Mon, 29 Aug 2016 16:08:59 +0800
Message-ID: <20160829080902.2952-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
References: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is quite useful for a lot of error report.
Enhance it to support custom output other than stdout.
And export it for later btrfsck enhancement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 59 ++++++++++++++++++++++++++++++-----------------------------
 print-tree.h |  1 +
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 81ab81f..601fc0f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -707,97 +707,98 @@ static void print_key_type(u64 objectid, u8 type)
 	};
 }
 
-static void print_objectid(u64 objectid, u8 type)
+void print_objectid(FILE *stream, u64 objectid, u8 type)
 {
 	switch (type) {
 	case BTRFS_DEV_EXTENT_KEY:
-		printf("%llu", (unsigned long long)objectid); /* device id */
+		/* device id */
+		fprintf(stream, "%llu", (unsigned long long)objectid);
 		return;
 	case BTRFS_QGROUP_RELATION_KEY:
-		printf("%llu/%llu", btrfs_qgroup_level(objectid),
+		fprintf(stream, "%llu/%llu", btrfs_qgroup_level(objectid),
 		       btrfs_qgroup_subvid(objectid));
 		return;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-		printf("0x%016llx", (unsigned long long)objectid);
+		fprintf(stream, "0x%016llx", (unsigned long long)objectid);
 		return;
 	}
 
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
 		if (type == BTRFS_DEV_ITEM_KEY)
-			printf("DEV_ITEMS");
+			fprintf(stream, "DEV_ITEMS");
 		else
-			printf("ROOT_TREE");
+			fprintf(stream, "ROOT_TREE");
 		break;
 	case BTRFS_EXTENT_TREE_OBJECTID:
-		printf("EXTENT_TREE");
+		fprintf(stream, "EXTENT_TREE");
 		break;
 	case BTRFS_CHUNK_TREE_OBJECTID:
-		printf("CHUNK_TREE");
+		fprintf(stream, "CHUNK_TREE");
 		break;
 	case BTRFS_DEV_TREE_OBJECTID:
-		printf("DEV_TREE");
+		fprintf(stream, "DEV_TREE");
 		break;
 	case BTRFS_FS_TREE_OBJECTID:
-		printf("FS_TREE");
+		fprintf(stream, "FS_TREE");
 		break;
 	case BTRFS_ROOT_TREE_DIR_OBJECTID:
-		printf("ROOT_TREE_DIR");
+		fprintf(stream, "ROOT_TREE_DIR");
 		break;
 	case BTRFS_CSUM_TREE_OBJECTID:
-		printf("CSUM_TREE");
+		fprintf(stream, "CSUM_TREE");
 		break;
 	case BTRFS_BALANCE_OBJECTID:
-		printf("BALANCE");
+		fprintf(stream, "BALANCE");
 		break;
 	case BTRFS_ORPHAN_OBJECTID:
-		printf("ORPHAN");
+		fprintf(stream, "ORPHAN");
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
-		printf("TREE_LOG");
+		fprintf(stream, "TREE_LOG");
 		break;
 	case BTRFS_TREE_LOG_FIXUP_OBJECTID:
-		printf("LOG_FIXUP");
+		fprintf(stream, "LOG_FIXUP");
 		break;
 	case BTRFS_TREE_RELOC_OBJECTID:
-		printf("TREE_RELOC");
+		fprintf(stream, "TREE_RELOC");
 		break;
 	case BTRFS_DATA_RELOC_TREE_OBJECTID:
-		printf("DATA_RELOC_TREE");
+		fprintf(stream, "DATA_RELOC_TREE");
 		break;
 	case BTRFS_EXTENT_CSUM_OBJECTID:
-		printf("EXTENT_CSUM");
+		fprintf(stream, "EXTENT_CSUM");
 		break;
 	case BTRFS_FREE_SPACE_OBJECTID:
-		printf("FREE_SPACE");
+		fprintf(stream, "FREE_SPACE");
 		break;
 	case BTRFS_FREE_INO_OBJECTID:
-		printf("FREE_INO");
+		fprintf(stream, "FREE_INO");
 		break;
 	case BTRFS_QUOTA_TREE_OBJECTID:
-		printf("QUOTA_TREE");
+		fprintf(stream, "QUOTA_TREE");
 		break;
 	case BTRFS_UUID_TREE_OBJECTID:
-		printf("UUID_TREE");
+		fprintf(stream, "UUID_TREE");
 		break;
 	case BTRFS_FREE_SPACE_TREE_OBJECTID:
-		printf("FREE_SPACE_TREE");
+		fprintf(stream, "FREE_SPACE_TREE");
 		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
-		printf("MULTIPLE");
+		fprintf(stream, "MULTIPLE");
 		break;
 	case (u64)-1:
-		printf("-1");
+		fprintf(stream, "-1");
 		break;
 	case BTRFS_FIRST_CHUNK_TREE_OBJECTID:
 		if (type == BTRFS_CHUNK_ITEM_KEY) {
-			printf("FIRST_CHUNK_TREE");
+			fprintf(stream, "FIRST_CHUNK_TREE");
 			break;
 		}
 		/* fall-thru */
 	default:
-		printf("%llu", (unsigned long long)objectid);
+		fprintf(stream, "%llu", (unsigned long long)objectid);
 	}
 }
 
@@ -808,7 +809,7 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	u64 offset = btrfs_disk_key_offset(disk_key);
 
 	printf("key (");
-	print_objectid(objectid, type);
+	print_objectid(stdout, objectid, type);
 	printf(" ");
 	print_key_type(objectid, type);
 	switch (type) {
diff --git a/print-tree.h b/print-tree.h
index f0153c1..73fb3e8 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -24,4 +24,5 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t, int foll
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
+void print_objectid(FILE *stream, u64 objectid, u8 type);
 #endif
-- 
2.9.3



