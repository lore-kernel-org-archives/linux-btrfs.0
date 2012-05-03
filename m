From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix crash in scrub repair code when device is missing
Date: Thu,  3 May 2012 11:31:22 +0200
Message-ID: <1336037482-16199-1-git-send-email-sbehrens@giantdisaster.de>
Cc: marco.crociani@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix that when scrub tries to repair an I/O or checksum error and one of
the devices containing the mirror is missing, it crashes in bio_add_page
because the bdev is a NULL pointer for missing devices.

Reported-by: Marco L. Crociani <marco.crociani@gmail.com>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b679bf6..7e487be 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -998,6 +998,7 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
 			page = sblock->pagev + page_index;
 			page->logical = logical;
 			page->physical = bbio->stripes[mirror_index].physical;
+			/* for missing devices, bdev is NULL */
 			page->bdev = bbio->stripes[mirror_index].dev->bdev;
 			page->mirror_num = mirror_index + 1;
 			page->page = alloc_page(GFP_NOFS);
@@ -1042,6 +1043,12 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		struct scrub_page *page = sblock->pagev + page_num;
 		DECLARE_COMPLETION_ONSTACK(complete);
 
+		if (page->bdev == NULL) {
+			page->io_error = 1;
+			sblock->no_io_error_seen = 0;
+			continue;
+		}
+
 		BUG_ON(!page->page);
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
-- 
1.7.10.1.362.g242cab3

