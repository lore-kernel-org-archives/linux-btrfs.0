Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbeGKFn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 01:43:58 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 592F5ADE2
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 05:41:24 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC v2 1/2] btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block()
Date: Wed, 11 Jul 2018 13:41:21 +0800
Message-Id: <20180711054122.13727-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In commit ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device
replace") we removed the branch of copy_nocow_pages() to avoid
corruption for compressed nodatasum extents.

However above commit only solves the problem in scrub_extent(), if
during scrub_pages() we failed to read some pages,
sctx->no_io_error_seen will be non-zero and we go to fixup function
scrub_handle_errored_block().

In scrub_handle_errored_block(), for sctx without csum (no matter if
we're doing replace or scrub) we go to scrub_fixup_nodatasum() routine,
which does the similar thing with copy_nocow_pages(), but does it
without the extra check in copy_nocow_pages() routine.

So for test cases like btrfs/100, where we emulate read errors during
replace/scrub, we could corrupt compressed extent data again.

This patch will fix it just by avoiding any "optimization" for
nodatasum, just falls back to the normal fixup routine by try read from
any good copy.

This also solves WARN_ON() or dead lock caused by lame backref iteration
in scrub_fixup_nodatasum() routine.

The deadlock or WARN_ON() won't be triggered before commit ac0b4145d662
("btrfs: scrub: Don't use inode pages for device replace") since
copy_nocow_pages() have better locking and extra check for data extent,
and it's already doing the fixup work by try to read data from any good
copy, so it won't go scrub_fixup_nodatasum() anyway.

Fixes: ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device replace")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Add detailed commit message for this.
---
 fs/btrfs/scrub.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 572306036477..328232fa5646 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1151,11 +1151,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		return ret;
 	}
 
-	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
-		sblocks_for_recheck = NULL;
-		goto nodatasum_case;
-	}
-
 	/*
 	 * read all mirrors one after the other. This includes to
 	 * re-read the extent or metadata block that failed (that was
@@ -1268,13 +1263,20 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		goto out;
 	}
 
-	if (!is_metadata && !have_csum) {
+	/*
+	 * NOTE: Even for nodatasum data case, it's still possible that it's
+	 * compressed data extent, thus scrub_fixup_nodatasum(), which
+	 * write inode page cache onto disk, could cause serious data
+	 * corruption.
+	 *
+	 * So here we could only read from disk, and hopes our recovery
+	 * could reach disk before newer write.
+	 */
+	if (0 && !is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
 		WARN_ON(sctx->is_dev_replace);
 
-nodatasum_case:
-
 		/*
 		 * !is_metadata and !have_csum, this means that the data
 		 * might not be COWed, that it might be modified
-- 
2.18.0

