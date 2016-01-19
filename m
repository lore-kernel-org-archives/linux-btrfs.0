Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58467 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756947AbcASCZd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 21:25:33 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id BF27E41896DC
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:25:12 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V7 3/3] btrfs: Introduce new mount option alias for nologreplay
Date: Tue, 19 Jan 2016 10:23:04 +0800
Message-ID: <1453170184-22869-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1453170184-22869-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1453170184-22869-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new mount option alias "norecovery" for nologreplay, to keep
"norecovery" behavior the same with other filesystems.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v6:
  Newly introduced
v7:
  None
---
 fs/btrfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1f97aa1..501a1de 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -304,7 +304,7 @@ enum {
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
-	Opt_nologreplay,
+	Opt_nologreplay, Opt_norecovery,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -337,6 +337,7 @@ static const match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_treelog, "treelog"},
 	{Opt_nologreplay, "nologreplay"},
+	{Opt_norecovery, "norecovery"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
@@ -599,6 +600,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 			btrfs_clear_and_info(root, NOTREELOG,
 					     "enabling tree log");
 			break;
+		case Opt_norecovery:
 		case Opt_nologreplay:
 			btrfs_set_and_info(root, NOLOGREPLAY,
 					   "disabling log replay at mount time");
-- 
2.7.0



