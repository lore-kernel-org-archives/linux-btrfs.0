Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42387 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3EFIxX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 04:53:23 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 02:53:23 -0600
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 98089C9001A
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 04:53:20 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468rKkr63570174
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468rJGi008165
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 05:53:20 -0300
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 5/5] btrfs: add hot relocation support
Date: Mon,  6 May 2013 16:53:38 +0800
Message-Id: <1367830418-26865-6-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
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
index 4cbd0de..b342f6f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -311,8 +311,13 @@ static void btrfs_put_super(struct super_block *sb)
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
 
@@ -327,7 +332,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_hot_track,
-	Opt_err,
+	Opt_hot_move, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -368,6 +373,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_hot_track, "hot_track"},
+	{Opt_hot_move, "hot_move"},
 	{Opt_err, NULL},
 };
 
@@ -636,6 +642,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_hot_track:
 			btrfs_set_opt(info->mount_opt, HOT_TRACK);
 			break;
+		case Opt_hot_move:
+			btrfs_set_opt(info->mount_opt, HOT_MOVE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -863,17 +872,26 @@ static int btrfs_fill_super(struct super_block *sb,
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
@@ -974,6 +992,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (btrfs_test_opt(root, HOT_TRACK))
 		seq_puts(seq, ",hot_track");
+	if (btrfs_test_opt(root, HOT_MOVE))
+		seq_puts(seq, ",hot_move");
 	return 0;
 }
 
-- 
1.7.11.7

