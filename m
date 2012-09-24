Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44778 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2IXEiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 00:38:17 -0400
Message-ID: <505FE3AF.2090302@gmail.com>
Date: Mon, 24 Sep 2012 12:38:07 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, jbacik@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Btrfs: check range early in map_private_extent_buffer
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check range early to avoid further check/compute in case
of range error.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..9250cf5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4643,6 +4643,14 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	unsigned long end_i = (start_offset + start + min_len - 1) >>
 		PAGE_CACHE_SHIFT;
 
+	if (start + min_len > eb->len) {
+		printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
+		       "wanted %lu %lu\n", (unsigned long long)eb->start,
+		       eb->len, start, min_len);
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	if (i != end_i)
 		return -EINVAL;
 
@@ -4654,14 +4662,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 		*map_start = ((u64)i << PAGE_CACHE_SHIFT) - start_offset;
 	}
 
-	if (start + min_len > eb->len) {
-		printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
-		       "wanted %lu %lu\n", (unsigned long long)eb->start,
-		       eb->len, start, min_len);
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
 	p = extent_buffer_page(eb, i);
 	kaddr = page_address(p);
 	*map = kaddr + offset;
-- 
1.7.1

