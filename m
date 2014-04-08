Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ae2-f132.auone-net.jp ([111.87.219.132]:51336 "EHLO
	dmta02.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756351AbaDHNrT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 09:47:19 -0400
Received: from amlmta031.auone-net.jp (amlmta031-MM [10.188.22.11])
	by dmta02.auone-net.jp (au one net mail) with ESMTP id EC60040013E
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Apr 2014 22:37:39 +0900 (JST)
Date: Tue, 8 Apr 2014 22:37:39 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Constify getters
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <5343fba300097b1000000e9600001608fc000431297f@amlmta031.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 ctree.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 9b461af..45f2faf 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1184,9 +1184,9 @@ struct btrfs_root {
 			   sizeof(((type *)0)->member)))
 
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb)	\
 {									\
-	struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
+	const struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
 	return le##bits##_to_cpu(h->member);				\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
@@ -1197,11 +1197,11 @@ static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 }
 
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
-				   type *s)				\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb,	\
+				   const type *s)			\
 {									\
 	unsigned long offset = (unsigned long)s;			\
-	type *p = (type *) (eb->data + offset);				\
+	const type *p = (type *) (eb->data + offset);			\
 	return get_unaligned_le##bits(&p->member);			\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
@@ -1213,7 +1213,7 @@ static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(type *s)				\
+static inline u##bits btrfs_##name(const type *s)			\
 {									\
 	return le##bits##_to_cpu(s->member);				\
 }									\
-- 
1.9.1

