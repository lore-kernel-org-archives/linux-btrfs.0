Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FB5C282CD
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 05:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DAED2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 05:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfA3FHz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 00:07:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:57250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbfA3FHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 00:07:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39CA0ADED
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 05:07:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Output ENOSPC debug info in inc_block_group_ro()
Date:   Wed, 30 Jan 2019 13:07:51 +0800
Message-Id: <20190130050751.31766-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since inc_block_group_ro() would return -ENOSPC, outputting debug info
for enospc_debug mount option would be helpful to debug some balance
false ENOSPC report.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b15afeae16df..6becfc3b2b72 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9588,6 +9588,7 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
+	u64 sinfo_used;
 	u64 min_allocable_bytes;
 	int ret = -ENOSPC;
 
@@ -9614,9 +9615,10 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
+	sinfo_used = btrfs_space_info_used(sinfo, true);
 
-	if (btrfs_space_info_used(sinfo, true) + num_bytes +
-	    min_allocable_bytes <= sinfo->total_bytes) {
+	if (sinfo_used + num_bytes + min_allocable_bytes <=
+	    sinfo->total_bytes) {
 		sinfo->bytes_readonly += num_bytes;
 		cache->ro++;
 		list_add_tail(&cache->ro_list, &sinfo->ro_bgs);
@@ -9625,6 +9627,15 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 out:
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
+	if (ret == -ENOSPC && btrfs_test_opt(cache->fs_info, ENOSPC_DEBUG)) {
+		btrfs_info(cache->fs_info,
+			"unable to make block group %llu ro",
+			cache->key.objectid);
+		btrfs_info(cache->fs_info,
+			"sinfo_used=%llu bg_num_bytes=%llu min_allocable=%llu",
+			sinfo_used, num_bytes, min_allocable_bytes);
+		dump_space_info(cache->fs_info, cache->space_info, 0, 0);
+	}
 	return ret;
 }
 
-- 
2.20.1

