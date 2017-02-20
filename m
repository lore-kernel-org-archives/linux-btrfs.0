Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45202 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdBTScL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:32:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71909AC17
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:32:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: add dummy callback for readpage_io_failed and drop checks
Date: Mon, 20 Feb 2017 19:31:33 +0100
Message-Id: <944371b69d2516a81dc182d6cf85e74583cf0ba4.1487615195.git.dsterba@suse.com>
In-Reply-To: <cover.1487615195.git.dsterba@suse.com>
References: <cover.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make extent_io_ops::readpage_io_failed_hook callback mandatory and
define a dummy function for btrfs_extent_io_ops. As the failed IO
callback is not performance critical, the branch vs extra trade off does
not hurt.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 2 +-
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 7 +++++++
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0715b6f3f686..fbf4921f4d60 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4658,7 +4658,7 @@ static const struct extent_io_ops btree_extent_io_ops = {
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
+	.readpage_io_failed_hook = btree_io_failed_hook,
 
 	/* optional callbacks */
-	.readpage_io_failed_hook = btree_io_failed_hook,
 };
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f5cff93ab152..eaee7bb2ff7c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2578,7 +2578,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		if (likely(uptodate))
 			goto readpage_ok;
 
-		if (tree->ops && tree->ops->readpage_io_failed_hook) {
+		if (tree->ops) {
 			ret = tree->ops->readpage_io_failed_hook(page, mirror);
 			if (!ret && !bio->bi_error)
 				uptodate = 1;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5c5e2e6cfb9e..63c8cc970b1c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -102,6 +102,7 @@ struct extent_io_ops {
 	int (*merge_bio_hook)(struct page *page, unsigned long offset,
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
+	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
 
 	/*
 	 * Optional hooks, called if the pointer is not NULL
@@ -109,7 +110,6 @@ struct extent_io_ops {
 	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
 			     unsigned long *nr_written);
-	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
 
 	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 72faf9b5616a..a74191fa3934 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10503,6 +10503,12 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 }
 
+__attribute__((const))
+static int dummy_readpage_io_failed_hook(struct page *page, int failed_mirror)
+{
+	return 0;
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -10545,6 +10551,7 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.merge_bio_hook = btrfs_merge_bio_hook,
+	.readpage_io_failed_hook = dummy_readpage_io_failed_hook,
 
 	/* optional callbacks */
 	.fill_delalloc = run_delalloc_range,
-- 
2.10.1

