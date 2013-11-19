Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57054 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3KSQTn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 11:19:43 -0500
Received: by mail-wi0-f179.google.com with SMTP id fb10so5713694wid.6
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 08:19:41 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix ordered extent check in btrfs_punch_hole
Date: Tue, 19 Nov 2013 16:19:24 +0000
Message-Id: <1384877964-8286-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the ordered extent's last byte was 1 less than our region's
start byte, we would unnecessarily wait for the completion of
that ordered extent, because it doesn't intersect our target
range.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c77da44..a679a36 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2129,7 +2129,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		 * we need to try again.
 		 */
 		if ((!ordered ||
-		    (ordered->file_offset + ordered->len < lockstart ||
+		    (ordered->file_offset + ordered->len <= lockstart ||
 		     ordered->file_offset > lockend)) &&
 		     !test_range_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockend, EXTENT_UPTODATE, 0,
-- 
1.7.9.5

