Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from voltaic.bi-co.net ([134.119.3.22]:35746 "EHLO voltaic.bi-co.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbbKHPm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 10:42:59 -0500
From: Michael Lass <bevan@bi-co.net>
To: linux-btrfs@vger.kernel.org
Cc: Michael Lass <bevan@bi-co.net>
Subject: [PATCH] btrfs-progs: mkfs: increase buffer size in is_ssd
Date: Sun,  8 Nov 2015 16:33:03 +0100
Message-Id: <1446996783-25363-1-git-send-email-bevan@bi-co.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In current versions of util-linux the buffer passed to blkid_devno_to_wholedisk
has to be sufficiently large to not only hold the device name but the complete
target of the /sys/dev/block/<maj:min> symlink. This was changed only recently
in 4419ffb9eff5801fdbd385a4a6199b3877f802ad.

The small buffer size currently can lead to failure of is_ssd due to truncated
device names:

readlink("/sys/dev/block/254:7", "../../devices/virtual/block/dm-", 31) = 31
open("/sys/block/dm-/queue/rotational", O_RDONLY) = -1 ENOENT (No such file or directory)

Signed-off-by: Michael Lass <bevan@bi-co.net>
---
 mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 0ea39f3..db69ab9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1102,7 +1102,7 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 static int is_ssd(const char *file)
 {
 	blkid_probe probe;
-	char wholedisk[32];
+	char wholedisk[PATH_MAX];
 	char sysfs_path[PATH_MAX];
 	dev_t devno;
 	int fd;
-- 
2.6.2

