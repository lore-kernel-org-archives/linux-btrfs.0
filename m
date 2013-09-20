Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3ITQmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 12:42:13 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 016B1A51FE
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 18:42:13 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: check if device supports trim
Date: Fri, 20 Sep 2013 18:42:07 +0200
Message-Id: <1379695327-30046-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The message about trim was printed unconditionally, we should check if
trim is supported at all.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index 5fa193b..6c74654 100644
--- a/utils.c
+++ b/utils.c
@@ -597,13 +597,16 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 
 	if (discard) {
-		fprintf(stderr, "Performing full device TRIM (%s) ...\n",
-				pretty_size(block_count));
 		/*
-		 * We intentionally ignore errors from the discard ioctl.  It is
-		 * not necessary for the mkfs functionality but just an optimization.
+		 * We intentionally ignore errors from the discard ioctl.  It
+		 * is not necessary for the mkfs functionality but just an
+		 * optimization.
 		 */
-		discard_blocks(fd, 0, block_count);
+		if (discard_blocks(fd, 0, 0) == 0) {
+			fprintf(stderr, "Performing full device TRIM (%s) ...\n",
+				pretty_size(block_count));
+			discard_blocks(fd, 0, block_count);
+		}
 	}
 
 	ret = zero_dev_start(fd);
-- 
1.8.3.1

