Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3GKF1E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 01:27:04 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6B5QxDP001051
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 13:27:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs: add branch prediction hints in the read page end IO function
Date: Thu, 11 Jul 2013 13:25:37 +0800
Message-Id: <1373520339-13870-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4bfbcc5..c9b28cf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2503,7 +2503,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		spin_lock(&tree->lock);
 		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
-		if (state && state->start == start) {
+		if (likely(state && state->start == start)) {
 			/*
 			 * take a reference on the state, unlock will drop
 			 * the ref
@@ -2513,7 +2513,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		spin_unlock(&tree->lock);
 
 		mirror = io_bio->mirror_num;
-		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
+		if (likely(uptodate && tree->ops &&
+			   tree->ops->readpage_end_io_hook)) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
 			if (ret)
@@ -2522,12 +2523,15 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 				clean_io_failure(start, page);
 		}
 
-		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
+		if (likely(uptodate))
+			goto readpage_ok;
+
+		if (tree->ops && tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(page, mirror);
 			if (!ret && !err &&
 			    test_bit(BIO_UPTODATE, &bio->bi_flags))
 				uptodate = 1;
-		} else if (!uptodate) {
+		} else {
 			/*
 			 * The generic bio_readpage_error handles errors the
 			 * following way: If possible, new read requests are
@@ -2548,7 +2552,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 				continue;
 			}
 		}
-
+readpage_ok:
 		if (uptodate && tree->track_uptodate) {
 			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
-- 
1.8.1.4

