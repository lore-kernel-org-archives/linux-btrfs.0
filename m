From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH] Btrfs: fix subvolume mount by name problem when default mount subvolume is set
Date: Thu, 31 Mar 2011 15:59:22 +0800
Message-ID: <1301558362-2650-1-git-send-email-xin.zhong@intel.com>
Cc: xin.zhong@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We create two subvolumes (meego_root and meego_home) in
btrfs root directory. And set meego_root as default mount
subvolume. After we remount btrfs, meego_root is mounted
to top directory by default. Then when we try to mount
meego_home (subvol=meego_home) to a subdirectory, it failed.
The problem is when default mount subvolume is set to
meego_root, we search meego_home in it but can not find it.
So the solution is to search meego_home in btrfs root
directory instead when subvol=meego_home is given.

Detail information can be found in meego bugzilla:
https://bugs.meego.com/show_bug.cgi?id=15055

Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 fs/btrfs/super.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db0a827..138bc4c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -786,15 +786,18 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		s->s_flags |= MS_ACTIVE;
 	}
 
-	root = get_default_root(s, subvol_objectid);
-	if (IS_ERR(root)) {
-		error = PTR_ERR(root);
-		deactivate_locked_super(s);
-		goto error_free_subvol_name;
-	}
 	/* if they gave us a subvolume name bind mount into that */
 	if (strcmp(subvol_name, ".")) {
 		struct dentry *new_root;
+		
+		/* we search subvolume name in the btrfs root, not the default mount subvolume */
+		root = get_default_root(s, BTRFS_FS_TREE_OBJECTID);
+		if (IS_ERR(root)) {
+			error = PTR_ERR(root);
+			deactivate_locked_super(s);
+			goto error_free_subvol_name;
+		}
+
 		mutex_lock(&root->d_inode->i_mutex);
 		new_root = lookup_one_len(subvol_name, root,
 				      strlen(subvol_name));
@@ -816,6 +819,14 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		dput(root);
 		root = new_root;
 	}
+	else {
+		root = get_default_root(s, subvol_objectid);
+		if (IS_ERR(root)) {
+			error = PTR_ERR(root);
+			deactivate_locked_super(s);
+			goto error_free_subvol_name;
+		}
+	}
 
 	mnt->mnt_sb = s;
 	mnt->mnt_root = root;
-- 
1.7.0.4

