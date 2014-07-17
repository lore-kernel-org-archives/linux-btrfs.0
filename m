Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6061 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbaGQDth (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:49:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H3nO6o031831
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 11:49:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] Btrfs: fix wrong write range for filemap_fdatawrite_range()
Date: Thu, 17 Jul 2014 11:44:13 +0800
Message-ID: <1405568654-22120-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

filemap_fdatawrite_range() expect the third arg to be @end
not @len, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e2c3d63..ed8b55c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7567,7 +7567,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	count = iov_iter_count(iter);
 	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 		     &BTRFS_I(inode)->runtime_flags))
-		filemap_fdatawrite_range(inode->i_mapping, offset, count);
+		filemap_fdatawrite_range(inode->i_mapping, offset,
+					 offset + count - 1);
 
 	if (rw & WRITE) {
 		/*
-- 
1.8.2.1

