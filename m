Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61538 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab3EVFIp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 01:08:45 -0400
Received: from [192.168.226.189] ([77.119.226.254]) by smtp.web.de (mrweb003)
 with ESMTPSA (Nemesis) id 0LbrTY-1UDhIO0LYK-00jSCL for
 <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 07:08:44 +0200
Message-ID: <519C52DA.9080000@web.de>
Date: Wed, 22 May 2013 07:08:42 +0200
From: Holger Fischer <hoo.mb@web.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-tools: debian/patches/09-unaligned-memaccess.patch
Content-Type: multipart/mixed;
 boundary="------------000205050306010102000803"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000205050306010102000803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear BTRFS-Community,
attached is a patch that probably could be applied upstream:
It is ... Fixing unaligned memory accesses ...
Details to this patch could be read under
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=656955

I rechecked against latest git.
As far as I can see, it's not applied yet.


Best Regards
Holger Fischer

--------------000205050306010102000803
Content-Type: text/x-diff;
 name="09-unaligned-memaccess.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="09-unaligned-memaccess.patch"

Author: Shawn Landen <shawnlandden@gmail.com>
Description: Fixing unaligned memory accesses (Closes: #656955).

Index: b/ctree.h
===================================================================
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
@@ -1072,13 +1074,17 @@ struct btrfs_root {
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
@@ -1104,11 +1110,15 @@ static inline void btrfs_set_##name(stru
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
Index: b/volumes.c
===================================================================
--- a/volumes.c
+++ b/volumes.c
@@ -425,10 +425,11 @@ static int find_next_chunk(struct btrfs_
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

--------------000205050306010102000803--
