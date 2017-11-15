Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933093AbdKORoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22546AD09
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: reoder btrfs_trans_handle members for better packing
Date: Wed, 15 Nov 2017 18:42:01 +0100
Message-Id: <e6a3d3470b20fa79a000a939729653c220b583cb.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recent updates to the structure left some holes, reorder the types so
the packing is tight. The size goes from 112 to 104 on 64bit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index afa88f035654..edf53112a6f2 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -111,11 +111,12 @@ struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
 	u64 chunk_bytes_reserved;
-	refcount_t use_count;
 	unsigned long delayed_ref_updates;
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	refcount_t use_count;
+	unsigned int type;
 	short aborted;
 	bool adding_csums;
 	bool allocating_chunk;
@@ -123,7 +124,6 @@ struct btrfs_trans_handle {
 	bool reloc_reserved;
 	bool sync;
 	bool dirty;
-	unsigned int type;
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info;
 	struct list_head new_bgs;
-- 
2.14.3

