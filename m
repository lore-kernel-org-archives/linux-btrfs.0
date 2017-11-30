Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbdK3QLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:11:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E43EAE74
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:10:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: SETFLAGS ioctl: use helper for compression type conversion
Date: Thu, 30 Nov 2017 17:09:02 +0100
Message-Id: <233097e27401c0f3163e7dc7c72442f50309705a.1512058075.git.dsterba@suse.com>
In-Reply-To: <cover.1512058075.git.dsterba@suse.com>
References: <cover.1512058075.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e8adebc8c1b0..c41c259d9283 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -307,12 +307,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
-		if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
-			comp = "lzo";
-		else if (fs_info->compress_type == BTRFS_COMPRESS_ZLIB)
-			comp = "zlib";
-		else
-			comp = "zstd";
+		comp = btrfs_compress_type2str(fs_info->compress_type);
+		if (!comp || comp[0] == 0)
+			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
+
 		ret = btrfs_set_prop(inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
 		if (ret)
-- 
2.15.0

