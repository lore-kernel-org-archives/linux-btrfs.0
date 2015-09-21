Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755818AbbIUCMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8L2CU5P003279
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 10:12:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs: Do per-chunk degraded check for remount
Date: Mon, 21 Sep 2015 10:10:41 +0800
Message-ID: <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just the same for mount time check, use new btrfs_check_degraded() to do
per chunk check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c389c13..720c044 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1681,11 +1681,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		ret = btrfs_check_degradable(fs_info, *flags);
+		if (ret < 0) {
+			btrfs_error(fs_info, ret,
+				    "degraded writable remount failed");
+			goto restore;
+		} else if (ret > 0 && !btrfs_test_opt(root, DEGRADED)) {
 			btrfs_warn(fs_info,
-				"too many missing devices, writeable remount is not allowed");
+				"some device missing, but still degraded mountable, please remount with -o degraded option");
 			ret = -EACCES;
 			goto restore;
 		}
-- 
2.5.2

