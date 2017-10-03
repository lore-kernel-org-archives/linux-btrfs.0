Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:49426 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751232AbdJCRbO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 13:31:14 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Jean-Denis Girard <jd.girard@sysnux.pf>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] btrfs: avoid overflow when sector_t is 32 bit
Date: Tue,  3 Oct 2017 19:31:10 +0200
Message-Id: <20171003173110.14789-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Jean-Denis Girard noticed commit c821e7f3 "pass bytes to
btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/) introduces a
regression on 32 bit machines.
When CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large
(2TB+) block devices and files) sector_t is 32 bit on 32bit machines.

In the function submit_extent_page, 'sector' (which is sector_t type) is
multiplied by 512 to convert it from sectors to bytes, leading to an
overflow when the disk is bigger than 4GB (!).

I added a cast to u64 to avoid overflow.

Based on v4.14-rc3.


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
Tested-by: Jean-Denis Girard <jd.girard@sysnux.pf>

---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 12ab19a4b93e..970190cd347e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2801,7 +2801,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		}
 	}
 
-	bio = btrfs_bio_alloc(bdev, sector << 9);
+	bio = btrfs_bio_alloc(bdev, (u64)sector << 9);
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
-- 
2.14.2

--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
