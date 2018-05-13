Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37894 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeEMSDU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 14:03:20 -0400
Date: Sun, 13 May 2018 19:03:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH] btrfs: take the last remnants of ->d_fsdata use out
Message-ID: <20180513180317.GR30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[spotted while going through ->d_fsdata handling around d_splice_alias();
don't really care which tree that goes through]

The only thing even looking at ->d_fsdata in there (since 2012)
had been kfree(dentry->d_fsdata) in btrfs_dentry_delete().  Which,
incidentally, is all btrfs_dentry_delete() does.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e064c49c9a9a..c6b2b0a20561 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5842,11 +5842,6 @@ static int btrfs_dentry_delete(const struct dentry *dentry)
 	return 0;
 }
 
-static void btrfs_dentry_release(struct dentry *dentry)
-{
-	kfree(dentry->d_fsdata);
-}
-
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
 {
@@ -10665,5 +10660,4 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
-	.d_release	= btrfs_dentry_release,
 };
