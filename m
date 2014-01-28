Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35329 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA1Bi6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 20:38:58 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so6539285wgh.26
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 17:38:57 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix send file hole detection leading to data corruption
Date: Tue, 28 Jan 2014 01:38:06 +0000
Message-Id: <1390873086-8591-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a case where file hole detection was incorrect and it would
cause an incremental send to override a section of a file with zeroes.

This happened in the case where between the last leaf we processed which
contained a file extent item for our current inode and the leaf we're
currently are at (and has a file extent item for our current inode) there
are only leafs containing exclusively file extent items for our current
inode, and none of them was updated since the previous send operation.
The file hole detection code would incorrectly consider the file range
covered by these leafs as a hole.

A test case for xfstests follows soon.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 306f9a9..16a0c84 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4485,6 +4485,21 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 		extent_end = key->offset +
 			btrfs_file_extent_num_bytes(path->nodes[0], fi);
 	}
+
+	if (path->slots[0] == 0 &&
+	    sctx->cur_inode_last_extent < key->offset) {
+		/*
+		 * We might have skipped entire leafs that contained only
+		 * file extent items for our current inode. These leafs have
+		 * a generation number smaller (older) than the one in the
+		 * current leaf and the leaf our last extent came from, and
+		 * are located between these 2 leafs.
+		 */
+		ret = get_last_extent(sctx, key->offset - 1);
+		if (ret)
+			return ret;
+	}
+
 	if (sctx->cur_inode_last_extent < key->offset)
 		ret = send_hole(sctx, key->offset);
 	sctx->cur_inode_last_extent = extent_end;
-- 
1.7.9.5

