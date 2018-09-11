Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33048 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:24 -0400
Received: by mail-qt0-f195.google.com with SMTP id r37-v6so29221046qtc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:58 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 26/36] btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
Date: Tue, 11 Sep 2018 13:57:57 -0400
Message-Id: <20180911175807.26181-27-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have this open coded in btrfs_destroy_delayed_refs, use the helper
instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 11ea2ea7439e..c72ab2ca7627 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4214,16 +4214,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
-		if (!mutex_trylock(&head->mutex)) {
-			refcount_inc(&head->refs);
-			spin_unlock(&delayed_refs->lock);
-
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref_head(head);
-			spin_lock(&delayed_refs->lock);
+		if (btrfs_delayed_ref_lock(delayed_refs, head))
 			continue;
-		}
+
 		spin_lock(&head->lock);
 		while ((n = rb_first(&head->ref_tree)) != NULL) {
 			ref = rb_entry(n, struct btrfs_delayed_ref_node,
-- 
2.14.3
