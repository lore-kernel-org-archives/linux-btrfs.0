Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2GGBht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2012 21:37:49 -0400
Received: by pbbrp8 with SMTP id rp8so15504798pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jul 2012 18:37:49 -0700 (PDT)
From: Shawn Landden <shawnlandden@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Shawn Landen <shawnlandden@gmail.com>
Subject: [PATCH] fix unaligned memory accesses (Closes: #656955)
Date: Fri,  6 Jul 2012 18:37:42 -0700
Message-Id: <1341625062-13044-1-git-send-email-shawnlandden@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Shawn Landen <shawnlandden@gmail.com>

Fix creation of volumes using mkfs.btrfs on armv5.

Signed-off-by: Shawn Landen <shawnlandden@gmail.com>
---
 ctree.h   |   26 ++++++++++++++++++++------
 volumes.c |    5 +++--
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/ctree.h b/ctree.h
index 6545c50..ef3f0cc 100644
--- a/ctree.h
+++ b/ctree.h
@@ -19,6 +19,8 @@
 #ifndef __BTRFS__
 #define __BTRFS__
 
+#include <stdint.h>
+
 #include "list.h"
 #include "kerncompat.h"
 #include "radix-tree.h"
@@ -970,13 +972,17 @@ struct btrfs_root {
 static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
 {									\
 	struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
-	return le##bits##_to_cpu(h->member);				\
+	uint##bits##_t t;						\
+	memcpy(&t, &h->member, sizeof(h->member));			\
+	return le##bits##_to_cpu(t);					\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    u##bits val)			\
 {									\
 	struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
-	h->member = cpu_to_le##bits(val);				\
+	uint##bits##_t t;						\
+	t = cpu_to_le##bits(val);					\
+	memcpy(&h->member, &t, sizeof(h->member));			\
 }
 
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
@@ -984,25 +990,33 @@ static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
 				   type *s)				\
 {									\
 	unsigned long offset = (unsigned long)s;			\
+	uint##bits##_t t;						\
 	type *p = (type *) (eb->data + offset);				\
-	return le##bits##_to_cpu(p->member);				\
+	memcpy(&t, &p->member, sizeof(p->member));			\
+	return le##bits##_to_cpu(t);					\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    type *s, u##bits val)		\
 {									\
 	unsigned long offset = (unsigned long)s;			\
+	uint##bits##_t t;						\
 	type *p = (type *) (eb->data + offset);				\
-	p->member = cpu_to_le##bits(val);				\
+	t = cpu_to_le##bits(val);					\
+	memcpy(&p->member, &t, sizeof(p->member));			\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(type *s)				\
 {									\
-	return le##bits##_to_cpu(s->member);				\
+	uint##bits##_t t;						\
+	memcpy(&t, &s->member, sizeof(s->member));			\
+	return le##bits##_to_cpu(t);					\
 }									\
 static inline void btrfs_set_##name(type *s, u##bits val)		\
 {									\
-	s->member = cpu_to_le##bits(val);				\
+	uint##bits##_t t;						\
+	t = cpu_to_le##bits(val);					\
+	memcpy(&s->member, &t, sizeof(s->member));			\
 }
 
 BTRFS_SETGET_FUNCS(device_type, struct btrfs_dev_item, type, 64);
diff --git a/volumes.c b/volumes.c
index 8dca5e1..0401eeb 100644
--- a/volumes.c
+++ b/volumes.c
@@ -425,10 +425,11 @@ static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
 		if (found_key.objectid != objectid)
 			*offset = 0;
 		else {
+			u64 t;
 			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
 					       struct btrfs_chunk);
-			*offset = found_key.offset +
-				btrfs_chunk_length(path->nodes[0], chunk);
+			t = found_key.offset + btrfs_chunk_length(path->nodes[0], chunk);
+			memcpy(offset, &t, sizeof(found_key.offset));
 		}
 	}
 	ret = 0;
-- 
1.7.10.4

