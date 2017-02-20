Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdBTScA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:32:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77BF8AC17
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:31:58 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: document existence of extent_io ops callbacks
Date: Mon, 20 Feb 2017 19:31:27 +0100
Message-Id: <269b815f3d73a00a442b8c97e70591ed171bb2be.1487615195.git.dsterba@suse.com>
In-Reply-To: <cover.1487615195.git.dsterba@suse.com>
References: <cover.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some of the callbacks defined in btree_extent_io_ops and
btrfs_extent_io_ops do always exist so we don't need to check the
existence before each call. This patch just reorders the definition and
documents which are mandatory/optional.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   |  7 +++++--
 fs/btrfs/extent_io.h | 23 ++++++++++++++++-------
 fs/btrfs/inode.c     |  7 +++++--
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b06f557c176..0715b6f3f686 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4653,9 +4653,12 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 }
 
 static const struct extent_io_ops btree_extent_io_ops = {
-	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	.readpage_io_failed_hook = btree_io_failed_hook,
+	/* mandatory callbacks */
 	.submit_bio_hook = btree_submit_bio_hook,
+	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
+
+	/* optional callbacks */
+	.readpage_io_failed_hook = btree_io_failed_hook,
 };
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index fbc92315b503..5c5e2e6cfb9e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -91,18 +91,27 @@ typedef	int (extent_submit_bio_hook_t)(struct inode *inode, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags,
 				       u64 bio_offset);
 struct extent_io_ops {
-	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
-			     u64 start, u64 end, int *page_started,
-			     unsigned long *nr_written);
-	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
+	/*
+	 * The following callbacks must be allways defined, the function
+	 * pointer will be called unconditionally.
+	 */
 	extent_submit_bio_hook_t *submit_bio_hook;
+	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
+				    struct page *page, u64 start, u64 end,
+				    int mirror);
 	int (*merge_bio_hook)(struct page *page, unsigned long offset,
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
+
+	/*
+	 * Optional hooks, called if the pointer is not NULL
+	 */
+	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
+			     u64 start, u64 end, int *page_started,
+			     unsigned long *nr_written);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
-				    struct page *page, u64 start, u64 end,
-				    int mirror);
+
+	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eafadf0851d1..72faf9b5616a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10541,10 +10541,13 @@ static const struct file_operations btrfs_dir_file_operations = {
 };
 
 static const struct extent_io_ops btrfs_extent_io_ops = {
-	.fill_delalloc = run_delalloc_range,
+	/* mandatory callbacks */
 	.submit_bio_hook = btrfs_submit_bio_hook,
-	.merge_bio_hook = btrfs_merge_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
+	.merge_bio_hook = btrfs_merge_bio_hook,
+
+	/* optional callbacks */
+	.fill_delalloc = run_delalloc_range,
 	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.writepage_start_hook = btrfs_writepage_start_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
-- 
2.10.1

