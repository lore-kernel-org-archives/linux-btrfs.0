Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753606AbeDTRFN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7F370AE7A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: add helpers for FS_XFLAG_* conversion
Date: Fri, 20 Apr 2018 19:02:41 +0200
Message-Id: <b4b5969a7f06d933157d91315c910e60f0f0f996.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparatory work for the FS_IOC_FSGETXATTR ioctl, basic conversions and
checking helpers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f0e6074233fa..a25ad4e6a478 100644
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

