Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8153 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753958AbbCECWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 21:22:21 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <zblaxell@furryterror.org>, <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v3 3/3] Btrfs: adapt df command to RAID5/6.
Date: Thu, 5 Mar 2015 10:18:38 +0800
Message-ID: <1425521918-30212-4-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1425521918-30212-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1425521918-30212-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we use btrfs with raid5/6, the output of df is unexpected as below.
Example:
        # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid5
        # mount /dev/vdf1 /mnt
        # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
        # df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       4.2G  1.3G  2.9G  32% /mnt
[root@atest-guest linux_btrfs]# btrfs fi show /mnt
Label: none  uuid: f7fac7f2-3898-482e-9cf2-fbcd7fdd7084
	Total devices 2 FS bytes used 1001.53MiB
	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
The @size should be 2G rather than 4.2G.

This patch makes the btrfs_calc_avail_data_space() consider raid5/6,
then we can get the correct result of it.

Example:
        # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid5
        # mount /dev/vdf1 /mnt
        # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
        # df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       2.0G  1.3G  713M  66% /mnt
[root@atest-guest linux_btrfs]# btrfs fi show /mnt
Label: none  uuid: ea3a6e6e-fbe1-47aa-b4b5-bc37b98565d9
	Total devices 2 FS bytes used 1001.53MiB
	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/super.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 25b0f79..7cac6b4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -52,6 +52,7 @@
 #include "props.h"
 #include "xattr.h"
 #include "volumes.h"
+#include "raid56.h"
 #include "export.h"
 #include "compression.h"
 #include "rcu-string.h"
@@ -1698,6 +1699,14 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		min_stripes = 4;
 		num_stripes = 4;
 		data_stripes = 2;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+		min_stripes = 2;
+		num_stripes = nr_devices;
+		data_stripes = num_stripes - nr_parity_stripes(type);
+	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+		min_stripes = 3;
+		num_stripes = nr_devices;
+		data_stripes = num_stripes - nr_parity_stripes(type);
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
@@ -1787,8 +1796,11 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	while (nr_devices >= min_stripes) {
 		if (num_stripes > nr_devices) {
 			num_stripes = nr_devices;
-			if (type & BTRFS_BLOCK_GROUP_RAID0)
-				data_stripes = num_stripes;
+			/* Only RAID0, RAID5 and RAID6 will get here.
+			 * And we can use the following calculation
+			 * for all the three cases.
+			 **/
+			data_stripes = num_stripes - nr_parity_stripes(type);
 		}
 
 		if (devices_info[i].max_avail >= min_stripe_size) {
-- 
1.8.4.2

