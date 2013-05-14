Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3ENKUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:20:53 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] Btrfs: move the R/O check out of btrfs_clean_one_deleted_snapshot()
Date: Tue, 14 May 2013 18:20:42 +0800
Message-Id: <1368526843-18000-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the fs is remounted to be R/O, it is unnecessary to call
btrfs_clean_one_deleted_snapshot(), so move the R/O check out of
this function. And besides that, it can make the check logic in the
caller more clear.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c     | 9 +++++++++
 fs/btrfs/transaction.c | 5 -----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 927da1a..c69ff46 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1702,6 +1702,15 @@ static int cleaner_kthread(void *arg)
 		if (!mutex_trylock(&root->fs_info->cleaner_mutex))
 			goto sleep;
 
+		/*
+		 * Avoid the problem that we change the status of the fs
+		 * during the above check and trylock.
+		 */
+		if (need_cleaner_sleep(root)) {
+			mutex_unlock(&root->fs_info->cleaner_mutex);
+			goto sleep;
+		}
+
 		btrfs_run_delayed_iputs(root);
 		again = btrfs_clean_one_deleted_snapshot(root);
 		mutex_unlock(&root->fs_info->cleaner_mutex);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 89fad06..4b63111 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1885,11 +1885,6 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	if (fs_info->sb->s_flags & MS_RDONLY) {
-		pr_debug("btrfs: cleaner called for RO fs!\n");
-		return 0;
-	}
-
 	spin_lock(&fs_info->trans_lock);
 	if (list_empty(&fs_info->dead_roots)) {
 		spin_unlock(&fs_info->trans_lock);
-- 
1.8.1.4

