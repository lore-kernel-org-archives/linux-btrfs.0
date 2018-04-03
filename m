Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbeDCSgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:36:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 214C6ABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:36:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/16] btrfs: squeeze btrfs_dev_replace_continue_on_mount to its caller
Date: Tue,  3 Apr 2018 20:34:03 +0200
Message-Id: <c231bf7bd55260809fd6cd7f3e835eba933914fe.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function is called once and is fairly small, we can merge it with
the caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0d203633bb96..c0397cd2a3ba 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -45,8 +45,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 						struct btrfs_device *srcdev,
 						struct btrfs_device *tgtdev);
 static int btrfs_dev_replace_kthread(void *data);
-static int btrfs_dev_replace_continue_on_mount(struct btrfs_fs_info *fs_info);
-
 
 int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 {
@@ -822,6 +820,7 @@ static int btrfs_dev_replace_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	u64 progress;
+	int ret;
 
 	progress = btrfs_dev_replace_progress(fs_info);
 	progress = div_u64(progress, 10);
@@ -832,23 +831,14 @@ static int btrfs_dev_replace_kthread(void *data)
 		btrfs_dev_name(dev_replace->tgtdev),
 		(unsigned int)progress);
 
-	btrfs_dev_replace_continue_on_mount(fs_info);
-	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
-
-	return 0;
-}
-
-static int btrfs_dev_replace_continue_on_mount(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-	int ret;
-
 	ret = btrfs_scrub_dev(fs_info, dev_replace->srcdev->devid,
 			      dev_replace->committed_cursor_left,
 			      btrfs_device_get_total_bytes(dev_replace->srcdev),
 			      &dev_replace->scrub_progress, 0, 1);
 	ret = btrfs_dev_replace_finishing(fs_info, ret);
 	WARN_ON(ret);
+
+	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return 0;
 }
 
-- 
2.16.2

