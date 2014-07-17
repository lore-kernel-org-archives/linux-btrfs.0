Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51298 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455AbaGQDtf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:49:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H3nLZs031823
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 11:49:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] Btrfs: fix off-by-one in cow_file_range_inline()
Date: Thu, 17 Jul 2014 11:44:11 +0800
Message-ID: <1405568654-22120-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs could still inline file data if its size is same as
page size, so don't skip max value here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e678391..e2c3d63 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -249,8 +249,8 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 		data_len = compressed_size;
 
 	if (start > 0 ||
-	    actual_end >= PAGE_CACHE_SIZE ||
-	    data_len >= BTRFS_MAX_INLINE_DATA_SIZE(root) ||
+	    actual_end > PAGE_CACHE_SIZE ||
+	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
 	    (!compressed_size &&
 	    (actual_end & (root->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
-- 
1.8.2.1

