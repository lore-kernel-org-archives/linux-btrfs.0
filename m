Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50706 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab2FOJ55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 05:57:57 -0400
Received: by bkcji2 with SMTP id ji2so2236683bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 02:57:56 -0700 (PDT)
Message-ID: <1339754209.2212.22.camel@ierdnac-hp>
Subject: [PATCH] Btrfs: add "nocompress" mount option
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: linux-btrfs@vger.kernel.org
Date: Fri, 15 Jun 2012 12:56:49 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs if we mount with "compress" we have no way to disable
compressing by remounting 
(mount -o remount /mnt/btrfs), only by unmounting and mounting without
"compress".
This patch adds "nocompress" mount option which can be used to remount
the filesystem without compression:
# mount -o remount,nocompress /mnt/btrfs
This option is usefull in cases when we have a filesystem mounted with
"compress" and we want to disable compression but we don't want to
umount and mount it.

Signed-off-by: Andrei Popa <ierdnah@gmail.com>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/super.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0236d03..c6e050a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1567,6 +1567,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_NOCOMPRESS	(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0874dba..a78a6cf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -280,7 +280,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_nocompress
 	Opt_err,
 };
 
@@ -299,6 +299,7 @@ static match_table_t tokens = {
 	{Opt_compress_type, "compress=%s"},
 	{Opt_compress_force, "compress-force"},
 	{Opt_compress_force_type, "compress-force=%s"},
+	{Opt_nocompress, "nocompress"},
 	{Opt_ssd, "ssd"},
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd, "nossd"},
@@ -404,6 +405,7 @@ int btrfs_parse_options(struct btrfs_root *root,
char *options)
 				goto out;
 			}
 
+			btrfs_clear_opt(info->mount_opt, NOCOMPRESS);
 			btrfs_set_opt(info->mount_opt, COMPRESS);
 			if (compress_force) {
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
@@ -413,6 +415,11 @@ int btrfs_parse_options(struct btrfs_root *root,
char *options)
 				pr_info("btrfs: use %s compression\n",
 					compress_type);
 			break;
+		case Opt_nocompress:
+			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+			btrfs_clear_opt(info->mount_opt, COMPRESS);
+			btrfs_set_opt(info->mount_opt, NOCOMPRESS);
+			break;
 		case Opt_ssd:
 			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
 			btrfs_set_opt(info->mount_opt, SSD);
@@ -856,6 +863,8 @@ static int btrfs_show_options(struct seq_file *seq,
struct dentry *dentry)
 		else
 			seq_printf(seq, ",compress=%s", compress_type);
 	}
+	if (btrfs_test_opt(root, NOCOMPRESS))
+		seq_puts(seq, ",nocompress");
 	if (btrfs_test_opt(root, NOSSD))
 		seq_puts(seq, ",nossd");
 	if (btrfs_test_opt(root, SSD_SPREAD))
-- 
1.7.3.4



