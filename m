Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37518 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeAHXGi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 18:06:38 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][btrfs-next] Btrfs: extent map selftest: add missing void parameter to btrfs_test_extent_map
Date: Mon,  8 Jan 2018 23:06:32 +0000
Message-Id: <20180108230632.8101-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Add a missing void parameter to function btrfs_test_extent_map, fixes
sparse warning:

warning: non-ANSI function declaration of function 'btrfs_test_extent_map'

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/tests/extent-map-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 66d5523d7a2b..d42e14c43a6a 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -340,7 +340,7 @@ static void test_case_4(struct extent_map_tree *em_tree)
 	__test_case_4(em_tree, SZ_4K);
 }
 
-int btrfs_test_extent_map()
+int btrfs_test_extent_map(void)
 {
 	struct extent_map_tree *em_tree;
 
-- 
2.15.1

