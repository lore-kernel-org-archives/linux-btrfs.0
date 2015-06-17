Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbbFQHzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:55:17 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com
Subject: [RFC PATCH v2 1/2] Btrfs: add noi_version option to disable MS_I_VERSION
Date: Wed, 17 Jun 2015 15:54:31 +0800
Message-Id: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MS_I_VERSION is enabled by default for btrfs, this adds an alternative
option to toggle it off.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..e610e3e 100644
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
1.7.7.6

