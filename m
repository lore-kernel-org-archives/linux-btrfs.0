Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3817 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbdHHIwC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Aug 2017 04:52:02 -0400
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
Subject: [PATCH v3 30/49] btrfs: use bvec_get_last_page to get bio's last page
Date: Tue,  8 Aug 2017 16:45:29 +0800
Message-Id: <20170808084548.18963-31-ming.lei@redhat.com>
In-Reply-To: <20170808084548.18963-1-ming.lei@redhat.com>
References: <20170808084548.18963-1-ming.lei@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparing for supporting multipage bvec.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/compression.c | 5 ++++-
 fs/btrfs/extent_io.c   | 8 ++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f795d0a6d176..28746588f228 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -392,8 +392,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 static u64 bio_end_offset(struct bio *bio)
 {
 	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
+	struct bio_vec bv;
 
-	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
+	bvec_get_last_page(last, &bv);
+
+	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
 }
 
 static noinline int add_ra_bio_pages(struct inode *inode,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0e7367817b92..c8f6a8657bf2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2738,11 +2738,15 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 {
 	blk_status_t ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
+	struct bio_vec bv;
+	struct page *page;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	bvec_get_last_page(bvec, &bv);
+	page = bv.bv_page;
+
+	start = page_offset(page) + bv.bv_offset;
 
 	bio->bi_private = NULL;
 	bio_get(bio);
-- 
2.9.4

