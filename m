From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] Btrfs: load the key from the dir item in readdir into a fake dentry
Date: Thu, 26 May 2011 10:48:36 -0400
Message-ID: <1306421316-1504-2-git-send-email-josef@redhat.com>
References: <adilger@dilger.ca, hch@lst.de>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <adilger@dilger.ca, hch@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs we have 2 indexes for inodes.  One is for readdir, it's in this nice
sequential order and works out brilliantly for readdir.  However if you use ls,
it usually stat's each file it gets from readdir.  This is where the second
index comes in, which is based on a hash of the name of the file.  So then the
lookup has to lookup this index, and then lookup the inode.  The index lookup is
going to be in random order (since its based on the name hash), which gives us
less than stellar performance.  Since we know the inode location from the
readdir index, I create a dummy dentry and copy the location key into
dentry->d_fsdata.  Then on lookup if we have d_fsdata we use that location to
lookup the inode, avoiding looking up the other directory index.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6228a30..2a1a028 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4120,12 +4120,19 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
 	int index;
-	int ret;
+	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(dir, dentry, &location);
+	if (unlikely(d_need_lookup(dentry))) {
+		memcpy(&location, dentry->d_fsdata, sizeof(struct btrfs_key));
+		kfree(dentry->d_fsdata);
+		dentry->d_fsdata = NULL;
+		d_clear_need_lookup(dentry);
+	} else {
+		ret = btrfs_inode_by_name(dir, dentry, &location);
+	}
 
 	if (ret < 0)
 		return ERR_PTR(ret);
@@ -4180,6 +4187,12 @@ static int btrfs_dentry_delete(const struct dentry *dentry)
 	return 0;
 }
 
+static void btrfs_dentry_release(struct dentry *dentry)
+{
+	if (dentry->d_fsdata)
+		kfree(dentry->d_fsdata);
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
@@ -4206,6 +4219,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
+	struct qstr q;
 	int ret;
 	struct extent_buffer *leaf;
 	int slot;
@@ -4284,6 +4298,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 		while (di_cur < di_total) {
 			struct btrfs_key location;
+			struct dentry *tmp;
 
 			if (verify_dir_item(root, leaf, di))
 				break;
@@ -4304,6 +4319,33 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			d_type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
 			btrfs_dir_item_key_to_cpu(leaf, di, &location);
 
+			q.name = name_ptr;
+			q.len = name_len;
+			q.hash = full_name_hash(q.name, q.len);
+			tmp = d_lookup(filp->f_dentry, &q);
+			if (!tmp) {
+				struct btrfs_key *newkey;
+
+				newkey = kzalloc(sizeof(struct btrfs_key),
+						 GFP_NOFS);
+				if (!newkey)
+					goto no_dentry;
+				tmp = d_alloc(filp->f_dentry, &q);
+				if (!tmp) {
+					kfree(newkey);
+					dput(tmp);
+					goto no_dentry;
+				}
+				memcpy(newkey, &location,
+				       sizeof(struct btrfs_key));
+				tmp->d_fsdata = newkey;
+				tmp->d_flags |= DCACHE_NEED_LOOKUP;
+				d_rehash(tmp);
+				dput(tmp);
+			} else {
+				dput(tmp);
+			}
+no_dentry:
 			/* is this a reference to our own snapshot? If so
 			 * skip it
 			 */
@@ -7566,4 +7608,5 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
+	.d_release	= btrfs_dentry_release,
 };
-- 
1.7.2.3

