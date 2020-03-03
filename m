Return-Path: <SRS0=NN0a=4U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173F6C3F2C6
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 07:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2762146E
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 07:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCCHPw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 02:15:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:57048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbgCCHPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Mar 2020 02:15:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41871B0BD
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2020 07:15:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 18/19] btrfs: relocation: Move the target backref node insert code into finish_upper_links()
Date:   Tue,  3 Mar 2020 15:14:08 +0800
Message-Id: <20200303071409.57982-19-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303071409.57982-1-wqu@suse.com>
References: <20200303071409.57982-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The snippet of code can be easily merged into finish_upper_links(), thus
make related code more reuseable.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4cb61165d852..ac3ac0c7ac9e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -400,8 +400,23 @@ static int finish_upper_links(struct backref_cache *cache,
 {
 	struct list_head *useless_node = &cache->useless_node;
 	struct backref_edge *edge;
+	struct rb_node *rb_node;
 	LIST_HEAD(pending_edge);
 
+	/*
+	 * everything goes well, connect backref nodes and insert backref nodes
+	 * into the cache.
+	 */
+	ASSERT(start->checked);
+	if (!start->cowonly) {
+		rb_node = simple_insert(&cache->rb_root, start->bytenr,
+					&start->rb_node);
+		if (rb_node)
+			backref_cache_panic(cache->fs_info, start->bytenr,
+					    -EEXIST);
+		list_add_tail(&start->lower, &cache->leaves);
+	}
+
 	/*
 	 * Use breadth first search to iterate all related edges.
 	 *
@@ -584,7 +599,6 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 	struct backref_node *lower;
 	struct backref_node *node = NULL;
 	struct backref_edge *edge;
-	struct rb_node *rb_node;
 	int ret;
 	int err = 0;
 
@@ -629,20 +643,6 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		}
 	}
 
-	/*
-	 * everything goes well, connect backref nodes and insert backref nodes
-	 * into the cache.
-	 */
-	ASSERT(node->checked);
-	if (!node->cowonly) {
-		rb_node = simple_insert(&cache->rb_root, node->bytenr,
-					&node->rb_node);
-		if (rb_node)
-			backref_cache_panic(cache->fs_info, node->bytenr,
-					    -EEXIST);
-		list_add_tail(&node->lower, &cache->leaves);
-	}
-
 	/* Finish the upper linkage of newly added edges/nodes */
 	ret = finish_upper_links(cache, node);
 	if (ret < 0) {
-- 
2.25.1

