Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbaFTLB7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:01:59 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/8] btrfs: remove obsolete comment in btrfs_clean_one_deleted_snapshot
Date: Fri, 20 Jun 2014 13:01:57 +0200
Message-Id: <c9976cb993107d07bb081a2860a74abbabe6d8d7.1403260619.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The comment applied when there was a BUG_ON.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/transaction.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 511839c04f11..da77045785dc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2012,9 +2012,6 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 		ret = btrfs_drop_snapshot(root, NULL, 0, 0);
 	else
 		ret = btrfs_drop_snapshot(root, NULL, 1, 0);
-	/*
-	 * If we encounter a transaction abort during snapshot cleaning, we
-	 * don't want to crash here
-	 */
+
 	return (ret < 0) ? 0 : 1;
 }
-- 
1.7.9

