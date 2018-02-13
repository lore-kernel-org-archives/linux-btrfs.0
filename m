Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934087AbeBMJs1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:48:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5Lj030869
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:26 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2g3w9s06q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9mPMo008240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:25 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D9mPtu013608
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:25 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: declare max_inline as u32
Date: Tue, 13 Feb 2018 17:49:49 +0800
Message-Id: <20180213094950.9412-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs_fs_info::max_line is u64, which can't be
larger than btrfs_fs_info::sectorsize which is defined as
u32, so make btrfs_fs_info::max_line u32,

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Born in v2.
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/super.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4759e988b0df..0b738f0a9a23 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -795,7 +795,7 @@ struct btrfs_fs_info {
 	 * extent. The write side(mount/remount) is under ->s_umount lock,
 	 * so it is also safe.
 	 */
-	u64 max_inline;
+	u32 max_inline;
 
 	struct btrfs_transaction *running_transaction;
 	wait_queue_head_t transaction_throttle;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 383be3609cc9..b13d68506f15 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -610,11 +610,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				kfree(num);
 
 				if (info->max_inline) {
-					info->max_inline = min_t(u64,
+					info->max_inline = min_t(u32,
 						info->max_inline,
 						info->sectorsize);
 				}
-				btrfs_info(info, "max_inline at %llu",
+				btrfs_info(info, "max_inline at %u",
 					   info->max_inline);
 			} else {
 				ret = -ENOMEM;
@@ -1325,7 +1325,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(info, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (info->max_inline != BTRFS_DEFAULT_MAX_INLINE)
-		seq_printf(seq, ",max_inline=%llu", info->max_inline);
+		seq_printf(seq, ",max_inline=%u", info->max_inline);
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
@@ -1801,7 +1801,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned old_flags = sb->s_flags;
 	unsigned long old_opts = fs_info->mount_opt;
 	unsigned long old_compress_type = fs_info->compress_type;
-	u64 old_max_inline = fs_info->max_inline;
+	u32 old_max_inline = fs_info->max_inline;
 	int old_thread_pool_size = fs_info->thread_pool_size;
 	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
-- 
2.7.0

