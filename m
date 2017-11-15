Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933104AbdKORoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F6CFAD06
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: remove unused member of btrfs_trans_handle
Date: Wed, 15 Nov 2017 18:41:57 +0100
Message-Id: <6c4d0537aceaa2054e4c560218a8ee7274dc010e.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last user was removed in a monster commit a22285a6a32390195235171
("Btrfs: Integrate metadata reservation with start_transaction") in
2010.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index a673142c003e..c48a4a03f1b4 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -112,7 +112,6 @@ struct btrfs_trans_handle {
 	u64 bytes_reserved;
 	u64 chunk_bytes_reserved;
 	unsigned long use_count;
-	unsigned long blocks_reserved;
 	unsigned long delayed_ref_updates;
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
-- 
2.14.3

