Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934355AbdBQQ2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:28:19 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B535ABA2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 16:28:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: constify name of subvolume in creation helpers
Date: Fri, 17 Feb 2017 17:27:48 +0100
Message-Id: <9f9b05119dd1a77bc302a6a993a953cf543c3d50.1487348702.git.dsterba@suse.com>
In-Reply-To: <cover.1487348702.git.dsterba@suse.com>
References: <cover.1487348702.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 717f34f977d5..8449ce435b27 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -434,7 +434,7 @@ int btrfs_is_empty_uuid(u8 *uuid)
 
 static noinline int create_subvol(struct inode *dir,
 				  struct dentry *dentry,
-				  char *name, int namelen,
+				  const char *name, int namelen,
 				  u64 *async_transid,
 				  struct btrfs_qgroup_inherit *inherit)
 {
@@ -832,7 +832,7 @@ static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
  * inside this filesystem so it's quite a bit simpler.
  */
 static noinline int btrfs_mksubvol(const struct path *parent,
-				   char *name, int namelen,
+				   const char *name, int namelen,
 				   struct btrfs_root *snap_src,
 				   u64 *async_transid, bool readonly,
 				   struct btrfs_qgroup_inherit *inherit)
@@ -1625,7 +1625,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 }
 
 static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
-				char *name, unsigned long fd, int subvol,
+				const char *name, unsigned long fd, int subvol,
 				u64 *transid, bool readonly,
 				struct btrfs_qgroup_inherit *inherit)
 {
-- 
2.10.1

