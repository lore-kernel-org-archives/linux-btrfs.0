Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42702 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbbFIMEo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 08:04:44 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t59C4htr005641
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 12:04:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t59C4gUZ023829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 12:04:43 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t59C4g1k026138
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 12:04:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 1/2] Btrfs: add noi_version option to disable MS_I_VERSION
Date: Tue,  9 Jun 2015 20:04:30 +0800
Message-Id: <1433851471-11543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MS_I_VERSION is enabled by default for btrfs, this adds an alternative
option to toggle it off.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/super.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f2c9f9d..c81a3f1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,7 +324,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog, Opt_noinode_cache,
+	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_noi_version,
 	Opt_err,
 };
 
@@ -351,6 +351,7 @@ static match_table_t tokens = {
 	{Opt_nossd, "nossd"},
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
+	{Opt_noi_version, "noi_version"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_treelog, "treelog"},
 	{Opt_flushoncommit, "flushoncommit"},
@@ -593,6 +594,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_noacl:
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
+		case Opt_noi_version:
+			root->fs_info->sb->s_flags &= ~MS_I_VERSION;
+			btrfs_info(root->fs_info, "disable i_version");
+			break;
 		case Opt_notreelog:
 			btrfs_set_and_info(root, NOTREELOG,
 					   "disabling tree log");
-- 
2.1.0

