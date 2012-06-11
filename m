Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2FKOQs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 10:16:48 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5BEGmjl030484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2012 10:16:48 -0400
Received: from localhost.localdomain.com (vpn-8-163.rdu.redhat.com [10.11.8.163])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q5BEGlkg017576
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2012 10:16:47 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: call filemap_fdatawrite twice for compression V2
Date: Mon, 11 Jun 2012 10:16:47 -0400
Message-Id: <1339424207-6224-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I removed this in an earlier commit and I was wrong.  Because compression
can return from filemap_fdatawrite() without having actually set any of it's
pages as writeback() it can make filemap_fdatawait() do essentially nothing,
and then we won't find any ordered extents because they may not have been
created yet.  So not only does this make fsync() completely useless, but it
will also screw up if you truncate on a non-page aligned offset since we
zero out the end and then wait on ordered extents and then call drop caches.
We can drop the cache before the io completes and then we try to unpin the
extent we just wrote we won't find it and everything goes sideways.  So fix
this by putting it back and put a giant comment there to keep me from trying
to remove it in the future.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: force_compress doesn't stay set the entire time and even though it
should be fine this way I'd rather not having something this fragile in place
that can cause corruption it somebody happens to do it wrong, so add a flag so
we know we have async extents on this inode.
 fs/btrfs/btrfs_inode.h  |    1 +
 fs/btrfs/inode.c        |   15 +++++++++------
 fs/btrfs/ordered-data.c |   22 +++++++++++++++++++++-
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index e616f887..12394a9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -37,6 +37,7 @@
 #define BTRFS_INODE_IN_DEFRAG			3
 #define BTRFS_INODE_DELALLOC_META_RESERVED	4
 #define BTRFS_INODE_HAS_ORPHAN_ITEM		5
+#define BTRFS_INODE_HAS_ASYNC_EXTENT		6
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 293c018..aef3054 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1398,20 +1398,23 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
-	else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC)
+	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	else if (!btrfs_test_opt(root, COMPRESS) &&
-		 !(BTRFS_I(inode)->force_compress) &&
-		 !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))
+	} else if (!btrfs_test_opt(root, COMPRESS) &&
+		   !(BTRFS_I(inode)->force_compress) &&
+		   !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
-	else
+	} else {
+		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written);
+	}
 	return ret;
 }
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9e138cd..643335a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -627,7 +627,27 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
 	 */
-	filemap_write_and_wait_range(inode->i_mapping, start, orig_end);
+	filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
+
+	/*
+	 * So with compression we will find and lock a dirty page and clear the
+	 * first one as dirty, setup an async extent, and immediately return
+	 * with the entire range locked but with nobody actually marked with
+	 * writeback.  So we can't just filemap_write_and_wait_range() and
+	 * expect it to work since it will just kick off a thread to do the
+	 * actual work.  So we need to call filemap_fdatawrite_range _again_
+	 * since it will wait on the page lock, which won't be unlocked until
+	 * after the pages have been marked as writeback and so we're good to go
+	 * from there.  We have to do this otherwise we'll miss the ordered
+	 * extents and that results in badness.  Please Josef, do not think you
+	 * know better and pull this out at some point in the future, it is
+	 * right and you are wrong.
+	 */
+	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+		     &BTRFS_I(inode)->runtime_flags))
+		filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
+
+	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 
 	end = orig_end;
 	found = 0;
-- 
1.7.7.6

