From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Fri, 19 Nov 2010 14:59:15 -0500
Message-ID: <1290196755-19607-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, raven@themaw.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a problem with how we use sget, it searches through the list of supers
attached to the fs_type looking for a super with the same fs_devices as what
we're trying to mount.  This depends on sb->s_fs_info being filled, but we don't
fill that in until we get to btrfs_fill_super, so we could hit supers on the
fs_type super list that have a null s_fs_info.  In order to fix that we need to
go ahead and setup a blank root with a blank fs_info to hold fs_devices, that
way our test will work out right and then we can set s_fs_info in
btrfs_set_super, and then open_ctree will simply use our pre-allocated root and
fs_info when setting everything up.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 fs/btrfs/super.c   |   35 ++++++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fb827d0..f0aa204 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1538,10 +1538,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 						 GFP_NOFS);
 	struct btrfs_root *csum_root = kzalloc(sizeof(struct btrfs_root),
 						 GFP_NOFS);
-	struct btrfs_root *tree_root = kzalloc(sizeof(struct btrfs_root),
-					       GFP_NOFS);
-	struct btrfs_fs_info *fs_info = kzalloc(sizeof(*fs_info),
-						GFP_NOFS);
+	struct btrfs_root *tree_root = btrfs_sb(sb);
+	struct btrfs_fs_info *fs_info = tree_root->fs_info;
 	struct btrfs_root *chunk_root = kzalloc(sizeof(struct btrfs_root),
 						GFP_NOFS);
 	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8299a25..9145551 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -562,12 +562,20 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 
 static int btrfs_test_super(struct super_block *s, void *data)
 {
-	struct btrfs_fs_devices *test_fs_devices = data;
+	struct btrfs_root *test_root = data;
 	struct btrfs_root *root = btrfs_sb(s);
 
-	return root->fs_info->fs_devices == test_fs_devices;
+	return root->fs_info->fs_devices == test_root->fs_info->fs_devices;
 }
 
+static int btrfs_set_super(struct super_block *s, void *data)
+{
+	s->s_fs_info = data;
+
+	return set_anon_super(s, data);
+}
+
+
 /*
  * Find a superblock for the given device / mount point.
  *
@@ -581,6 +589,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	struct super_block *s;
 	struct dentry *root;
 	struct btrfs_fs_devices *fs_devices = NULL;
+	struct btrfs_root *tree_root = NULL;
+	struct btrfs_fs_info *fs_info = NULL;
 	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
@@ -608,8 +618,25 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		goto error_close_devices;
 	}
 
+	/*
+	 * Setup a dummy root and fs_info for test/set super.  This is because
+	 * we don't actually fill this stuff out until open_ctree, but we need
+	 * it for searching for existing supers, so this lets us do that and
+	 * then open_ctree will properly initialize everything later.
+	 */
+	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
+	tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
+	if (!fs_info || !tree_root) {
+		kfree(fs_info);
+		kfree(tree_root);
+		goto error_close_devices;
+	}
+	fs_info->tree_root = tree_root;
+	fs_info->fs_devices = fs_devices;
+	tree_root->fs_info = fs_info;
+
 	bdev = fs_devices->latest_bdev;
-	s = sget(fs_type, btrfs_test_super, set_anon_super, fs_devices);
+	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
 	if (IS_ERR(s))
 		goto error_s;
 
@@ -675,6 +702,8 @@ error_s:
 	error = PTR_ERR(s);
 error_close_devices:
 	btrfs_close_devices(fs_devices);
+	kfree(fs_info);
+	kfree(tree_root);
 error_free_subvol_name:
 	kfree(subvol_name);
 	return ERR_PTR(error);
-- 
1.6.6.1

