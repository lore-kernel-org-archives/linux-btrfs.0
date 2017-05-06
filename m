Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38782 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdEFWBK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 May 2017 18:01:10 -0400
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: remove redundant assignment and check on variable ret
Date: Sat,  6 May 2017 23:01:05 +0100
Message-Id: <20170506220105.13206-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable ret is assigned to zero and is always zero throughout the
function.  Thus the check for ret being less than zero is always
false and so mapping_set_error always has an -EIO error passed to
it.  Hence we can remove the redundant assignment and check on ret.

Detected by CoverityScan, CID#1414312 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/extent_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d8da3edf2ac3..7922cd34ba82 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2447,7 +2447,6 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
-	int ret = 0;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
@@ -2458,8 +2457,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	if (!uptodate) {
 		ClearPageUptodate(page);
 		SetPageError(page);
-		ret = ret < 0 ? ret : -EIO;
-		mapping_set_error(page->mapping, ret);
+		mapping_set_error(page->mapping, -EIO);
 	}
 }
 
-- 
2.11.0

