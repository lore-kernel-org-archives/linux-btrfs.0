Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46482 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755906AbeAHIDg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 03:03:36 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 1/3] btrfs: fail mount when sb flag is not in BTRFS_SUPER_FLAG_SUPP
Date: Mon,  8 Jan 2018 16:04:19 +0800
Message-Id: <20180108080421.17668-2-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-1-anand.jain@oracle.com>
References: <20180108080421.17668-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appear from the original commit [1] that there isn't any design
specific reason not to fail the mount instead of just warning. This
patch will change it to fail.

[1]
 commit 319e4d0661e5323c9f9945f0f8fb5905e5fe74c3
    btrfs: Enhance super validation check

Signed-off-by: Anand Jain <anand.jain@oracle.com>
  cc: wqu@suse.com
---
 fs/btrfs/disk-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a69e5944dc08..b04da740a9a2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3906,9 +3906,11 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		btrfs_err(fs_info, "no valid FS found");
 		ret = -EINVAL;
 	}
-	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)
-		btrfs_warn(fs_info, "unrecognized super flag: %llu",
+	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
+		btrfs_err(fs_info, "unrecognized or unsupported super flag: %llu",
 				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
+		ret = -EINVAL;
+	}
 	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
 		btrfs_err(fs_info, "tree_root level too big: %d >= %d",
 				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
-- 
2.15.0

