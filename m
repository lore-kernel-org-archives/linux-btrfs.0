Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49327 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754568AbdGNRgd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1682AAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] btrfs: use GFP_KERNEL in mount and remount
Date: Fri, 14 Jul 2017 19:35:18 +0200
Message-Id: <5b90b9a0224194ec4d363bb5319b6ad9ce84c5bd.1500053599.git.dsterba@suse.com>
In-Reply-To: <cover.1500053599.git.dsterba@suse.com>
References: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to restrict the allocation flags in btrfs_mount or
_remount. No big filesystem locks are held (possibly s_umount but that
does no count here).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74e47794e63f..35aae1c0377b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -425,7 +425,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	 * strsep changes the string, duplicate it because parse_options
 	 * gets called twice
 	 */
-	options = kstrdup(options, GFP_NOFS);
+	options = kstrdup(options, GFP_KERNEL);
 	if (!options)
 		return -ENOMEM;
 
@@ -949,7 +949,7 @@ static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
 	}
 	path->leave_spinning = 1;
 
-	name = kmalloc(PATH_MAX, GFP_NOFS);
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name) {
 		ret = -ENOMEM;
 		goto err;
@@ -1336,10 +1336,11 @@ static char *setup_root_args(char *args)
 	char *buf, *dst, *sep;
 
 	if (!args)
-		return kstrdup("subvolid=0", GFP_NOFS);
+		return kstrdup("subvolid=0", GFP_KERNEL);
 
 	/* The worst case is that we add ",subvolid=0" to the end. */
-	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1, GFP_NOFS);
+	buf = dst = kmalloc(strlen(args) + strlen(",subvolid=0") + 1,
+			GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1568,7 +1569,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	 * it for searching for existing supers, so this lets us do that and
 	 * then open_ctree will properly initialize everything later.
 	 */
-	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
+	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
 	if (!fs_info) {
 		error = -ENOMEM;
 		goto error_sec_opts;
@@ -1576,8 +1577,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	fs_info->fs_devices = fs_devices;
 
-	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
-	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
+	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
+	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
 	security_init_mnt_opts(&fs_info->security_opts);
 	if (!fs_info->super_copy || !fs_info->super_for_commit) {
 		error = -ENOMEM;
-- 
2.13.0

