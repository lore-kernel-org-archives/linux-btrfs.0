From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [RFC PATCH 2/4] btrfs: Do not use bio->bi_bdev after submission
Date: Fri, 22 Jul 2011 16:58:06 +0200
Message-ID: <74d6cec5467dcf696e28846edd1d17843cc4451a.1311344751.git.list.btrfs@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

The block layer modifies bio->bi_bdev and bio->bi_sector while working on
the bio, they do _not_ come back unmodified in the completion callback.

To call add_page, we need at least some bi_bdev set, which is why the code
was working, previously. With this patch, we use the latest_bdev from
fsinfo instead of the leftover in the bio. This gives us the possibility to
use the bi_bdev field for another purpose.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4a13730..6ec7a93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1916,7 +1916,7 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
 	bio->bi_sector = failrec->logical >> 9;
-	bio->bi_bdev = failed_bio->bi_bdev;
+	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 	bio->bi_size = 0;
 
 	bio_add_page(bio, page, failrec->len, start - page_offset(page));
-- 
1.7.3.4

