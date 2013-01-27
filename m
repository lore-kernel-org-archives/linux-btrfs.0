Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kepler.killerwolves.net ([103.4.235.74]:59918 "EHLO
	kepler.killerwolves.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3A0Gn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 01:43:26 -0500
From: Ben Peddell <klightspeed@killerwolves.net>
To: linux-btrfs@vger.kernel.org
Date: Sun, 27 Jan 2013 15:45:43 +1000
Subject: [PATCH] btrfs-progs: fix unaligned accesses v2
Message-Id: <20130127063404.6B61CF4275@kepler.killerwolves.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gcc optimizes out the memcpy calls at -O2 and -Os.

Replacing memcpy with memmove does't work - gcc treats memmove
the same way it treats memcpy.

This patch brings in {get|put}_unaligned_le{16|32|64} (using the
packed struct method), and uses them in the failing get/set calls.

On architectures where unaligned accesses are cheap, these unaligned
macros should be optimized out by the compiler.

Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
---
 ctree.h      |    8 ++------
 kerncompat.h |   13 +++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 0675989..1f5a795 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1086,19 +1086,15 @@ static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
 				   type *s)				\
 {									\
 	unsigned long offset = (unsigned long)s;			\
-	u##bits m;							\
 	type *p = (type *) (eb->data + offset);				\
-	memcpy(&m, &p->member, sizeof(m));				\
-	return le##bits##_to_cpu(m);					\
+	return get_unaligned_le##bits(&p->member);			\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    type *s, u##bits val)		\
 {									\
 	unsigned long offset = (unsigned long)s;			\
-	u##bits m;							\
 	type *p = (type *) (eb->data + offset);				\
-	m = cpu_to_le##bits(val);					\
-	memcpy(&p->member, &m, sizeof(m));				\
+	put_unaligned_le##bits(val, &p->member);			\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
diff --git a/kerncompat.h b/kerncompat.h
index d60f722..a38a9b0 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -267,6 +267,19 @@ typedef u64 __bitwise __be64;
 #define cpu_to_le16(x) ((__force __le16)(u16)(x))
 #define le16_to_cpu(x) ((__force u16)(__le16)(x))
 #endif
+
+struct __una_u16 { u16 x; } __attribute__((__packed__));
+struct __una_u32 { u32 x; } __attribute__((__packed__));
+struct __una_u64 { u64 x; } __attribute__((__packed__));
+
+#define get_unaligned_le8(p) (*((u8 *)(p)))
+#define put_unaligned_le8(val,p) ((*((u8 *)(p))) = (val))
+#define get_unaligned_le16(p) le16_to_cpu(((const struct __una_u16 *)(p))->x)
+#define put_unaligned_le16(val,p) (((struct __una_u16 *)(p))->x = cpu_to_le16(val))
+#define get_unaligned_le32(p) le32_to_cpu(((const struct __una_u32 *)(p))->x)
+#define put_unaligned_le32(val,p) (((struct __una_u32 *)(p))->x = cpu_to_le32(val))
+#define get_unaligned_le64(p) le64_to_cpu(((const struct __una_u64 *)(p))->x)
+#define put_unaligned_le64(val,p) (((struct __una_u64 *)(p))->x = cpu_to_le64(val))
 #endif
 
 #ifndef noinline
-- 
1.7.3.4

