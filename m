From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: make print-tree.c aware of free space cache
Date: Tue, 13 Mar 2012 22:54:37 +0200
Message-ID: <1331672077-7850-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This adds proper formatting for free space and inode cache items in
btrfs-debug-tree output.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 ctree.h      |   29 +++++++++++++++++++++++++++++
 print-tree.c |   52 +++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/ctree.h b/ctree.h
index 141ec59..147c3cb 100644
--- a/ctree.h
+++ b/ctree.h
@@ -256,6 +256,13 @@ struct btrfs_chunk {
 	/* additional stripes go here */
 } __attribute__ ((__packed__));
 
+struct btrfs_free_space_header {
+	struct btrfs_disk_key location;
+	__le64 generation;
+	__le64 num_entries;
+	__le64 num_bitmaps;
+} __attribute__ ((__packed__));
+
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
 	BUG_ON(num_stripes == 0);
@@ -1432,6 +1439,28 @@ static inline void btrfs_set_dir_item_key(struct extent_buffer *eb,
 	write_eb_member(eb, item, struct btrfs_dir_item, location, key);
 }
 
+/* struct btrfs_free_space_header */
+BTRFS_SETGET_FUNCS(free_space_entries, struct btrfs_free_space_header,
+		   num_entries, 64);
+BTRFS_SETGET_FUNCS(free_space_bitmaps, struct btrfs_free_space_header,
+		   num_bitmaps, 64);
+BTRFS_SETGET_FUNCS(free_space_generation, struct btrfs_free_space_header,
+		   generation, 64);
+
+static inline void btrfs_free_space_key(struct extent_buffer *eb,
+					struct btrfs_free_space_header *h,
+					struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, h, struct btrfs_free_space_header, location, key);
+}
+
+static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
+					    struct btrfs_free_space_header *h,
+					    struct btrfs_disk_key *key)
+{
+	write_eb_member(eb, h, struct btrfs_free_space_header, location, key);
+}
+
 /* struct btrfs_disk_key */
 BTRFS_SETGET_STACK_FUNCS(disk_key_objectid, struct btrfs_disk_key,
 			 objectid, 64);
diff --git a/print-tree.c b/print-tree.c
index fc134c0..face47a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -94,6 +94,7 @@ static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
 	}
 }
+
 static void print_dev_item(struct extent_buffer *eb,
 			   struct btrfs_dev_item *dev_item)
 {
@@ -276,8 +277,29 @@ static void print_root_ref(struct extent_buffer *leaf, int slot, char *tag)
 	       namelen, namebuf);
 }
 
-static void print_key_type(u8 type)
+static void print_free_space_header(struct extent_buffer *leaf, int slot)
 {
+	struct btrfs_free_space_header *header;
+	struct btrfs_disk_key location;
+
+	header = btrfs_item_ptr(leaf, slot, struct btrfs_free_space_header);
+	btrfs_free_space_key(leaf, header, &location);
+	printf("\t\tlocation ");
+	btrfs_print_key(&location);
+	printf("\n");
+	printf("\t\tcache generation %llu entries %llu bitmaps %llu\n",
+	       (unsigned long long)btrfs_free_space_generation(leaf, header),
+	       (unsigned long long)btrfs_free_space_entries(leaf, header),
+	       (unsigned long long)btrfs_free_space_bitmaps(leaf, header));
+}
+
+static void print_key_type(u64 objectid, u8 type)
+{
+	if (type == 0 && objectid == BTRFS_FREE_SPACE_OBJECTID) {
+		printf("UNTYPED");
+		return;
+	}
+
 	switch (type) {
 	case BTRFS_INODE_ITEM_KEY:
 		printf("INODE_ITEM");
@@ -362,10 +384,10 @@ static void print_key_type(u8 type)
 	};
 }
 
-static void print_objectid(unsigned long long objectid, u8 type)
+static void print_objectid(u64 objectid, u8 type)
 {
 	if (type == BTRFS_DEV_EXTENT_KEY) {
-		printf("%llu", objectid); /* device id */
+		printf("%llu", (unsigned long long)objectid); /* device id */
 		return;
 	}
 
@@ -415,6 +437,12 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	case BTRFS_EXTENT_CSUM_OBJECTID:
 		printf("EXTENT_CSUM");
 		break;
+	case BTRFS_FREE_SPACE_OBJECTID:
+		printf("FREE_SPACE");
+		break;
+	case BTRFS_FREE_INO_OBJECTID:
+		printf("FREE_INO");
+		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
 		break;
@@ -425,19 +453,19 @@ static void print_objectid(unsigned long long objectid, u8 type)
 		}
 		/* fall-thru */
 	default:
-		printf("%llu", objectid);
+		printf("%llu", (unsigned long long)objectid);
 	}
 }
 
 void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
-	u8 type;
+	u64 objectid = btrfs_disk_key_objectid(disk_key);
+	u8 type = btrfs_disk_key_type(disk_key);
+
 	printf("key (");
-	type = btrfs_disk_key_type(disk_key);
-	print_objectid((unsigned long long)btrfs_disk_key_objectid(disk_key),
-		type);
+	print_objectid(objectid, type);
 	printf(" ");
-	print_key_type(type);
+	print_key_type(objectid, type);
 	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
 }
 
@@ -460,6 +488,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_block_group_item bg_item;
 	struct btrfs_dir_log_item *dlog;
 	u32 nr = btrfs_header_nritems(l);
+	u64 objectid;
 	u32 type;
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
@@ -472,12 +501,17 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key(l, &disk_key, i);
+		objectid = btrfs_disk_key_objectid(&disk_key);
 		type = btrfs_disk_key_type(&disk_key);
 		printf("\titem %d ", i);
 		btrfs_print_key(&disk_key);
 		printf(" itemoff %d itemsize %d\n",
 			btrfs_item_offset(l, item),
 			btrfs_item_size(l, item));
+
+		if (type == 0 && objectid == BTRFS_FREE_SPACE_OBJECTID)
+			print_free_space_header(l, i);
+
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-- 
1.7.9.1

