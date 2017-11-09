Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:53654 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754731AbdKITbI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 14:31:08 -0500
Received: by mail-qt0-f196.google.com with SMTP id n61so9067566qte.10
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Nov 2017 11:31:07 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 4/6] export radix_tree_iter_tag_set
Date: Thu,  9 Nov 2017 14:30:59 -0500
Message-Id: <1510255861-8020-4-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1510255861-8020-1-git-send-email-josef@toxicpanda.com>
References: <1510255861-8020-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We use this in btrfs for metadata writeback.

Acked-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 lib/radix-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 8b1feca1230a..0c1cde9fcb69 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1459,6 +1459,7 @@ void radix_tree_iter_tag_set(struct radix_tree_root *root,
 {
 	node_tag_set(root, iter->node, tag, iter_offset(iter));
 }
+EXPORT_SYMBOL(radix_tree_iter_tag_set);
 
 static void node_tag_clear(struct radix_tree_root *root,
 				struct radix_tree_node *node,
-- 
2.7.5

