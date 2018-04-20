Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55027 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753599AbeDTRFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0835AC4F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:07 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/7] btrfs: rename check_flags to reflect which flags it touches
Date: Fri, 20 Apr 2018 19:02:36 +0200
Message-Id: <0500fb0c95262dcced06607fe24941b26007890b.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The FS_*_FL flags cannot be easily identified by a prefix but we still
need to recognize them so the 'fsflags' should be closer to the naming
scheme but again the 'fs' part sounds like it's a filesystem flag. I
don't have a better idea for now.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2c26beffd82..953473f2a136 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -168,7 +168,8 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 	return 0;
 }
 
-static int check_flags(unsigned int flags)
+/* Check if @flags are a supported and valid set of FS_*_FL flags */
+static int check_fsflags(unsigned int flags)
 {
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
@@ -205,7 +206,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
 
-	ret = check_flags(flags);
+	ret = check_fsflags(flags);
 	if (ret)
 		return ret;
 
-- 
2.16.2

