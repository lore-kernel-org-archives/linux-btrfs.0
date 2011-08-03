From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: rewrite BTRFS_SETGET_FUNCS macro
Date: Wed, 03 Aug 2011 16:12:05 +0800
Message-ID: <4E3902D5.6020600@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_SETGET_FUNCS macro is used to generate btrfs_set_foo() and
btrfs_foo() functions, which read and write specific fields in the
extent buffer.

The total number of set/get functions is ~200, but in fact we only
need 8 functions: 2 for u8 field, 2 for u16, 2 for u32 and 2 for u64.

It results in redunction of ~22K bytes.

   text    data     bss     dec     hex filename
 528069    4328    1060  533457   823d1 fs/btrfs/btrfs.o.orig
 505997    4328    1060  511385   7cd99 fs/btrfs/btrfs.o

Compared btrfs_set_bits() with btrfs_set_foo(), the extra runtime overhead
is we have to pass one more argument.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        |   26 +++++++++--
 fs/btrfs/struct-funcs.c |  118 ++++++++++++++++++++++++-----------------------
 2 files changed, 83 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 746e6b4..fae542e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1406,11 +1406,29 @@ struct btrfs_ioctl_defrag_range_args {
 			    offsetof(type, member),			\
 			   sizeof(((type *)0)->member)))
 
-#ifndef BTRFS_SETGET_FUNCS
+#define DECLARE_BTRFS_SETGET_BITS(bits)					\
+u##bits btrfs_get_u##bits(struct extent_buffer *eb, void *ptr,		\
+			  unsigned long off);				\
+void btrfs_set_u##bits(struct extent_buffer *eb, void *ptr,		\
+		       unsigned long off, u##bits val)
+
+DECLARE_BTRFS_SETGET_BITS(8);
+DECLARE_BTRFS_SETGET_BITS(16);
+DECLARE_BTRFS_SETGET_BITS(32);
+DECLARE_BTRFS_SETGET_BITS(64);
+
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-u##bits btrfs_##name(struct extent_buffer *eb, type *s);		\
-void btrfs_set_##name(struct extent_buffer *eb, type *s, u##bits val);
-#endif
+static inline u##bits btrfs_##name(struct extent_buffer *eb, type *s)	\
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0)->member));	\
+	return btrfs_get_u##bits(eb, s, offsetof(type, member));	\
+}									\
+static inline void btrfs_set_##name(struct extent_buffer *eb, type *s,	\
+				    u##bits val)			\
+{									\
+	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
+	btrfs_set_u##bits(eb, s, offsetof(type, member), val);		\
+}
 
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index bc1f6ad..9f76745 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -17,80 +17,84 @@
  */
 
 #include <linux/highmem.h>
+#include <asm/unaligned.h>
 
-/* this is some deeply nasty code.  ctree.h has a different
- * definition for this BTRFS_SETGET_FUNCS macro, behind a #ifndef
- *
- * The end result is that anyone who #includes ctree.h gets a
- * declaration for the btrfs_set_foo functions and btrfs_foo functions
- *
- * This file declares the macros and then #includes ctree.h, which results
- * in cpp creating the function here based on the template below.
- *
+#include "ctree.h"
+
+/*
  * These setget functions do all the extent_buffer related mapping
  * required to efficiently read and write specific fields in the extent
  * buffers.  Every pointer to metadata items in btrfs is really just
  * an unsigned long offset into the extent buffer which has been
  * cast to a specific type.  This gives us all the gcc type checking.
  *
- * The extent buffer api is used to do all the kmapping and page
- * spanning work required to get extent buffers in highmem and have
- * a metadata blocksize different from the page size.
+ * The extent buffer api is used to do the page spanning work required
+ * to have a metadata blocksize different from the page size.
  *
  * The macro starts with a simple function prototype declaration so that
  * sparse won't complain about it being static.
  */
 
-#define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-u##bits btrfs_##name(struct extent_buffer *eb, type *s);		\
-void btrfs_set_##name(struct extent_buffer *eb, type *s, u##bits val);	\
-u##bits btrfs_##name(struct extent_buffer *eb,				\
-				   type *s)				\
+#define DEFINE_BTRFS_SETGET_BITS(bits)					\
+u##bits btrfs_get_u##bits(struct extent_buffer *eb, void *ptr,		\
+			  unsigned long off);				\
+void btrfs_set_u##bits(struct extent_buffer *eb, void *ptr,		\
+		       unsigned long off, u##bits val);			\
+u##bits btrfs_get_u##bits(struct extent_buffer *eb, void *ptr,		\
+			  unsigned long off)				\
 {									\
-	unsigned long part_offset = (unsigned long)s;			\
-	unsigned long offset = part_offset + offsetof(type, member);	\
-	type *p;							\
-	int err;						\
-	char *kaddr;						\
-	unsigned long map_start;				\
-	unsigned long map_len;					\
-	u##bits res;						\
-	err = map_private_extent_buffer(eb, offset,		\
-			sizeof(((type *)0)->member),		\
-			&kaddr, &map_start, &map_len);		\
-	if (err) {						\
-		__le##bits leres;				\
-		read_eb_member(eb, s, type, member, &leres);	\
-		return le##bits##_to_cpu(leres);		\
-	}							\
-	p = (type *)(kaddr + part_offset - map_start);		\
-	res = le##bits##_to_cpu(p->member);			\
-	return res;						\
+	unsigned long part_offset = (unsigned long)ptr;			\
+	unsigned long offset = part_offset + off;			\
+	void *p;							\
+	int err;							\
+	char *kaddr;							\
+	unsigned long map_start;					\
+	unsigned long map_len;						\
+	u##bits res;							\
+	int size = sizeof(u##bits);					\
+									\
+	err = map_private_extent_buffer(eb, offset, size,		\
+					&kaddr, &map_start, &map_len);	\
+	if (err) {							\
+		__le##bits leres;					\
+									\
+		read_extent_buffer(eb, &leres, offset, size);		\
+		return le##bits##_to_cpu(leres);			\
+	}								\
+									\
+	p = kaddr + part_offset - map_start;				\
+	res = get_unaligned((u##bits *)(p + off));			\
+	return res;							\
 }									\
-void btrfs_set_##name(struct extent_buffer *eb,				\
-				    type *s, u##bits val)		\
+void btrfs_set_u##bits(struct extent_buffer *eb, void *ptr,		\
+		       unsigned long off, u##bits val)			\
 {									\
-	unsigned long part_offset = (unsigned long)s;			\
-	unsigned long offset = part_offset + offsetof(type, member);	\
-	type *p;							\
-	int err;						\
-	char *kaddr;						\
-	unsigned long map_start;				\
-	unsigned long map_len;					\
-	err = map_private_extent_buffer(eb, offset,		\
-			sizeof(((type *)0)->member),		\
-			&kaddr, &map_start, &map_len);		\
-	if (err) {						\
-		__le##bits val2;				\
-		val2 = cpu_to_le##bits(val);			\
-		write_eb_member(eb, s, type, member, &val2);	\
-		return;						\
-	}							\
-	p = (type *)(kaddr + part_offset - map_start);		\
-	p->member = cpu_to_le##bits(val);			\
+	unsigned long part_offset = (unsigned long)ptr;			\
+	unsigned long offset = part_offset + off;			\
+	void *p;							\
+	int err;							\
+	char *kaddr;							\
+	unsigned long map_start;					\
+	unsigned long map_len;						\
+	int size = sizeof(u##bits);					\
+									\
+	err = map_private_extent_buffer(eb, offset, size,		\
+					&kaddr, &map_start, &map_len);	\
+	if (err) {							\
+		__le##bits val2;					\
+									\
+		val2 = cpu_to_le##bits(val);				\
+		write_extent_buffer(eb, &val2, offset, size);		\
+	} else {							\
+		p = kaddr + part_offset - map_start;			\
+		put_unaligned(val, (u##bits *)(p + off));		\
+	}								\
 }
 
-#include "ctree.h"
+DEFINE_BTRFS_SETGET_BITS(8);
+DEFINE_BTRFS_SETGET_BITS(16);
+DEFINE_BTRFS_SETGET_BITS(32);
+DEFINE_BTRFS_SETGET_BITS(64);
 
 void btrfs_node_key(struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr)
-- 
1.7.3.1
