Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdFZMP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:15:28 -0400
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
Subject: [PATCH v2 15/51] btrfs: comment on direct access bvec table
Date: Mon, 26 Jun 2017 20:09:58 +0800
Message-Id: <20170626121034.3051-16-ming.lei@redhat.com>
In-Reply-To: <20170626121034.3051-1-ming.lei@redhat.com>
References: <20170626121034.3051-1-ming.lei@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/compression.c |  4 ++++
 fs/btrfs/inode.c       | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2c0b7b57fcd5..5972f74354ca 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -541,6 +541,10 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
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
index 4ab02b34f029..7e725d84917b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8055,6 +8055,12 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
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
@@ -8146,6 +8152,12 @@ static void btrfs_retry_endio(struct bio *bio)
 
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

