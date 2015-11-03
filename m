Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56691 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752252AbbKCHBI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 02:01:08 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA33Onkv022157
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Nov 2015 11:24:50 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: mkfs: Round device size down to sectorsize
Date: Tue, 3 Nov 2015 11:23:36 +0800
Message-ID: <4372105ede489b71eec1af7720117900ddb6e427.1446520971.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When do following command in a vm, whose disks are created by
qemu-img create -f raw 11 2.6G:
 # mkfs.btrfs -f /dev/vdd /dev/vde /dev/vdf
 # btrfs-show-super /dev/vdd /dev/vde /dev/vdf | grep dev_item.total_bytes
 dev_item.total_bytes    2791727104
 dev_item.total_bytes    2791729152
 dev_item.total_bytes    2791729152
We can see that the first device's size is little smaller.

And it fails xfstests btrfs/011.

Reason:
 First device's size is rounded down to sectorsize in make_btrfs(),
 but other devices are not.

Fix:
 Round down remain devices' size in btrfs_add_to_fsid().

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils.c b/utils.c
index d17291a..b7752df 100644
--- a/utils.c
+++ b/utils.c
@@ -736,6 +736,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	u64 num_devs;
 	int ret;
 
+	device_total_bytes = (device_total_bytes / sectorsize) * sectorsize;
+
 	device = kzalloc(sizeof(*device), GFP_NOFS);
 	if (!device)
 		goto err_nomem;
-- 
1.8.5.1

