Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:16610 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2GJCWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 22:22:50 -0400
Message-ID: <4FFB91EB.9070305@huawei.com>
Date: Tue, 10 Jul 2012 10:22:35 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: rewrite BTRFS_SETGET_FUNCS
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_SETGET_FUNCS macro is used to generate btrfs_set_foo() and
btrfs_foo() functions, which read and write specific fields in the
extent buffer.

The total number of set/get functions is ~200, but in fact we only
need 8 functions: 2 for u8 field, 2 for u16, 2 for u32 and 2 for u64.

It results in redunction of ~37K bytes.

   text    data     bss     dec     hex filename
 629661   12489     216  642366   9cd3e fs/btrfs/btrfs.o.orig
 592637   12489     216  605342   93c9e fs/btrfs/btrfs.o

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/btrfs/ctree.h        |   53 +++++++++++--
 fs/btrfs/struct-funcs.c |  196 ++++++++++++++++++++++++-----------------------
 2 files changed, 146 insertions(+), 103 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6761490..e262362 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1623,13 +1623,54 @@ static inline void btrfs_init_map_token (struct btrfs_map_token *token)
 			    offsetof(type, member),			\
 			   sizeof(((type *)0)->member)))
 
-#ifndef BTRFS_SETGET_FUNCS
+#define DECLARE_BTRFS_SETGET_BITS(bits)					\
+u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
+			       unsigned long off,			\
+			       struct btrfs_map_token *token);		\
+void btrfs_set_token_##bits(struct extent_buffer *eb, void *ptr,	\
+			    unsigned long off, u##bits val,		\
+			    struct btrfs_map_token *token);		\
+static inline u##bits btrfs_get_##bits(struct extent_buffer *eb, void *ptr, \
+				       unsigned long off)		\
+{									\
+	return btrfs_get_token_##bits(eb, ptr, off, NULL);		\
+}									\
+static inline void btrfs_set_##bits(struct extent_buffer *eb, void *ptr, \
+				    unsigned long off, u##bits val)	\
+{									\
+	btrfs_set_token_##bits(eb, ptr, off, val, NULL);		\
+}
+
+DECLARE_BTRFS_SETGET_BITS(8)
+DECLARE_BTRFS_SETGET_BITS(16)
+DECLARE_BTRFS_SETGET_BITS(32)
+DECLARE_BTRFS_SETGET_BITS(64)
+
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-u##bits btrfs_##name(struct extent_buffer *eb, type *s);		\
-u##bits btrfs_token_##name(struct extent_buffer *eb, type *s, struct btrfs_map_token *token);		\
-void btrfs_set_token_##name(struct extent_buffer *eb, type *s, u##bits val, struct btrfs_map_token *token);\
-void btrfs_set_##name(struct extent_buffer *eb, type *s, u##bits val);
-#endif
+static inline u##bits btrfs_##name(struct extent_buffer *eb, type *s)	\
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
+	return btrfs_get_##bits(eb, s, offsetof(type, member));		\
+}									\
+static inline void btrfs_set_##name(struct extent_buffer *eb, type *s,	\
+				    u##bits val)			\
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
+	btrfs_set_##bits(eb, s, offsetof(type, member), val);		\
+}									\
+static inline u##bits btrfs_token_##name(struct extent_buffer *eb, type *s, \
+					 struct btrfs_map_token *token)	\
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
+	return btrfs_get_token_##bits(eb, s, offsetof(type, member), token); \
+}									\
+static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
+					  type *s, u##bits val,		\
+					  struct btrfs_map_token *token) \
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
+	btrfs_set_token_##bits(eb, s, offsetof(type, member), val, token); \
+}
 
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index c6ffa58..1f4ede9 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -17,15 +17,27 @@
  */
 
 #include <linux/highmem.h>
+#include <asm/unaligned.h>
 
-/* this is some deeply nasty code.  ctree.h has a different
- * definition for this BTRFS_SETGET_FUNCS macro, behind a #ifndef
+#include "ctree.h"
+
+static inline u8 get_unaligned_le8(const void *p)
+{
+	return *(u8 *)p;
+}
+
+static inline void put_unaligned_le8(u8 val, void *p)
+{
+	*(u8 *)p = val;
+}
+
+/*
+ * this is some deeply nasty code.
  *
  * The end result is that anyone who #includes ctree.h gets a
- * declaration for the btrfs_set_foo functions and btrfs_foo functions
- *
- * This file declares the macros and then #includes ctree.h, which results
- * in cpp creating the function here based on the template below.
+ * declaration for the btrfs_set_foo functions and btrfs_foo functions,
+ * which are wappers of btrfs_set_token_#bits functions and
+ * btrfs_get_token_#bits functions, which are defined in this file.
  *
  * These setget functions do all the extent_buffer related mapping
  * required to efficiently read and write specific fields in the extent
@@ -33,103 +45,93 @@
  * an unsigned long offset into the extent buffer which has been
  * cast to a specific type.  This gives us all the gcc type checking.
  *
- * The extent buffer api is used to do all the kmapping and page
- * spanning work required to get extent buffers in highmem and have
- * a metadata blocksize different from the page size.
- *
- * The macro starts with a simple function prototype declaration so that
- * sparse won't complain about it being static.
+ * The extent buffer api is used to do the page spanning work required to
+ * have a metadata blocksize different from the page size.
  */
 
-#define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-u##bits btrfs_##name(struct extent_buffer *eb, type *s);		\
-void btrfs_set_##name(struct extent_buffer *eb, type *s, u##bits val);	\
-void btrfs_set_token_##name(struct extent_buffer *eb, type *s, u##bits val, struct btrfs_map_token *token);	\
-u##bits btrfs_token_##name(struct extent_buffer *eb,				\
-			   type *s, struct btrfs_map_token *token)	\
+#define DEFINE_BTRFS_SETGET_BITS(bits)					\
+u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
+			       unsigned long off,			\
+			       struct btrfs_map_token *token)		\
 {									\
-	unsigned long part_offset = (unsigned long)s;			\
-	unsigned long offset = part_offset + offsetof(type, member);	\
-	type *p;							\
-	int err;						\
-	char *kaddr;						\
-	unsigned long map_start;				\
-	unsigned long map_len;					\
-	unsigned long mem_len = sizeof(((type *)0)->member);	\
-	u##bits res;						\
-	if (token && token->kaddr && token->offset <= offset &&	\
-	    token->eb == eb &&					\
-	   (token->offset + PAGE_CACHE_SIZE >= offset + mem_len)) { \
-		kaddr = token->kaddr;				\
-		p = (type *)(kaddr + part_offset - token->offset);  \
-		res = le##bits##_to_cpu(p->member);		\
-		return res;					\
-	}							\
-	err = map_private_extent_buffer(eb, offset,		\
-			mem_len,				\
-			&kaddr, &map_start, &map_len);		\
-	if (err) {						\
-		__le##bits leres;				\
-		read_eb_member(eb, s, type, member, &leres);	\
-		return le##bits##_to_cpu(leres);		\
-	}							\
-	p = (type *)(kaddr + part_offset - map_start);		\
-	res = le##bits##_to_cpu(p->member);			\
-	if (token) {						\
-		token->kaddr = kaddr;				\
-		token->offset = map_start;			\
-		token->eb = eb;					\
-	}							\
-	return res;						\
+	unsigned long part_offset = (unsigned long)ptr;			\
+	unsigned long offset = part_offset + off;			\
+	void *p;							\
+	int err;							\
+	char *kaddr;							\
+	unsigned long map_start;					\
+	unsigned long map_len;						\
+	int size = sizeof(u##bits);					\
+	u##bits res;							\
+									\
+	if (token && token->kaddr && token->offset <= offset &&		\
+	    token->eb == eb &&						\
+	   (token->offset + PAGE_CACHE_SIZE >= offset + size)) {	\
+		kaddr = token->kaddr;					\
+		p = kaddr + part_offset - token->offset;		\
+		res = get_unaligned_le##bits(p + off);			\
+		return res;						\
+	}								\
+	err = map_private_extent_buffer(eb, offset, size,		\
+					&kaddr, &map_start, &map_len);	\
+	if (err) {							\
+		__le##bits leres;					\
+									\
+		read_extent_buffer(eb, &leres, offset, size);		\
+		return le##bits##_to_cpu(leres);			\
+	}								\
+	p = kaddr + part_offset - map_start;				\
+	res = get_unaligned_le##bits(p + off);				\
+	if (token) {							\
+		token->kaddr = kaddr;					\
+		token->offset = map_start;				\
+		token->eb = eb;						\
+	}								\
+	return res;							\
 }									\
-void btrfs_set_token_##name(struct extent_buffer *eb,				\
-			    type *s, u##bits val, struct btrfs_map_token *token)		\
+void btrfs_set_token_##bits(struct extent_buffer *eb,			\
+			    void *ptr, unsigned long off, u##bits val,	\
+			    struct btrfs_map_token *token)		\
 {									\
-	unsigned long part_offset = (unsigned long)s;			\
-	unsigned long offset = part_offset + offsetof(type, member);	\
-	type *p;							\
-	int err;						\
-	char *kaddr;						\
-	unsigned long map_start;				\
-	unsigned long map_len;					\
-	unsigned long mem_len = sizeof(((type *)0)->member);	\
-	if (token && token->kaddr && token->offset <= offset &&	\
-	    token->eb == eb &&					\
-	   (token->offset + PAGE_CACHE_SIZE >= offset + mem_len)) { \
-		kaddr = token->kaddr;				\
-		p = (type *)(kaddr + part_offset - token->offset);  \
-		p->member = cpu_to_le##bits(val);		\
-		return;						\
-	}							\
-	err = map_private_extent_buffer(eb, offset,		\
-			mem_len,				\
-			&kaddr, &map_start, &map_len);		\
-	if (err) {						\
-		__le##bits val2;				\
-		val2 = cpu_to_le##bits(val);			\
-		write_eb_member(eb, s, type, member, &val2);	\
-		return;						\
-	}							\
-	p = (type *)(kaddr + part_offset - map_start);		\
-	p->member = cpu_to_le##bits(val);			\
-	if (token) {						\
-		token->kaddr = kaddr;				\
-		token->offset = map_start;			\
-		token->eb = eb;					\
-	}							\
-}								\
-void btrfs_set_##name(struct extent_buffer *eb,			\
-		      type *s, u##bits val)			\
-{								\
-	btrfs_set_token_##name(eb, s, val, NULL);		\
-}								\
-u##bits btrfs_##name(struct extent_buffer *eb,			\
-		      type *s)					\
-{								\
-	return btrfs_token_##name(eb, s, NULL);			\
-}								\
+	unsigned long part_offset = (unsigned long)ptr;			\
+	unsigned long offset = part_offset + off;			\
+	void *p;							\
+	int err;							\
+	char *kaddr;							\
+	unsigned long map_start;					\
+	unsigned long map_len;						\
+	int size = sizeof(u##bits);					\
+									\
+	if (token && token->kaddr && token->offset <= offset &&		\
+	    token->eb == eb &&						\
+	   (token->offset + PAGE_CACHE_SIZE >= offset + size)) { 	\
+		kaddr = token->kaddr;					\
+		p = kaddr + part_offset - token->offset;		\
+		put_unaligned_le##bits(val, p + off);			\
+		return;							\
+	}								\
+	err = map_private_extent_buffer(eb, offset, size,		\
+			&kaddr, &map_start, &map_len);			\
+	if (err) {							\
+		__le##bits val2;					\
+									\
+		val2 = cpu_to_le##bits(val);				\
+		write_extent_buffer(eb, &val2, offset, size);		\
+		return;							\
+	}								\
+	p = kaddr + part_offset - map_start;				\
+	put_unaligned_le##bits(val, p + off);				\
+	if (token) {							\
+		token->kaddr = kaddr;					\
+		token->offset = map_start;				\
+		token->eb = eb;						\
+	}								\
+}
 
-#include "ctree.h"
+DEFINE_BTRFS_SETGET_BITS(8)
+DEFINE_BTRFS_SETGET_BITS(16)
+DEFINE_BTRFS_SETGET_BITS(32)
+DEFINE_BTRFS_SETGET_BITS(64)
 
 void btrfs_node_key(struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr)
-- 
1.7.9.7
