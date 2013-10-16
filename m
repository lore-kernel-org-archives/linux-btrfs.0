Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761010Ab3JPTKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:10:47 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAkHQ009267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:46 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAiSD026570
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:46 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: remove move_pages()
Date: Wed, 16 Oct 2013 12:10:33 -0700
Message-Id: <1381950634-20490-3-git-send-email-zab@redhat.com>
In-Reply-To: <1381950634-20490-1-git-send-email-zab@redhat.com>
References: <1381950634-20490-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

move_pages() has an inefficient backwards byte copy of regions of two
different pages.  They're different pages so the regions won't overlap
and it could use memcpy().

At that point, though, move_pages() would be a slightly dimmer
re-implementation of copy_pages() that lacked the test for overlapping
page regions.

So remove move_pages() and just call copy_pages().

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/extent_io.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c10291c..46a4022 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5093,23 +5093,6 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	}
 }
 
-static void move_pages(struct page *dst_page, struct page *src_page,
-		       unsigned long dst_off, unsigned long src_off,
-		       unsigned long len)
-{
-	char *dst_kaddr = page_address(dst_page);
-	if (dst_page == src_page) {
-		memmove(dst_kaddr + dst_off, dst_kaddr + src_off, len);
-	} else {
-		char *src_kaddr = page_address(src_page);
-		char *p = dst_kaddr + dst_off + len;
-		char *s = src_kaddr + src_off + len;
-
-		while (len--)
-			*--p = *--s;
-	}
-}
-
 static inline bool areas_overlap(unsigned long src, unsigned long dst, unsigned long len)
 {
 	unsigned long distance = (src > dst) ? src - dst : dst - src;
@@ -5220,7 +5203,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 
 		cur = min_t(unsigned long, len, src_off_in_page + 1);
 		cur = min(cur, dst_off_in_page + 1);
-		move_pages(extent_buffer_page(dst, dst_i),
+		copy_pages(extent_buffer_page(dst, dst_i),
 			   extent_buffer_page(dst, src_i),
 			   dst_off_in_page - cur + 1,
 			   src_off_in_page - cur + 1, cur);
-- 
1.7.11.7

