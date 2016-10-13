Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30069 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933430AbcJMBfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 21:35:15 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id E782C41B4BC2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 09:29:28 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: make file clone aware of fatal signals
Date: Thu, 13 Oct 2016 09:23:39 +0800
Message-Id: <20161013012339.30387-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Indeed this just make the behavior similar to xfs when process has
fatal signals pending, and it'll make fstests/generic/298 happy.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7fd939b..fcd2b3b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3813,6 +3813,11 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		}
 		btrfs_release_path(path);
 		key.offset = next_key_min_offset;
+
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
 	}
 	ret = 0;
 
-- 
2.9.0



