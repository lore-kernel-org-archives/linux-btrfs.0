Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab2EQL7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 07:59:53 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4HBxmSs006003
	for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 19:59:51 +0800
Message-ID: <4FB4E7DD.8020802@cn.fujitsu.com>
Date: Thu, 17 May 2012 19:58:21 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: cancel the scrub when remounting a fs to ro
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the filesystem is mounted to readonly, we should not run scrub.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ea17f0a..817b3a7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1151,6 +1151,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		/* pause restriper - we want to resume on remount to r/w */
 		btrfs_pause_balance(root->fs_info);
 
+		btrfs_scrub_cancel(root);
+
 		ret = btrfs_commit_super(root);
 		if (ret)
 			goto restore;
-- 
1.7.6.5
