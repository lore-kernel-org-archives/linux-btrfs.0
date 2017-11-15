Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43229 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932951AbdKORoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92DA3AAEF
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: use narrower type for btrfs_transaction::num_dirty_bgs
Date: Wed, 15 Nov 2017 18:42:04 +0100
Message-Id: <5e6b0adce5f26cda1aa233beb8eda7b001c97731.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The u64 is an overkill here, we could not possibly create that many
blockgroups in one transaction.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/transaction.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 11b7d613140b..d59a65852447 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2894,7 +2894,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *global_rsv;
 	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
 	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
-	u64 num_dirty_bgs = trans->transaction->num_dirty_bgs;
+	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
 	u64 num_bytes, num_dirty_bgs_bytes;
 	int ret = 0;
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index edf53112a6f2..1805fd101767 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -70,7 +70,7 @@ struct btrfs_transaction {
 	struct list_head dirty_bgs;
 	struct list_head io_bgs;
 	struct list_head dropped_roots;
-	u64 num_dirty_bgs;
+	unsigned int num_dirty_bgs;
 
 	/*
 	 * we need to make sure block group deletion doesn't race with
-- 
2.14.3

