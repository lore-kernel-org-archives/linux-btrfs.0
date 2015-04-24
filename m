Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24755 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbbDXBOq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 21:14:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3O1DUhf023795
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 09:13:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
Date: Fri, 24 Apr 2015 09:12:40 +0800
Message-ID: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
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
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9c89ca..d6f3aa0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -173,6 +173,7 @@ struct btrfs_ordered_sum;
 
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
+#define BTRFS_CSUM_LAST_TYPE	0
 
 static int btrfs_csum_sizes[] = { 4, 0 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..e33a01b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -426,9 +426,9 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
 		}
 	}
 
-	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+	if (csum_type > BTRFS_CSUM_LAST_TYPE) {
 		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
-				csum_type);
+		       csum_type);
 		ret = 1;
 	}
 
-- 
2.3.5

