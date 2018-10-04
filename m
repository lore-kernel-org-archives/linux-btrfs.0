Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35ABEC64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0221213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0221213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbeJDMle (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 08:41:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:53136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbeJDMle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 08:41:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47134B063
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 05:49:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Validate btrfs_super_block::log_root_transid
Date:   Thu,  4 Oct 2018 13:49:50 +0800
Message-Id: <20181004054950.11651-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181004054950.11651-1-wqu@suse.com>
References: <20181004054950.11651-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

So we can detect log root related problem early and report the error
more meaningfully other than hitting it log root read time.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5124c15705ce..34c68401c6bc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2408,6 +2408,7 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 {
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
+	u64 generation;
 	int ret = 0;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
@@ -2534,21 +2535,36 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
+	generation = btrfs_super_generation(sb);
 	/*
 	 * The generation is a global counter, we'll trust it more than the others
 	 * but it's still possible that it's the one that's wrong.
 	 */
-	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
+	if (generation < btrfs_super_chunk_root_generation(sb))
 		btrfs_warn(fs_info,
 			"suspicious: generation < chunk_root_generation: %llu < %llu",
-			btrfs_super_generation(sb),
-			btrfs_super_chunk_root_generation(sb));
-	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
+			generation, btrfs_super_chunk_root_generation(sb));
+	if (generation < btrfs_super_cache_generation(sb)
 	    && btrfs_super_cache_generation(sb) != (u64)-1)
 		btrfs_warn(fs_info,
 			"suspicious: generation < cache_generation: %llu < %llu",
-			btrfs_super_generation(sb),
-			btrfs_super_cache_generation(sb));
+			generation, btrfs_super_cache_generation(sb));
+
+	/*
+	 * Check log root transid against super block generation.
+	 *
+	 * Older kernel doesn't populate log_root_transid, only need to check
+	 * it when it's not zero.
+	 * Since replaying suspicious log tree can cause serious problem, refuse
+	 * to mount if it doesn't match.
+	 */
+	if (btrfs_super_log_root_transid(sb) &&
+	    btrfs_super_log_root_transid(sb) != generation + 1) {
+		btrfs_err(fs_info,
+	"bad log tree, log_root_transid != generation + 1: %llu != %llu + 1",
+			  btrfs_super_log_root_transid(sb), generation);
+		ret = -EINVAL;
+	}
 
 	return ret;
 }
-- 
2.19.0

