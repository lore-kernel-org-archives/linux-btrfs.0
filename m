From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs-progs: Update for new inode number allocator
Date: Wed, 26 Jan 2011 09:53:04 +0800
Message-ID: <4D3F7E80.5080300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- Create an initial ino extent in the fs tree.
- Add debug code to btrfs-debug-tree command.

Singed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 ctree.h      |    2 ++
 mkfs.c       |   16 ++++++++++++++++
 print-tree.c |   23 ++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/ctree.h b/ctree.h
index b79e238..997cff0 100644
--- a/ctree.h
+++ b/ctree.h
@@ -849,6 +849,8 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_INO_EXTENT_KEY	230
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..8bebb05 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -69,6 +69,18 @@ static u64 parse_size(char *s)
 	return atol(s) * mult;
 }
 
+static int insert_ino_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
+{
+	struct btrfs_key key;
+
+	key.objectid = (BTRFS_FIRST_FREE_OBJECTID + 1) + ((u64)1 << 63);
+	key.type = BTRFS_INO_EXTENT_KEY;
+	key.offset = BTRFS_LAST_FREE_OBJECTID;
+
+	return btrfs_insert_item(trans, root, &key, NULL, 0);
+}
+
 static int make_root_dir(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
@@ -135,6 +147,10 @@ static int make_root_dir(struct btrfs_root *root)
 	if (ret)
 		goto err;
 
+	ret = insert_ino_extent(trans, root);
+	if (ret)
+		goto err;
+
 	btrfs_commit_transaction(trans, root);
 err:
 	return ret;
diff --git a/print-tree.c b/print-tree.c
index ac575d5..b6d5dc9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -351,6 +351,9 @@ static void print_key_type(u8 type)
 	case BTRFS_DEV_EXTENT_KEY:
 		printf("DEV_EXTENT");
 		break;
+	case BTRFS_INO_EXTENT_KEY:
+		printf("INO_EXTENT");
+		break;
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
@@ -364,6 +367,9 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	if (type == BTRFS_DEV_EXTENT_KEY) {
 		printf("%llu", objectid); /* device id */
 		return;
+	} else if (type == BTRFS_INO_EXTENT_KEY) {
+		printf("%llu", objectid - ((u64)1 << 63));
+		return;
 	}
 
 	switch (objectid) {
@@ -423,16 +429,28 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	}
 }
 
+static void print_key_offset(unsigned long long offset, u8 type)
+{
+	if (type == BTRFS_INO_EXTENT_KEY)
+		printf("%llu", offset - ((u64)1 << 63));
+	else
+		printf("%llu", offset);
+}
+
 void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
 	u8 type;
+
 	printf("key (");
 	type = btrfs_disk_key_type(disk_key);
 	print_objectid((unsigned long long)btrfs_disk_key_objectid(disk_key),
 		type);
 	printf(" ");
 	print_key_type(type);
-	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
+	printf(" ");
+	print_key_offset((unsigned long long)btrfs_disk_key_offset(disk_key),
+		type);
+	printf(")");
 }
 
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
@@ -600,6 +618,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
 			break;
+		case BTRFS_INO_EXTENT_KEY:
+			/* The item of this type has no data */
+			break;
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
-- 1.6.3 
