Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbeHDPLt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:11:49 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 7F7674B66A09
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:11:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs: simplify the send_in_progress check in btrfs_delete_subvolume()
Date: Sat, 4 Aug 2018 21:10:53 +0800
Message-ID: <20180804131057.9967-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only when send_in_progress, we have to do something different such as
btrfs_warn() and return -EPERM. Therefore, we could check
send_in_progress first and process error handling, after the
root_item_lock has been got.

Just for better readability. No Functional Change.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f51ddc18f98..a7d9691a681f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4287,18 +4287,17 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	 * again is not run concurrently.
 	 */
 	spin_lock(&dest->root_item_lock);
-	root_flags = btrfs_root_flags(&dest->root_item);
-	if (dest->send_in_progress == 0) {
-		btrfs_set_root_flags(&dest->root_item,
-				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
-		spin_unlock(&dest->root_item_lock);
-	} else {
+	if (dest->send_in_progress) {
 		spin_unlock(&dest->root_item_lock);
 		btrfs_warn(fs_info,
 			   "attempt to delete subvolume %llu during send",
 			   dest->root_key.objectid);
 		return -EPERM;
 	}
+	root_flags = btrfs_root_flags(&dest->root_item);
+	btrfs_set_root_flags(&dest->root_item,
+			     root_flags | BTRFS_ROOT_SUBVOL_DEAD);
+	spin_unlock(&dest->root_item_lock);
 
 	down_write(&fs_info->subvol_sem);
 
-- 
2.18.0



