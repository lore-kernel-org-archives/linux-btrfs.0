Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DB0C77B7A
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jun 2023 19:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjFGTYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjFGTYq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2023 15:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9BB1FDA
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 12:24:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EDC2639BC
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CBFC433EF
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Jun 2023 19:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686165884;
        bh=jYKVurW1jejNCsQA0grZ4GuvimYWAQi2AtMolKOXeag=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=USDTJRaSGvfuCtp3MS6E9I8kkRrlkalDkrOS+66qTg2plUla0GdMYJiWmFWq+u1qp
         /s326vGQmrL4+Zy4+IA7mT37HlyifVkRD5CvzV1r7sbCvWIgkIq4y9ku2k+SWE+Ra+
         50E1uDQSZqy+iTQCmzaaGDJRuwpaZiNN1PzqK2JONNSDDiHm2pQUqZ6mKy8rMJRtN6
         8KIG2/zXfbQaJbVcrsHkkE/oRKigVkLhLkMCW2sXsWjgwDkDOhXmDowvZx9sqgnLHK
         y+MbUXURO/A4oWXVi5sv33MaKSu3LMH1YDsUdMVszOlJU/bO4rv4qe3szh6gy960PQ
         oxWGdcDiMN/Tw==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 04/13] btrfs: do not BUG_ON() on tree mod log failure at __btrfs_cow_block()
Date:   Wed,  7 Jun 2023 20:24:28 +0100
Message-Id: <33736c36355cd1d902b9f2ccc65d5f6fc13c5e56.1686164806.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1686164789.git.fdmanana@suse.com>
References: <cover.1686164789.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At __btrfs_cow_block(), instead of doing a BUG_ON() in case we fail to
record a tree mod log root insertion operation, do a transaction abort
instead. There's really no need for the BUG_ON(), we can properly
release all resources in this context and turn the filesystem to RO mode
and in an error state instead.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8496535828de..d6c29564ce49 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -584,9 +584,14 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
 			parent_start = buf->start;
 
-		atomic_inc(&cow->refs);
 		ret = btrfs_tree_mod_log_insert_root(root->node, cow, true);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_tree_unlock(cow);
+			free_extent_buffer(cow);
+			btrfs_abort_transaction(trans, ret);
+			return ret;
+		}
+		atomic_inc(&cow->refs);
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
-- 
2.34.1

