Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbdFZMPD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:15:03 -0400
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Ming Lei <ming.lei@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH v2 14/51] btrfs: avoid to access bvec table directly for a cloned bio
Date: Mon, 26 Jun 2017 20:09:57 +0800
Message-Id: <20170626121034.3051-15-ming.lei@redhat.com>
In-Reply-To: <20170626121034.3051-1-ming.lei@redhat.com>
References: <20170626121034.3051-1-ming.lei@redhat.com>
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
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 06dea7c89bbd..4ab02b34f029 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7993,6 +7993,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	int read_mode = 0;
 	int segs;
 	int ret;
+	struct bio_vec bvec;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
@@ -8008,8 +8009,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	}
 
 	segs = bio_segments(failed_bio);
+	bio_get_first_bvec(failed_bio, &bvec);
 	if (segs > 1 ||
-	    (failed_bio->bi_io_vec->bv_len > btrfs_inode_sectorsize(inode)))
+	    (bvec.bv_len > btrfs_inode_sectorsize(inode)))
 		read_mode |= REQ_FAILFAST_DEV;
 
 	isector = start - btrfs_io_bio(failed_bio)->logical;
-- 
2.9.4

