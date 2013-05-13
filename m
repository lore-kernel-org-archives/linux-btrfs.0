Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3EMPM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:12:29 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4DDtVm4019982
	for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 21:55:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/5] Btrfs: don't abort the current transaction if there is no enough space for inode cache
Date: Mon, 13 May 2013 21:55:08 +0800
Message-Id: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The filesystem with inode cache was forced to be read-only when we umounted it.

Steps to reproduce:
 # mkfs.btrfs -f ${DEV}
 # mount -o inode_cache ${DEV} ${MNT}
 # dd if=/dev/zero of=${MNT}/file1 bs=1M count=8192
 # btrfs fi syn ${MNT}
 # dd if=${MNT}/file1 of=/dev/null bs=1M
 # rm -f ${MNT}/file1
 # btrfs fi syn ${MNT}
 # umount ${MNT}

It is because there was no enough space to do inode cache truncation, and then
we aborted the current transaction.

But no space error is not a serious problem when we write out the inode cache,
and it is safe that we just skip this step if we meet this problem. So we need
not abort the current transaction.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode-map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d26f67a..9818d4a 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -468,7 +468,8 @@ again:
 	if (i_size_read(inode) > 0) {
 		ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
 		if (ret) {
-			btrfs_abort_transaction(trans, root, ret);
+			if (ret != -ENOSPC)
+				btrfs_abort_transaction(trans, root, ret);
 			goto out_put;
 		}
 	}
-- 
1.8.0.1

