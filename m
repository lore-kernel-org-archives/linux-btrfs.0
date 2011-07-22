From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [RFC PATCH 3/4] btrfs: Put mirror_num in bi_bdev
Date: Fri, 22 Jul 2011 16:58:07 +0200
Message-ID: <b4cb072ad700b2c2940b15904dafc8bf2533d904.1311344751.git.list.btrfs@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

The error correction code wants to make sure that only the bad mirror is
rewritten. Thus, we need to know which mirror is the bad one. I did not
find a more apropriate field than bi_bdev. But I think using this is fine,
because it is modified by the block layer, anyway, and should not be read
after the bio returned.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/volumes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e839b72..55fbd4d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3169,6 +3169,8 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		}
 		bio->bi_private = bbio->private;
 		bio->bi_end_io = bbio->end_io;
+		bio->bi_bdev = (struct block_device *)
+					(unsigned long)bbio->mirror_num;
 		/* only send an error to the higher layers if it is
 		 * beyond the tolerance of the multi-bio
 		 */
-- 
1.7.3.4

