From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
Date: Tue, 28 Jun 2011 12:34:49 +0900
Message-ID: <201106280334.AA00027@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The return value of btrfs_lookup_dentry is checked so that
the panic such as illegal address reference should not occur.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    1 +
 fs/btrfs/ioctl.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 447612d..1364ae8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4082,6 +4082,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	inode = btrfs_lookup_dentry(dir, dentry);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
+	BUG_ON(!inode);
 
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..39c62d3 100644
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
@@ -437,7 +438,14 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	BUG_ON(ret);
 
-	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
+	inode = btrfs_lookup_dentry(dir, dentry);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto fail;
+	}
+	BUG_ON(!inode);
+
+	d_instantiate(dentry, inode);
 fail:
 	dput(parent);
 	if (async_transid) {


