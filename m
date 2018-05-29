Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2274 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754466AbeE2GuN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 02:50:13 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>, Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH] btrfs: set device state reappearing missing device
Date: Tue, 29 May 2018 14:50:09 +0800
Message-ID: <1527576609-9347-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

patch for commit 921518924084
("btrfs: handle dynamically reappearing missing device").

Since BTRFS_DEV_STATE_IN_FS_METADATA will be clear in
btrfs_open_one_device, and when alloc a new chunk in
__btrfs_alloc_chunk, device with BTRFS_DEV_STATE_IN_FS_METADATA
not be set will be skipped, so it can not alloc chunk correctly.

And from the source logic, BTRFS_DEV_STATE_IN_FS_METADATA should
be also set when reapearing a missing device.

And with this patch, xfstests-dev/tests/btrfs/154 should run
successfully.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8699080ef505..bf8a41b2847e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -849,6 +849,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 			fs_devices->missing_devices--;
 			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
+			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+					&device->dev_state);
 
 			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
 				     &device->dev_state) &&
-- 
2.17.0



