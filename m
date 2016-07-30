Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp78.mediacombb.net ([68.66.77.78]:37053 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753010AbcG3VyL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 17:54:11 -0400
From: Shaun Tancheff <shaun@tancheff.com>
To: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>,
        Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Mike Christie <mchristi@redhat.com>
Subject: Fixup direct bi_rw modifiers
Date: Sat, 30 Jul 2016 16:45:48 -0500
Message-Id: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bi_rw should be using bio_set_op_attrs to set bi_rw.

Signed-off-by: Shaun Tancheff <shaun@tancheff.com>

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
Patch is against linux-next tag next-20160729

NOTE: In 4.7 this was not including the 'WRITE' macro so may have
      it may not have been operating as intended.
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f67d6a1..720e6ef 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2050,7 +2050,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 		return -EIO;
 	}
 	bio->bi_bdev = dev->bdev;
-	bio->bi_rw = WRITE_SYNC;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_SYNC);
 	bio_add_page(bio, page, length, pg_offset);
 
 	if (btrfsic_submit_bio_wait(bio)) {
-- 
2.8.1

