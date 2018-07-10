Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751086AbeGJF5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 01:57:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A597AD0D
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 05:57:54 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/2] btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block()
Date: Tue, 10 Jul 2018 13:57:50 +0800
Message-Id: <20180710055751.13309-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we need to fixup error blocks during scrub/dev-replace for
nodatasum extents, we still goes through the inode page cache and write
them back onto disk.

It's already proved that such usage of on-disk data could lead to
serious data corruption for compressed extent.
So here we also need to avoid such case, so avoid any calling to
scrub_fixup_nodatasum().

Signed-off-by: Qu Wenruo <wqu@suse.com>
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

