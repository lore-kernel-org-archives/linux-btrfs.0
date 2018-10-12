Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01D8C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9096C206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9096C206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbeJLOOA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 10:14:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:37258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbeJLOOA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 10:14:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C45E2AEE4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:43:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: find-root: Fix wrong generation for log tree
Date:   Fri, 12 Oct 2018 14:42:57 +0800
Message-Id: <20181012064258.27033-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When searching for log tree, we should use btrfs_super_generation + 1
other than log_root_transid.

Since log_root_transid is never touched and will be deprecated soon.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-find-root.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index e2d2e70c408c..376bbc4c47fa 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -73,7 +73,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
 		level = btrfs_super_log_root_level(super);
-		gen = btrfs_super_log_root_transid(super);
+		gen = btrfs_super_generation(super) + 1;
 		break;
 	case BTRFS_UUID_TREE_OBJECTID:
 		gen = btrfs_super_uuid_tree_generation(super);
-- 
2.19.1

