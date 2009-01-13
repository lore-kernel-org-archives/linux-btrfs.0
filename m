From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: [PATCH] remove some unused lines in submit_one_bio()
Date: Tue, 13 Jan 2009 12:34:56 +0800
Message-ID: <977a2be20901122034w46d259f7ve246f8912112311a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
 remove some unused lines.
--
Regards,
Zhu Yanhai

--
diff --git a/extent_io.c b/extent_io.c
index e086d40..5716e1e 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -1841,11 +1841,6 @@ static int submit_one_bio(int rw, struct bio
*bio, int mirror_num,
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
-	u64 end;
-
-	start = ((u64)page->index << PAGE_CACHE_SHIFT) + bvec->bv_offset;
-	end = start + bvec->bv_len - 1;

 	bio->bi_private = NULL;
