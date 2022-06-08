Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935B6C433EF
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jun 2022 16:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbiFHQsF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbiFHQsE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2022 12:48:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68964BBB5
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Jun 2022 09:48:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 19B2821B22;
        Wed,  8 Jun 2022 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654706881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0rEqmaiwSuHMTNCnNHVnGEUhyR//o+l8cjEch3Xnlc0=;
        b=i3t2Lq6zbpYSuRgFXA2nkDncEZpq07ysC2XI69KtEJM3WzpTPnHi+CN2DX/KbB/716Zyh0
        pSBxuRg+OrU+d4CwOgrsDfmRXoxZVNz1WbRS/FhafIh2tf1xhpQGkOJgYxvXRmh2Efc6iU
        J1N3gjtGSl4SGRuyG9LSPFwn6yGUGeA=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 08E042C141;
        Wed,  8 Jun 2022 16:48:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76D81DA883; Wed,  8 Jun 2022 18:43:32 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/9] btrfs: remove node and parent parameters from insert_state
Date:   Wed,  8 Jun 2022 18:43:32 +0200
Message-Id: <2457c75452daee079a80c55923d89124855947e4.1654706034.git.dsterba@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654706034.git.dsterba@suse.com>
References: <cover.1654706034.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There's no caller left that would pass valid pointers to insert_state so
we can drop them.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 00a6a2d0b112..b7d6f2dc4706 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -525,8 +525,6 @@ static void set_state_bits(struct extent_io_tree *tree,
  */
 static int insert_state(struct extent_io_tree *tree,
 			struct extent_state *state,
-			struct rb_node ***node_in,
-			struct rb_node **parent_in,
 			u32 bits, struct extent_changeset *changeset)
 {
 	struct rb_node **node;
@@ -535,13 +533,6 @@ static int insert_state(struct extent_io_tree *tree,
 
 	set_state_bits(tree, state, bits, changeset);
 
-	/* Caller provides the exact tree location */
-	if (node_in && parent_in) {
-		node = *node_in;
-		parent = *parent_in;
-		goto insert_new;
-	}
-
 	node = &tree->state.rb_node;
 	while (*node) {
 		struct tree_entry *entry;
@@ -561,7 +552,6 @@ static int insert_state(struct extent_io_tree *tree,
 		}
 	}
 
-insert_new:
 	rb_link_node(&state->rb_node, parent, node);
 	rb_insert_color(&state->rb_node, &tree->state);
 
@@ -1151,7 +1141,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, u32 bits,
 		 */
 		prealloc->start = start;
 		prealloc->end = this_end;
-		err = insert_state(tree, prealloc, NULL, NULL, bits, changeset);
+		err = insert_state(tree, prealloc, bits, changeset);
 		if (err)
 			extent_io_tree_panic(tree, err);
 
@@ -1372,7 +1362,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		 */
 		prealloc->start = start;
 		prealloc->end = this_end;
-		err = insert_state(tree, prealloc, NULL, NULL, bits, NULL);
+		err = insert_state(tree, prealloc, bits, NULL);
 		if (err)
 			extent_io_tree_panic(tree, err);
 		cache_state(prealloc, cached_state);
-- 
2.36.1

