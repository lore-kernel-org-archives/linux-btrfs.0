Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48701 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbKJJKQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 04:10:16 -0500
Date: Tue, 10 Nov 2015 12:10:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: tests: checking for NULL instead of IS_ERR()
Message-ID: <20151110091003.GC2934@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_dummy_root() return an error pointer on failure, it never
returns NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index c8c3d70..8b72b00 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -898,8 +898,10 @@ int btrfs_test_free_space_cache(void)
 	}
 
 	root = btrfs_alloc_dummy_root();
-	if (!root)
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto out;
+	}
 
 	root->fs_info = btrfs_alloc_dummy_fs_info();
 	if (!root->fs_info)
