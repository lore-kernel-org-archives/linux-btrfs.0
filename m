Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48515 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbeFFFNQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 01:13:16 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: scrub: Don't use inode pages for device replace
Date: Wed,  6 Jun 2018 13:13:11 +0800
Message-Id: <20180606051312.3886-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Btrfs can easily create compressed extent without checksum (even
though it shouldn't), and if we then try to replace device containing
such extent, the result device will contain all the uncompressed data
instead of the compressed one.

Test case already submitted to fstests:
https://patchwork.kernel.org/patch/10442353/

[CAUSE]
When handling compressed extent without checksum, device replace will
goes into copy_nocow_pages() function.

In that function, btrfs will get all inodes referring to this data
extents and then use find_or_create_page() to get pages direct from that
inode.

The problem here is, pages directly from inode are always uncompressed.
And for compressed data extent, they mismatch with on-disk data.
Thus this leads to corrupted data extent written to replace device.

[FIX]
In this patch, we could just avoid the "optimization" branch, and let
unified scrub_pages() to handle it.

Although scrub_pages() won't bother reusing page cache, thus it will be a
little slower, but it does the correct csum checking (skipped in this case)
and won't cause such data corruption cause by "optimization".

Please note that, this patch will just avoid the copy_nocow_pages(),
while still leave related functions here, to make it small enough for a
late merge window.
Full functions removal will happen later.

Fixes: Fixes: ff023aac3119 ("Btrfs: add code to scrub to copy read data to another disk")
Cc: stable@vger.kernel.org
Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changlog:
v1:
  Split the RFC ver.B patch into 2 patches, the smaller fix will be
  easier to get merged for late merge window.
---
 fs/btrfs/scrub.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 52b39a0924e9..79e154575366 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2799,7 +2799,16 @@ static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
 			have_csum = scrub_find_csum(sctx, logical, csum);
 			if (have_csum == 0)
 				++sctx->stat.no_csum;
-			if (sctx->is_dev_replace && !have_csum) {
+
+			/*
+			 * For replace on nodatasum extent, don't use
+			 * copy_nocow_pages() routine which will copy pages
+			 * from inode to disk. It could cause deadly corruption
+			 * for compressed extent.
+			 * NOTE: copy_nocow_pages() and all its children will
+			 * be removed later.
+			 */
+			if (0 && sctx->is_dev_replace && !have_csum) {
 				ret = copy_nocow_pages(sctx, logical, l,
 						       mirror_num,
 						      physical_for_dev_replace);
-- 
2.17.1

