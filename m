Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51298 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455AbaGQDth (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:49:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H3nPVp031834
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 11:49:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] Btrfs: fix wrong extent mapping for DirectIO
Date: Thu, 17 Jul 2014 11:44:14 +0800
Message-ID: <1405568654-22120-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_next_leaf() will use current leaf's last key to search
and then return a bigger one. So it may still return a file extent
item that is smaller than expected value and we will
get an overflow here for @em->len.

This is easy to reproduce for Btrfs Direct writting, it did not
cause any problem, because writting will re-insert right mapping later.

However, by hacking code to make DIO support compression, wrong extent
mapping is kept and it encounter merging failure(EEXIST) quickly.

Fix this problem by looping to find next file extent item that is bigger
than @start or we could not find anything more.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ed8b55c..d1ba5e4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6308,6 +6308,8 @@ next:
 			goto not_found;
 		if (start + len <= found_key.offset)
 			goto not_found;
+		if (start > found_key.offset)
+			goto next;
 		em->start = start;
 		em->orig_start = start;
 		em->len = found_key.offset - start;
-- 
1.8.2.1

