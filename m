From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: debug-tree output tree/key type instead of id
Date: Wed, 07 Jan 2009 14:50:50 +0800
Message-ID: <496450CA.9060303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I'm not sure if this patch is useful.
I developed it only for my personal using.

Make the tree name and key type output more readable.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 debug-tree.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++-----
 print-tree.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 138 insertions(+), 13 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index 885962b..53f8be4 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -178,21 +178,79 @@ int main(int ac, char **av)
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
 				if (!skip)
-					printf("root ");
+					printf("root");
+				break;
+			case BTRFS_EXTENT_TREE_OBJECTID:
+				skip = 0;
+				if (!extent_only)
+					printf("extent");
+				break;
+			case BTRFS_CHUNK_TREE_OBJECTID:
+				if (!skip) {
+					printf("chunk");
+				}
 				break;
 			case BTRFS_DEV_TREE_OBJECTID:
 				if (!skip) {
-					printf("device extent tree ");
+					printf("device");
 				}
 				break;
-			case BTRFS_EXTENT_TREE_OBJECTID:
-				skip = 0;
-				if (!extent_only)
-					printf("extent tree ");
+			case BTRFS_FS_TREE_OBJECTID:
+				if (!skip) {
+					printf("fs");
+				}
+				break;
+			case BTRFS_ROOT_TREE_DIR_OBJECTID:
+				if (!skip) {
+					printf("directory");
+				}
+				break;
+			case BTRFS_CSUM_TREE_OBJECTID:
+				if (!skip) {
+					printf("checksum");
+				}
+				break;
+			case BTRFS_ORPHAN_OBJECTID:
+				if (!skip) {
+					printf("orphan");
+				}
 				break;
+			case BTRFS_TREE_LOG_OBJECTID:
+				if (!skip) {
+					printf("log");
+				}
+				break;
+			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
+				if (!skip) {
+					printf("log fixup");
+				}
+				break;
+			case BTRFS_TREE_RELOC_OBJECTID:
+				if (!skip) {
+					printf("reloc");
+				}
+				break;
+			case BTRFS_DATA_RELOC_TREE_OBJECTID:
+				if (!skip) {
+					printf("data reloc");
+				}
+				break;
+			case BTRFS_EXTENT_CSUM_OBJECTID:
+				if (!skip) {
+					printf("extent checksum");
+				}
+			case BTRFS_MULTIPLE_OBJECTIDS:
+				if (!skip) {
+					printf("multiple");
+				}
+				break;
+			default:
+				if (!skip) {
+					printf("file");
+				}
 			}
 			if (!skip && !extent_only) {
-				printf("tree %llu %u %llu\n",
+				printf(" tree (%llu %u %llu)\n",
 				       (unsigned long long)found_key.objectid,
 				       found_key.type,
 				       (unsigned long long)found_key.offset);
diff --git a/print-tree.c b/print-tree.c
index b69447d..52ef7c7 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -174,6 +174,71 @@ static void print_root_ref(struct extent_buffer *leaf, int slot, char *tag)
 	       namelen, namebuf);
 }
 
+static void print_key_type(u8 type)
+{
+	switch (type) {
+	case BTRFS_INODE_ITEM_KEY:
+		printf("INODE_ITEM");
+		break;
+	case BTRFS_INODE_REF_KEY:
+		printf("INODE_REF");
+		break;
+	case BTRFS_DIR_ITEM_KEY:
+		printf("DIR_ITEM");
+		break;
+	case BTRFS_DIR_INDEX_KEY:
+		printf("DIR_INDEX");
+		break;
+	case BTRFS_XATTR_ITEM_KEY:
+		printf("XATTR_ITEM");
+		break;
+	case BTRFS_ORPHAN_ITEM_KEY:
+		printf("ORPHAN_ITEM");
+		break;
+	case BTRFS_ROOT_ITEM_KEY:
+		printf("ROOT_ITEM");
+		break;
+	case BTRFS_ROOT_REF_KEY:
+		printf("ROOT_REF");
+		break;
+	case BTRFS_ROOT_BACKREF_KEY:
+		printf("ROOT_BACKREF");
+		break;
+	case BTRFS_EXTENT_ITEM_KEY:
+		printf("EXTENT_ITEM");
+		break;
+	case BTRFS_EXTENT_REF_KEY:
+		printf("EXTENT_REF");
+		break;
+	case BTRFS_CSUM_ITEM_KEY:
+		printf("CSUM_ITEM");
+		break;
+	case BTRFS_EXTENT_CSUM_KEY:
+		printf("EXTENT_CSUM");
+		break;
+	case BTRFS_EXTENT_DATA_KEY:
+		printf("EXTENT_DATA");
+		break;
+	case BTRFS_BLOCK_GROUP_ITEM_KEY:
+		printf("GROUP_ITEM");
+		break;
+	case BTRFS_CHUNK_ITEM_KEY:
+		printf("CHUNK_ITEM");
+		break;
+	case BTRFS_DEV_ITEM_KEY:
+		printf("DEV_ITEM");
+		break;
+	case BTRFS_DEV_EXTENT_KEY:
+		printf("DEV_EXTENT");
+		break;
+	case BTRFS_STRING_ITEM_KEY:
+		printf("STRING_ITEM");
+		break;
+	default:
+		printf("UNKNOWN");
+	};
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -206,10 +271,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key(l, &disk_key, i);
 		type = btrfs_disk_key_type(&disk_key);
-		printf("\titem %d key (%llu %x %llu) itemoff %d itemsize %d\n",
+		printf("\titem %d key (%llu ",
 			i,
-			(unsigned long long)btrfs_disk_key_objectid(&disk_key),
-			btrfs_disk_key_type(&disk_key),
+			(unsigned long long)btrfs_disk_key_objectid(&disk_key));
+		print_key_type(type);
+		printf(" %llu) itemoff %d itemsize %d\n",
 			(unsigned long long)btrfs_disk_key_offset(&disk_key),
 			btrfs_item_offset(l, item),
 			btrfs_item_size(l, item));
@@ -355,10 +421,11 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 	for (i = 0; i < nr; i++) {
 		u64 blocknr = btrfs_node_blockptr(eb, i);
 		btrfs_node_key_to_cpu(eb, &key, i);
-		printf("\tkey %d (%llu %x %llu) block %llu (%llu) gen %llu\n",
+		printf("\tkey %d (%llu ",
 		       i,
-		       (unsigned long long)key.objectid,
-		       key.type,
+		       (unsigned long long)key.objectid);
+		print_key_type(key.type);
+		printf(" %llu) block %llu (%llu) gen %llu\n",
 		       (unsigned long long)key.offset,
 		       (unsigned long long)blocknr,
 		       (unsigned long long)blocknr / size,
-- 
1.6.0.6

