Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752134AbdFZMST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:18:19 -0400
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
Subject: [PATCH v2 32/51] btrfs: use bvec_get_last_page to get bio's last page
Date: Mon, 26 Jun 2017 20:10:15 +0800
Message-Id: <20170626121034.3051-33-ming.lei@redhat.com>
In-Reply-To: <20170626121034.3051-1-ming.lei@redhat.com>
References: <20170626121034.3051-1-ming.lei@redhat.com>
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
index 5972f74354ca..fdab5b821aa8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -391,8 +391,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
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
index 5b453cada1ea..7cc6c8a52e49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2741,11 +2741,15 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
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

