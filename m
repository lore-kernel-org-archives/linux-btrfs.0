Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36365 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751423AbaHTIKW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 04:10:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] btrfs: Fix a deadlock in btrfs_dev_replace_finishing()
Date: Wed, 20 Aug 2014 16:10:15 +0800
Message-ID: <1408522215-15803-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-transacion:5657
[stack snip]
btrfs_bio_map()
    btrfs_bio_counter_inc_blocked()
        percpu_counter_inc(&fs_info->bio_counter)  ###bio_counter > 0(A)
        __btrfs_bio_map()
            btrfs_dev_replace_lock()
                mutex_lock(dev_replace->lock)	   ###wait mutex(B)

btrfs:32612
[stack snip]
btrfs_dev_replace_start()
    btrfs_dev_replace_lock()
	mutex_lock(dev_replace->lock)		   ###hold mutex(B)
    btrfs_dev_replace_finishing()
        btrfs_rm_dev_replace_blocked()
            wait until percpu_counter_sum == 0	   ###wait on bio_counter(A)

This bug can be triggered quite easily by the following test script:
http://pastebin.com/MQmb37Cy

This patch will fix the ABBA problem by calling
btrfs_dev_replace_unlock() before btrfs_rm_dev_replace_blocked().

The consistency of btrfs devices list and their superblocks is protected
by device_list_mutex, not btrfs_dev_replace_lock/unlock().
So it is safe the move btrfs_dev_replace_unlock() before
btrfs_rm_dev_replace_blocked().

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..d738ff8 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -567,6 +567,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	btrfs_kobj_rm_device(fs_info, src_device);
 	btrfs_kobj_add_device(fs_info, tgt_device);
 
+	btrfs_dev_replace_unlock(dev_replace);
+
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
@@ -580,7 +582,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * superblock is scratched out so that it is no longer marked to
 	 * belong to this filesystem.
 	 */
-	btrfs_dev_replace_unlock(dev_replace);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	mutex_unlock(&root->fs_info->chunk_mutex);
 
-- 
2.0.4

