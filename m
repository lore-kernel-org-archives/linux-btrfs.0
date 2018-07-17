Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48214 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbeGQWoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 18:44:01 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>,
        linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Wed, 18 Jul 2018 00:09:00 +0200
Message-Id: <20180717220900.3588-2-kilobyte@angband.pl>
In-Reply-To: <20180717220900.3588-1-kilobyte@angband.pl>
References: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
 <20180717220900.3588-1-kilobyte@angband.pl>
Subject: [PATCH resend 2/2] btrfs: defrag: return EPERM not EINVAL when only permissions fail
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
index 01c150b6ab62..e96e3c3caca1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2943,7 +2943,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	case S_IFREG:
 		if (!capable(CAP_SYS_ADMIN) &&
 		    inode_permission(inode, MAY_WRITE)) {
-			ret = -EINVAL;
+			ret = -EPERM;
 			goto out;
 		}
 
-- 
2.18.0

