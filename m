Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:32924 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWGqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:15 -0400
Received: by mail-pf0-f170.google.com with SMTP id k3so3737683pfc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:15 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/7] Btrfs: fix incorrect {node,sector}size endianness from BTRFS_IOC_FS_INFO
Date: Tue, 22 Aug 2017 23:46:00 -0700
Message-Id: <0f9325bfb4a8245c2fd0eb0fec73dc791a04932f.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
In-Reply-To: <cover.1503470354.git.osandov@fb.com>
References: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

fs_info->super_copy->{node,sector}size are little-endian, but the ioctl
should return the values in native endianness. Use the cached values in
btrfs_fs_info instead. Found with sparse.

Fixes: 80a773fbfc2d ("btrfs: retrieve more info from FS_INFO ioctl")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..b51124d5b8a3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2804,9 +2804,9 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	fi_args->nodesize = fs_info->super_copy->nodesize;
-	fi_args->sectorsize = fs_info->super_copy->sectorsize;
-	fi_args->clone_alignment = fs_info->super_copy->sectorsize;
+	fi_args->nodesize = fs_info->nodesize;
+	fi_args->sectorsize = fs_info->sectorsize;
+	fi_args->clone_alignment = fs_info->sectorsize;
 
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
 		ret = -EFAULT;
-- 
2.14.1

