Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48885 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbeBPD7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 22:59:53 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A6C02AD93
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Feb 2018 03:59:52 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: use kvzalloc to allocate btrfs_fs_info
Date: Thu, 15 Feb 2018 22:59:47 -0500
Message-Id: <20180216035947.31590-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The srcu_struct in btrfs_fs_infoa scales in size with NR_CPUS.  On
kernels built with NR_CPUS=8192, this can result in kmalloc failures
that prevent mounting.

There is work in progress to try to resolve this for every user of
srcu_struct but using kvzalloc will work around the failures until
that is complete.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/super.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a462ab85c49..0f521ba5f2f9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2974,7 +2974,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
-	kfree(fs_info);
+	kvfree(fs_info);
 }
 
 /* tree mod log functions from ctree.c */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6e71a2a78363..4b817947e00f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1545,7 +1545,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	 * it for searching for existing supers, so this lets us do that and
 	 * then open_ctree will properly initialize everything later.
 	 */
-	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
+	fs_info = kvzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
 	if (!fs_info) {
 		error = -ENOMEM;
 		goto error_sec_opts;
-- 
2.15.1

