Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50756 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaDHQ0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 12:26:01 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so1229923wgh.19
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 09:26:00 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: update btrfs_file_extent_inline_len to match kernel version
Date: Tue,  8 Apr 2014 18:25:43 +0100
Message-Id: <1396977943-12427-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following kernel commit changed the definition of the inline function
btrfs_file_extent_inline_len():

    commit 514ac8ad8793a097c0c9d89202c642479d6dfa34
    Author: Chris Mason <clm@fb.com>
    Date:   Fri Jan 3 21:07:00 2014 -0800

    Btrfs: don't use ram_bytes for uncompressed inline items

    If we truncate an uncompressed inline item, ram_bytes isn't updated to reflect
    the new size.  The fixe uses the size directly from the item header when
    reading uncompressed inlines, and also fixes truncate to update the
    size as it goes.

Not having this new definition implies that the restore tool might misbehave when
restoring files with an inline extent that got truncated on a kernel older than
release 3.14.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |  3 +--
 ctree.h        | 31 ++++++++++++++++++++++---------
 print-tree.c   |  5 +++--
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 2ecbc94..96b97e1 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -229,8 +229,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	ptr = btrfs_file_extent_inline_start(fi);
-	len = btrfs_file_extent_inline_item_len(leaf,
-					btrfs_item_nr(path->slots[0]));
+	len = btrfs_file_extent_inline_len(leaf, path->slots[0], fi);
 	read_extent_buffer(leaf, buf, ptr, len);
 
 	compress = btrfs_file_extent_compression(leaf, fi);
diff --git a/ctree.h b/ctree.h
index 9b461af..667dc07 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2094,15 +2094,6 @@ BTRFS_SETGET_STACK_FUNCS(stack_qgroup_limit_rsv_referenced,
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_limit_rsv_exclusive,
 			 struct btrfs_qgroup_limit_item, rsv_exclusive, 64);
 
-/* this returns the number of file bytes represented by the inline item.
- * If an item is compressed, this is the uncompressed size
- */
-static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
-					struct btrfs_file_extent_item *e)
-{
-       return btrfs_file_extent_ram_bytes(eb, e);
-}
-
 /*
  * this returns the number of bytes used by the item on disk, minus the
  * size of any extent headers.  If a file is compressed on disk, this is
@@ -2116,6 +2107,28 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
        return btrfs_item_size(eb, e) - offset;
 }
 
+/* this returns the number of file bytes represented by the inline item.
+ * If an item is compressed, this is the uncompressed size
+ */
+static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
+					       int slot,
+					       struct btrfs_file_extent_item *fi)
+{
+	/*
+	 * return the space used on disk if this item isn't
+	 * compressed or encoded
+	 */
+	if (btrfs_file_extent_compression(eb, fi) == 0 &&
+	    btrfs_file_extent_encryption(eb, fi) == 0 &&
+	    btrfs_file_extent_other_encoding(eb, fi) == 0) {
+		return btrfs_file_extent_inline_item_len(eb,
+							 btrfs_item_nr(slot));
+	}
+
+	/* otherwise use the ram bytes field */
+	return btrfs_file_extent_ram_bytes(eb, fi);
+}
+
 static inline u32 btrfs_level_size(struct btrfs_root *root, int level) {
 	if (level == 0)
 		return root->leafsize;
diff --git a/print-tree.c b/print-tree.c
index 9b90f9b..7263b09 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -209,6 +209,7 @@ static void print_uuids(struct extent_buffer *eb)
 
 static void print_file_extent_item(struct extent_buffer *eb,
 				   struct btrfs_item *item,
+				   int slot,
 				   struct btrfs_file_extent_item *fi)
 {
 	int extent_type = btrfs_file_extent_type(eb, fi);
@@ -217,7 +218,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 		printf("\t\tinline extent data size %u "
 		       "ram %u compress %d\n",
 		  btrfs_file_extent_inline_item_len(eb, item),
-		  btrfs_file_extent_inline_len(eb, fi),
+		  btrfs_file_extent_inline_len(eb, slot, fi),
 		  btrfs_file_extent_compression(eb, fi));
 		return;
 	}
@@ -829,7 +830,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
-			print_file_extent_item(l, item, fi);
+			print_file_extent_item(l, item, i, fi);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
-- 
1.9.1

