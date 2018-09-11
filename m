Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f181.google.com ([209.85.222.181]:40182 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:31 -0400
Received: by mail-qk1-f181.google.com with SMTP id c126-v6so17335233qkd.7
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:06 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 30/36] btrfs: just delete pending bgs if we are aborted
Date: Tue, 11 Sep 2018 13:58:01 -0400
Message-Id: <20180911175807.26181-31-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We still need to do all of the accounting cleanup for pending block
groups if we abort.  So set the ret to trans->aborted so if we aborted
the cleanup happens and everybody is happy.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 20fed467468e..47690589d89b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10358,9 +10358,15 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
-	int ret = 0;
+	int ret;
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
+	/*
+	 * If we aborted the transaction with pending bg's we need to just
+	 * cleanup the list and carry on.
+	 */
+	ret = trans->aborted;
+
 	trans->can_flush_pending_bgs = false;
 	while (!list_empty(&trans->new_bgs)) {
 		block_group = list_first_entry(&trans->new_bgs,
-- 
2.14.3
