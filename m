Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26079 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbbAZIaf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 03:30:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0Q8TqDi023694
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 16:29:52 +0800
From: Xing Gu <gux.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Xing Gu <gux.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: don't output operational status information to stderr
Date: Mon, 26 Jan 2015 16:26:38 +0800
Message-ID: <1422260798-8090-1-git-send-email-gux.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 9b08144..48f85b1 100644
--- a/utils.c
+++ b/utils.c
@@ -750,7 +750,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		 * optimization.
 		 */
 		if (discard_range(fd, 0, 0) == 0) {
-			fprintf(stderr, "Performing full device TRIM (%s) ...\n",
+			printf("Performing full device TRIM (%s) ...\n",
 				pretty_size(block_count));
 			discard_blocks(fd, 0, block_count);
 		}
-- 
1.9.3

