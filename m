Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59862 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3KEHWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 02:22:11 -0500
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] BTRFS: fixed a coding style issue
Date: Tue,  5 Nov 2013 09:21:54 +0200
Message-Id: <1383636115-5291-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line 31: Removed spaces before the semicolons.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/print-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 0088bed..19dd143 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -28,7 +28,7 @@ static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	       "num_stripes %d\n",
 	       btrfs_chunk_length(eb, chunk), btrfs_chunk_owner(eb, chunk),
 	       btrfs_chunk_type(eb, chunk), num_stripes);
-	for (i = 0 ; i < num_stripes ; i++) {
+	for (i = 0; i < num_stripes; i++) {
 		printk(KERN_INFO "\t\t\tstripe %d devid %llu offset %llu\n", i,
 		      btrfs_stripe_devid_nr(eb, chunk, i),
 		      btrfs_stripe_offset_nr(eb, chunk, i));
-- 
1.8.3.2

