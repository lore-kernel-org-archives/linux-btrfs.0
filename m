Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D1EC282DE
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589ED20989
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 07:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfAUHfV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:35:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:58306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728710AbfAUHfU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 02:35:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1A16AD6F
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 07:35:19 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: Remove "recovery" mount option
Date:   Mon, 21 Jan 2019 15:35:10 +0800
Message-Id: <20190121073512.17675-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121073512.17675-1-wqu@suse.com>
References: <20190121073512.17675-1-wqu@suse.com>
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
index c5586ffd1426..6a08f23e5600 100644
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
@@ -664,7 +660,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_clear_and_info(info, NOTREELOG,
 					     "enabling tree log");
 			break;
-		case Opt_norecovery:
 		case Opt_nologreplay:
 			btrfs_set_and_info(info, NOLOGREPLAY,
 					   "disabling log replay at mount time");
@@ -753,10 +748,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
2.20.1

