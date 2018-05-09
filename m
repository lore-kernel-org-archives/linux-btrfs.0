Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34329 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756236AbeEIN5L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:11 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 3/8] btrfs: rename check_flags to reflect which flags it touches
Date: Wed,  9 May 2018 15:54:33 +0200
Message-Id: <6707dfa1a0e40b204214b236c4628465ab519a18.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
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
index e93dc3a6f554..0b84f9e68f86 100644
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

