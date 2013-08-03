Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65117 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3HCSnl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Aug 2013 14:43:41 -0400
Received: by mail-wi0-f179.google.com with SMTP id hr7so400719wib.6
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 11:43:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: race free update of super flags
Date: Sat,  3 Aug 2013 19:43:17 +0100
Message-Id: <1375555397-10886-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before updating the super block's flags, which is a non-atomic
operation, grab the super_lock in the fs_info structure. At
the moment only 2 different code paths can update these flags
in parallel:

1) when adding a new device
2) writing all super block copies to disk

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.h   |    4 ++--
 fs/btrfs/disk-io.c |    2 ++
 fs/btrfs/volumes.c |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cbb1263..fd47c02 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1375,8 +1375,8 @@ struct btrfs_fs_info {
 	wait_queue_head_t async_submit_wait;
 
 	/*
-	 * Used to protect the incompat_flags, compat_flags, compat_ro_flags
-	 * when they are updated.
+	 * Used to protect the incompat_flags, compat_flags, compat_ro_flags,
+	 * flags and label when they are updated.
 	 *
 	 * Because we do not clear the flags for ever, so we needn't use
 	 * the lock on the read side.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b71e882..3900c36 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3357,8 +3357,10 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
 		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
 
+		spin_lock(&root->fs_info->super_lock);
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
+		spin_unlock(&root->fs_info->super_lock);
 
 		ret = write_dev_supers(dev, sb, do_barriers, 0, max_mirrors);
 		if (ret)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 090f57c..8c67bd7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1862,9 +1862,11 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(root->fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	spin_lock(&root->fs_info->super_lock);
 	super_flags = btrfs_super_flags(disk_super) &
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
+	spin_unlock(&root->fs_info->super_lock);
 
 	return 0;
 }
-- 
1.7.9.5

