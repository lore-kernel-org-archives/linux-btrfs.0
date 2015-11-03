Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55726 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbbKCLE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 06:04:57 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA3B4E1l019307
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Nov 2015 19:04:14 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: mkfs: remove unused code of format uuid string
Date: Tue, 3 Nov 2015 19:03:01 +0800
Message-ID: <94d473ab47ad4398547cce2cb70eddec8d9800fd.1446548572.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <0e4f0ae269fdaf041e1f53d2460e92ac3f926b88.1446548572.git.zhaolei@cn.fujitsu.com>
References: <0e4f0ae269fdaf041e1f53d2460e92ac3f926b88.1446548572.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variant named dev_uuid and uuid_unparse() for set its value are
not used, remove it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 75fc086..d5da1fb 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1176,9 +1176,6 @@ static void list_all_devices(struct btrfs_root *root)
 	printf("Devices:\n");
 	printf("   ID        SIZE  PATH\n");
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		char dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
-
-		uuid_unparse(device->uuid, dev_uuid);
 		printf("  %3llu  %10s  %s\n",
 			device->devid,
 			pretty_size(device->total_bytes),
-- 
1.8.5.1

