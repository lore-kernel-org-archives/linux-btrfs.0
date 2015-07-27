Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4253 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751924AbbG0LeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 07:34:15 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6RBWMM3021957
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 19:32:23 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Show detail error message when write sb failed in write_dev_supers()
Date: Mon, 27 Jul 2015 19:32:37 +0800
Message-ID: <8277e478b7947c957be606f17b5137ae8d78ee66.1437996746.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

fsck-tests.sh failed and show following message in my node:
  # ./fsck-tests.sh
     [TEST]   001-bad-file-extent-bytenr
  disk-io.c:1444: write_dev_supers: Assertion `ret != BTRFS_SUPER_INFO_SIZE` failed.
  /root/btrfsprogs/btrfs-image(write_all_supers+0x2d2)[0x41031c]
  /root/btrfsprogs/btrfs-image(write_ctree_super+0xc5)[0x41042e]
  /root/btrfsprogs/btrfs-image(btrfs_commit_transaction+0x208)[0x410976]
  /root/btrfsprogs/btrfs-image[0x438780]
  /root/btrfsprogs/btrfs-image(main+0x3d5)[0x438c5c]
  /lib64/libc.so.6(__libc_start_main+0xfd)[0x335e01ecdd]
  /root/btrfsprogs/btrfs-image[0x4074e9]
  failed to restore image /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
  #

  # cat fsck-tests-results.txt
  === Entering /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr
  restoring image default_case.img
  failed to restore image /root/btrfsprogs/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
  #

Reason:
  I run above test in a NFS mountpoint, it don't have enouth space to write
  all superblock to image file, and don't support sparse file.
  So write_dev_supers() failed in writing sb and output above message.

It takes me quite of time to know what happened, we can save these time
by output exact information in write-sb-fail case.

After patch:
  # ./fsck-tests.sh
    [TEST]   001-bad-file-extent-bytenr
  WARNING: Write sb failed: File too large
  disk-io.c:1492: write_all_supers: Assertion `ret` failed.
  ...
  #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 disk-io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index fdcfd6d..607d4a1 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1419,7 +1419,8 @@ static int write_dev_supers(struct btrfs_root *root,
 		ret = pwrite64(device->fd, root->fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE,
 				root->fs_info->super_bytenr);
-		BUG_ON(ret != BTRFS_SUPER_INFO_SIZE);
+		if (ret != BTRFS_SUPER_INFO_SIZE)
+			goto write_err;
 		return 0;
 	}
 
@@ -1441,10 +1442,19 @@ static int write_dev_supers(struct btrfs_root *root,
 		 */
 		ret = pwrite64(device->fd, root->fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE, bytenr);
-		BUG_ON(ret != BTRFS_SUPER_INFO_SIZE);
+		if (ret != BTRFS_SUPER_INFO_SIZE)
+			goto write_err;
 	}
 
 	return 0;
+
+write_err:
+	if (ret > 0)
+		fprintf(stderr, "WARNING: Failed to write all sb data\n");
+	else
+		fprintf(stderr, "WARNING: Write sb failed: %s\n",
+			strerror(errno));
+	return ret;
 }
 
 int write_all_supers(struct btrfs_root *root)
-- 
1.8.5.1

