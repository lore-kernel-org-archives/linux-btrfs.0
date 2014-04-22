Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:7589 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaDVNab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 09:30:31 -0400
Date: Tue, 22 Apr 2014 16:30:27 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix check to test trim support
Message-ID: <20140422133025.GA13578@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was added in 25d82d22 but broke recently in 4724d7b0 while making
discard interruptible.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 0bfb9d9..068b4f3 100644
--- a/utils.c
+++ b/utils.c
@@ -629,7 +629,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		 * is not necessary for the mkfs functionality but just an
 		 * optimization.
 		 */
-		if (discard_blocks(fd, 0, 0) == 0) {
+		if (discard_range(fd, 0, 0) == 0) {
 			fprintf(stderr, "Performing full device TRIM (%s) ...\n",
 				pretty_size(block_count));
 			discard_blocks(fd, 0, block_count);
-- 
1.8.5.3

