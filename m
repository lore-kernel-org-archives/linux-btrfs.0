Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18255 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629AbbD1BIM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 21:08:12 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3S16uWD009793
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 09:06:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Fix superblock csum type check.
Date: Tue, 28 Apr 2015 09:06:03 +0800
Message-ID: <1430183163-10870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old csum type check is wrong and can't catch csum_type 1(not supported).

Fix it to avoid hostile 0 division.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   Fix existing codes other than adding new one.
v3:
   Just remove the tailing in btrfs_csum_sizes array.
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9c89ca..745b5e7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -174,7 +174,7 @@ struct btrfs_ordered_sum;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4 };
 
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..e3495b1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -428,7 +428,7 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
 		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
-				csum_type);
+		       csum_type);
 		ret = 1;
 	}
 
-- 
2.3.6

