Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4184 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbaDJH3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 03:29:20 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3A7TFBB010815
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 15:29:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old libblkid cache
Date: Thu, 10 Apr 2014 15:30:21 +0800
Message-ID: <1397115021-30426-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs scan' uses libblkid to scan devices by default, and libblkid uses
cache to reduce the probe.

But if operations below is done in less than 2 seconds(BLKID_PROBE_MIN),
'btrfs scan' will still use the uncorrect cache and scan on the deleted device.
0. /dev/sda[1-4] mounted on /mnt using single data/metadata
1. btrfs dev scan
2. btrfs dev del /dev/sda3 /mnt
3. btrfs dev scan

Since the cache made by step 1 is still validated, step 3 will use the
cache and consider /dev/sda3 as a btrfs filesystem and try to scan it.
But the superblock(at least the first one) is wiped and failed to scan,
a error message, which can be avoided and is unneeded, is output.

This patch will force scan_for_btrfs() not to use cache to avoid the
problem.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Singed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 0bfb9d9..1cd1d28 100644
--- a/utils.c
+++ b/utils.c
@@ -2057,7 +2057,8 @@ int btrfs_scan_lblkid(int update_kernel)
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
 
-	if (blkid_get_cache(&cache, 0) < 0) {
+	/* No to use libblkid cache to avoid old data */
+	if (blkid_get_cache(&cache, "/dev/null") < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
 	}
-- 
1.9.1

