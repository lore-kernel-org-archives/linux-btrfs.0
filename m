From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 6/8] btrfs: fix error check of btrfs_lookup_dentry()
Date: Thu, 18 Aug 2011 14:56:59 -0700
Message-ID: <1313704621-15219-7-git-send-email-mfasheh@suse.de>
References: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
Cc: chris.mason@oracle.com, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313704621-15219-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Clean up btrfs_lookup_dentry() to never return NULL, but PTR_ERR(-ENOENT)
instead. This keeps the return value convention consistent.

Callers who pass to d_instatiate() require a trivial update.

create_snapshot() in particular looks like it can also lose a BUG_ON(!inode)
which is not really needed - there seems less harm in returning ENOENT to
userspace at that point in the stack than there is to crash the machine.

Mark: Fixed conflicts against latest tree, gave the patch a more thorough
description.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/inode.c |   12 ++++++++++--
 fs/btrfs/ioctl.c |   11 +++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7028c0c..9f3a85d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4027,7 +4027,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		return ERR_PTR(ret);
 
 	if (location.objectid == 0)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
@@ -4085,7 +4085,15 @@ static void btrfs_dentry_release(struct dentry *dentry)
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
-	return d_splice_alias(btrfs_lookup_dentry(dir, dentry), dentry);
+	struct inode *inode = btrfs_lookup_dentry(dir, dentry);
+	if (IS_ERR(inode)) {
+		if (PTR_ERR(inode) == -ENOENT)
+			inode = NULL;
+		else
+			return ERR_CAST(inode);
+	}
+
+	return d_splice_alias(inode, dentry);
 }
 
 unsigned char btrfs_filetype_table[] = {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b3440f5..692eac2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -325,6 +325,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	struct btrfs_root *new_root;
 	struct dentry *parent = dentry->d_parent;
 	struct inode *dir;
+	struct inode *inode;
 	int ret;
 	int err;
 	u64 objectid;
@@ -435,7 +436,13 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	BUG_ON(ret);
 
-	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
+	inode = btrfs_lookup_dentry(dir, dentry);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto fail;
+	}
+
+	d_instantiate(dentry, inode);
 fail:
 	if (async_transid) {
 		*async_transid = trans->transid;
@@ -505,7 +512,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		ret = PTR_ERR(inode);
 		goto fail;
 	}
-	BUG_ON(!inode);
+
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:
-- 
1.7.6

