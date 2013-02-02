Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:51104 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710Ab3BBSCg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Feb 2013 13:02:36 -0500
Message-ID: <510D54E3.6090006@inwind.it>
Date: Sat, 02 Feb 2013 19:03:15 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Mason <chris.mason@fusionio.com>
Subject: [BTRFS][PATCH] Removed the 'subvolrootid' mount option.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this is a trivial patch, which remove old unused code. Please apply.

BR

----

The commit 830c4adb (Btrfs: fix how we mount subvol=<whatever>) removed
the function related to the option 'subvolrootid'. The option is still here,
the same is true for some code which handles the option parsing, but the 
value is never used by btrfs.

This patch removed all the _unused_ codes around this option. In order
to avoid break the boot process phase, if this options is passed again a
WARNING is raised in the dmesg log instead of stopping the mount.
---
 fs/btrfs/super.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..127943b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -322,6 +322,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_old_option,
 	Opt_err,
 };
 
@@ -352,7 +353,7 @@ static match_table_t tokens = {
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_enospc_debug, "enospc_debug"},
-	{Opt_subvolrootid, "subvolrootid=%d"},
+	{Opt_old_option, "subvolrootid=%d"}, /* removed; old Opt_subvolrootid, */
 	{Opt_defrag, "autodefrag"},
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
@@ -411,7 +412,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 		case Opt_subvol:
 		case Opt_subvolid:
-		case Opt_subvolrootid:
 		case Opt_device:
 			/*
 			 * These are parsed by btrfs_parse_early_options
@@ -629,6 +629,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			       "'%s'\n", p);
 			ret = -EINVAL;
 			goto out;
+		case Opt_old_option:
+			printk(KERN_WARNING 
+				"btrfs: obsolete mount option: '%s'\n", p );
+			break;
 		default:
 			break;
 		}
@@ -648,7 +652,7 @@ out:
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		void *holder, char **subvol_name, u64 *subvol_objectid,
-		u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
+		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
@@ -690,18 +694,6 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 					*subvol_objectid = intarg;
 			}
 			break;
-		case Opt_subvolrootid:
-			intarg = 0;
-			error = match_int(&args[0], &intarg);
-			if (!error) {
-				/* we want the original fs_tree */
-				if (!intarg)
-					*subvol_rootid =
-						BTRFS_FS_TREE_OBJECTID;
-				else
-					*subvol_rootid = intarg;
-			}
-			break;
 		case Opt_device:
 			device_name = match_strdup(&args[0]);
 			if (!device_name) {
@@ -1078,7 +1070,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
-	u64 subvol_rootid = 0;
 	int error = 0;
 
 	if (!(flags & MS_RDONLY))
@@ -1086,7 +1077,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &subvol_objectid,
-					  &subvol_rootid, &fs_devices);
+					  &fs_devices);
 	if (error) {
 		kfree(subvol_name);
 		return ERR_PTR(error);
-- 
1.7.10.4


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
