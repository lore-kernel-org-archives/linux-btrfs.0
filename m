Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56691 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbbKCHBK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 02:01:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA33OpZb022161
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Nov 2015 11:24:51 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: Rename variables in btrfs_add_to_fsid
Date: Tue, 3 Nov 2015 11:23:37 +0800
Message-ID: <2b4af96b4d18a9b78f4febbec74e17675693752b.1446520971.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <4372105ede489b71eec1af7720117900ddb6e427.1446520971.git.zhaolei@cn.fujitsu.com>
References: <4372105ede489b71eec1af7720117900ddb6e427.1446520971.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two total_bytes in btrfs_add_to_fsid(), local variable
of total_bytes means fs_total_bytes, and device->total_bytes means
device's total_bytes.
And device's total_bytes in argument is named block_count in current
code.

This patch rename:
 total_bytes -> fs_total_bytes
 block_count -> device_total_bytes

To make code more readable.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index b7752df..999af43 100644
--- a/utils.c
+++ b/utils.c
@@ -724,7 +724,7 @@ static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
 
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
-		      u64 block_count, u32 io_width, u32 io_align,
+		      u64 device_total_bytes, u32 io_width, u32 io_align,
 		      u32 sectorsize)
 {
 	struct btrfs_super_block *disk_super;
@@ -732,7 +732,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	struct btrfs_device *device;
 	struct btrfs_dev_item *dev_item;
 	char *buf = NULL;
-	u64 total_bytes;
+	u64 fs_total_bytes;
 	u64 num_devs;
 	int ret;
 
@@ -757,7 +757,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->sector_size = sectorsize;
 	device->fd = fd;
 	device->writeable = 1;
-	device->total_bytes = block_count;
+	device->total_bytes = device_total_bytes;
 	device->bytes_used = 0;
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;
@@ -768,8 +768,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
 
-	total_bytes = btrfs_super_total_bytes(super) + block_count;
-	btrfs_set_super_total_bytes(super, total_bytes);
+	fs_total_bytes = btrfs_super_total_bytes(super) + device_total_bytes;
+	btrfs_set_super_total_bytes(super, fs_total_bytes);
 
 	num_devs = btrfs_super_num_devices(super) + 1;
 	btrfs_set_super_num_devices(super, num_devs);
-- 
1.8.5.1

