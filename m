Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39844 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbeBHONb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 09:13:31 -0500
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][btrfs-next] Btrfs: extent map selftest: fix non-ANSI btrfs_test_extent_map declaration
Date: Thu,  8 Feb 2018 14:13:27 +0000
Message-Id: <20180208141327.10951-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The function btrfs_test_extent_map requires a void argument to be ANSI C
compliant and so it matches the prototype in fs/btrfs/tests/btrfs-tests.h

Cleans up sparse warning:
fs/btrfs/tests/extent-map-tests.c:346:27: warning: non-ANSI function
declaration of function 'btrfs_test_extent_map'

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/tests/extent-map-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 70c993f01670..c23bd00bdd92 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -343,7 +343,7 @@ static void test_case_4(struct extent_map_tree *em_tree)
 	__test_case_4(em_tree, SZ_4K);
 }
 
-int btrfs_test_extent_map()
+int btrfs_test_extent_map(void)
 {
 	struct extent_map_tree *em_tree;
 
-- 
2.15.1

