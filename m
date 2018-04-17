Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60806 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752252AbeDQKoH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Apr 2018 06:44:07 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Fix wrong btrfs_delalloc_release_extents parameter
Date: Tue, 17 Apr 2018 18:43:58 +0800
Message-Id: <20180417104358.16667-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type
for delalloc") merged into mainline is not the latest version submitted
to mail list in Dec 2017.

It has a fatal wrong @qgroup_free parameter, which results increasing
qgroup metadata pertrans reserved space, and causing a lot of early EDQUOT.

Fix it by applying the correct diff on top of current branch.

Fixes: 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type for delalloc")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dd1b79750d6a..9701aa7361f3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1763,7 +1763,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state);
 		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
-					       (ret != 0));
+					       true);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
-- 
2.17.0

