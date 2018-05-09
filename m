Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756311AbeEIN5Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:16 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 5/8] btrfs: add helpers for FS_XFLAG_* conversion
Date: Wed,  9 May 2018 15:54:37 +0200
Message-Id: <a4136c4ded65ad0c588d01357253f180ccad22f6.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparatory work for the FS_IOC_FSGETXATTR ioctl, basic conversions and
checking helpers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 40eeb99310d5..54dfcb851ec2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -338,6 +338,38 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	return ret;
 }
 
+/*
+ * Translate btrfs internal inode flags to xflags as expected by the
+ * FS_IOC_FSGETXATT ioctl. Filter only the supported ones, unknown flags are
+ * silently dropped.
+ */
+static unsigned int btrfs_inode_flags_to_xflags(unsigned int flags)
+{
+	unsigned int xflags = 0;
+
+	if (flags & BTRFS_INODE_APPEND)
+		xflags |= FS_XFLAG_APPEND;
+	if (flags & BTRFS_INODE_IMMUTABLE)
+		xflags |= FS_XFLAG_IMMUTABLE;
+	if (flags & BTRFS_INODE_NOATIME)
+		xflags |= FS_XFLAG_NOATIME;
+	if (flags & BTRFS_INODE_NODUMP)
+		xflags |= FS_XFLAG_NODUMP;
+	if (flags & BTRFS_INODE_SYNC)
+		xflags |= FS_XFLAG_SYNC;
+
+	return xflags;
+}
+
+/* Check if @flags are a supported and valid set of FS_XFLAGS_* flags */
+static int check_xflags(unsigned int flags)
+{
+	if (flags & ~(FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE | FS_XFLAG_NOATIME |
+		      FS_XFLAG_NODUMP | FS_XFLAG_SYNC))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
 {
 	struct inode *inode = file_inode(file);
-- 
2.16.2

