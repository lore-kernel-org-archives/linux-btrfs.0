Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58661 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbeFTOfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:35:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] btrfs: use 64-bit timestamps for struct btrfs_dev_replace_item
Date: Wed, 20 Jun 2018 16:34:33 +0200
Message-Id: <20180620143448.44388-2-arnd@arndb.de>
In-Reply-To: <20180620143448.44388-1-arnd@arndb.de>
References: <20180620143448.44388-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The structure already has 64-bit fields for the timestamps, but
calling get_seconds() may truncate and risk overflow on 32-bit
architectures.

This changes the dev-replace code to use ktime_get_real_seconds()
instead, which always returns 64-bit timestamps.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/dev-replace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e2ba0419297a..1b30c38d05c9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -465,7 +465,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	 * go to the tgtdev as well (refer to btrfs_map_block()).
 	 */
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED;
-	dev_replace->time_started = get_seconds();
+	dev_replace->time_started = ktime_get_real_seconds();
 	dev_replace->cursor_left = 0;
 	dev_replace->committed_cursor_left = 0;
 	dev_replace->cursor_left_last_write_of_item = 0;
@@ -618,7 +618,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
-	dev_replace->time_stopped = get_seconds();
+	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 
 	/* replace old device with new one in mapping tree */
@@ -807,7 +807,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		break;
 	}
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
-	dev_replace->time_stopped = get_seconds();
+	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 	btrfs_dev_replace_write_unlock(dev_replace);
 	btrfs_scrub_cancel(fs_info);
@@ -848,7 +848,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
-		dev_replace->time_stopped = get_seconds();
+		dev_replace->time_stopped = ktime_get_real_seconds();
 		dev_replace->item_needs_writeback = 1;
 		btrfs_info(fs_info, "suspending dev_replace for unmount");
 		break;
-- 
2.9.0

