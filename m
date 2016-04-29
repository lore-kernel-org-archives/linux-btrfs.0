Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbcD2JUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 40E4CAD78
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/16] btrfs: sink gfp parameter to set_extent_delalloc
Date: Fri, 29 Apr 2016 11:20:30 +0200
Message-Id: <7cd8c7527cb3ad3b397fecfa1bdc8eec9fa33dd8.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Callers pass GFP_NOFS and tests pass GFP_KERNEL, but using NOFS there
does not hurt. No need to pass the flags around.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h             | 4 ++--
 fs/btrfs/inode.c                 | 2 +-
 fs/btrfs/tests/extent-io-tests.c | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9e987ee03361..e99a6befdbf5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -291,11 +291,11 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       struct extent_state **cached_state, gfp_t mask);
 
 static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached_state, gfp_t mask)
+		u64 end, struct extent_state **cached_state)
 {
 	return set_extent_bit(tree, start, end,
 			      EXTENT_DELALLOC | EXTENT_UPTODATE,
-			      NULL, cached_state, mask);
+			      NULL, cached_state, GFP_NOFS);
 }
 
 static inline int set_extent_defrag(struct extent_io_tree *tree, u64 start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d37997f4eb98..1a4bd193962c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1962,7 +1962,7 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 {
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   cached_state, GFP_NOFS);
+				   cached_state);
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 88e28e5d2c38..c190d2a520d1 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -113,7 +113,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 * |---  search  ---|
 	 */
-	set_extent_delalloc(&tmp, 0, 4095, NULL, GFP_KERNEL);
+	set_extent_delalloc(&tmp, 0, 4095, NULL);
 	start = 0;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -144,7 +144,7 @@ static int test_find_delalloc(void)
 		test_msg("Couldn't find the locked page\n");
 		goto out_bits;
 	}
-	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL, GFP_KERNEL);
+	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -199,7 +199,7 @@ static int test_find_delalloc(void)
 	 *
 	 * We are re-using our test_start from above since it works out well.
 	 */
-	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL, GFP_KERNEL);
+	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-- 
2.7.1

