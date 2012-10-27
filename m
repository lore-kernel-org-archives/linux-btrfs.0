Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:32494 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2J0KgB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 06:36:01 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9RAV9FA031306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 10:31:10 GMT
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9RATnNx006637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 10:29:50 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9RATmBE029334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 10:29:49 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9RATmpc032357
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 05:29:48 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
Date: Sat, 27 Oct 2012 18:28:41 +0800
Message-Id: <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This feature works on our crucial write endio path, so if we've got
lots of fragments to process, it will be kind of a disaster to the
performance, so I make such a change.

One can benifit from it while mounting with '-o snap_aware_defrag'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/inode.c |   16 ++++++++++------
 fs/btrfs/ioctl.c |    5 +++--
 fs/btrfs/super.c |   12 ++++++++++--
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 926c9ff..f9cd9c9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1756,6 +1756,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_SA_DEFRAG		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 35e6993..069499e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2488,13 +2488,17 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state);
 
-	ret = test_range_bit(io_tree, ordered_extent->file_offset,
-			ordered_extent->file_offset + ordered_extent->len - 1,
-			EXTENT_DEFRAG, 1, cached_state);
-	if (ret && btrfs_root_last_snapshot(&root->root_item) >=
+	if (btrfs_test_opt(root, SA_DEFRAG)) {
+		ret = test_range_bit(io_tree, ordered_extent->file_offset,
+				     ordered_extent->file_offset +
+				     ordered_extent->len - 1,
+				     EXTENT_DEFRAG, 1, cached_state);
+		if (ret &&
+		    btrfs_root_last_snapshot(&root->root_item) >=
 						BTRFS_I(inode)->generation) {
-		/* the inode is shared */
-		new = record_old_file_extents(inode, ordered_extent);
+			/* the inode is shared */
+			new = record_old_file_extents(inode, ordered_extent);
+		}
 	}
 
 	if (nolock)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6116880..1367165 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1058,8 +1058,9 @@ again:
 	}
 
 
-	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
-			  &cached_state, GFP_NOFS);
+	if (btrfs_test_opt(BTRFS_I(inode)->root, SA_DEFRAG))
+		set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start,
+				  page_end - 1, &cached_state, GFP_NOFS);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..24eac5f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -308,8 +308,8 @@ enum {
 	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
-	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
-	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
+	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_sa_defrag,
+	Opt_inode_cache, Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors,
 	Opt_err,
@@ -344,6 +344,7 @@ static match_table_t tokens = {
 	{Opt_enospc_debug, "enospc_debug"},
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
+	{Opt_sa_defrag, "snap_aware_defrag"},
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
@@ -564,6 +565,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
+		case Opt_sa_defrag:
+			printk(KERN_INFO "btrfs: enabling snapshot-aware"
+			       " defrag\n");
+			btrfs_set_opt(info->mount_opt, SA_DEFRAG);
+			break;
 		case Opt_recovery:
 			printk(KERN_INFO "btrfs: enabling auto recovery\n");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
@@ -935,6 +941,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",enospc_debug");
 	if (btrfs_test_opt(root, AUTO_DEFRAG))
 		seq_puts(seq, ",autodefrag");
+	if (btrfs_test_opt(root, SA_DEFRAG))
+		seq_puts(seq, ",snap_aware_defrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
 	if (btrfs_test_opt(root, SKIP_BALANCE))
-- 
1.7.7.6

