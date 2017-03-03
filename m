Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdCCKfQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 05:35:16 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 11/17] fs, btrfs: convert compressed_bio.pending_bios from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:20 +0200
Message-Id: <1488531326-21271-12-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/compression.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c7721a6..10e6b28 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -44,7 +44,7 @@
 
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
-	atomic_t pending_bios;
+	refcount_t pending_bios;
 
 	/* the pages with the compressed data on them */
 	struct page **compressed_pages;
@@ -161,7 +161,7 @@ static void end_compressed_bio_read(struct bio *bio)
 	/* if there are more bios still pending for this compressed
 	 * extent, just exit
 	 */
-	if (!atomic_dec_and_test(&cb->pending_bios))
+	if (!refcount_dec_and_test(&cb->pending_bios))
 		goto out;
 
 	inode = cb->inode;
@@ -274,7 +274,7 @@ static void end_compressed_bio_write(struct bio *bio)
 	/* if there are more bios still pending for this compressed
 	 * extent, just exit
 	 */
-	if (!atomic_dec_and_test(&cb->pending_bios))
+	if (!refcount_dec_and_test(&cb->pending_bios))
 		goto out;
 
 	/* ok, we're the last bio for this extent, step one is to
@@ -342,7 +342,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
 	if (!cb)
 		return -ENOMEM;
-	atomic_set(&cb->pending_bios, 0);
+	refcount_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
 	cb->start = start;
@@ -363,7 +363,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
-	atomic_inc(&cb->pending_bios);
+	refcount_set(&cb->pending_bios, 1);
 
 	/* create and submit bios for the compressed pages */
 	bytes_left = compressed_len;
@@ -388,7 +388,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			 * we inc the count.  Otherwise, the cb might get
 			 * freed before we're done setting it up
 			 */
-			atomic_inc(&cb->pending_bios);
+			refcount_inc(&cb->pending_bios);
 			ret = btrfs_bio_wq_end_io(fs_info, bio,
 						  BTRFS_WQ_ENDIO_DATA);
 			BUG_ON(ret); /* -ENOMEM */
@@ -607,7 +607,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	if (!cb)
 		goto out;
 
-	atomic_set(&cb->pending_bios, 0);
+	refcount_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
 	cb->mirror_num = mirror_num;
@@ -656,7 +656,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	bio_set_op_attrs (comp_bio, REQ_OP_READ, 0);
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
-	atomic_inc(&cb->pending_bios);
+	refcount_set(&cb->pending_bios, 1);
 
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		page = cb->compressed_pages[pg_index];
@@ -685,7 +685,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			 * we inc the count.  Otherwise, the cb might get
 			 * freed before we're done setting it up
 			 */
-			atomic_inc(&cb->pending_bios);
+			refcount_inc(&cb->pending_bios);
 
 			if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
 				ret = btrfs_lookup_bio_sums(inode, comp_bio,
-- 
2.7.4

