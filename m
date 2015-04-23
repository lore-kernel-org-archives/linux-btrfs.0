Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752522AbbDWBdh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 21:33:37 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH] btrfs: Check superblock csum type to avoid 0 division or array overflow.
Date: Thu, 23 Apr 2015 09:31:21 +0800
Message-ID: <1429752681-566-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs only support CRC32 checksum, and if csum_type is 1, we
will get 0 csum size, causing 0 division later destroy the whole kernel.
Or csum_type is later than 1, we will get data from other random memory
causing more problem.

So check csum_type in btrfs_check_super_valid() to avoid such hostile
attack.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 7 +++++++
 2 files changed, 8 insertions(+)

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
index 639f266..8687ab5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3885,6 +3885,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
+	/* Also check csum type, to avoid 0 csum_size */
+	if (btrfs_super_csum_type(sb) > BTRFS_CSUM_LAST_TYPE) {
+		printk(KERN_ERR "BTRFS: unsupported checksum type: %d\n",
+		       btrfs_super_csum_type(sb));
+		ret = -EINVAL;
+	}
+
 	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
 		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
 				fs_info->fsid, sb->dev_item.fsid);
-- 
2.3.5

