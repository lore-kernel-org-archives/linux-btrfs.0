From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: handle NFS lookups properly
Date: Wed, 17 Nov 2010 13:54:54 -0500
Message-ID: <1290020094-2441-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

People kept reporting NFS issues, specifically getting ESTALE alot.  I figured
out how to reproduce the problem

SERVER
mkfs.btrfs /dev/sda1
mount /dev/sda1 /mnt/btrfs-test
<add /mnt/btrfs-test to /etc/exports>
btrfs subvol create /mnt/btrfs-test/foo
service nfs start

CLIENT
mount server:/mnt/btrfs /mnt/test
cd /mnt/test/foo
ls

SERVER
echo 3 > /proc/sys/vm/drop_caches

CLIENT
ls			<-- get an ESTALE here

This is because the standard way to lookup a name in nfsd is to use readdir, and
what it does is do a readdir on the parent directory looking for the inode of
the child.  So in this case the parent being / and the child being foo.  Well
subvols all have the same inode number, so doing a readdir of / looking for
inode 256 will return '.', which obviously doesn't match foo.  So instead we
need to have our own .get_name so that we can find the right name.

Our .get_name will either lookup the inode backref or the root backref,
whichever we're looking for, and return the name we find.  Running the above
reproducer with this patch results in everything acting the way its supposed to.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/export.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 951ef09..6f04444 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -232,9 +232,85 @@ fail:
 	return ERR_PTR(ret);
 }
 
+static int btrfs_get_name(struct dentry *parent, char *name,
+			  struct dentry *child)
+{
+	struct inode *inode = child->d_inode;
+	struct inode *dir = parent->d_inode;
+	struct btrfs_path *path;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_inode_ref *iref;
+	struct btrfs_root_ref *rref;
+	struct extent_buffer *leaf;
+	unsigned long name_ptr;
+	struct btrfs_key key;
+	int name_len;
+	int ret;
+
+	if (!dir || !inode)
+		return -EINVAL;
+
+	if (!S_ISDIR(dir->i_mode))
+		return -EINVAL;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+		key.objectid = BTRFS_I(inode)->root->root_key.objectid;
+		key.type = BTRFS_ROOT_BACKREF_KEY;
+		key.offset = (u64)-1;
+		root = root->fs_info->tree_root;
+	} else {
+		key.objectid = inode->i_ino;
+		key.offset = dir->i_ino;
+		key.type = BTRFS_INODE_REF_KEY;
+	}
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		btrfs_free_path(path);
+		return ret;
+	} else if (ret > 0) {
+		if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+			path->slots[0]--;
+		} else {
+			btrfs_free_path(path);
+			return -ENOENT;
+		}
+	}
+	leaf = path->nodes[0];
+
+	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	       rref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_root_ref);
+	       name_ptr = (unsigned long)(rref + 1);
+	       name_len = btrfs_root_ref_name_len(leaf, rref);
+	} else {
+		iref = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_inode_ref);
+		name_ptr = (unsigned long)(iref + 1);
+		name_len = btrfs_inode_ref_name_len(leaf, iref);
+	}
+
+	read_extent_buffer(leaf, name, name_ptr, name_len);
+	btrfs_free_path(path);
+
+	/*
+	 * have to add the null termination to make sure that reconnect_path
+	 * gets the right len for strlen
+	 */
+	name[name_len] = '\0';
+
+	return 0;
+}
+
 const struct export_operations btrfs_export_ops = {
 	.encode_fh	= btrfs_encode_fh,
 	.fh_to_dentry	= btrfs_fh_to_dentry,
 	.fh_to_parent	= btrfs_fh_to_parent,
 	.get_parent	= btrfs_get_parent,
+	.get_name	= btrfs_get_name,
 };
-- 
1.6.6.1

