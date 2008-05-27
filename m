From: Sven Wegener <sven.wegener@stealer.net>
Subject: Drop dcache entry after creating snapshot and subvolume
Date: Wed, 28 May 2008 00:41:24 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805280011160.5461@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

when creating a new snapshot or subvolume we need to drop an existing 
negative dentry for the new name, else this happens:

host ~ # ls -l /mnt/btrfs
total 1
dr-xr-xr-x 1 root root 0 Jan  1  1970 default
host ~ # stat /mnt/btrfs/snapshot
stat: cannot stat `/mnt/btrfs/snapshot': No such file or directory
host ~ # btrfsctl -s snapshot /mnt/btrfs/default
ioctl returns 0
host ~ # stat /mnt/btrfs/snapshot
stat: cannot stat `/mnt/btrfs/snapshot': No such file or directory
host ~ # ls -l /mnt/btrfs
ls: cannot access /mnt/btrfs/snapshot: No such file or directory
total 1
dr-xr-xr-x 1 root root 0 Jan  1  1970 default
d????????? ? ?    ?    ?            ? snapshot

I have a patch (see below) that does an explicit d_drop() on the dentry 
after looking it up via d_find_alias() and d_lookup(), starting at the 
root inode. Currently it's for snapshot creation only, subvolume creation 
needs the same. There doesn't seem to be a kernel function for this case 
and using the normal d_revalidate method is inefficient as snapshot and 
subvolume creation is the only place where we need this and the creation 
is a rare case. Is this the right way to go?

Sven

---
  transaction.c |   18 ++++++++++++++++++
  1 file changed, 18 insertions(+)

--- a/transaction.c
+++ b/transaction.c
@@ -557,6 +557,8 @@
  	struct btrfs_root *tree_root = fs_info->tree_root;
  	struct btrfs_root *root = pending->root;
  	struct extent_buffer *tmp;
+	struct dentry *alias, *snap;
+	struct qstr qstr;
  	int ret;
  	u64 objectid;

@@ -604,6 +606,22 @@
  	ret = btrfs_insert_inode_ref(trans, root->fs_info->tree_root,
  			     pending->name, strlen(pending->name), objectid,
  			     root->fs_info->sb->s_root->d_inode->i_ino);
+
+	/*
+	 * We need to drop the dcache entry for the new snapshot.
+	 */
+	alias = d_find_alias(root->fs_info->sb->s_root->d_inode);
+	if (alias) {
+		qstr.name = pending->name;
+		qstr.len = strlen(qstr.name);
+		qstr.hash = full_name_hash(qstr.name, qstr.len);
+		snap = d_lookup(alias, &qstr);
+		dput(alias);
+		if (snap) {
+			d_drop(snap);
+			dput(snap);
+		}
+	}
  fail:
  	kfree(new_root_item);
  	return ret;
