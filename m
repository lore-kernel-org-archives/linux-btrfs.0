Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61924 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752704AbbJMMyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:54:02 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9DCrV68019608
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 20:53:31 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: mkfs: Fix different mixed type by argument sequence
Date: Tue, 13 Oct 2015 20:52:18 +0800
Message-ID: <7e3694d3e448468cbb376e8623a81a381436b889.1444740703.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given a 200G vdd1 and 1G vdd2:

In current code:
  # mkfs.btrfs -f /dev/vdd1 /dev/vdd2
  SMALL VOLUME: forcing mixed metadata/data groups
  btrfs-progs v4.1.2
  See http://btrfs.wiki.kernel.org for more information.

  Label:              (null)
  UUID:               7aa6fc75-ce23-4033-9d47-fd046afa2992
  Node size:          4096
  Sector size:        4096
  Filesystem size:    1.20GiB
  Block group profiles:
    Data+Metadata:    single            8.00MiB
    System:           single            4.00MiB
  SSD detected:       no
  Incompat features:  mixed-bg, extref, skinny-metadata
  Number of devices:  2
  Devices:
     ID        SIZE  PATH
      1   200.29MiB  /dev/vdd1
      2     1.00GiB  /dev/vdd2
  #
  # mkfs.btrfs -f /dev/vdd2 /dev/vdd1
  btrfs-progs v4.1.2
  See http://btrfs.wiki.kernel.org for more information.

  Label:              (null)
  UUID:               ac659809-66c1-427d-934d-bd4c209c91a8
  Node size:          16384
  Sector size:        4096
  Filesystem size:    1.20GiB
  Block group profiles:
    Data:             RAID0           136.00MiB
    Metadata:         RAID1            69.38MiB
    System:           RAID1            12.00MiB
  SSD detected:       no
  Incompat features:  extref, skinny-metadata
  Number of devices:  2
  Devices:
     ID        SIZE  PATH
      1     1.00GiB  /dev/vdd2
      2   200.29MiB  /dev/vdd1

We can see:
 mkfs.btrfs -f /dev/vdd1 /dev/vdd2
 and
 mkfs.btrfs -f /dev/vdd2 /dev/vdd1
 have different "mixed" type.

Reason:
 Current code determine "is to use mixed-type" only by
 first device.

Fix:
 Use mixed-type only if all device are small.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index cdae94d..29cab13 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1358,6 +1358,7 @@ int main(int ac, char **av)
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
+	int large_device_cnt = 0;
 
 	while(1) {
 		int c;
@@ -1494,17 +1495,25 @@ int main(int ac, char **av)
 		if (is_block_device(file) == 1)
 			if (test_dev_for_mkfs(file, force_overwrite))
 				exit(1);
+		ret = is_vol_small(file);
+		if (ret < 0) {
+			error("Failed to check size for '%s': %s",
+			      file, strerror(-ret));
+			exit(1);
+		}
+		large_device_cnt += (!ret);
+		ret = 0;
 	}
 
-	file = av[optind];
-	ssd = is_ssd(file);
-
-	if (is_vol_small(file) || mixed) {
+	if (!large_device_cnt || mixed) {
 		if (verbose)
 			printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
 		mixed = 1;
 	}
 
+	file = av[optind];
+	ssd = is_ssd(file);
+
 	/*
 	* Set default profiles according to number of added devices.
 	* For mixed groups defaults are single/single.
-- 
1.8.5.1

