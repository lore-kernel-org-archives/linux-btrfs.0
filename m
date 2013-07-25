Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab3GYLWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMmWZ027101
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 2/6] Btrfs: add branch prediction hints in the read page end IO function
Date: Thu, 25 Jul 2013 19:22:33 +0800
Message-Id: <1374751357-3327-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
References: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add some branch prediction hints into the end IO function
of the read page, it reduced the percentage of the branch misses from
5.5% to 4.9%.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- Just change the description in the changelog
---
 fs/btrfs/extent_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a722235..6b6ba1a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2502,7 +2502,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		spin_lock(&tree->lock);
 		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
-		if (state && state->start == start) {
+		if (likely(state && state->start == start)) {
 			/*
 			 * take a reference on the state, unlock will drop
 			 * the ref
@@ -2512,7 +2512,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		spin_unlock(&tree->lock);
 
 		mirror = io_bio->mirror_num;
-		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
+		if (likely(uptodate && tree->ops &&
+			   tree->ops->readpage_end_io_hook)) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
 			if (ret)
@@ -2521,12 +2522,15 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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
@@ -2547,7 +2551,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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

