Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3L3INY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:24 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 07/14] Btrfs: introduce dedup state
Date: Mon, 30 Dec 2013 16:12:47 +0800
Message-Id: <1388391175-29539-8-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces dedup state and relative operations to mark and unmark
the dedup data range, it'll be used in later patches.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 14 ++++++++++++++
 fs/btrfs/extent_io.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8e457fc..54cef32 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1251,6 +1251,20 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 				cached_state, mask);
 }
 
+int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		     struct extent_state **cached_state, gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_DEDUP, 0,
+			      cached_state, mask);
+}
+
+int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached_state, gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end, EXTENT_DEDUP, 0, 0,
+				cached_state, mask);
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 19620c5..5c6a78d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,6 +20,7 @@
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
 #define EXTENT_NORESERVE (1 << 15)
+#define EXTENT_DEDUP (1 << 16)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -227,6 +228,10 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			  struct extent_state **cached_state, gfp_t mask);
+int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		     struct extent_state **cached_state, gfp_t mask);
+int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		       struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-- 
1.8.2.1

