Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834Ab2FHT07 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:26:59 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q58JQxAP008310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Jun 2012 15:26:59 -0400
Received: from localhost.localdomain.com (vpn-8-48.rdu.redhat.com [10.11.8.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q58JQwjY030608
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Jun 2012 15:26:58 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: call filemap_fdatawrite twice for compression
Date: Fri,  8 Jun 2012 15:26:58 -0400
Message-Id: <1339183618-14136-1-git-send-email-josef@redhat.com>
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
 fs/btrfs/ordered-data.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9e138cd..49cacdb 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -611,6 +611,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
  */
 void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 end;
 	u64 orig_end;
 	struct btrfs_ordered_extent *ordered;
@@ -627,7 +628,28 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
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
+	if (btrfs_test_opt(root, COMPRESS) ||
+	    (BTRFS_I(inode)->force_compress) ||
+	    (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))
+		filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
+
+	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 
 	end = orig_end;
 	found = 0;
-- 
1.7.7.6

