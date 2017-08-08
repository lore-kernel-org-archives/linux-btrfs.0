Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752170AbdHHIs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Aug 2017 04:48:28 -0400
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Ming Lei <ming.lei@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v3 13/49] btrfs: comment on direct access bvec table
Date: Tue,  8 Aug 2017 16:45:12 +0800
Message-Id: <20170808084548.18963-14-ming.lei@redhat.com>
In-Reply-To: <20170808084548.18963-1-ming.lei@redhat.com>
References: <20170808084548.18963-1-ming.lei@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Acked: David Sterba <dsterba@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/compression.c |  4 ++++
 fs/btrfs/inode.c       | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d2ef9ac2a630..f795d0a6d176 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -542,6 +542,10 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
+	/*
+	 * It is still safe to retrieve the 1st page of the bio
+	 * in this way after supporting multipage bvec.
+	 */
 	em = lookup_extent_mapping(em_tree,
 				   page_offset(bio->bi_io_vec->bv_page),
 				   PAGE_SIZE);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5cf320ee7ea0..084ed99dd308 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8051,6 +8051,12 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 	if (bio->bi_status)
 		goto end;
 
+	/*
+	 * WARNING:
+	 *
+	 * With multipage bvec, the following way of direct access to
+	 * bvec table is only safe if the bio includes single page.
+	 */
 	ASSERT(bio->bi_vcnt == 1);
 	io_tree = &BTRFS_I(inode)->io_tree;
 	failure_tree = &BTRFS_I(inode)->io_failure_tree;
@@ -8143,6 +8149,12 @@ static void btrfs_retry_endio(struct bio *bio)
 
 	uptodate = 1;
 
+	/*
+	 * WARNING:
+	 *
+	 * With multipage bvec, the following way of direct access to
+	 * bvec table is only safe if the bio includes single page.
+	 */
 	ASSERT(bio->bi_vcnt == 1);
 	ASSERT(bio->bi_io_vec->bv_len == btrfs_inode_sectorsize(done->inode));
 
-- 
2.9.4

