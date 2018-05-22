Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46724 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbeEVWCW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 18:02:22 -0400
Received: by mail-pf0-f194.google.com with SMTP id p12-v6so9404205pff.13
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:02:21 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 1/2] Btrfs: fix clone vs chattr NODATASUM race
Date: Tue, 22 May 2018 15:02:12 -0700
Message-Id: <d8b7c9b717e879eff65bb01e4247696811e975f1.1527026445.git.osandov@fb.com>
In-Reply-To: <cover.1527026445.git.osandov@fb.com>
References: <cover.1527026445.git.osandov@fb.com>
In-Reply-To: <cover.1527026445.git.osandov@fb.com>
References: <cover.1527026445.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In btrfs_clone_files(), we must check the NODATASUM flag while the
inodes are locked. Otherwise, it's possible that btrfs_ioctl_setflags()
will change the flags after we check and we can end up with a party
checksummed file.

Fixes: 0e7b824c4ef9 ("Btrfs: don't make a file partly checksummed through file clone")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cf0d3bc6f625..784e267aad32 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4280,11 +4280,6 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	    src->i_sb != inode->i_sb)
 		return -EXDEV;
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		return -EINVAL;
-
 	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
 		return -EISDIR;
 
@@ -4294,6 +4289,13 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 		inode_lock(src);
 	}
 
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/* determine range to clone */
 	ret = -EINVAL;
 	if (off + len > src->i_size || off + len < off)
-- 
2.17.0

