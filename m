Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:46 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58B94ACBB
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/11] btrfs: dev-replace: avoid useless lock on error handling path
Date: Fri,  7 Sep 2018 16:55:11 +0200
Message-Id: <41a1cc8519061dde7a7cbf2139f672d433a5cfbd.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The exit sequence in btrfs_dev_replace_start does not allow to simply
add a label to the right place so the error handling after starting
transaction failure jumps there. Currently there's a lock that pairs
with the unlock in the section, which is unnecessary and only raises
questions.  Add a variable to track the locking status and avoid the
extra locking.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8b512dddf727..0a49843b2ee6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -400,6 +400,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	int ret;
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
+	bool need_unlock;
 
 	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
 					    srcdev_name, &src_device);
@@ -424,6 +425,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		return PTR_ERR(trans);
 	}
 
+	need_unlock = true;
 	btrfs_dev_replace_write_lock(dev_replace);
 	switch (dev_replace->replace_state) {
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
@@ -462,6 +464,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	atomic64_set(&dev_replace->num_write_errors, 0);
 	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
 	btrfs_dev_replace_write_unlock(dev_replace);
+	need_unlock = false;
 
 	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
 	if (ret)
@@ -473,7 +476,6 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_dev_replace_write_lock(dev_replace);
 		goto leave;
 	}
 
@@ -497,7 +499,8 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 leave:
 	dev_replace->srcdev = NULL;
 	dev_replace->tgtdev = NULL;
-	btrfs_dev_replace_write_unlock(dev_replace);
+	if (need_unlock)
+		btrfs_dev_replace_write_unlock(dev_replace);
 	btrfs_destroy_dev_replace_tgtdev(tgt_device);
 	return ret;
 }
-- 
2.18.0
