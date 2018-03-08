Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754780AbeCHOfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E114EAE22
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/22] btrfs: document more parameters of submit_extent_page
Date: Thu,  8 Mar 2018 15:33:17 +0100
Message-Id: <d8d983be9834b99e0b9698789ee2a24e70b4b5d2.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2fbc58b0b908..f1d199c8883e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2746,7 +2746,19 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 
 /*
  * @opf:	bio REQ_OP_* and REQ_* flags as one value
+ * @tree:	tree so we can call our merge_bio hook
+ * @wbc:	optional writeback control for io accounting
+ * @page:	page to add to the bio
+ * @pg_offset:	offset of the new bio or to check whether we are adding
+ *              a contiguous page to the previous one
+ * @size:	portion of page that we want to write
+ * @offset:	starting offset in the page
+ * @bdev:	attach newly created bios to this bdev
  * @bio_ret:	must be valid pointer, newly allocated bio will be stored there
+ * @end_io_func:     end_io callback for new bio
+ * @mirror_num:	     desired mirror to read/write
+ * @prev_bio_flags:  flags of previous bio to see if we can merge the current one
+ * @bio_flags:	flags of the current bio to see if we can merge them
  */
 static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
-- 
2.16.2

