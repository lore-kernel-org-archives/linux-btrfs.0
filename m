Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43954 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753276AbcITCTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 22:19:35 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: hawken@thehawken.org
Subject: [PATCH 1/2] btrfs-progs: Return more meaningful value for btrfs_read_dev_super
Date: Tue, 20 Sep 2016 10:19:01 +0800
Message-Id: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_dev_super() only returns 0 or -1, which doesn't really help,
caller won't know if it's caused by bad superblock or superblock out of
range.

Change it to return -ENOENT for superblock which is out of range, and
return -EIO for bad superblocks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 854c285..26852ee 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1590,14 +1590,15 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, buf, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
+		/* Special return value for out of dev/file range */
 		if (ret < BTRFS_SUPER_INFO_SIZE)
-			return -1;
+			return -ENOENT;
 
 		if (btrfs_super_bytenr(buf) != sb_bytenr)
-			return -1;
+			return -EIO;
 
 		if (check_super(buf, sbflags))
-			return -1;
+			return -EIO;
 		memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
 	}
@@ -1641,7 +1642,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		}
 	}
 
-	return transid > 0 ? 0 : -1;
+	return transid > 0 ? 0 : -EIO;
 }
 
 static int write_dev_supers(struct btrfs_root *root,
-- 
2.10.0



