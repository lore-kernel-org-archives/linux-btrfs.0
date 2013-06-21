Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41528 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161052Ab3FUMWP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 08:22:15 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Fri, 21 Jun 2013 08:22:14 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D86B0C90045
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:22:11 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r5LCMCLe269436
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:22:12 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r5LCMBDn019029
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 09:22:12 -0300
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, chris.mason@fusionio.com, jbacik@fusionio.com,
        idryomov@gmail.com, Martin@lichtvoll.de,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 5/5] BTRFS hot reloc: add hot relocation support
Date: Fri, 21 Jun 2013 20:21:00 +0800
Message-Id: <1371817260-8615-6-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
References: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add one new mount option '-o hot_move' for hot
relocation support. When hot relocation is enabled,
hot tracking will be enabled automatically.
  Its usage looks like:
    mount -o hot_move
    mount -o nouser,hot_move
    mount -o nouser,hot_move,loop
    mount -o hot_move,nouser

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/super.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9ee751f..31e1d17 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -309,8 +309,13 @@ static void btrfs_put_super(struct super_block *sb)
 	 * process...  Whom would you report that to?
 	 */
 
+	/* Hot data relocation */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_MOVE))
+		hot_relocate_exit(btrfs_sb(sb));
+
 	/* Hot data tracking */
-	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_MOVE)
+		|| btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
 		hot_track_exit(sb);
 }
 
@@ -325,7 +330,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_hot_track,
-	Opt_err,
+	Opt_hot_move, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -366,6 +371,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_hot_track, "hot_track"},
+	{Opt_hot_move, "hot_move"},
 	{Opt_err, NULL},
 };
 
@@ -634,6 +640,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_hot_track:
 			btrfs_set_opt(info->mount_opt, HOT_TRACK);
 			break;
+		case Opt_hot_move:
+			btrfs_set_opt(info->mount_opt, HOT_MOVE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -853,17 +862,26 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
-	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+	if (btrfs_test_opt(fs_info->tree_root, HOT_MOVE)
+		|| btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
 		err = hot_track_init(sb);
 		if (err)
 			goto fail_hot;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_MOVE)) {
+		err = hot_relocate_init(fs_info);
+		if (err)
+			goto fail_reloc;
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
 
+fail_reloc:
+	hot_track_exit(sb);
 fail_hot:
 	dput(sb->s_root);
 	sb->s_root = NULL;
@@ -964,6 +982,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (btrfs_test_opt(root, HOT_TRACK))
 		seq_puts(seq, ",hot_track");
+	if (btrfs_test_opt(root, HOT_MOVE))
+		seq_puts(seq, ",hot_move");
 	return 0;
 }
 
-- 
1.7.11.7

