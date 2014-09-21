Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47975 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaIUBBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 21:01:34 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so1318388wgg.6
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 18:01:32 -0700 (PDT)
From: Dimitri John Ledkov <xnox@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: Shawn Landen <shawnlandden@gmail.com>,
        Dimitri John Ledkov <xnox@debian.org>
Subject: [PATCH 3/4] Fixing unaligned memory accesses.
Date: Sun, 21 Sep 2014 02:01:21 +0100
Message-Id: <1411261282-26831-3-git-send-email-xnox@debian.org>
In-Reply-To: <1411261282-26831-1-git-send-email-xnox@debian.org>
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Shawn Landen <shawnlandden@gmail.com>

Bug-Debian: http://bugs.debian.org/656955
Signed-off-by: Dimitri John Ledkov <xnox@debian.org>
---
 ctree.h   | 18 ++++++++++++++----
 volumes.c |  5 +++--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index fa73c4a..92c6ad3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -19,6 +19,8 @@
 #ifndef __BTRFS__
 #define __BTRFS__
 
+#include <stdint.h>
+
 #if BTRFS_FLAT_INCLUDES
 #include "list.h"
 #include "kerncompat.h"
@@ -1191,13 +1193,17 @@ struct btrfs_root {
 static inline u##bits btrfs_##name(const struct extent_buffer *eb)	\
 {									\
 	const struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
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
@@ -1219,11 +1225,15 @@ static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
 static inline u##bits btrfs_##name(const type *s)			\
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
index 388c94e..102380b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -472,10 +472,11 @@ static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
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
2.1.0.rc1

