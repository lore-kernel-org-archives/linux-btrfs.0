From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: load the key from the dir item in readdir into a fake dentry
Date: Fri, 13 May 2011 13:47:36 -0400
Message-ID: <1305308856-5446-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Ok so if your name is Christoph Hellwig or Al Viro, please point a video camera
at your face and start recording before reading further.  Once you are done
please upload to youtube because I imagine the expressions on your faces will be
epic.

In btrfs we have 2 indexes for inodes.  One is for readdir, it's in this nice
sequential order and works out brilliantly for readdir.  However if you use ls,
it usually stat's each file it gets from readdir.  This is where the second
index comes in, which is based on a hash of the name of the file.  So then the
lookup has to lookup this index, and then lookup the inode.  The index lookup is
going to be in random order (since its based on the name hash), which gives us
something like this

http://people.redhat.com/jwhiter/ls.png

Now I turned off readahead in the non-readdir case, which helped quite a bit,
and gave me this

http://people.redhat.com/jwhiter/ls-noreada.png

Enter this patch.  Since we know the inode location from the readdir index, I
create a dummy dentry and copy the location key into dentry->d_fsdata.  Then on
lookup if we have d_fsdata we use that location to lookup the inode, which
results in a big speedup, 800 seconds faster from the noreada patch

http://people.redhat.com/jwhiter/ls-dcache-trickery.png

But because the lookup code will just look for a dentry and not care if d_inode
is populated, I have to force that to happen.  Thankfully if the lookup code
finds a dentry in cache it calls d_revalidate against it, so that is where I
check to see if we have a d_inode set, and if not call the lookup which uses our
d_fsdata and we populate the dentry appropriately.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca9d977..447a22c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4119,12 +4119,18 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
 	int index;
-	int ret;
+	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(dir, dentry, &location);
+	if (dentry->d_fsdata) {
+		memcpy(&location, dentry->d_fsdata, sizeof(struct btrfs_key));
+		kfree(dentry->d_fsdata);
+		dentry->d_fsdata = NULL;
+	} else {
+		ret = btrfs_inode_by_name(dir, dentry, &location);
+	}
 
 	if (ret < 0)
 		return ERR_PTR(ret);
@@ -4179,6 +4185,34 @@ static int btrfs_dentry_delete(const struct dentry *dentry)
 	return 0;
 }
 
+static void btrfs_dentry_release(struct dentry *dentry)
+{
+	if (dentry->d_fsdata)
+		kfree(dentry->d_fsdata);
+}
+
+static int btrfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode;
+	struct dentry *d, *parent;
+
+	if (dentry->d_inode || !dentry->d_fsdata)
+		return 0;
+
+	parent = dget_parent(dentry);
+	inode = btrfs_lookup_dentry(parent->d_inode, dentry);
+	if (IS_ERR(inode)) {
+		dput(parent);
+		return PTR_ERR(inode);
+	}
+
+	dput(parent);
+	d = d_splice_alias(inode, dentry);
+	if (d)
+		dput(dentry);
+	return 0;
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
@@ -4205,6 +4239,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
+	struct qstr q;
 	int ret;
 	u32 nritems;
 	struct extent_buffer *leaf;
@@ -4293,6 +4328,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 		while (di_cur < di_total) {
 			struct btrfs_key location;
+			struct dentry *tmp;
 
 			if (verify_dir_item(root, leaf, di))
 				break;
@@ -4310,6 +4346,28 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			read_extent_buffer(leaf, name_ptr,
 					   (unsigned long)(di + 1), name_len);
 
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
+					goto next;
+				tmp = d_alloc(filp->f_dentry, &q);
+				if (!tmp) {
+					kfree(newkey);
+					goto next;
+				}
+				tmp->d_fsdata = newkey;
+				dput(tmp);
+			} else {
+				dput(tmp);
+			}
+next:
 			d_type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
 			btrfs_dir_item_key_to_cpu(leaf, di, &location);
 
@@ -7566,4 +7624,6 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
+	.d_release	= btrfs_dentry_release,
+	.d_revalidate	= btrfs_dentry_revalidate,
 };
-- 
1.7.2.3

