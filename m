Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752324AbdBMJes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:48 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3AE7AD26
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 17/29] btrfs: remove unused parameter from extent_write_cache_pages
Date: Mon, 13 Feb 2017 10:34:13 +0100
Message-Id: <43296f2bae8942890fda6c428617fb474c812696.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'tree' was used to call locking hook that does not exist anymore.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f683fa5a4b91..22a2f2fa62c7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3916,8 +3916,7 @@ int btree_write_cache_pages(struct address_space *mapping,
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
  */
-static int extent_write_cache_pages(struct extent_io_tree *tree,
-			     struct address_space *mapping,
+static int extent_write_cache_pages(struct address_space *mapping,
 			     struct writeback_control *wbc,
 			     writepage_t writepage, void *data,
 			     void (*flush_fn)(void *))
@@ -4158,8 +4157,7 @@ int extent_writepages(struct extent_io_tree *tree,
 		.bio_flags = 0,
 	};
 
-	ret = extent_write_cache_pages(tree, mapping, wbc,
-				       __extent_writepage, &epd,
+	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
 				       flush_write_bio);
 	flush_epd_write_bio(&epd);
 	return ret;
-- 
2.10.1

