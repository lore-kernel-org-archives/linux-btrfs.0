From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 10/18] btrfs: Remove unnecessary variant processing in submit_one_bio()
Date: Thu, 25 Mar 2010 20:33:58 +0800
Message-ID: <4BAB5836.8020302@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

start and end are never used in this function,
we don't need to declare them and calculate these value.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3194c79..dbbf9ca 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1905,11 +1905,6 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
-	u64 end;
-
-	start = ((u64)page->index << PAGE_CACHE_SHIFT) + bvec->bv_offset;
-	end = start + bvec->bv_len - 1;
 
 	bio->bi_private = NULL;
 
-- 
1.6.5.2


