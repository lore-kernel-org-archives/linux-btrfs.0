Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32477 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbcEBSM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 14:12:59 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH] Btrfs-progs: fix incorrect flag check
Date: Mon,  2 May 2016 11:13:20 -0700
Message-Id: <1462212800-26837-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The flag OPEN_CTREE_RECOVER_SUPER is set when it's going to recover
any bad superblock copy, the current code doesn't match that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 6fcca42..2c22156 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1264,7 +1264,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		goto out;
 
 	disk_super = fs_info->super_copy;
-	if (!(flags & OPEN_CTREE_RECOVER_SUPER))
+	if (flags & OPEN_CTREE_RECOVER_SUPER)
 		ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 					   disk_super, sb_bytenr, 1);
 	else
-- 
2.5.0

