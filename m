Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43243 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933087AbdKORoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1D73AC88
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: switch btrfs_trans_handle::adding_csums to bool
Date: Wed, 15 Nov 2017 18:41:54 +0100
Message-Id: <bac1a66da076f7af878c9e83641da93d4d2dd80f.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The semantics of adding_csums matches bool, 'short' was most likely used
to save space in a698d0755adb6f2 ("Btrfs: add a type field for the
transaction handle").

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c       | 4 ++--
 fs/btrfs/transaction.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f352662e066f..3a32e782ccc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2036,10 +2036,10 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 	struct btrfs_ordered_sum *sum;
 
 	list_for_each_entry(sum, list, list) {
-		trans->adding_csums = 1;
+		trans->adding_csums = true;
 		btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
-		trans->adding_csums = 0;
+		trans->adding_csums = false;
 	}
 	return 0;
 }
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index c55e44560103..a673142c003e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -118,7 +118,7 @@ struct btrfs_trans_handle {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
 	short aborted;
-	short adding_csums;
+	bool adding_csums;
 	bool allocating_chunk;
 	bool can_flush_pending_bgs;
 	bool reloc_reserved;
-- 
2.14.3

