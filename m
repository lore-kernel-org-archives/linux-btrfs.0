Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:58222 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2I2IH6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 04:07:58 -0400
Received: by dady13 with SMTP id y13so899022dad.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 01:07:58 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 2/2] btrfs: move inline function code to header file
Date: Sat, 29 Sep 2012 16:07:47 +0800
Message-Id: <1348906067-9348-2-git-send-email-robin.k.dong@gmail.com>
In-Reply-To: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
References: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When building btrfs from kernel code, it will report:

	fs/btrfs/extent_io.h:281: warning: 'extent_buffer_page' declared inline after being called
	fs/btrfs/extent_io.h:281: warning: previous declaration of 'extent_buffer_page' was here
	fs/btrfs/extent_io.h:280: warning: 'num_extent_pages' declared inline after being called
	fs/btrfs/extent_io.h:280: warning: previous declaration of 'num_extent_pages' was here

because of the wrong declaration of inline functions.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/btrfs/extent_io.c |   12 ------------
 fs/btrfs/extent_io.h |   14 ++++++++++++--
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..82abd4e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3914,18 +3914,6 @@ out:
 	return ret;
 }
 
-inline struct page *extent_buffer_page(struct extent_buffer *eb,
-					      unsigned long i)
-{
-	return eb->pages[i];
-}
-
-inline unsigned long num_extent_pages(u64 start, u64 len)
-{
-	return ((start + len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) -
-		(start >> PAGE_CACHE_SHIFT);
-}
-
 static void __free_extent_buffer(struct extent_buffer *eb)
 {
 #if LEAK_DEBUG
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 25900af..0ebe4b5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -277,8 +277,18 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num);
-unsigned long num_extent_pages(u64 start, u64 len);
-struct page *extent_buffer_page(struct extent_buffer *eb, unsigned long i);
+
+static inline unsigned long num_extent_pages(u64 start, u64 len)
+{
+	return ((start + len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) -
+		(start >> PAGE_CACHE_SHIFT);
+}
+
+static inline struct page *extent_buffer_page(struct extent_buffer *eb,
+					      unsigned long i)
+{
+	return eb->pages[i];
+}
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-- 
1.7.3.2

