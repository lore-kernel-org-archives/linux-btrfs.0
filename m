Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45185 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdBTSb5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:31:57 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83A0DABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:31:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: let writepage_end_io_hook return void
Date: Mon, 20 Feb 2017 19:31:24 +0100
Message-Id: <f29564877a65f4feb138891d6023de0ec1f91c8b.1487615195.git.dsterba@suse.com>
In-Reply-To: <cover.1487615195.git.dsterba@suse.com>
References: <cover.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no error path in any of the instances, always return 0.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 9 +++------
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 6 ++----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d15b5ddb6732..8de29aa4d1a2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2435,12 +2435,9 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-	if (tree->ops && tree->ops->writepage_end_io_hook) {
-		ret = tree->ops->writepage_end_io_hook(page, start,
-					       end, NULL, uptodate);
-		if (ret)
-			uptodate = 0;
-	}
+	if (tree->ops && tree->ops->writepage_end_io_hook)
+		tree->ops->writepage_end_io_hook(page, start, end, NULL,
+				uptodate);
 
 	if (!uptodate) {
 		ClearPageUptodate(page);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 270d03be290e..fbc92315b503 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -103,7 +103,7 @@ struct extent_io_ops {
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
-	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
+	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
 			     unsigned *bits);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dae2734a725b..eafadf0851d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2977,7 +2977,7 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+static void btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
@@ -2991,7 +2991,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	ClearPagePrivate2(page);
 	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
 					    end - start + 1, uptodate))
-		return 0;
+		return;
 
 	if (btrfs_is_free_space_inode(inode)) {
 		wq = fs_info->endio_freespace_worker;
@@ -3004,8 +3004,6 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	btrfs_init_work(&ordered_extent->work, func, finish_ordered_fn, NULL,
 			NULL);
 	btrfs_queue_work(wq, &ordered_extent->work);
-
-	return 0;
 }
 
 static int __readpage_endio_check(struct inode *inode,
-- 
2.10.1

