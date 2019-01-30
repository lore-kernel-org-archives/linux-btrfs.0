Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF834C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3E020882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfA3OvQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:38164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731400AbfA3OvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B476B0B0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 13/15] btrfs: Fix gross misnaming
Date:   Wed, 30 Jan 2019 16:51:00 +0200
Message-Id: <20190130145102.4708-14-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The variables and function parameters of __etree_search which pertain to
prev/next are grossly misnamed. Namely, prev_ret holds the next state
and not the previous. Similarly, next_ret actually holds the previous
extent state relating to the offset we are interested in. Fix this by
renaming the variables as well as switching the arguments order. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e788d4aa53d1..d5525d18803d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -309,8 +309,8 @@ static struct rb_node *tree_insert(struct rb_root *root,
 }
 
 static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
-				      struct rb_node **prev_ret,
 				      struct rb_node **next_ret,
+				      struct rb_node **prev_ret,
 				      struct rb_node ***p_ret,
 				      struct rb_node **parent_ret)
 {
@@ -339,23 +339,23 @@ static struct rb_node *__etree_search(struct extent_io_tree *tree, u64 offset,
 	if (parent_ret)
 		*parent_ret = prev;
 
-	if (prev_ret) {
+	if (next_ret) {
 		orig_prev = prev;
 		while (prev && offset > prev_entry->end) {
 			prev = rb_next(prev);
 			prev_entry = rb_entry(prev, struct tree_entry, rb_node);
 		}
-		*prev_ret = prev;
+		*next_ret = prev;
 		prev = orig_prev;
 	}
 
-	if (next_ret) {
+	if (prev_ret) {
 		prev_entry = rb_entry(prev, struct tree_entry, rb_node);
 		while (prev && offset < prev_entry->start) {
 			prev = rb_prev(prev);
 			prev_entry = rb_entry(prev, struct tree_entry, rb_node);
 		}
-		*next_ret = prev;
+		*prev_ret = prev;
 	}
 	return NULL;
 }
@@ -366,12 +366,12 @@ tree_search_for_insert(struct extent_io_tree *tree,
 		       struct rb_node ***p_ret,
 		       struct rb_node **parent_ret)
 {
-	struct rb_node *prev = NULL;
+	struct rb_node *next= NULL;
 	struct rb_node *ret;
 
-	ret = __etree_search(tree, offset, &prev, NULL, p_ret, parent_ret);
+	ret = __etree_search(tree, offset, &next, NULL, p_ret, parent_ret);
 	if (!ret)
-		return prev;
+		return next;
 	return ret;
 }
 
-- 
2.17.1

