Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933363AbdLRMZX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:25:23 -0500
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J . Wong" <darrick.wong@oracle.com>, Coly Li <colyli@suse.de>,
        Filipe Manana <fdmanana@gmail.com>, Ming Lei <ming.lei@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH V4 10/45] btrfs: avoid to access bvec table directly for a cloned bio
Date: Mon, 18 Dec 2017 20:22:12 +0800
Message-Id: <20171218122247.3488-11-ming.lei@redhat.com>
In-Reply-To: <20171218122247.3488-1-ming.lei@redhat.com>
References: <20171218122247.3488-1-ming.lei@redhat.com>
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
index 4d5cb6e93c80..cb1e2d201434 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8015,6 +8015,7 @@ static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
 	int segs;
 	int ret;
 	blk_status_t status;
+	struct bio_vec bvec;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
@@ -8030,8 +8031,9 @@ static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
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

