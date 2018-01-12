Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33392 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964809AbeALQxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 11:53:04 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][btrfs-next] btrfs: remove redundant check on ret and goto
Date: Fri, 12 Jan 2018 16:52:58 +0000
Message-Id: <20180112165258.27431-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for a non-zero ret is redundant as the goto will jump to
the very next statement anyway.  Remove this extraneous code.

Detected by CoverityScan, CID#1463784 ("Identical code for different
branches")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/tests/btrfs-tests.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 9786d8cd0aa6..e74278170806 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -278,8 +278,7 @@ int btrfs_run_sanity_tests(void)
 		}
 	}
 	ret = btrfs_test_extent_map();
-	if (ret)
-		goto out;
+
 out:
 	btrfs_destroy_test_fs();
 	return ret;
-- 
2.15.1

