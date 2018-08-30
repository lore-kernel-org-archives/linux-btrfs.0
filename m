Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44455 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeH3Vqb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:31 -0400
Received: by mail-qt0-f193.google.com with SMTP id k38-v6so11284966qtk.11
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:16 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l23-v6sm4879700qta.30.2018.08.30.10.43.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:43:14 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 26/35] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date: Thu, 30 Aug 2018 13:42:16 -0400
Message-Id: <20180830174225.2200-27-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of open coding this stuff use the helper instead.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c72ab2ca7627..1d3f5731d616 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4232,12 +4232,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (head->must_insert_reserved)
 			pin_bytes = true;
 		btrfs_free_delayed_extent_op(head->extent_op);
-		delayed_refs->num_heads--;
-		if (head->processing == 0)
-			delayed_refs->num_heads_ready--;
-		atomic_dec(&delayed_refs->num_entries);
-		rb_erase(&head->href_node, &delayed_refs->href_root);
-		RB_CLEAR_NODE(&head->href_node);
+		btrfs_delete_ref_head(delayed_refs, head);
 		spin_unlock(&head->lock);
 		spin_unlock(&delayed_refs->lock);
 		mutex_unlock(&head->mutex);
-- 
2.14.3
