Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56496 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754738AbbHXPgD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 11:36:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7OFZrLo015995
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 23:35:53 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs: Reset sblock->xxx_error stats before calling scrub_recheck_block_checksum
Date: Mon, 24 Aug 2015 23:34:17 +0800
Message-ID: <c078b25e1eb968d01424c283730d4620bdccfe11.1440430437.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440430437.git.zhaolei@cn.fujitsu.com>
References: <cover.1440430437.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should reset sblock->xxx_error stats before calling
scrub_recheck_block_checksum().

Current code run correctly because all sblock are allocated by
k[cz]alloc(), and the error stats are not got changed.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c8c16f4..4326e16 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1508,6 +1508,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 	sblock->no_io_error_seen = 1;
 	sblock->header_error = 0;
 	sblock->checksum_error = 0;
+	sblock->generation_error = 0;
 
 	for (page_num = 0; page_num < sblock->page_count; page_num++) {
 		struct bio *bio;
@@ -2216,6 +2217,9 @@ static void scrub_missing_raid56_worker(struct btrfs_work *work)
 	logical = sblock->pagev[0]->logical;
 	dev = sblock->pagev[0]->dev;
 
+	sblock->header_error = 0;
+	sblock->checksum_error = 0;
+	sblock->generation_error = 0;
 	if (sblock->no_io_error_seen) {
 		scrub_recheck_block_checksum(fs_info, sblock, is_metadata,
 					     have_csum, csum, generation,
-- 
1.8.5.1

