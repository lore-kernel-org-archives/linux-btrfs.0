Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752324AbdBMJer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B75F0AC53
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 18/29] btrfs: remove unused parameter from btrfs_fill_super
Date: Mon, 13 Feb 2017 10:34:16 +0100
Message-Id: <a644ec1f6d10a61e4f0f5fcb313cf9d0894e9876.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used for anything meaningful since we have our own superblock
filler.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 93ed29c2a38b..da687dc79cce 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1114,7 +1114,7 @@ static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objec
 
 static int btrfs_fill_super(struct super_block *sb,
 			    struct btrfs_fs_devices *fs_devices,
-			    void *data, int silent)
+			    void *data)
 {
 	struct inode *inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
@@ -1611,8 +1611,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		error = btrfs_fill_super(s, fs_devices, data,
-					 flags & MS_SILENT ? 1 : 0);
+		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (error) {
 		deactivate_locked_super(s);
-- 
2.10.1

