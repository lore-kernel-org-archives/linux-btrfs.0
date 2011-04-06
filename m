From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH V2] Btrfs: fix subvolume mount by name problem when default mount subvolume is set
Date: Wed,  6 Apr 2011 15:13:57 +0800
Message-ID: <1302074037-7206-1-git-send-email-xin.zhong@intel.com>
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
meego_root, we search meego_home in meego_root but can not find
it. So the solution is to add a new mount option (subvolrootid)
to specify subvol id of root and search subvol name in it. For
our case, now we can use "-o subvolrootid=0,subvol=meego_home)
to mount meego_home.

Detail information can be found in meego bugzilla:
https://bugs.meego.com/show_bug.cgi?id=15055

Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 fs/btrfs/super.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db0a827..5e7bc51 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -156,7 +156,7 @@ enum {
 	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
-	Opt_enospc_debug, Opt_err,
+	Opt_enospc_debug, Opt_subvolrootid, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -186,6 +186,7 @@ static match_table_t tokens = {
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_enospc_debug, "enospc_debug"},
+	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_err, NULL},
 };
 
@@ -229,6 +230,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 		case Opt_subvol:
 		case Opt_subvolid:
+		case Opt_subvolrootid:
 		case Opt_device:
 			/*
 			 * These are parsed by btrfs_parse_early_options
@@ -385,7 +387,7 @@ out:
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		void *holder, char **subvol_name, u64 *subvol_objectid,
-		struct btrfs_fs_devices **fs_devices)
+		u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *orig, *p;
@@ -426,6 +428,18 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 					*subvol_objectid = intarg;
 			}
 			break;
+		case Opt_subvolrootid:
+			intarg = 0;
+			error = match_int(&args[0], &intarg);
+			if (!error) {
+				/* we want the original fs_tree */
+				if (!intarg)
+					*subvol_rootid =
+						BTRFS_FS_TREE_OBJECTID;
+				else
+					*subvol_rootid = intarg;
+			}
+			break;
 		case Opt_device:
 			error = btrfs_scan_one_device(match_strdup(&args[0]),
 					flags, holder, fs_devices);
@@ -715,6 +729,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
+	u64 subvol_rootid = 0;
 	int error = 0;
 
 	if (!(flags & MS_RDONLY))
@@ -722,7 +737,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &subvol_objectid,
-					  &fs_devices);
+					  &subvol_rootid, &fs_devices);
 	if (error)
 		return error;
 
@@ -786,15 +801,17 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
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
+		root = get_default_root(s, subvol_rootid);
+		if (IS_ERR(root)) {
+			error = PTR_ERR(root);
+			deactivate_locked_super(s);
+			goto error_free_subvol_name;
+		}
+
 		mutex_lock(&root->d_inode->i_mutex);
 		new_root = lookup_one_len(subvol_name, root,
 				      strlen(subvol_name));
@@ -816,6 +833,14 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		dput(root);
 		root = new_root;
 	}
+	} else {
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

