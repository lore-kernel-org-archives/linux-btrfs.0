Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761112Ab3JPTKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:10:47 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAkMx004783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:47 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAiSC026570
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:46 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: use get_seconds() instead of btrfs wrapper
Date: Wed, 16 Oct 2013 12:10:32 -0700
Message-Id: <1381950634-20490-2-git-send-email-zab@redhat.com>
In-Reply-To: <1381950634-20490-1-git-send-email-zab@redhat.com>
References: <1381950634-20490-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/dev-replace.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2a9bd5b..d3ee6e7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -38,7 +38,6 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 
-static u64 btrfs_get_seconds_since_1970(void);
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				       int scrub_ret);
 static void btrfs_dev_replace_update_device_in_mapping_tree(
@@ -296,13 +295,6 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 		dev_replace->cursor_left_last_write_of_item;
 }
 
-static u64 btrfs_get_seconds_since_1970(void)
-{
-	struct timespec t = CURRENT_TIME_SEC;
-
-	return t.tv_sec;
-}
-
 int btrfs_dev_replace_start(struct btrfs_root *root,
 			    struct btrfs_ioctl_dev_replace_args *args)
 {
@@ -390,7 +382,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	 * go to the tgtdev as well (refer to btrfs_map_block()).
 	 */
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED;
-	dev_replace->time_started = btrfs_get_seconds_since_1970();
+	dev_replace->time_started = get_seconds();
 	dev_replace->cursor_left = 0;
 	dev_replace->committed_cursor_left = 0;
 	dev_replace->cursor_left_last_write_of_item = 0;
@@ -493,7 +485,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
-	dev_replace->time_stopped = btrfs_get_seconds_since_1970();
+	dev_replace->time_stopped = get_seconds();
 	dev_replace->item_needs_writeback = 1;
 
 	if (scrub_ret) {
@@ -668,7 +660,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		break;
 	}
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
-	dev_replace->time_stopped = btrfs_get_seconds_since_1970();
+	dev_replace->time_stopped = get_seconds();
 	dev_replace->item_needs_writeback = 1;
 	btrfs_dev_replace_unlock(dev_replace);
 	btrfs_scrub_cancel(fs_info);
@@ -703,7 +695,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
-		dev_replace->time_stopped = btrfs_get_seconds_since_1970();
+		dev_replace->time_stopped = get_seconds();
 		dev_replace->item_needs_writeback = 1;
 		pr_info("btrfs: suspending dev_replace for unmount\n");
 		break;
-- 
1.7.11.7

