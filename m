Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbIYIcZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 04:32:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 1/1] btrfs: Do per-chunk degraded check for remount
Date: Fri, 25 Sep 2015 16:24:48 +0800
Message-Id: <1443169488-18217-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Just the same for mount time check, use new btrfs_check_degraded() to do
per chunk check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Btrfs: use btrfs_error instead of btrfs_err during remount

apply on top of the patch

[PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 181db38..16f1412 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1664,11 +1664,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		ret = btrfs_check_degradable(fs_info, *flags);
+		if (ret < 0) {
+			btrfs_err(fs_info,
+				"degraded writable remount failed %d", ret);
+			goto restore;
+		} else if (ret > 0 && !btrfs_test_opt(root, DEGRADED)) {
 			btrfs_warn(fs_info,
-				"too many missing devices, writeable remount is not allowed");
+				"some device missing, but still degraded mountable, please remount with -o degraded option");
 			ret = -EACCES;
 			goto restore;
 		}
-- 
2.4.1

