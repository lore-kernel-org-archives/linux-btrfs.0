Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdCDSdK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Mar 2017 13:33:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A1DF1AAB2
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Mar 2017 18:33:08 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs: No need to check !(flags & MS_RDONLY) twice
Date: Sat,  4 Mar 2017 12:32:50 -0600
Message-Id: <20170304183250.32295-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Code cleanup.
The code block is for !(*flags & MS_RDONLY). We don't need
to check it again.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index da687dc..e9ae93e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1785,8 +1785,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		     fs_info->num_tolerated_disk_barrier_failures) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
-- 
2.10.2

