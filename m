Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59471 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754802AbbHXPgE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 11:36:04 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7OFZtwX016004
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 23:35:55 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs: Remove len argument from scrub_find_csum
Date: Mon, 24 Aug 2015 23:34:20 +0800
Message-ID: <315d3649c18620fb6b421894f3d2d07ac034a3c4.1440430437.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440430437.git.zhaolei@cn.fujitsu.com>
References: <cover.1440430437.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is useless.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bdf44c9..daf75ac 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2459,8 +2459,7 @@ static void scrub_block_complete(struct scrub_block *sblock)
 	}
 }
 
-static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
-			   u8 *csum)
+static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u8 *csum)
 {
 	struct btrfs_ordered_sum *sum = NULL;
 	unsigned long index;
@@ -2524,7 +2523,7 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 		if (flags & BTRFS_EXTENT_FLAG_DATA) {
 			/* push csums to sbio */
-			have_csum = scrub_find_csum(sctx, logical, l, csum);
+			have_csum = scrub_find_csum(sctx, logical, csum);
 			if (have_csum == 0)
 				++sctx->stat.no_csum;
 			if (sctx->is_dev_replace && !have_csum) {
@@ -2662,7 +2661,7 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
 
 		if (flags & BTRFS_EXTENT_FLAG_DATA) {
 			/* push csums to sbio */
-			have_csum = scrub_find_csum(sctx, logical, l, csum);
+			have_csum = scrub_find_csum(sctx, logical, csum);
 			if (have_csum == 0)
 				goto skip;
 		}
-- 
1.8.5.1

