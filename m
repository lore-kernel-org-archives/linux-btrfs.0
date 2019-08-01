Return-Path: <SRS0=y5XK=V5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55749C19759
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35A6A20665
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfHAMuD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:50:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:34502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfHAMuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Aug 2019 08:50:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01AA7ADF1
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Aug 2019 12:50:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1F1C8DA7D9; Thu,  1 Aug 2019 14:50:35 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: tree-log: use symbolic name for first replay stage
Date:   Thu,  1 Aug 2019 14:50:35 +0200
Message-Id: <5e7f207680bb5e16c0ef4f8499b060bff308a8f5.1564663765.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564663765.git.dsterba@suse.com>
References: <cover.1564663765.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5513e76cc336..f48c8b9b513b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6237,7 +6237,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 	struct btrfs_fs_info *fs_info = log_root_tree->fs_info;
 	struct walk_control wc = {
 		.process_func = process_one_buffer,
-		.stage = 0,
+		.stage = LOG_WALK_PIN_ONLY,
 	};
 
 	path = btrfs_alloc_path();
-- 
2.22.0

