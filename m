Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay108.isp.belgacom.be ([195.238.20.135]:17181 "EHLO
	mailrelay108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbbDCTul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 15:50:41 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH V2 linux-next] Btrfs: use BTRFS_COMPRESS_NONE instead of 0
Date: Fri,  3 Apr 2015 21:50:34 +0200
Message-Id: <1428090634-21126-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() was called with 0 instead of actual definition.

btrfs_finish_ordered_io() initialized compress_type with 0 as well.
(Thanks to David Sterba for suggesting this update).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

V2: also replace 0 in btrfs_finish_ordered_io()

 fs/btrfs/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5b6fbae..2f064d7 100644
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
@@ -2793,7 +2794,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
 	struct new_sa_defrag_extent *new = NULL;
-	int compress_type = 0;
+	int compress_type = BTRFS_COMPRESS_NONE;
 	int ret = 0;
 	u64 logical_len = ordered_extent->len;
 	bool nolock;
-- 
1.9.1

