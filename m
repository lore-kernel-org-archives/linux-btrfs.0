Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51478 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3DWPJ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 11:09:57 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CCFAA9A041C
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 09:09:56 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id M7Lpeia0qkCXnL7W (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 09:09:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't try and free ebs twice in log replay
Date: Tue, 23 Apr 2013 11:09:54 -0400
Message-ID: <1366729794-1542-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This work is done by btrfs_free_path() anyway so there's no need for this
duplicate work.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 52287ec..1fdc221 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2161,7 +2161,6 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 	int wret;
 	int level;
 	struct btrfs_path *path;
-	int i;
 	int orig_level;
 
 	path = btrfs_alloc_path();
@@ -2218,12 +2217,6 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 	}
 
 out:
-	for (i = 0; i <= orig_level; i++) {
-		if (path->nodes[i]) {
-			free_extent_buffer(path->nodes[i]);
-			path->nodes[i] = NULL;
-		}
-	}
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.7.6

