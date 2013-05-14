Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:40726 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3ENA7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:51 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:59:50 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 10/12] VFS hot tracking, btrfs: add hot tracking support
Date: Tue, 14 May 2013 08:59:42 +0800
Message-Id: <1368493184-5939-11-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new mount option '-o hot_track',
and add its parsing support.
  Its usage looks like:
   mount -o hot_track
   mount -o nouser,hot_track
   mount -o nouser,hot_track,loop
   mount -o hot_track,nouser

Reviewed-by:   David Sterba <dsterba@suse.cz>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/super.c | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 63c328a..133a6ed 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1927,6 +1927,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a4807ce..09fb9d2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -42,6 +42,7 @@
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
 #include <linux/btrfs.h>
+#include <linux/hot_tracking.h>
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -306,6 +307,10 @@ static void btrfs_put_super(struct super_block *sb)
 	 * last process that kept it busy.  Or segfault in the aforementioned
 	 * process...  Whom would you report that to?
 	 */
+
+	/* Hot data tracking */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+		hot_track_exit(sb);
 }
 
 enum {
@@ -318,7 +323,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_hot_track,
 	Opt_err,
 };
 
@@ -359,6 +364,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
+	{Opt_hot_track, "hot_track"},
 	{Opt_err, NULL},
 };
 
@@ -624,6 +630,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_hot_track:
+			btrfs_set_opt(info->mount_opt, HOT_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -843,11 +852,20 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+		err = hot_track_init(sb);
+		if (err)
+			goto fail_hot;
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
 
+fail_hot:
+	dput(sb->s_root);
+	sb->s_root = NULL;
 fail_close:
 	close_ctree(fs_info->tree_root);
 	return err;
@@ -943,6 +961,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (btrfs_test_opt(root, HOT_TRACK))
+		seq_puts(seq, ",hot_track");
 	return 0;
 }
 
-- 
1.7.11.7

