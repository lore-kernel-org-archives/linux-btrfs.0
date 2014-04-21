Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaDUJio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 05:38:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3L9cfUP027011
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 17:38:41 +0800
From: Li Yang <liyang.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Li Yang <liyang.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: mkfs: Remove 'zero_end =1' since it has been set to a value
Date: Mon, 21 Apr 2014 05:38:08 -0400
Message-ID: <1398073088-40489-1-git-send-email-liyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In utils.c, zero_end is used as a parameter, should not force it to 1.
In mkfs.c, zero_end is set to 1 or 0(-b) at the beginning, should not
force it to 1 unconditionally.

Signed-off-by: Li Yang <liyang.fnst@cn.fujitsu.com>
---
 mkfs.c  |    1 -
 utils.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index dbd83f5..f2b5779 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1543,7 +1543,6 @@ int main(int ac, char **av)
 
 	btrfs_register_one_device(file);
 
-	zero_end = 1;
 	while (dev_cnt-- > 0) {
 		int old_mixed = mixed;
 
diff --git a/utils.c b/utils.c
index 0bfb9d9..db5fdb3 100644
--- a/utils.c
+++ b/utils.c
@@ -616,7 +616,6 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
-	zero_end = 1;
 
 	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
 		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
-- 
1.7.1

