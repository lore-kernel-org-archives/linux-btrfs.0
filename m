Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38169 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbeC0GEt (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Mar 2018 02:04:49 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs-progs: print-tree: Use macro to replace immediate number for readable flags string buffer length
Date: Tue, 27 Mar 2018 14:04:30 +0800
Message-Id: <20180327060430.22836-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In print-tree, we have a lot of parsers to convert numeric flags to
human readable string.

For the buffer size we're using immediate numbers for all their callers.
Change this to macro so it will be much easier for us to expand the
buffer size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Move all buffer length macros to the header part.
  Change comment to refer to the buffer length marco for later
  modication.
---
 print-tree.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a2f6bfc027c9..064f1bb9ff8c 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -26,6 +26,12 @@
 #include "print-tree.h"
 #include "utils.h"
 
+#define BG_FLAGS_BUF_LEN	64	/* for bg_flags_to_str() */
+#define QGROUP_FLAGS_BUF_LEN	32	/* for qgroup_flags_to_str() */
+#define EXTENT_FLAGS_BUF_LEN	32	/* for extent_flags_to_str() */
+#define ROOT_FLAGS_BUF_LEN	16	/* for root_flags_to_str() */
+#define INODE_FLAGS_BUF_LEN	128	/* for inode_flags_to_str() */
+#define HEADER_FLAGS_BUF_LEN	32	/* for header_flags_to_str() */
 
 static void print_dir_item_type(struct extent_buffer *eb,
                                 struct btrfs_dir_item *di)
@@ -137,7 +143,13 @@ static void print_inode_ref_item(struct extent_buffer *eb, u32 size,
 	}
 }
 
-/* Caller should ensure sizeof(*ret)>=21 "DATA|METADATA|RAID10" */
+/*
+ * Caller should ensure sizeof(*ret)>=21 "DATA|METADATA|RAID10"
+ * Here we bump up to 64 bytes to handle the worst (and invalid) case:
+ * "DATA|METADATA|SYSTEM|RAID0|RAID1|DUP|RAID10|RAID5|RAID6"
+ *
+ * BG_FLAGS_BUF_LEN is ensured to have enough space.
+ */
 static void bg_flags_to_str(u64 flags, char *ret)
 {
 	int empty = 1;
@@ -180,7 +192,11 @@ static void bg_flags_to_str(u64 flags, char *ret)
 	}
 }
 
-/* Caller should ensure sizeof(*ret)>= 26 "OFF|SCANNING|INCONSISTENT" */
+/*
+ * Caller should ensure sizeof(*ret)>= 26 "OFF|SCANNING|INCONSISTENT"
+ *
+ * QGROUP_FLAGS_BUF_LEN is ensured to have enough space.
+ */
 static void qgroup_flags_to_str(u64 flags, char *ret)
 {
 	if (flags & BTRFS_QGROUP_STATUS_FLAG_ON)
@@ -199,7 +215,7 @@ void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	u16 num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
 	u32 chunk_item_size;
-	char chunk_flags_str[32] = {0};
+	char chunk_flags_str[BG_FLAGS_BUF_LEN] = {0};
 
 	/* The chunk must contain at least one stripe */
 	if (num_stripes < 1) {
@@ -385,7 +401,11 @@ static void print_file_extent_item(struct extent_buffer *eb,
 			compress_str);
 }
 
-/* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
+/*
+ * Caller should ensure sizeof(*ret) > strlen("DATA|TREE_BLOCK|FULL_BACKREF")
+ *
+ * EXTENT_FLAGS_BUF_LEN is ensured to have enough space.
+ */
 static void extent_flags_to_str(u64 flags, char *ret)
 {
 	int empty = 1;
@@ -420,7 +440,7 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
-	char flags_str[32] = {0};
+	char flags_str[EXTENT_FLAGS_BUF_LEN] = {0};
 
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -542,6 +562,8 @@ static int empty_uuid(const u8 *uuid)
 
 /*
  * Caller must ensure sizeof(*ret) >= 7 "RDONLY"
+ *
+ * ROOT_FLAGS_BUF_LEN is ensured to have enough space
  */
 static void root_flags_to_str(u64 flags, char *ret)
 {
@@ -577,7 +599,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	struct btrfs_root_item root_item;
 	int len;
 	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
-	char flags_str[32] = {0};
+	char flags_str[ROOT_FLAGS_BUF_LEN] = {0};
 	struct btrfs_key drop_key;
 
 	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
@@ -887,6 +909,8 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 /*
  * Caller should ensure sizeof(*ret) >= 102: all charactors plus '|' of
  * BTRFS_INODE_* flags
+ *
+ * INODE_FLAGS_BUF_LEN is ensured to have enough space
  */
 static void inode_flags_to_str(u64 flags, char *ret)
 {
@@ -911,7 +935,7 @@ static void inode_flags_to_str(u64 flags, char *ret)
 static void print_inode_item(struct extent_buffer *eb,
 		struct btrfs_inode_item *ii)
 {
-	char flags_str[256];
+	char flags_str[INODE_FLAGS_BUF_LEN];
 
 	memset(flags_str, 0, sizeof(flags_str));
 	inode_flags_to_str(btrfs_inode_flags(eb, ii), flags_str);
@@ -1002,7 +1026,7 @@ static void print_block_group_item(struct extent_buffer *eb,
 		struct btrfs_block_group_item *bgi)
 {
 	struct btrfs_block_group_item bg_item;
-	char flags_str[256];
+	char flags_str[BG_FLAGS_BUF_LEN];
 
 	read_extent_buffer(eb, &bg_item, (unsigned long)bgi, sizeof(bg_item));
 	memset(flags_str, 0, sizeof(flags_str));
@@ -1070,7 +1094,7 @@ static void print_dev_extent(struct extent_buffer *eb, int slot)
 static void print_qgroup_status(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_qgroup_status_item *qg_status;
-	char flags_str[256];
+	char flags_str[QGROUP_FLAGS_BUF_LEN];
 
 	qg_status = btrfs_item_ptr(eb, slot, struct btrfs_qgroup_status_item);
 	memset(flags_str, 0, sizeof(flags_str));
@@ -1157,7 +1181,11 @@ static void print_extent_csum(struct extent_buffer *eb,
 			(unsigned long long)start + size, size);
 }
 
-/* Caller must ensure sizeof(*ret) >= 14 "WRITTEN|RELOC" */
+/*
+ * Caller must ensure sizeof(*ret) >= 14 "WRITTEN|RELOC"
+ *
+ * HEADER_FLAGS_BUF_LEN is ensured to have enough space.
+ */
 static void header_flags_to_str(u64 flags, char *ret)
 {
 	int empty = 1;
@@ -1177,7 +1205,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 {
 	struct btrfs_item *item;
 	struct btrfs_disk_key disk_key;
-	char flags_str[128];
+	char flags_str[HEADER_FLAGS_BUF_LEN];
 	u32 i;
 	u32 nr;
 	u64 flags;
-- 
2.16.2

