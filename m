Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55726 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbbKCLE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 06:04:56 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA3B4Eqq019304
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Nov 2015 19:04:14 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: mkfs: output device list in sorted order
Date: Tue, 3 Nov 2015 19:03:00 +0800
Message-ID: <0e4f0ae269fdaf041e1f53d2460e92ac3f926b88.1446548572.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

list_for_each_entry_reverse() in current code can not output
devices in sorted order, because the sequence are broken in
btrfs_alloc_chunk().

We can use list_sort() instead.

Before patch:
 # mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf
 ...
 Number of devices:  3
 Devices:
    ID        SIZE  PATH
     3     2.60GiB  /dev/vdf
     1     2.60GiB  /dev/vdd
     2     2.60GiB  /dev/vde

After patch:
 # mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf
 ...
 Number of devices:  3
 Devices:
    ID        SIZE  PATH
     1     2.60GiB  /dev/vdd
     2     2.60GiB  /dev/vde
     3     2.60GiB  /dev/vdf

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 14e7eb4..75fc086 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -42,6 +42,7 @@
 #include "volumes.h"
 #include "transaction.h"
 #include "utils.h"
+#include "list_sort.h"
 
 static u64 index_cnt = 2;
 static int verbose = 1;
@@ -1148,6 +1149,13 @@ static int is_ssd(const char *file)
 	return !atoi((const char *)&rotational);
 }
 
+static int _cmp_device_by_id(void *priv, struct list_head *a,
+			     struct list_head *b)
+{
+	return list_entry(a, struct btrfs_device, dev_list)->devid -
+	       list_entry(b, struct btrfs_device, dev_list)->devid;
+}
+
 static void list_all_devices(struct btrfs_root *root)
 {
 	struct btrfs_fs_devices *fs_devices;
@@ -1160,12 +1168,14 @@ static void list_all_devices(struct btrfs_root *root)
 	list_for_each_entry(device, &fs_devices->devices, dev_list)
 		number_of_devices++;
 
+	list_sort(NULL, &fs_devices->devices, _cmp_device_by_id);
+
 	printf("Number of devices:  %d\n", number_of_devices);
 	/* printf("Total devices size: %10s\n", */
 		/* pretty_size(total_block_count)); */
 	printf("Devices:\n");
 	printf("   ID        SIZE  PATH\n");
-	list_for_each_entry_reverse(device, &fs_devices->devices, dev_list) {
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		char dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
 
 		uuid_unparse(device->uuid, dev_uuid);
-- 
1.8.5.1

