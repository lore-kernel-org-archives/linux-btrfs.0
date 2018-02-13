Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934451AbeBMJtc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5NA065880
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2g3wc8r5n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nUkp022806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:31 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D9nUVF014610
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: manage commit mount option as %u
Date: Tue, 13 Feb 2018 17:50:46 +0800
Message-Id: <20180213095048.9550-5-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As -o commit mount option is unsinged so manage it as %u
for token verifications, instead of %d.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/super.c | 26 ++++++++++----------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 23b7e6756b15..80d1d4d12f9d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -788,7 +788,7 @@ struct btrfs_fs_info {
 	unsigned long pending_changes;
 	unsigned long compress_type:4;
 	unsigned int compress_level;
-	int commit_interval;
+	u32 commit_interval;
 	/*
 	 * It is a suggestive number, the read side is safe even it gets a
 	 * wrong number because we will write out the data into a regular
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 83e11bbacc17..0a299a0ded3a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -385,7 +385,7 @@ static const match_table_t tokens = {
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%u"},
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
-	{Opt_commit_interval, "commit=%d"},
+	{Opt_commit_interval, "commit=%u"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
@@ -777,24 +777,18 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_commit_interval:
 			intarg = 0;
 			ret = match_int(&args[0], &intarg);
-			if (ret < 0) {
-				btrfs_err(info, "invalid commit interval");
-				ret = -EINVAL;
+			if (ret)
 				goto out;
-			}
-			if (intarg > 0) {
-				if (intarg > 300) {
-					btrfs_warn(info,
-						"excessive commit interval %d",
-						intarg);
-				}
-				info->commit_interval = intarg;
-			} else {
+			if (intarg == 0) {
 				btrfs_info(info,
-					   "using default commit interval %ds",
+					   "using default commit interval %us",
 					   BTRFS_DEFAULT_COMMIT_INTERVAL);
-				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
+				intarg = BTRFS_DEFAULT_COMMIT_INTERVAL;
+			} else if (intarg > 300) {
+				btrfs_warn(info, "excessive commit interval %d",
+					   intarg);
 			}
+			info->commit_interval = intarg;
 			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:
@@ -1363,7 +1357,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(info, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
 	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
-		seq_printf(seq, ",commit=%d", info->commit_interval);
+		seq_printf(seq, ",commit=%u", info->commit_interval);
 #ifdef CONFIG_BTRFS_DEBUG
 	if (btrfs_test_opt(info, FRAGMENT_DATA))
 		seq_puts(seq, ",fragment=data");
-- 
2.7.0

