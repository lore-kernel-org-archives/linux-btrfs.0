Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbcDBBbT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 21:31:19 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: yauhen.kharuzhy@zavadatar.com, dsterba@suse.cz
Subject: [PATCH 03/13] btrfs: Do per-chunk degraded check for remount
Date: Sat,  2 Apr 2016 09:30:41 +0800
Message-Id: <1459560651-14809-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Just the same for mount time check, use new btrfs_check_degraded() to do
per chunk check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Btrfs: use btrfs_error instead of btrfs_err during remount

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 00b8f37cc306..87639fa53b10 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1767,11 +1767,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
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
2.7.0

