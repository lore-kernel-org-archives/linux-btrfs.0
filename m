Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38A8C7EE43
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jun 2023 19:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjFGTY7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjFGTYr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2023 15:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC96B1FDA
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 12:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50FB464319
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C5AC4339B
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686165885;
        bh=FNcsxZs/Nu3S9UPO66qsu5qD30c9KgD8AegESC9oMvo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RrNGhoTHjzzaj269ZJS0O18KUf1wBXmKhOBnJe0hrH6sVsq5IQElrDuGickKk85UE
         BVDpvAB/agw/tupbQ/H6mg+jZjDguUmWPsQljmYHfflk9Hv3kMAD+kinSKSSNVr5tg
         ri1Y3OqHAxaT+AdJP0qIgxlTbCRpVGbkxZxIKopcRPJ9QbeVxrrRMESp5gmfaY6nR1
         tbw1r73sj3XzbRJo8wROjGXsrN4e/R/mgJzTIsjJotAoQQ7JERSwbDc804Nqtsm21q
         wpC7hIyDXaKlDsGxRFZqN3zNpUUWAeIFmyvlAm7rdKN7ohStLr71WcogCWdlwRDXia
         Ix49XRd8+tvcA==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 05/13] btrfs: do not BUG_ON() on tree mod log failure at balance_level()
Date:   Wed,  7 Jun 2023 20:24:29 +0100
Message-Id: <4d83a67f420c7e8f6ceb4535ab5431fde9ecc82f.1686164810.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1686164789.git.fdmanana@suse.com>
References: <cover.1686164789.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At balance_level(), instead of doing a BUG_ON() in case we fail to record
tree mod log operations, do a transaction abort and return the error to
the callers. There's really no need for the BUG_ON() as we can release
all resources in this context, and we have to abort because other future
tree searches that use the tree mod log (btrfs_search_old_slot()) may get
inconsistent results if other operations modify the tree after that
failure and before the tree mod log based search.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d6c29564ce49..d60b28c6bd1b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1054,7 +1054,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		}
 
 		ret = btrfs_tree_mod_log_insert_root(root->node, child, true);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_tree_unlock(child);
+			free_extent_buffer(child);
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 		rcu_assign_pointer(root->node, child);
 
 		add_root_to_dirty_list(root);
@@ -1142,7 +1147,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			btrfs_node_key(right, &right_key, 0);
 			ret = btrfs_tree_mod_log_insert_key(parent, pslot + 1,
 					BTRFS_MOD_LOG_KEY_REPLACE);
-			BUG_ON(ret < 0);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto enospc;
+			}
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -1188,7 +1196,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		btrfs_node_key(mid, &mid_key, 0);
 		ret = btrfs_tree_mod_log_insert_key(parent, pslot,
 						    BTRFS_MOD_LOG_KEY_REPLACE);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, ret);
+			goto enospc;
+		}
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
 	}
-- 
2.34.1

