Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3D3O3r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 10:29:47 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0BF14A52BF
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 16:29:47 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add debug check for extent_io range alignment
Date: Tue, 30 Apr 2013 16:29:44 +0200
Message-Id: <1367332184-13367-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'end' value must exactly cover the end of the interval, which means
one byte less than the expected block alignment, or in case of a file
smaller than one block, one byte less than the inode size.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c4949f1..6f6beda 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -76,10 +76,29 @@ void btrfs_leak_debug_check(void)
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
 }
+
+#define btrfs_debug_check_extent_io_range(inode, start, end)		\
+	__btrfs_debug_check_extent_io_range(__func__, (inode), (start), (end))
+static inline void __btrfs_debug_check_extent_io_range(const char *caller,
+		struct inode *inode, u64 start, u64 end)
+{
+	u64 isize = i_size_read(inode);
+
+	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
+		printk_ratelimited(KERN_DEBUG
+		    "btrfs: %s: ino %llu isize %llu odd range [%llu,%llu)\n",
+				caller,
+				(unsigned long long)btrfs_ino(inode),
+				(unsigned long long)isize,
+				(unsigned long long)start,
+				(unsigned long long)end);
+	}
+}
 #else
 #define btrfs_leak_debug_add(new, head)	do {} while (0)
 #define btrfs_leak_debug_del(entry)	do {} while (0)
 #define btrfs_leak_debug_check()	do {} while (0)
+#define btrfs_debug_check_extent_io_range(c, s, e)	do {} while (0)
 #endif
 
 #define BUFFER_LRU_MAX 64
@@ -509,6 +528,8 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err;
 	int clear = 0;
 
+	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
 	bits |= EXTENT_FIRST_DELALLOC;
@@ -664,6 +685,8 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *state;
 	struct rb_node *node;
 
+	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+
 	spin_lock(&tree->lock);
 again:
 	while (1) {
@@ -756,6 +779,8 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_start;
 	u64 last_end;
 
+	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
@@ -976,6 +1001,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_start;
 	u64 last_end;
 
+	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-- 
1.7.9

