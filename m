Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756311AbeEIN5X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:23 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 8/8] btrfs: unify naming of flags variables for SETFLAGS and XFLAGS
Date: Wed,  9 May 2018 15:54:44 +0200
Message-Id: <76fc804ae9daab86d7ed28215ab186ac5c65bf28.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* The simple 'flags' refer to the btrfs inode
* ... that's in 'binode
* the FS_*_FL variables are 'fsflags'
* the old copies of the variable are prefixed by 'old_'
* Struct inode flags contain 'i_flags'.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 106 +++++++++++++++++++++++++++----------------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 838a7a80e6b0..c1904d9d99e2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -140,18 +140,18 @@ static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
  */
 void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 {
-	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_inode *binode = BTRFS_I(inode);
 	unsigned int new_fl = 0;
 
-	if (ip->flags & BTRFS_INODE_SYNC)
+	if (binode->flags & BTRFS_INODE_SYNC)
 		new_fl |= S_SYNC;
-	if (ip->flags & BTRFS_INODE_IMMUTABLE)
+	if (binode->flags & BTRFS_INODE_IMMUTABLE)
 		new_fl |= S_IMMUTABLE;
-	if (ip->flags & BTRFS_INODE_APPEND)
+	if (binode->flags & BTRFS_INODE_APPEND)
 		new_fl |= S_APPEND;
-	if (ip->flags & BTRFS_INODE_NOATIME)
+	if (binode->flags & BTRFS_INODE_NOATIME)
 		new_fl |= S_NOATIME;
-	if (ip->flags & BTRFS_INODE_DIRSYNC)
+	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
 
 	set_mask_bits(&inode->i_flags,
@@ -161,8 +161,8 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 
 static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 {
-	struct btrfs_inode *ip = BTRFS_I(file_inode(file));
-	unsigned int flags = btrfs_inode_flags_to_fsflags(ip->flags);
+	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
+	unsigned int flags = btrfs_inode_flags_to_fsflags(binode->flags);
 
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
@@ -189,13 +189,13 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_inode *ip = BTRFS_I(inode);
-	struct btrfs_root *root = ip->root;
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	struct btrfs_root *root = binode->root;
 	struct btrfs_trans_handle *trans;
-	unsigned int flags, oldflags;
+	unsigned int fsflags, old_fsflags;
 	int ret;
-	u64 ip_oldflags;
-	unsigned int i_oldflags;
+	u64 old_flags;
+	unsigned int old_i_flags;
 	umode_t mode;
 
 	if (!inode_owner_or_capable(inode))
@@ -204,10 +204,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
-	if (copy_from_user(&flags, arg, sizeof(flags)))
+	if (copy_from_user(&fsflags, arg, sizeof(fsflags)))
 		return -EFAULT;
 
-	ret = check_fsflags(flags);
+	ret = check_fsflags(fsflags);
 	if (ret)
 		return ret;
 
@@ -217,44 +217,44 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	inode_lock(inode);
 
-	ip_oldflags = ip->flags;
-	i_oldflags = inode->i_flags;
+	old_flags = binode->flags;
+	old_i_flags = inode->i_flags;
 	mode = inode->i_mode;
 
-	flags = btrfs_mask_fsflags_for_type(inode, flags);
-	oldflags = btrfs_inode_flags_to_fsflags(ip->flags);
-	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
+	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+	if ((fsflags ^ old_fsflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
 		if (!capable(CAP_LINUX_IMMUTABLE)) {
 			ret = -EPERM;
 			goto out_unlock;
 		}
 	}
 
-	if (flags & FS_SYNC_FL)
-		ip->flags |= BTRFS_INODE_SYNC;
+	if (fsflags & FS_SYNC_FL)
+		binode->flags |= BTRFS_INODE_SYNC;
 	else
-		ip->flags &= ~BTRFS_INODE_SYNC;
-	if (flags & FS_IMMUTABLE_FL)
-		ip->flags |= BTRFS_INODE_IMMUTABLE;
+		binode->flags &= ~BTRFS_INODE_SYNC;
+	if (fsflags & FS_IMMUTABLE_FL)
+		binode->flags |= BTRFS_INODE_IMMUTABLE;
 	else
-		ip->flags &= ~BTRFS_INODE_IMMUTABLE;
-	if (flags & FS_APPEND_FL)
-		ip->flags |= BTRFS_INODE_APPEND;
+		binode->flags &= ~BTRFS_INODE_IMMUTABLE;
+	if (fsflags & FS_APPEND_FL)
+		binode->flags |= BTRFS_INODE_APPEND;
 	else
-		ip->flags &= ~BTRFS_INODE_APPEND;
-	if (flags & FS_NODUMP_FL)
-		ip->flags |= BTRFS_INODE_NODUMP;
+		binode->flags &= ~BTRFS_INODE_APPEND;
+	if (fsflags & FS_NODUMP_FL)
+		binode->flags |= BTRFS_INODE_NODUMP;
 	else
-		ip->flags &= ~BTRFS_INODE_NODUMP;
-	if (flags & FS_NOATIME_FL)
-		ip->flags |= BTRFS_INODE_NOATIME;
+		binode->flags &= ~BTRFS_INODE_NODUMP;
+	if (fsflags & FS_NOATIME_FL)
+		binode->flags |= BTRFS_INODE_NOATIME;
 	else
-		ip->flags &= ~BTRFS_INODE_NOATIME;
-	if (flags & FS_DIRSYNC_FL)
-		ip->flags |= BTRFS_INODE_DIRSYNC;
+		binode->flags &= ~BTRFS_INODE_NOATIME;
+	if (fsflags & FS_DIRSYNC_FL)
+		binode->flags |= BTRFS_INODE_DIRSYNC;
 	else
-		ip->flags &= ~BTRFS_INODE_DIRSYNC;
-	if (flags & FS_NOCOW_FL) {
+		binode->flags &= ~BTRFS_INODE_DIRSYNC;
+	if (fsflags & FS_NOCOW_FL) {
 		if (S_ISREG(mode)) {
 			/*
 			 * It's safe to turn csums off here, no extents exist.
@@ -262,10 +262,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			 * status of the file and will not set it.
 			 */
 			if (inode->i_size == 0)
-				ip->flags |= BTRFS_INODE_NODATACOW
-					   | BTRFS_INODE_NODATASUM;
+				binode->flags |= BTRFS_INODE_NODATACOW
+					      | BTRFS_INODE_NODATASUM;
 		} else {
-			ip->flags |= BTRFS_INODE_NODATACOW;
+			binode->flags |= BTRFS_INODE_NODATACOW;
 		}
 	} else {
 		/*
@@ -273,10 +273,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		 */
 		if (S_ISREG(mode)) {
 			if (inode->i_size == 0)
-				ip->flags &= ~(BTRFS_INODE_NODATACOW
+				binode->flags &= ~(BTRFS_INODE_NODATACOW
 				             | BTRFS_INODE_NODATASUM);
 		} else {
-			ip->flags &= ~BTRFS_INODE_NODATACOW;
+			binode->flags &= ~BTRFS_INODE_NODATACOW;
 		}
 	}
 
@@ -285,18 +285,18 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	 * flag may be changed automatically if compression code won't make
 	 * things smaller.
 	 */
-	if (flags & FS_NOCOMP_FL) {
-		ip->flags &= ~BTRFS_INODE_COMPRESS;
-		ip->flags |= BTRFS_INODE_NOCOMPRESS;
+	if (fsflags & FS_NOCOMP_FL) {
+		binode->flags &= ~BTRFS_INODE_COMPRESS;
+		binode->flags |= BTRFS_INODE_NOCOMPRESS;
 
 		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
-	} else if (flags & FS_COMPR_FL) {
+	} else if (fsflags & FS_COMPR_FL) {
 		const char *comp;
 
-		ip->flags |= BTRFS_INODE_COMPRESS;
-		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+		binode->flags |= BTRFS_INODE_COMPRESS;
+		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
 		comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
@@ -311,7 +311,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
-		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
+		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
 	trans = btrfs_start_transaction(root, 1);
@@ -328,8 +328,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	btrfs_end_transaction(trans);
  out_drop:
 	if (ret) {
-		ip->flags = ip_oldflags;
-		inode->i_flags = i_oldflags;
+		binode->flags = old_flags;
+		inode->i_flags = old_i_flags;
 	}
 
  out_unlock:
-- 
2.16.2

