Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:21558 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdIJL3m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 07:29:42 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com, nborisov@suse.com,
        jeffm@suse.com, osandov@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] btrfs: tests: Fix a memory leak in error handling path in 'run_test()'
Date: Sun, 10 Sep 2017 13:19:38 +0200
Message-Id: <20170910111938.15201-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If 'btrfs_alloc_path()' fails, we must free the resourses already
allocated, as done in the other error handling paths in this function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/btrfs/tests/free-space-tree-tests.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 1458bb0ea124..8444a018cca2 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -500,7 +500,8 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	path = btrfs_alloc_path();
 	if (!path) {
 		test_msg("Couldn't allocate path\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	ret = add_block_group_free_space(&trans, root->fs_info, cache);
-- 
2.11.0

