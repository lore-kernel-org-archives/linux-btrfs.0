From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Fix NFS exporting of subvol roots.
Date: Tue, 19 Aug 2008 22:32:55 +0100
Message-ID: <1219181575.2988.15.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_lookup_fs_root() only finds subvol roots which have already been
seen and put into the cache. For btrfs_get_dentry() we actually have to
go to the medium -- so use btrfs_read_fs_root_no_name() instead.

In btrfs_get_parent(), notice when we've hit the root of the
subvolume and return the real root instead.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

Is the offset of (u64)-1 in btrfs_read_fs_root_no_name() correct?

And can we have subroots (with ino == parent ino) elsewhere, or only as
direct children of sb->s_root? 

 export.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/export.c b/export.c
index a913b9b..36cbc68 100644
--- a/export.c
+++ b/export.c
@@ -71,11 +71,18 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
 	struct dentry *result;
 	struct btrfs_key key;
 
+	key.objectid = root_objectid;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root_no_name(btrfs_sb(sb)->fs_info, &key);
+	if (IS_ERR(root))
+		return ERR_CAST(root);
+
 	key.objectid = objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	root = btrfs_lookup_fs_root(btrfs_sb(sb)->fs_info, root_objectid);
 	inode = btrfs_iget(sb, &key, root, NULL);
 	if (IS_ERR(inode))
 		return (void *)inode;
@@ -178,6 +185,10 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 
 	objectid = key.offset;
 
+	/* If we are already at the root of a subvol, return the real root */
+	if (objectid == dir->i_ino)
+		return dget(dir->i_sb->s_root);
+
 	/* Build a new key for the inode item */
 	key.objectid = objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



