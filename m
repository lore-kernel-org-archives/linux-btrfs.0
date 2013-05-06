Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab3EFVLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 17:11:24 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 26A17A50DD
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 23:11:23 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: image: handle superblocks correctly on fs with big blocks
Date: Mon,  6 May 2013 23:11:20 +0200
Message-Id: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Superblock is always 4k, but metadata blocks may be larger. We have to
use the appropriate block size when doing checksums, otherwise they're
wrong.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-image.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 188291c..dca7a28 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -469,6 +469,16 @@ static int read_data_extent(struct metadump_struct *md,
 	return 0;
 }
 
+static int is_sb_offset(u64 offset) {
+	switch (offset) {
+		case 65536:
+		case 67108864:
+		case 274877906944:
+			return 1;
+	}
+	return 0;
+}
+
 static int flush_pending(struct metadump_struct *md, int done)
 {
 	struct async_work *async = NULL;
@@ -506,7 +516,16 @@ static int flush_pending(struct metadump_struct *md, int done)
 		}
 
 		while (!md->data && size > 0) {
-			eb = read_tree_block(md->root, start, blocksize, 0);
+			/*
+			 * We must differentiate between superblock and
+			 * metadata on filesystems with blocksize > 4k,
+			 * otherwise the checksum fails for superblock
+			 */
+			int bs = blocksize;
+
+			if (is_sb_offset(start))
+				bs = BTRFS_SUPER_INFO_SIZE;
+			eb = read_tree_block(md->root, start, bs, 0);
 			if (!eb) {
 				free(async->buffer);
 				free(async);
@@ -516,9 +535,9 @@ static int flush_pending(struct metadump_struct *md, int done)
 			}
 			copy_buffer(async->buffer + offset, eb);
 			free_extent_buffer(eb);
-			start += blocksize;
-			offset += blocksize;
-			size -= blocksize;
+			start += bs;
+			offset += bs;
+			size -= bs;
 		}
 
 		md->pending_start = (u64)-1;
-- 
1.8.2

