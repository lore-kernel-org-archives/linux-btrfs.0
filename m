Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52131 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755565AbaICNeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DY2Vv006639
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/18] Btrfs: cleanup double assignment of device->bytes_used when device replace finishes
Date: Wed, 3 Sep 2014 21:35:31 +0800
Message-ID: <1409751347-5296-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a85b5f5..10dfb41 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -550,7 +550,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	tgt_device->is_tgtdev_for_dev_replace = 0;
 	tgt_device->devid = src_device->devid;
 	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
-	tgt_device->bytes_used = src_device->bytes_used;
 	memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
 	memcpy(tgt_device->uuid, src_device->uuid, sizeof(tgt_device->uuid));
 	memcpy(src_device->uuid, uuid_tmp, sizeof(src_device->uuid));
-- 
1.9.3

