Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753288AbeGDHYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 03:24:55 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80D6FACED
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 07:24:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Reword dodgy comments
Date: Wed,  4 Jul 2018 10:24:52 +0300
Message-Id: <1530689092-18090-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1530689092-18090-1-git-send-email-nborisov@suse.com>
References: <1530689092-18090-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit eb14ab8ed24a ("Btrfs: fix page->private races") fixed a genuine
race between extent buffer initialisation and btree_releaseage.
Unfortunately as the code has evolved the comments weren't changed
which made them slightly wrong and they weren't very clear in the
fist place. Fix this by (hopefully) rewording them in a more
approachable manner.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2f5c6721d3bc..07b143577c28 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5001,8 +5001,11 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			uptodate = 0;
 
 		/*
-		 * see below about how we avoid a nasty race with release page
-		 * and why we unlock later
+		 * We can't unlock the pages just yet since the extent buffer
+		 * hasn't been properly inserted in the radix tree, this
+		 * opens a race with btree_releasepage which can free a page
+		 * while we are still filling in all pages for the buffer and
+		 * we crash.
 		 */
 	}
 	if (uptodate)
@@ -5031,13 +5034,9 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
 
 	/*
-	 * there is a race where release page may have
-	 * tried to find this extent buffer in the radix
-	 * but failed.  It will tell the VM it is safe to
-	 * reclaim the, and it will clear the page private bit.
-	 * We must make sure to set the page private bit properly
-	 * after the extent buffer is in the radix tree so
-	 * it doesn't get lost
+	 * Now it's safe to unlock the pages because any calls to
+	 * btree_release page will correctly detect that a page belongs to a
+	 * live buffer and won't free them pre-maturely.
 	 */
 	for (i = 0; i < num_pages; i++)
 		unlock_page(eb->pages[i]);
-- 
2.7.4

