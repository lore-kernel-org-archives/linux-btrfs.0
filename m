Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab3A1MeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 07:34:13 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0SCYA3O007382
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 20:34:11 +0800
Message-ID: <5106706F.5030803@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 20:34:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: fix wrong sync_writers decrement in btrfs_file_aio_write()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the checks at the beginning of btrfs_file_aio_write() fail, we needn't
decrease ->sync_writers, because we have not increased it. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20452c1..370ed5b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1595,9 +1595,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		if (err < 0 && num_written > 0)
 			num_written = err;
 	}
-out:
+
 	if (sync)
 		atomic_dec(&BTRFS_I(inode)->sync_writers);
+out:
 	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
-- 
1.6.5.2
