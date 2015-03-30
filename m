Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay107.isp.belgacom.be ([195.238.20.134]:17219 "EHLO
	mailrelay107.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbbC3UVS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 16:21:18 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1 linux-next] Btrfs: use BTRFS_COMPRESS_NONE instead of 0
Date: Mon, 30 Mar 2015 22:21:11 +0200
Message-Id: <1427746872-17086-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() was called with 0 instead of
actual definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 686331f..f626519 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -524,7 +524,8 @@ cont:
 			 * to make an uncompressed inline extent.
 			 */
 			ret = cow_file_range_inline(root, inode, start, end,
-						    0, 0, NULL);
+						    0, BTRFS_COMPRESS_NONE,
+						    NULL);
 		} else {
 			/* try making a compressed inline extent */
 			ret = cow_file_range_inline(root, inode, start, end,
@@ -943,8 +944,8 @@ static noinline int cow_file_range(struct inode *inode,
 
 	if (start == 0) {
 		/* lets try to make an inline extent */
-		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
-					    NULL);
+		ret = cow_file_range_inline(root, inode, start, end, 0,
+					    BTRFS_COMPRESS_NONE, NULL);
 		if (ret == 0) {
 			extent_clear_unlock_delalloc(inode, start, end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
-- 
1.9.1

