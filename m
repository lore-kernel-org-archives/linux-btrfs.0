Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45276 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab2F0VQK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 17:16:10 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id jqpszMP3TqbelIvz (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 15:16:09 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: hold a ref on the inode during writepages
Date: Wed, 27 Jun 2012 17:20:51 -0400
Message-ID: <1340832051-4998-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can race with unlink and not actually be able to do our igrab in
btrfs_add_ordered_extent.  This will result in all sorts of problems.
Instead of doing the complicated work to try and handle returning an error
properly from btrfs_add_ordered_extent, just hold a ref to the inode during
writepages.  If we cannot grab a ref we know we're freeing this inode anyway
and can just drop the dirty pages on the floor, because screw them we're
going to invalidate them anyway.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8e9dea7..190e5b6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3638,6 +3638,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 			     writepage_t writepage, void *data,
 			     void (*flush_fn)(void *))
 {
+	struct inode *inode = mapping->host;
 	int ret = 0;
 	int done = 0;
 	int nr_to_write_done = 0;
@@ -3648,6 +3649,18 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	int scanned = 0;
 	int tag;
 
+	/*
+	 * We have to hold onto the inode so that ordered extents can do their
+	 * work when the IO finishes.  The alternative to this is failing to add
+	 * an ordered extent if the igrab() fails there and that is a huge pain
+	 * to deal with, so instead just hold onto the inode throughout the
+	 * writepages operation.  If it fails here we are freeing up the inode
+	 * anyway and we'd rather not waste our time writing out stuff that is
+	 * going to be truncated anyway.
+	 */
+	if (!igrab(inode))
+		return 0;
+
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
@@ -3742,6 +3755,7 @@ retry:
 		index = 0;
 		goto retry;
 	}
+	btrfs_add_delayed_iput(inode);
 	return ret;
 }
 
-- 
1.7.7.6

