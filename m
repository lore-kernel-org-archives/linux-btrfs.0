Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51987 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeC3FtM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:49:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/5] btrfs-progs: extent_io: Init eb->lru to avoid NULL pointer dereference
Date: Fri, 30 Mar 2018 13:48:54 +0800
Message-Id: <20180330054857.6106-3-wqu@suse.com>
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
References: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

eb->lru is not initialized in __alloc_extent_buffer(), so in the
following call chain, it could call NULL pointer dereference:

btrfs_clone_extent_buffer()
|- __alloc_extent_buffer()
   |- Now eb->lru is NULL (not initialized)

free_extent_buffer_final()
|- list_del_init(&eb->lru)

Thankfully, current btrfs-progs won't trigger such bug as the only
btrfs_clone_extent_buffer() user is paths_from_inode(), which is not
used by anyone.
(But due to the usefulness of that function in future offline scrub, I'd
like to keep this dead code)

Anyway, initialize eb->lru in __alloc_extent_bufer() bring no harm.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extent_io.c b/extent_io.c
index 986ad5c0577c..3117782335ab 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -564,6 +564,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->cache_node.start = bytenr;
 	eb->cache_node.size = blocksize;
 	INIT_LIST_HEAD(&eb->recow);
+	INIT_LIST_HEAD(&eb->lru);
 
 	return eb;
 }
-- 
2.16.3

