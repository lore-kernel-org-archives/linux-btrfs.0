Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdJaQro (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 12:47:44 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Nick Terrell <terrelln@fb.com>
Subject: [PATCH] btrfs: fix default compression value when set by SETFLAGS ioctl
Date: Tue, 31 Oct 2017 17:45:51 +0100
Message-Id: <20171031164551.6447-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current default for the compression file flag is 'zlib', the zstd
patch silently changed that to zstd. Though the choice of zlib might not
be the best one, we should keep the backward compatibility.

The incompat bit for zstd is not set, so this could lead to a filesystem
with a zstd compression in the extents but no flag for the filesystem.

Fixes: 5c1aab1dd5445ed8bd ("btrfs: Add zstd support")
CC: Nick Terrell <terrelln@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd172a93d11a..0ce9a895931a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -309,10 +309,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 		if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
 			comp = "lzo";
-		else if (fs_info->compress_type == BTRFS_COMPRESS_ZLIB)
-			comp = "zlib";
-		else
+		else if (fs_info->compress_type == BTRFS_COMPRESS_ZSTD)
 			comp = "zstd";
+		else
+			comp = "zlib";
 		ret = btrfs_set_prop(inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
 		if (ret)
-- 
2.14.0

