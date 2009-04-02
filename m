From: Shen Feng <shen@cn.fujitsu.com>
Subject: [RESEND][PATCH] Btrfs-progs: update btrfs-debug-tree to output human
 readable objectid
Date: Thu, 02 Apr 2009 13:46:41 +0800
Message-ID: <49D45141.4010507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Wu Fengguang <fengguang.wu@intel.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


output objectid in btrfs_disk_key with human readable strings.
Other updates are included for more readable output.

Thanks Fengguang's fix to this patch.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 debug-tree.c |   11 +++--
 print-tree.c |  121 +++++++++++++++++++++++++++++++++++++++++++++------------
 print-tree.h |    1 +
 3 files changed, 102 insertions(+), 31 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index 53f8be4..9de9759 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -108,6 +108,7 @@ int main(int ac, char **av)
 	struct btrfs_key key;
 	struct btrfs_root_item ri;
 	struct extent_buffer *leaf;
+	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
 	char uuidbuf[37];
 	int ret;
@@ -164,7 +165,8 @@ int main(int ac, char **av)
 			leaf = path.nodes[0];
 			slot = path.slots[0];
 		}
-		btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
+		btrfs_item_key(leaf, &disk_key, path.slots[0]);
+		btrfs_disk_key_to_cpu(&found_key, &disk_key);
 		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
 			struct extent_buffer *buf;
@@ -250,10 +252,9 @@ int main(int ac, char **av)
 				}
 			}
 			if (!skip && !extent_only) {
-				printf(" tree (%llu %u %llu)\n",
-				       (unsigned long long)found_key.objectid,
-				       found_key.type,
-				       (unsigned long long)found_key.offset);
+				printf(" tree ");
+				btrfs_print_key(&disk_key);
+				printf(" \n");
 				btrfs_print_tree(root, buf);
 			} else if (extent_only && !skip) {
 				print_extents(root, buf);
diff --git a/print-tree.c b/print-tree.c
index 52ef7c7..0721b28 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -23,6 +23,7 @@
 #include "radix-tree.h"
 #include "ctree.h"
 #include "disk-io.h"
+#include "print-tree.h"
 
 static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 			  struct btrfs_dir_item *di)
@@ -38,9 +39,9 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	total = btrfs_item_size(eb, item);
 	while(cur < total) {
 		btrfs_dir_item_key(eb, di, &location);
-		printf("\t\tdir index %llu type %u\n",
-		       (unsigned long long)btrfs_disk_key_objectid(&location),
-		       btrfs_dir_type(eb, di));
+		printf("\t\tlocation ");
+		btrfs_print_key(&location);
+		printf(" type %u\n", btrfs_dir_type(eb, di));
 		name_len = btrfs_dir_name_len(eb, di);
 		data_len = btrfs_dir_data_len(eb, di);
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
@@ -220,7 +221,7 @@ static void print_key_type(u8 type)
 		printf("EXTENT_DATA");
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-		printf("GROUP_ITEM");
+		printf("BLOCK_GROUP_ITEM");
 		break;
 	case BTRFS_CHUNK_ITEM_KEY:
 		printf("CHUNK_ITEM");
@@ -239,6 +240,79 @@ static void print_key_type(u8 type)
 	};
 }
 
+static void print_objectid(unsigned long long objectid, u8 type)
+{
+	if (type == BTRFS_DEV_EXTENT_KEY) {
+		printf("%llu", objectid); /* device id */
+		return;
+	}
+
+	switch (objectid) {
+	case BTRFS_ROOT_TREE_OBJECTID:
+		if (type == BTRFS_DEV_ITEM_KEY)
+			printf("DEV_ITEMS");
+		else
+			printf("ROOT_TREE");
+		break;
+	case BTRFS_EXTENT_TREE_OBJECTID:
+		printf("EXTENT_TREE");
+		break;
+	case BTRFS_CHUNK_TREE_OBJECTID:
+		printf("CHUNK_TREE");
+		break;
+	case BTRFS_DEV_TREE_OBJECTID:
+		printf("DEV_TREE");
+		break;
+	case BTRFS_FS_TREE_OBJECTID:
+		printf("FS_TREE");
+		break;
+	case BTRFS_ROOT_TREE_DIR_OBJECTID:
+		printf("ROOT_TREE_DIR");
+		break;
+	case BTRFS_CSUM_TREE_OBJECTID:
+		printf("CSUM_TREE");
+		break;
+	case BTRFS_ORPHAN_OBJECTID:
+		printf("ORPHAN");
+		break;
+	case BTRFS_TREE_LOG_OBJECTID:
+		printf("TREE_LOG");
+		break;
+	case BTRFS_TREE_LOG_FIXUP_OBJECTID:
+		printf("LOG_FIXUP");
+		break;
+	case BTRFS_TREE_RELOC_OBJECTID:
+		printf("TREE_RELOC");
+		break;
+	case BTRFS_DATA_RELOC_TREE_OBJECTID:
+		printf("DATA_RELOC_TREE");
+		break;
+	case BTRFS_EXTENT_CSUM_OBJECTID:
+		printf("EXTENT_CSUM");
+		break;
+	case BTRFS_MULTIPLE_OBJECTIDS:
+		printf("MULTIPLE");
+		break;
+	case BTRFS_FIRST_CHUNK_TREE_OBJECTID:
+		printf("FIRST_CHUNK_TREE");
+		break;
+	default:
+		printf("%llu", objectid);
+	}
+}
+
+void btrfs_print_key(struct btrfs_disk_key *disk_key)
+{
+	u8 type;
+	printf("key (");
+	type = btrfs_disk_key_type(disk_key);
+	print_objectid((unsigned long long)btrfs_disk_key_objectid(disk_key),
+		type);
+	printf(" ");
+	print_key_type(type);
+	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -260,7 +334,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u32 type;
 
-	printf("leaf %llu ptrs %d free space %d generation %llu owner %llu\n",
+	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l),
 		(unsigned long long)btrfs_header_generation(l),
@@ -271,12 +345,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key(l, &disk_key, i);
 		type = btrfs_disk_key_type(&disk_key);
-		printf("\titem %d key (%llu ",
-			i,
-			(unsigned long long)btrfs_disk_key_objectid(&disk_key));
-		print_key_type(type);
-		printf(" %llu) itemoff %d itemsize %d\n",
-			(unsigned long long)btrfs_disk_key_offset(&disk_key),
+		printf("\titem %d ", i);
+		btrfs_print_key(&disk_key);
+		printf(" itemoff %d itemsize %d\n",
 			btrfs_item_offset(l, item),
 			btrfs_item_size(l, item));
 		switch (type) {
@@ -310,15 +381,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 				btrfs_root_level(&root_item),
 				(unsigned long long)btrfs_root_dirid(&root_item),
 				btrfs_root_refs(&root_item));
-			if (1 || btrfs_root_refs(&root_item) == 0) {
+			if (btrfs_root_refs(&root_item) == 0) {
 				struct btrfs_key drop_key;
 				btrfs_disk_key_to_cpu(&drop_key,
 						      &root_item.drop_progress);
-				printf("\t\tdrop key %Lu %x %Lu level %d\n",
-				       (unsigned long long)drop_key.objectid,
-				       drop_key.type,
-				       (unsigned long long)drop_key.offset,
-				       root_item.drop_level);
+				printf("\t\tdrop ");
+				btrfs_print_key(&root_item.drop_progress);
+				printf(" level %d\n", root_item.drop_level);
 			}
 			break;
 		case BTRFS_ROOT_REF_KEY:
@@ -359,8 +428,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 					    struct btrfs_block_group_item);
 			read_extent_buffer(l, &bg_item, (unsigned long)bi,
 					   sizeof(bg_item));
-			printf("\t\tblock group used %llu flags %llu\n",
+			printf("\t\tblock group used %llu chunk_objectid %llu flags %llu\n",
 			       (unsigned long long)btrfs_block_group_used(&bg_item),
+			       (unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
 			       (unsigned long long)btrfs_block_group_flags(&bg_item));
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
@@ -400,6 +470,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 	int i;
 	u32 nr;
 	u32 size;
+	struct btrfs_disk_key disk_key;
 	struct btrfs_key key;
 
 	if (!eb)
@@ -409,7 +480,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 		btrfs_print_leaf(root, eb);
 		return;
 	}
-	printf("node %llu level %d ptrs %d free %u generation %llu owner %llu\n",
+	printf("node %llu level %d items %d free %u generation %llu owner %llu\n",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
 		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr,
@@ -420,13 +491,11 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb)
 	size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
 	for (i = 0; i < nr; i++) {
 		u64 blocknr = btrfs_node_blockptr(eb, i);
-		btrfs_node_key_to_cpu(eb, &key, i);
-		printf("\tkey %d (%llu ",
-		       i,
-		       (unsigned long long)key.objectid);
-		print_key_type(key.type);
-		printf(" %llu) block %llu (%llu) gen %llu\n",
-		       (unsigned long long)key.offset,
+		btrfs_node_key(eb, &disk_key, i);
+		btrfs_disk_key_to_cpu(&key, &disk_key);
+		printf("\t");
+		btrfs_print_key(&disk_key);
+		printf(" block %llu (%llu) gen %llu\n",
 		       (unsigned long long)blocknr,
 		       (unsigned long long)blocknr / size,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
diff --git a/print-tree.h b/print-tree.h
index da75efe..4d1a01a 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -20,4 +20,5 @@
 #define __PRINT_TREE_
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
 void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t);
+void btrfs_print_key(struct btrfs_disk_key *disk_key);
 #endif
-- 
1.6.0.6

