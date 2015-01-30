Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760180AbbA3JXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 04:23:13 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0U9MLG2028861
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 17:22:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 7/9] btrfs: Move btrfs_sysfs_remove_one(fs_info) before transcation thread cleanup.
Date: Fri, 30 Jan 2015 17:20:52 +0800
Message-ID: <1422609654-19519-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs sysfs interfaces can start new transaction, we need to do it
before transaction thread cleanup.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v5:
  Newly introduced.
---
 fs/btrfs/disk-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f4d168d..7c185a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3630,6 +3630,12 @@ void close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
+	/*
+	 * Remove btrfs sysfs interfaces first,
+	 * since it can start new transaction.
+	 */
+	btrfs_sysfs_remove_one(fs_info);
+
 	/* wait for the uuid_scan task to finish */
 	down(&fs_info->uuid_tree_rescan_sem);
 	/* avoid complains from lockdep et al., set sem back to initial state */
@@ -3673,8 +3679,6 @@ void close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_sysfs_remove_one(fs_info);
-
 	btrfs_free_fs_roots(fs_info);
 
 	btrfs_put_block_group_cache(fs_info);
-- 
2.2.2

