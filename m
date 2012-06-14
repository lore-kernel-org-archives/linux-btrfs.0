Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2FNIQF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:05 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/10 trival] Btrfs: fix typo in cow_file_range_async
Date: Thu, 14 Jun 2012 16:23:24 +0800
Message-Id: <1339662206-5307-9-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should be 10 * 1024 * 1024.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3bb6b25..da2fd8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1031,7 +1031,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
 	u64 cur_end;
-	int limit = 10 * 1024 * 1042;
+	int limit = 10 * 1024 * 1024;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);
-- 
1.6.5.2

