Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3CTNVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 09:21:21 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6DA65A4F28
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 14:21:20 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: deprecate subvolrootid mount option
Date: Wed, 20 Mar 2013 14:21:10 +0100
Message-Id: <1363785670-357-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This mount option was a workaround when subvol= assumed path relative
to the default subvolume, not the toplevel one. This was fixed long time
ago and subvolrootid has no effect.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5f21797..78ca113 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -643,7 +643,7 @@ out:
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		void *holder, char **subvol_name, u64 *subvol_objectid,
-		u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
+		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
@@ -686,16 +686,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 			}
 			break;
 		case Opt_subvolrootid:
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
+			printk(KERN_WARNING
+				"btrfs: 'subvolrootid' mount option is deprecated and has no effect\n");
 			break;
 		case Opt_device:
 			device_name = match_strdup(&args[0]);
@@ -1073,7 +1065,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
-	u64 subvol_rootid = 0;
 	int error = 0;
 
 	if (!(flags & MS_RDONLY))
@@ -1081,7 +1072,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &subvol_objectid,
-					  &subvol_rootid, &fs_devices);
+					  &fs_devices);
 	if (error) {
 		kfree(subvol_name);
 		return ERR_PTR(error);
-- 
1.7.9

