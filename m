From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: Add fallocate support v2
Date: Fri, 31 Oct 2008 01:01:51 +0800
Message-ID: <4909E87F.3040607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, ukernel@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates btrfs-progs for fallocate support.
 
Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---

diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2008-10-10 04:21:07.395540565 +0800
+++ btrfs-progs/btrfsck.c	2008-10-30 16:12:47.000000000 +0800
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
diff -urp btrfs-progs-unstable/ctree.h btrfs-progs/ctree.h
--- btrfs-progs-unstable/ctree.h	2008-10-30 07:21:15.836721845 +0800
+++ btrfs-progs/ctree.h	2008-10-30 16:13:47.000000000 +0800
@@ -427,6 +427,7 @@ struct btrfs_root_item {
 	__le64 bytenr;
 	__le64 byte_limit;
 	__le64 bytes_used;
+	__le64 last_snapshot;
 	__le32 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
@@ -434,8 +435,9 @@ struct btrfs_root_item {
 	u8 level;
 } __attribute__ ((__packed__));
 
-#define BTRFS_FILE_EXTENT_REG 0
-#define BTRFS_FILE_EXTENT_INLINE 1
+#define BTRFS_FILE_EXTENT_INLINE 0
+#define BTRFS_FILE_EXTENT_REG 1
+#define BTRFS_FILE_EXTENT_PREALLOC 2
 
 struct btrfs_file_extent_item {
 	/*
@@ -1251,6 +1253,9 @@ BTRFS_SETGET_STACK_FUNCS(root_refs, stru
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 32);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
+BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
+			 last_snapshot, 64);
+
 
 /* struct btrfs_super_block */
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
diff -urp btrfs-progs-unstable/print-tree.c btrfs-progs/print-tree.c
--- btrfs-progs-unstable/print-tree.c	2008-10-30 07:21:15.837696131 +0800
+++ btrfs-progs/print-tree.c	2008-10-30 16:25:45.000000000 +0800
@@ -124,6 +124,41 @@ static void print_uuids(struct extent_bu
 	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
 }
 
+static void print_file_extent_item(struct extent_buffer *eb,
+				   struct btrfs_item *item,
+				   struct btrfs_file_extent_item *fi)
+{
+	int extent_type = btrfs_file_extent_type(eb, fi);
+
+	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+		printf("\t\tinline extent data size %u "
+		       "ram %llu compress %d\n",
+	          btrfs_file_extent_inline_len(eb, item),
+		  (unsigned long long) btrfs_file_extent_ram_bytes(eb, fi),
+		  btrfs_file_extent_compression(eb, fi));
+		return;
+	}
+	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		printf("\t\tprealloc data disk byte %llu nr %llu\n",
+		  (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
+		  (unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
+		printf("\t\tprealloc data offset %llu nr %llu\n",
+		  (unsigned long long)btrfs_file_extent_offset(eb, fi),
+		  (unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
+		return;
+	}
+	printf("\t\textent data disk byte %llu nr %llu\n",
+		(unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
+		(unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
+	printf("\t\textent data offset %llu nr %llu ram %llu\n",
+	  	(unsigned long long)btrfs_file_extent_offset(eb, fi),
+	  	(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
+	  	(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
+	printf("\t\textent compression %d\n",
+	       btrfs_file_extent_compression(eb, fi));
+}
+
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -226,25 +261,7 @@ void btrfs_print_leaf(struct btrfs_root 
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(l, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE) {
-				printf("\t\tinline extent data size %u "
-				       "ram %llu compress %d\n",
-			          btrfs_file_extent_inline_len(l, item),
-				  (unsigned long long)
-				  btrfs_file_extent_ram_bytes(l, fi),
-				  btrfs_file_extent_compression(l, fi));
-				break;
-			}
-			printf("\t\textent data disk byte %llu nr %llu\n",
-			       (unsigned long long)btrfs_file_extent_disk_bytenr(l, fi),
-			       (unsigned long long)btrfs_file_extent_disk_num_bytes(l, fi));
-			printf("\t\textent data offset %llu nr %llu ram %llu\n",
-			  (unsigned long long)btrfs_file_extent_offset(l, fi),
-			  (unsigned long long)btrfs_file_extent_num_bytes(l, fi),
-			  (unsigned long long)btrfs_file_extent_ram_bytes(l, fi));
-			printf("\t\textent compression %d\n",
-			       btrfs_file_extent_compression(l, fi));
+			print_file_extent_item(l, item, fi);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
