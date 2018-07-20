Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTPTB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:19:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1CD8AD96
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:30:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: dev-replace: remove unused members of btrfs_dev_replace
Date: Fri, 20 Jul 2018 16:30:20 +0200
Message-Id: <dd7a5ce9d50e3d5acdcc14aee55b0b054a0cdd49.1532096607.git.dsterba@suse.com>
In-Reply-To: <cover.1532096607.git.dsterba@suse.com>
References: <cover.1532096607.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lock owner and nesting level have been unused since day 1, probably
copy&pasted from the extent_buffer locking scheme without much thinking.
The locking of device replace is simpler and does not need any lock
nesting.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 2 --
 fs/btrfs/disk-io.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4ca6c4e141ea..5f6ec80d374f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -365,8 +365,6 @@ struct btrfs_dev_replace {
 	struct btrfs_device *srcdev;
 	struct btrfs_device *tgtdev;
 
-	pid_t lock_owner;
-	atomic_t nesting_level;
 	struct mutex lock_finishing_cancel_unmount;
 	rwlock_t lock;
 	atomic_t read_locks;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3830867e0225..c1d287a766c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2154,8 +2154,6 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
 
 static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
-	fs_info->dev_replace.lock_owner = 0;
-	atomic_set(&fs_info->dev_replace.nesting_level, 0);
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	rwlock_init(&fs_info->dev_replace.lock);
 	atomic_set(&fs_info->dev_replace.read_locks, 0);
-- 
2.18.0

