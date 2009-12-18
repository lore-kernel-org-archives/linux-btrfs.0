From: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Simplify offset calculation method for ctree.h
Date: Fri, 18 Dec 2009 09:30:52 +0800
Message-ID: <4B2ADB4C.7010900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: LKML <linux-kernel@vger.kernel.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Use simple struct operation instead of address calculation.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |   46 ++++++++++++++--------------------------------
 1 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e5dd628..44a3e98 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1264,12 +1264,12 @@ BTRFS_SETGET_STACK_FUNCS(stack_device_generation, struct btrfs_dev_item,
 
 static inline char *btrfs_device_uuid(struct btrfs_dev_item *d)
 {
-	return (char *)d + offsetof(struct btrfs_dev_item, uuid);
+	return (char *)&d->uuid;
 }
 
 static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
 {
-	return (char *)d + offsetof(struct btrfs_dev_item, fsid);
+	return (char *)&d->fsid;
 }
 
 BTRFS_SETGET_FUNCS(chunk_length, struct btrfs_chunk, length, 64);
@@ -1286,7 +1286,7 @@ BTRFS_SETGET_FUNCS(stripe_offset, struct btrfs_stripe, offset, 64);
 
 static inline char *btrfs_stripe_dev_uuid(struct btrfs_stripe *s)
 {
-	return (char *)s + offsetof(struct btrfs_stripe, dev_uuid);
+	return (char *)&s->dev_uuid;
 }
 
 BTRFS_SETGET_STACK_FUNCS(stack_chunk_length, struct btrfs_chunk, length, 64);
@@ -1310,10 +1310,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_stripe_offset, struct btrfs_stripe, offset, 64);
 static inline struct btrfs_stripe *btrfs_stripe_nr(struct btrfs_chunk *c,
 						   int nr)
 {
-	unsigned long offset = (unsigned long)c;
-	offset += offsetof(struct btrfs_chunk, stripe);
-	offset += nr * sizeof(struct btrfs_stripe);
-	return (struct btrfs_stripe *)offset;
+	return &c->stripe + nr;
 }
 
 static inline char *btrfs_stripe_dev_uuid_nr(struct btrfs_chunk *c, int nr)
@@ -1383,33 +1380,25 @@ BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
 {
-	unsigned long ptr = (unsigned long)inode_item;
-	ptr += offsetof(struct btrfs_inode_item, atime);
-	return (struct btrfs_timespec *)ptr;
+	return &inode_item->atime;
 }
 
 static inline struct btrfs_timespec *
 btrfs_inode_mtime(struct btrfs_inode_item *inode_item)
 {
-	unsigned long ptr = (unsigned long)inode_item;
-	ptr += offsetof(struct btrfs_inode_item, mtime);
-	return (struct btrfs_timespec *)ptr;
+	return &inode_item->mtime;
 }
 
 static inline struct btrfs_timespec *
 btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
 {
-	unsigned long ptr = (unsigned long)inode_item;
-	ptr += offsetof(struct btrfs_inode_item, ctime);
-	return (struct btrfs_timespec *)ptr;
+	return &inode_item->ctime;
 }
 
 static inline struct btrfs_timespec *
 btrfs_inode_otime(struct btrfs_inode_item *inode_item)
 {
-	unsigned long ptr = (unsigned long)inode_item;
-	ptr += offsetof(struct btrfs_inode_item, otime);
-	return (struct btrfs_timespec *)ptr;
+	return &inode_item->otime;
 }
 
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
@@ -1426,8 +1415,7 @@ BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
 
 static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 {
-	unsigned long ptr = offsetof(struct btrfs_dev_extent, chunk_tree_uuid);
-	return (u8 *)((unsigned long)dev + ptr);
+	return (u8 *)&dev->chunk_tree_uuid;
 }
 
 BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 64);
@@ -1731,26 +1719,22 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 
 static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, fsid);
-	return (u8 *)ptr;
+	return (u8 *)offsetof(struct btrfs_header, fsid);
 }
 
 static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, chunk_tree_uuid);
-	return (u8 *)ptr;
+	return (u8 *)offsetof(struct btrfs_header, chunk_tree_uuid);
 }
 
 static inline u8 *btrfs_super_fsid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_super_block, fsid);
-	return (u8 *)ptr;
+	return (u8 *)offsetof(struct btrfs_super_block, fsid);
 }
 
 static inline u8 *btrfs_header_csum(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, csum);
-	return (u8 *)ptr;
+	return (u8 *)offsetof(struct btrfs_header, csum);
 }
 
 static inline struct btrfs_node *btrfs_buffer_node(struct extent_buffer *eb)
@@ -1858,9 +1842,7 @@ BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 static inline unsigned long
 btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
 {
-	unsigned long offset = (unsigned long)e;
-	offset += offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return offset;
+	return (unsigned long)&e->disk_bytenr;
 }
 
 static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
-- 
1.5.5.3


