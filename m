Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3O5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 09:57:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2DDC2ABFC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 14:57:38 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/5] btrfs-progs: check, fix path leak in error branch
Date: Tue, 30 Dec 2014 15:57:37 +0100
Message-Id: <0665aaf5a3733c5153e7fc0959d813c6ff76ee34.1419951036.git.dsterba@suse.cz>
In-Reply-To: <cover.1419951036.git.dsterba@suse.cz>
References: <cover.1419951036.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-coverity-id: 1260250
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e74b116c0c43..71e4f4f3a13b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2839,7 +2839,7 @@ static int repair_btree(struct btrfs_root *root,
 		ret = PTR_ERR(trans);
 		fprintf(stderr, "Error starting transaction: %s\n",
 			strerror(-ret));
-		return ret;
+		goto out_free_path;
 	}
 	cache = first_cache_extent(corrupt_blocks);
 	while (cache) {
@@ -2894,8 +2894,9 @@ static int repair_btree(struct btrfs_root *root,
 		cache = next_cache_extent(cache);
 	}
 out:
-	btrfs_free_path(path);
 	btrfs_commit_transaction(trans, root);
+out_free_path:
+	btrfs_free_path(path);
 	return ret;
 }
 
-- 
2.1.3

