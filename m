Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934033AbeF0Nie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 09:38:34 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 64D9CAD77
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 13:38:33 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Rename EXTENT_BUFFER_DUMMY to EXTENT_BUFFER_PRIVATE
Date: Wed, 27 Jun 2018 16:38:24 +0300
Message-Id: <1530106705-27186-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1530106705-27186-1-git-send-email-nborisov@suse.com>
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EXTENT_BUFFER_DUMMY is an awful name for this flag. Buffers which have
this flag set are not in any way dummy. Rather, they are private in
the sense that are not linked to the global buffer tree. This flag has
subtle implications to the way free_extent_buffer work for example, as
well as controls whether page->mapping->private_lock is held during
extent_buffer release. Pages for a private buffer cannot be under io,
nor can they be written by a 3rd party so taking the lock is
unnecessary.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c | 10 +++++-----
 fs/btrfs/extent_io.h |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a469f70d5ee..1c655be92690 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4093,7 +4093,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
 	 * outside of the sanity tests.
 	 */
-	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
+	if (unlikely(test_bit(EXTENT_BUFFER_PRIVATE, &buf->bflags)))
 		return;
 #endif
 	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6ac15804bab1..6611207e8e1f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4642,7 +4642,7 @@ int extent_buffer_under_io(struct extent_buffer *eb)
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
 	int i;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	int mapped = !test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
@@ -4755,7 +4755,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	}
 
 	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
-	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
+	set_bit(EXTENT_BUFFER_PRIVATE, &new->bflags);
 
 	return new;
 }
@@ -4780,7 +4780,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	}
 	set_extent_buffer_uptodate(eb);
 	btrfs_set_header_nritems(eb, 0);
-	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+	set_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags);
 
 	return eb;
 err:
@@ -5086,7 +5086,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
 		/* Should be safe to release our pages at this point */
 		btrfs_release_extent_buffer_page(eb);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
+		if (unlikely(test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags))) {
 			__free_extent_buffer(eb);
 			return 1;
 		}
@@ -5117,7 +5117,7 @@ void free_extent_buffer(struct extent_buffer *eb)
 
 	spin_lock(&eb->refs_lock);
 	if (atomic_read(&eb->refs) == 2 &&
-	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
+	    test_bit(EXTENT_BUFFER_PRIVATE, &eb->bflags))
 		atomic_dec(&eb->refs);
 
 	if (atomic_read(&eb->refs) == 2 &&
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0bfd4aeb822d..bfccaec2c89a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -46,7 +46,7 @@
 #define EXTENT_BUFFER_STALE 6
 #define EXTENT_BUFFER_WRITEBACK 7
 #define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
-#define EXTENT_BUFFER_DUMMY 9
+#define EXTENT_BUFFER_PRIVATE 9
 #define EXTENT_BUFFER_IN_TREE 10
 #define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
 
-- 
2.7.4

