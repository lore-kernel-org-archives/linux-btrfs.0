Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0040.outbound.protection.outlook.com ([104.47.37.40]:60591
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755489AbcINJSS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:18:18 -0400
Subject: [PATCH 2/3] block, dm-crypt, btrfs: Introduce bio_flags()
To: Jens Axboe <axboe@fb.com>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
CC: Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <144083a3-2d0a-00ff-add2-a2f6f3690528@sandisk.com>
Date: Wed, 14 Sep 2016 10:45:36 +0200
MIME-Version: 1.0
In-Reply-To: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the bio_flags() macro. Ensure that the second argument of
bio_set_op_attrs() only contains flags and no operation. This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Chris Mason <clm@fb.com> (maintainer:BTRFS FILE SYSTEM)
Cc: Josef Bacik <jbacik@fb.com> (maintainer:BTRFS FILE SYSTEM)
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>
---
 drivers/md/dm-crypt.c     | 2 +-
 fs/btrfs/inode.c          | 5 +++--
 include/linux/blk_types.h | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8742957..0448e7e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1136,7 +1136,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_private = io;
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
-	bio_set_op_attrs(clone, bio_op(io->base_bio), io->base_bio->bi_opf);
+	bio_set_op_attrs(clone, bio_op(io->base_bio), bio_flags(io->base_bio));
 }
 
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c4..ca01106 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8412,7 +8412,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	if (!bio)
 		return -ENOMEM;
 
-	bio_set_op_attrs(bio, bio_op(orig_bio), orig_bio->bi_opf);
+	bio_set_op_attrs(bio, bio_op(orig_bio), bio_flags(orig_bio));
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
 	btrfs_io_bio(bio)->logical = file_offset;
@@ -8450,7 +8450,8 @@ next_block:
 						  start_sector, GFP_NOFS);
 			if (!bio)
 				goto out_err;
-			bio_set_op_attrs(bio, bio_op(orig_bio), orig_bio->bi_opf);
+			bio_set_op_attrs(bio, bio_op(orig_bio),
+					 bio_flags(orig_bio));
 			bio->bi_private = dip;
 			bio->bi_end_io = btrfs_end_dio_bio;
 			btrfs_io_bio(bio)->logical = file_offset;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1e1ef21..311fa2f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -90,11 +90,12 @@ struct bio {
 };
 
 #define BIO_OP_SHIFT	(8 * FIELD_SIZEOF(struct bio, bi_opf) - REQ_OP_BITS)
+#define bio_flags(bio)	((bio)->bi_opf & ((1 << BIO_OP_SHIFT) - 1))
 #define bio_op(bio)	((bio)->bi_opf >> BIO_OP_SHIFT)
 
 #define bio_set_op_attrs(bio, op, op_flags) do {		\
 	WARN_ON(op >= (1 << REQ_OP_BITS));			\
-	(bio)->bi_opf &= ((1 << BIO_OP_SHIFT) - 1);		\
+	(bio)->bi_opf = bio_flags(bio);				\
 	(bio)->bi_opf |= ((unsigned int) (op) << BIO_OP_SHIFT);	\
 	(bio)->bi_opf |= op_flags;				\
 } while (0)
-- 
2.10.0

