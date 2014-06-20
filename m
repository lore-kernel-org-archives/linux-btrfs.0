Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971AbaFTKHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 06:07:12 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: remove stale comment from btrfs_flush_all_pending_stuffs
Date: Fri, 20 Jun 2014 12:07:09 +0200
Message-Id: <ddfaf307d207f6c153b2fb419d95535f10e3945c.1403258477.git.dsterba@suse.cz>
In-Reply-To: <cover.1403258476.git.dsterba@suse.cz>
References: <cover.1403258476.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit fcebe4562dec83b3f8d3088d77584727b09130b2 (Btrfs: rework qgroup
accounting) removed the qgroup accounting after delayed refs.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/transaction.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 511839c04f11..d27d9e6d5a45 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1615,11 +1615,6 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_run_delayed_items(trans, root);
-	/*
-	 * running the delayed items may have added new refs. account
-	 * them now so that they hinder processing of more delayed refs
-	 * as little as possible.
-	 */
 	if (ret)
 		return ret;
 
-- 
1.7.9

