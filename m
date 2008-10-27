From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: Add fallocate support
Date: Mon, 27 Oct 2008 22:57:13 +0800
Message-ID: <4905D6C9.4090102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	yanzheng@21cn.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates btrfs-progs for fallocate support.
 
Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-1/btrfsck.c btrfs-progs-2/btrfsck.c
--- btrfs-progs-1/btrfsck.c	2008-10-27 13:15:31.000000000 +0800
+++ btrfs-progs-2/btrfsck.c	2008-10-27 11:08:56.000000000 +0800
@@ -621,8 +621,8 @@ static int run_next_block(struct btrfs_r
 				continue;
 			fi = btrfs_item_ptr(buf, i,
 					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) !=
-			    BTRFS_FILE_EXTENT_REG)
+			if (btrfs_file_extent_type(buf, fi) ==
+			    BTRFS_FILE_EXTENT_INLINE)
 				continue;
 			if (btrfs_file_extent_disk_bytenr(buf, fi) == 0)
 				continue;
diff -urp btrfs-progs-1/ctree.h btrfs-progs-2/ctree.h
--- btrfs-progs-1/ctree.h	2008-10-27 13:15:47.000000000 +0800
+++ btrfs-progs-2/ctree.h	2008-10-27 11:08:56.000000000 +0800
@@ -418,6 +418,7 @@ struct btrfs_root_item {
 	__le64 bytenr;
 	__le64 byte_limit;
 	__le64 bytes_used;
+	__le64 last_snapshot;
 	__le32 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
@@ -427,6 +428,7 @@ struct btrfs_root_item {
 
 #define BTRFS_FILE_EXTENT_REG 0
 #define BTRFS_FILE_EXTENT_INLINE 1
+#define BTRFS_FILE_EXTENT_PREALLOC 2
 
 struct btrfs_file_extent_item {
 	__le64 generation;
@@ -1216,6 +1218,8 @@ BTRFS_SETGET_STACK_FUNCS(root_refs, stru
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 32);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
+BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
+			 last_snapshot, 64);
 
 /* struct btrfs_super_block */
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
diff -urp btrfs-progs-1/print-tree.c btrfs-progs-2/print-tree.c
--- btrfs-progs-1/print-tree.c	2008-10-27 13:15:31.000000000 +0800
+++ btrfs-progs-2/print-tree.c	2008-10-27 11:08:56.000000000 +0800
@@ -78,6 +78,27 @@ static int print_inode_ref_item(struct e
 	return 0;
 }
 
+static void print_file_extent_item(struct extent_buffer *eb, struct btrfs_item *item,
+				   struct btrfs_file_extent_item *fi)
+{
+	int extent_type = btrfs_file_extent_type(eb, fi);
+	char *type_name = "extent data";
+
+	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+		printf("\t\tinline extent data size %u\n",
+			btrfs_file_extent_inline_len(eb, item));
+		return;
+	}
+	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
+		type_name = "prealloc data";
+	printf("\t\t%s disk byte %llu nr %llu\n", type_name,
+		(unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
+		(unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
+	printf("\t\t%s offset %llu nr %llu\n", type_name,
+		(unsigned long long)btrfs_file_extent_offset(eb, fi),
+		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
+}
+
 static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
@@ -226,18 +247,7 @@ void btrfs_print_leaf(struct btrfs_root 
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(l, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE) {
-				printf("\t\tinline extent data size %u\n",
-			           btrfs_file_extent_inline_len(l, item));
-				break;
-			}
-			printf("\t\textent data disk byte %llu nr %llu\n",
-			       (unsigned long long)btrfs_file_extent_disk_bytenr(l, fi),
-			       (unsigned long long)btrfs_file_extent_disk_num_bytes(l, fi));
-			printf("\t\textent data offset %llu nr %llu\n",
-			  (unsigned long long)btrfs_file_extent_offset(l, fi),
-			  (unsigned long long)btrfs_file_extent_num_bytes(l, fi));
+			print_file_extent_item(l, item, fi);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
