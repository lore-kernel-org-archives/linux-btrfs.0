Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13024 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754834AbaFZDM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 23:12:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q3COqL027977
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 11:12:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix race between balance recovery and root deletion
Date: Thu, 26 Jun 2014 11:08:16 +0800
Message-ID: <1403752096-4776-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance recovery is called when RW mounting or remounting from
RO to RW, it is called to finish roots merging.

When doing balance recovery, relocation root's corresponding
fs root(whose root refs is 0) might be destroyed by cleaner
thread, this will make btrfs fail to mount.

Fix this problem by holding @cleaner_mutex when doing balance
recovery.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 2 ++
 fs/btrfs/super.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa1..61d8e87 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2904,7 +2904,9 @@ retry_root_backup:
 		if (ret)
 			goto fail_qgroup;
 
+		mutex_lock(&fs_info->cleaner_mutex);
 		ret = btrfs_recover_relocation(tree_root);
+		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
 			printk(KERN_WARNING
 			       "BTRFS: failed to recover relocation\n");
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..b6ebde2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1467,7 +1467,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 
 		/* recover relocation */
+		mutex_lock(&fs_info->cleaner_mutex);
 		ret = btrfs_recover_relocation(root);
+		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret)
 			goto restore;
 
-- 
1.8.2.1

