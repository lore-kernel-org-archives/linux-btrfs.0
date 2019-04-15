Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033D8C10F11
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 05:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8A652075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 05:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfDOFgP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 01:36:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:52700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725779AbfDOFgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 01:36:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6294ABF0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 05:36:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1 1/3] btrfs: Remove "recovery" mount option
Date:   Mon, 15 Apr 2019 13:36:06 +0800
Message-Id: <20190415053608.29003-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415053608.29003-1-wqu@suse.com>
References: <20190415053608.29003-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 8dcddfa048de ("btrfs: Introduce new mount option usebackuproot to
replace recovery") deprecates "recovery" mount option in 2016, and it
has been 3 years, it should be OK to remove "recovery" mount option.

As we're even going to deprecate the successor, "usebackuproot" mount
option, there isn't really much need to keep the original option.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 120e4340792a..4625e7fbeba5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -311,7 +311,6 @@ enum {
 	Opt_defrag, Opt_nodefrag,
 	Opt_discard, Opt_nodiscard,
 	Opt_nologreplay,
-	Opt_norecovery,
 	Opt_ratio,
 	Opt_rescan_uuid_tree,
 	Opt_skip_balance,
@@ -329,7 +328,6 @@ enum {
 
 	/* Deprecated options */
 	Opt_alloc_start,
-	Opt_recovery,
 	Opt_subvolrootid,
 
 	/* Debugging options */
@@ -374,7 +372,6 @@ static const match_table_t tokens = {
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
 	{Opt_nologreplay, "nologreplay"},
-	{Opt_norecovery, "norecovery"},
 	{Opt_ratio, "metadata_ratio=%u"},
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_skip_balance, "skip_balance"},
@@ -396,7 +393,6 @@ static const match_table_t tokens = {
 
 	/* Deprecated options */
 	{Opt_alloc_start, "alloc_start=%s"},
-	{Opt_recovery, "recovery"},
 	{Opt_subvolrootid, "subvolrootid=%d"},
 
 	/* Debugging options */
@@ -670,7 +666,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_clear_and_info(info, NOTREELOG,
 					     "enabling tree log");
 			break;
-		case Opt_norecovery:
 		case Opt_nologreplay:
 			btrfs_set_and_info(info, NOLOGREPLAY,
 					   "disabling log replay at mount time");
@@ -759,10 +754,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_clear_and_info(info, AUTO_DEFRAG,
 					     "disabling auto defrag");
 			break;
-		case Opt_recovery:
-			btrfs_warn(info,
-				   "'recovery' is deprecated, use 'usebackuproot' instead");
-			/* fall through */
 		case Opt_usebackuproot:
 			btrfs_info(info,
 				   "trying to use backup root at mount time");
-- 
2.21.0

