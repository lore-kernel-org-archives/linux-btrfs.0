Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41054 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id h138-v6so17324530qke.8
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:00 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 27/36] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date: Tue, 11 Sep 2018 13:57:58 -0400
Message-Id: <20180911175807.26181-28-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of open coding this stuff use the helper instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
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
