Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbdLHNQX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:16:23 -0500
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH 10/10] btrfs: avoid to access bvec table directly for a cloned bio
Date: Fri,  8 Dec 2017 21:14:09 +0800
Message-Id: <20171208131409.11889-11-ming.lei@redhat.com>
In-Reply-To: <20171208131409.11889-1-ming.lei@redhat.com>
References: <20171208131409.11889-1-ming.lei@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 17347cec15f919901c90(Btrfs: change how we iterate bios in endio)
mentioned that for dio the submitted bio may be fast cloned, we
can't access the bvec table directly for a cloned bio, so use
bio_get_first_bvec() to retrieve the 1st bvec.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Acked: David Sterba <dsterba@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d28b66019d54..7f23c1993d24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8013,6 +8013,7 @@ static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
 	int segs;
 	int ret;
 	blk_status_t status;
+	struct bio_vec bvec;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
@@ -8028,8 +8029,9 @@ static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
 	}
 
 	segs = bio_segments(failed_bio);
+	bio_get_first_bvec(failed_bio, &bvec);
 	if (segs > 1 ||
-	    (failed_bio->bi_io_vec->bv_len > btrfs_inode_sectorsize(inode)))
+	    (bvec.bv_len > btrfs_inode_sectorsize(inode)))
 		read_mode |= REQ_FAILFAST_DEV;
 
 	isector = start - btrfs_io_bio(failed_bio)->logical;
-- 
2.9.5

