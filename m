Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE2C433E7
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA37D2098B
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgHaLyP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:54:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:38968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgHaLxz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Aug 2020 07:53:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07CB0B7C4;
        Mon, 31 Aug 2020 11:53:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/12] btrfs: Make inode_tree_del take btrfs_inode
Date:   Mon, 31 Aug 2020 14:42:38 +0300
Message-Id: <20200831114249.8360-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831114249.8360-1-nborisov@suse.com>
References: <20200831114249.8360-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ab84202cd456..c59615efab9e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5289,15 +5289,15 @@ static void inode_tree_add(struct inode *inode)
 	spin_unlock(&root->inode_lock);
 }
 
-static void inode_tree_del(struct inode *inode)
+static void inode_tree_del(struct btrfs_inode *inode)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	int empty = 0;
 
 	spin_lock(&root->inode_lock);
-	if (!RB_EMPTY_NODE(&BTRFS_I(inode)->rb_node)) {
-		rb_erase(&BTRFS_I(inode)->rb_node, &root->inode_tree);
-		RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
+	if (!RB_EMPTY_NODE(&inode->rb_node)) {
+		rb_erase(&inode->rb_node, &root->inode_tree);
+		RB_CLEAR_NODE(&inode->rb_node);
 		empty = RB_EMPTY_ROOT(&root->inode_tree);
 	}
 	spin_unlock(&root->inode_lock);
@@ -8613,7 +8613,7 @@ void btrfs_destroy_inode(struct inode *inode)
 		}
 	}
 	btrfs_qgroup_check_reserved_leak(BTRFS_I(inode));
-	inode_tree_del(inode);
+	inode_tree_del(BTRFS_I(inode));
 	btrfs_drop_extent_cache(BTRFS_I(inode), 0, (u64)-1, 0);
 	btrfs_inode_clear_file_extent_range(BTRFS_I(inode), 0, (u64)-1);
 	btrfs_put_root(BTRFS_I(inode)->root);
-- 
2.17.1

