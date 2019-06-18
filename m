Return-Path: <SRS0=NB0J=UR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78575C31E5B
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 17:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631E7205F4
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Jun 2019 17:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfFRR7T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:59:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:45066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729349AbfFRR7T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jun 2019 13:59:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE0E2AEA1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2019 17:59:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 12E19DA871; Tue, 18 Jun 2019 20:00:05 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: use common helpers for extent IO state insertion messages
Date:   Tue, 18 Jun 2019 20:00:05 +0200
Message-Id: <b7824fd41f86ac8bcb4dfd19565d590d97cbe2f5.1560880630.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560880630.git.dsterba@suse.com>
References: <cover.1560880630.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Print the error messages using the helpers that also print the
filesystem identification.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8634eda07b7a..a6ad2f6f2bf7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -524,9 +524,11 @@ static int insert_state(struct extent_io_tree *tree,
 {
 	struct rb_node *node;
 
-	if (end < start)
-		WARN(1, KERN_ERR "BTRFS: end < start %llu %llu\n",
-		       end, start);
+	if (end < start) {
+		btrfs_err(tree->fs_info,
+			"insert state: end < start %llu %llu", end, start);
+		WARN_ON(1);
+	}
 	state->start = start;
 	state->end = end;
 
@@ -536,7 +538,8 @@ static int insert_state(struct extent_io_tree *tree,
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
-		pr_err("BTRFS: found node %llu %llu on insert of %llu %llu\n",
+		btrfs_err(tree->fs_info,
+		       "found node %llu %llu on insert of %llu %llu",
 		       found->start, found->end, start, end);
 		return -EEXIST;
 	}
-- 
2.21.0

