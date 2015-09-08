Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbbIHNSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 09:18:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t88DIHm0018031
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 21:18:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: add ext2fs_close_inode_scan to copy_inodes
Date: Tue, 8 Sep 2015 21:16:51 +0800
Message-ID: <8ed299639db87f1026ecc444f952c439412230eb.1441718128.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
References: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need use ext2fs_close_inode_scan to release relative resource
get from ext2fs_open_inode_scan() in copy_inodes()

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-convert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 934f4dc..e7f3c9e 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1186,6 +1186,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 	}
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
+	ext2fs_close_inode_scan(ext2_scan);
 
 	return ret;
 }
-- 
1.8.5.1

