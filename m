Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30940 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932861AbcH2IJQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:09:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1C8F64334C75
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 16:09:07 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: Enhance and export print_key_type function
Date: Mon, 29 Aug 2016 16:09:00 +0800
Message-ID: <20160829080902.2952-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
References: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just the same thing done for print_objectid().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 86 ++++++++++++++++++++++++++++++------------------------------
 print-tree.h |  1 +
 2 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 601fc0f..f97482f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -577,133 +577,133 @@ static void print_free_space_header(struct extent_buffer *leaf, int slot)
 	       (unsigned long long)btrfs_free_space_bitmaps(leaf, header));
 }
 
-static void print_key_type(u64 objectid, u8 type)
+void print_key_type(FILE *stream, u64 objectid, u8 type)
 {
 	if (type == 0 && objectid == BTRFS_FREE_SPACE_OBJECTID) {
-		printf("UNTYPED");
+		fprintf(stream, "UNTYPED");
 		return;
 	}
 
 	switch (type) {
 	case BTRFS_INODE_ITEM_KEY:
-		printf("INODE_ITEM");
+		fprintf(stream, "INODE_ITEM");
 		break;
 	case BTRFS_INODE_REF_KEY:
-		printf("INODE_REF");
+		fprintf(stream, "INODE_REF");
 		break;
 	case BTRFS_INODE_EXTREF_KEY:
-		printf("INODE_EXTREF");
+		fprintf(stream, "INODE_EXTREF");
 		break;
 	case BTRFS_DIR_ITEM_KEY:
-		printf("DIR_ITEM");
+		fprintf(stream, "DIR_ITEM");
 		break;
 	case BTRFS_DIR_INDEX_KEY:
-		printf("DIR_INDEX");
+		fprintf(stream, "DIR_INDEX");
 		break;
 	case BTRFS_DIR_LOG_ITEM_KEY:
-		printf("DIR_LOG_ITEM");
+		fprintf(stream, "DIR_LOG_ITEM");
 		break;
 	case BTRFS_DIR_LOG_INDEX_KEY:
-		printf("DIR_LOG_INDEX");
+		fprintf(stream, "DIR_LOG_INDEX");
 		break;
 	case BTRFS_XATTR_ITEM_KEY:
-		printf("XATTR_ITEM");
+		fprintf(stream, "XATTR_ITEM");
 		break;
 	case BTRFS_ORPHAN_ITEM_KEY:
-		printf("ORPHAN_ITEM");
+		fprintf(stream, "ORPHAN_ITEM");
 		break;
 	case BTRFS_ROOT_ITEM_KEY:
-		printf("ROOT_ITEM");
+		fprintf(stream, "ROOT_ITEM");
 		break;
 	case BTRFS_ROOT_REF_KEY:
-		printf("ROOT_REF");
+		fprintf(stream, "ROOT_REF");
 		break;
 	case BTRFS_ROOT_BACKREF_KEY:
-		printf("ROOT_BACKREF");
+		fprintf(stream, "ROOT_BACKREF");
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
-		printf("EXTENT_ITEM");
+		fprintf(stream, "EXTENT_ITEM");
 		break;
 	case BTRFS_METADATA_ITEM_KEY:
-		printf("METADATA_ITEM");
+		fprintf(stream, "METADATA_ITEM");
 		break;
 	case BTRFS_TREE_BLOCK_REF_KEY:
-		printf("TREE_BLOCK_REF");
+		fprintf(stream, "TREE_BLOCK_REF");
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
-		printf("SHARED_BLOCK_REF");
+		fprintf(stream, "SHARED_BLOCK_REF");
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
-		printf("EXTENT_DATA_REF");
+		fprintf(stream, "EXTENT_DATA_REF");
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
-		printf("SHARED_DATA_REF");
+		fprintf(stream, "SHARED_DATA_REF");
 		break;
 	case BTRFS_EXTENT_REF_V0_KEY:
-		printf("EXTENT_REF_V0");
+		fprintf(stream, "EXTENT_REF_V0");
 		break;
 	case BTRFS_CSUM_ITEM_KEY:
-		printf("CSUM_ITEM");
+		fprintf(stream, "CSUM_ITEM");
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		printf("EXTENT_CSUM");
+		fprintf(stream, "EXTENT_CSUM");
 		break;
 	case BTRFS_EXTENT_DATA_KEY:
-		printf("EXTENT_DATA");
+		fprintf(stream, "EXTENT_DATA");
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-		printf("BLOCK_GROUP_ITEM");
+		fprintf(stream, "BLOCK_GROUP_ITEM");
 		break;
 	case BTRFS_FREE_SPACE_INFO_KEY:
-		printf("FREE_SPACE_INFO");
+		fprintf(stream, "FREE_SPACE_INFO");
 		break;
 	case BTRFS_FREE_SPACE_EXTENT_KEY:
-		printf("FREE_SPACE_EXTENT");
+		fprintf(stream, "FREE_SPACE_EXTENT");
 		break;
 	case BTRFS_FREE_SPACE_BITMAP_KEY:
-		printf("FREE_SPACE_BITMAP");
+		fprintf(stream, "FREE_SPACE_BITMAP");
 		break;
 	case BTRFS_CHUNK_ITEM_KEY:
-		printf("CHUNK_ITEM");
+		fprintf(stream, "CHUNK_ITEM");
 		break;
 	case BTRFS_DEV_ITEM_KEY:
-		printf("DEV_ITEM");
+		fprintf(stream, "DEV_ITEM");
 		break;
 	case BTRFS_DEV_EXTENT_KEY:
-		printf("DEV_EXTENT");
+		fprintf(stream, "DEV_EXTENT");
 		break;
 	case BTRFS_BALANCE_ITEM_KEY:
-		printf("BALANCE_ITEM");
+		fprintf(stream, "BALANCE_ITEM");
 		break;
 	case BTRFS_DEV_REPLACE_KEY:
-		printf("DEV_REPLACE");
+		fprintf(stream, "DEV_REPLACE");
 		break;
 	case BTRFS_STRING_ITEM_KEY:
-		printf("STRING_ITEM");
+		fprintf(stream, "STRING_ITEM");
 		break;
 	case BTRFS_QGROUP_STATUS_KEY:
-		printf("QGROUP_STATUS");
+		fprintf(stream, "QGROUP_STATUS");
 		break;
 	case BTRFS_QGROUP_RELATION_KEY:
-		printf("QGROUP_RELATION");
+		fprintf(stream, "QGROUP_RELATION");
 		break;
 	case BTRFS_QGROUP_INFO_KEY:
-		printf("QGROUP_INFO");
+		fprintf(stream, "QGROUP_INFO");
 		break;
 	case BTRFS_QGROUP_LIMIT_KEY:
-		printf("QGROUP_LIMIT");
+		fprintf(stream, "QGROUP_LIMIT");
 		break;
 	case BTRFS_DEV_STATS_KEY:
-		printf("DEV_STATS");
+		fprintf(stream, "DEV_STATS");
 		break;
 	case BTRFS_UUID_KEY_SUBVOL:
-		printf("UUID_KEY_SUBVOL");
+		fprintf(stream, "UUID_KEY_SUBVOL");
 		break;
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-		printf("UUID_KEY_RECEIVED_SUBVOL");
+		fprintf(stream, "UUID_KEY_RECEIVED_SUBVOL");
 		break;
 	default:
-		printf("UNKNOWN.%d", type);
+		fprintf(stream, "UNKNOWN.%d", type);
 	};
 }
 
@@ -811,7 +811,7 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	printf("key (");
 	print_objectid(stdout, objectid, type);
 	printf(" ");
-	print_key_type(objectid, type);
+	print_key_type(stdout, objectid, type);
 	switch (type) {
 	case BTRFS_QGROUP_RELATION_KEY:
 	case BTRFS_QGROUP_INFO_KEY:
diff --git a/print-tree.h b/print-tree.h
index 73fb3e8..9865500 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -25,4 +25,5 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key);
 void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
 void print_objectid(FILE *stream, u64 objectid, u8 type);
+void print_key_type(FILE *stream, u64 objectid, u8 type);
 #endif
-- 
2.9.3



