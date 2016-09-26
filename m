Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53513 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbcIZEwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 00:52:49 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: Return more meaningful value for btrfs_read_deve_super
Date: Mon, 26 Sep 2016 12:52:33 +0800
Message-Id: <20160926045233.13664-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_dev_super() only returns 0 or -1, which doesn't really help,
caller won't know if it's caused by bad superblock or superblock out of
range.

Return -errno if pread64() return -1, and return -EOF if none or part of
the super is read out, and return what check_super() returned.

So caller can get -EIO to catch real corrupted super blocks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:
  Use better return values from pread64() and check_super().
---
 disk-io.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 854c285..4c5be08 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1590,14 +1590,20 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, buf, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
+		/* real error */
+		if (ret < 0)
+			return -errno;
+
+		/* Not large enough sb, return EOF instead of normal -EIO */
 		if (ret < BTRFS_SUPER_INFO_SIZE)
-			return -1;
+			return -ENOENT;
 
 		if (btrfs_super_bytenr(buf) != sb_bytenr)
-			return -1;
+			return -EIO;
 
-		if (check_super(buf, sbflags))
-			return -1;
+		ret = check_super(buf, sbflags);
+		if (ret < 0)
+			return ret;
 		memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
 	}
-- 
2.10.0



