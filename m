Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41986 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbeEUOpx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 10:45:53 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 21 May 2018 16:45:15 +0200
Message-Id: <20180521144515.16501-2-kilobyte@angband.pl>
In-Reply-To: <20180521144515.16501-1-kilobyte@angband.pl>
References: <20180521144254.4zdxt6jtxoeca26o@angband.pl>
 <20180521144515.16501-1-kilobyte@angband.pl>
Subject: [PATCH 2/2] btrfs: defrag: return EPERM not EINVAL when only permissions fail
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We give EINVAL when the request is invalid; here it's ok but merely the
user has insufficient privileges.  Thus, this return value reflects the
error better -- as discussed in the identical case for dedupe.

According to codesearch.debian.net, no userspace program distinguishes
these values beyond strerror().

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b75db9d72106..ae6a110987a7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2563,7 +2563,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	case S_IFREG:
 		if (!capable(CAP_SYS_ADMIN) &&
 		    inode_permission(inode, MAY_WRITE)) {
-			ret = -EINVAL;
+			ret = -EPERM;
 			goto out;
 		}
 
-- 
2.17.0

