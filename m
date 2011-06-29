From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH v3] Btrfs: fix error check of btrfs_lookup_dentry()
Date: Wed, 29 Jun 2011 13:54:51 +0900
Message-ID: <201106290454.AA00029@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The return value of btrfs_lookup_dentry is checked so that
the panic such as illegal address reference should not occur.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
V1->V2: unnecessary BUG_ON was deleted
V2->V3: to return -ENOENT instead of NULL when no entry was found,
        return value of btrfs_lookup_dentry is changed.

 fs/btrfs/inode.c |   10 +++++++---
 fs/btrfs/ioctl.c |   10 ++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 447612d..9210c60 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4025,7 +4025,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		return ERR_PTR(ret);
 
 	if (location.objectid == 0)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
@@ -4080,8 +4080,12 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 
 	inode = btrfs_lookup_dentry(dir, dentry);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
+	if (IS_ERR(inode)) {
+		if (PTR_ERR(inode) == -ENOENT)
+			inode = NULL;
+		else
+			return ERR_CAST(inode);
+	}
 
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..981084d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -325,6 +325,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	struct btrfs_root *new_root;
 	struct dentry *parent = dget_parent(dentry);
 	struct inode *dir;
+	struct inode *inode;
 	int ret;
 	int err;
 	u64 objectid;
@@ -437,7 +438,13 @@ static noinline int create_subvol(struct btrfs_root *root,
 
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
 	dput(parent);
 	if (async_transid) {
@@ -511,7 +518,6 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		ret = PTR_ERR(inode);
 		goto fail;
 	}
-	BUG_ON(!inode);
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:


