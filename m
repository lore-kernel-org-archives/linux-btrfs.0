Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40711 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1EJTzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2011 15:55:08 -0400
From: y@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 1/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
Date: Tue, 10 May 2011 22:57:27 +0300
Message-Id: <1305057449-12075-2-git-send-email-y>
In-Reply-To: <1305057449-12075-1-git-send-email-y>
References: <1305057449-12075-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Observed as a large delay when --mixed filesystem is filled up.
Test example:
1. create tiny --mixed FS:
   $ dd if=/dev/zero of=2G.img seek=$((2048 * 1024 * 1024 - 1)) count=1 bs=1
   $ mkfs.btrfs --mixed 2G.img
   $ mount -oloop 2G.img /mnt/ut/
2. Try to fill it up:
   $ dd if=/dev/urandom of=10M.file bs=10240 count=1024
   $ seq 1 256 | while read file_no; do echo $file_no; time cp 10M.file ${file_no}.copy; done

Up to '200.copy' it goes fast, but when disk fills-up each -ENOSPC
message takes 3 seconds to pop-up _every_ ENOSPC (and in usermode linux
it's even more: 30-60 seconds!). (Maybe, time depends on kernel's timer resolution).

No IO, no CPU load, just rescheduling. Some debugging revealed busy spinning
in shrink_delalloc.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ee6bd5..9f5fdd3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3425,6 +3425,10 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	if (reserved == 0)
 		return 0;
 
+	/* nothing to shrink - nothing to reclaim */
+	if (root->fs_info->delalloc_bytes == 0)
+		return 0;
+
 	max_reclaim = min(reserved, to_reclaim);
 
 	while (loops < 1024) {
-- 
1.7.3.4

