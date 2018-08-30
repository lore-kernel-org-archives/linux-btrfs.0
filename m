Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44485 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbeH3Vqg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:36 -0400
Received: by mail-qt0-f196.google.com with SMTP id k38-v6so11285517qtk.11
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v10-v6sm4945076qtv.77.2018.08.30.10.43.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:43:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 29/35] btrfs: just delete pending bgs if we are aborted
Date: Thu, 30 Aug 2018 13:42:19 -0400
Message-Id: <20180830174225.2200-30-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We still need to do all of the accounting cleanup for pending block
groups if we abort.  So set the ret to trans->aborted so if we aborted
the cleanup happens and everybody is happy.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 90f267f4dd0f..132a1157982c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10333,7 +10333,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
-	int ret = 0;
+	int ret = trans->aborted;
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
 	trans->can_flush_pending_bgs = false;
-- 
2.14.3
