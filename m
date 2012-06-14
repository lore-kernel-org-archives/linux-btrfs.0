Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2FNIQG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:06 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/10 trival] Btrfs: fix typo in btrfs_finish_ordered_io
Date: Thu, 14 Jun 2012 16:23:23 +0800
Message-Id: <1339662206-5307-8-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix typo errors in comments of btrfs_finish_ordered_io.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc66330..3bb6b25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1929,8 +1929,8 @@ out:
 				      ordered_extent->len - 1, NULL, GFP_NOFS);
 
 	/*
-	 * This needs to be dont to make sure anybody waiting knows we are done
-	 * upating everything for this ordered extent.
+	 * This needs to be done to make sure anybody waiting knows we are done
+	 * updating everything for this ordered extent.
 	 */
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
-- 
1.6.5.2

