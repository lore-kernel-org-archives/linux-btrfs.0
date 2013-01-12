Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab3ALC5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 21:57:24 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0C2vNp2022517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 21:57:23 -0500
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0C2vMV5008681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 21:57:23 -0500
Message-ID: <50F0D112.3020407@redhat.com>
Date: Fri, 11 Jan 2013 20:57:22 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: update timestamps on truncate()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

truncate() vs. ftruncate() differ in the VFS; truncate()
doesn't set (ATTR_CTIME | ATTR_MTIME), and it's up to the
fs to do the timestamp updates if the size changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Hm, am I breaking the rules by updating the vfs inode fields
before the transaction starts?

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16d9e8e..af1ab2d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -88,7 +88,7 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
 
-static int btrfs_setsize(struct inode *inode, loff_t newsize);
+static int btrfs_setsize(struct inode *inode, struct iattr *attr);
 static int btrfs_truncate(struct inode *inode);
 static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
@@ -3748,16 +3748,27 @@ next:
 	return err;
 }
 
-static int btrfs_setsize(struct inode *inode, loff_t newsize)
+static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	loff_t oldsize = i_size_read(inode);
+	loff_t newsize = attr->ia_size;
+	int mask = attr->ia_valid;
 	int ret;
 
 	if (newsize == oldsize)
 		return 0;
 
+	/*
+	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
+	 * special case where we need to update the times despite not having
+	 * these flags set.  For all other operations the VFS set these flags
+	 * explicitly if it wants a timestamp update.
+	 */
+	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
+		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
+
 	if (newsize > oldsize) {
 		truncate_pagecache(inode, oldsize, newsize);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
@@ -3805,7 +3816,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 		return err;
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		err = btrfs_setsize(inode, attr->ia_size);
+		err = btrfs_setsize(inode, attr);
 		if (err)
 			return err;
 	}

