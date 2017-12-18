Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbdLRKDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 05:03:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51CC1ACD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 10:03:48 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix memory leak on multiple mounts
Date: Mon, 18 Dec 2017 12:03:46 +0200
Message-Id: <1513591426-2349-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if a mounted-btrfs instance is mounted for the 2nd time
without first unmounting the first instance then we hit a memory leak
in btrfs_mount_root due to the fs_info of the acquired superblock is
different than the newly allocated fs info. Fix this by specifically
checking if the fs_info instance of the newly acquired superblock is
the same as ours and free it if not.

Reproducer:

mount /dev/vdc /media/scratch
mount /dev/vdc /media/scratch2 <- memory leak hit

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e57eb6e70278..ea3bca85be44 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1612,7 +1612,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_sec_opts;
 	}
 
-	fs_info = btrfs_sb(s);
+	if (btrfs_sb(s) != fs_info) {
+		free_fs_info(fs_info);
+		fs_info = btrfs_sb(s);
+	}
+
 	error = setup_security_options(fs_info, s, &new_sec_opts);
 	if (error) {
 		deactivate_locked_super(s);
-- 
2.7.4

