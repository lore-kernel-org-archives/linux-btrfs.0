From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 2/6] Handle possible bio_alloc failure in btrfs
Date: Tue, 14 Apr 2009 16:36:36 +0530
Message-ID: <200904141636.36894.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Handle possible bio_alloc failure in btrfs.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -1714,6 +1714,11 @@ static int btrfs_io_failed_hook(struct b
 		return -EIO;
 	}
 	bio = bio_alloc(GFP_NOFS, 1);
+	if (unlikely(!bio)) {
+		kfree(failrec);
+		return -ENOMEM;
+	}
+	
 	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
 	bio->bi_sector = failrec->logical >> 9;


