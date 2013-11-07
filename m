Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:64059 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3KGLOt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 06:14:49 -0500
Received: by mail-we0-f172.google.com with SMTP id q58so361302wes.17
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 03:14:48 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: don't wait for ordered data outside desired range
Date: Thu,  7 Nov 2013 11:13:31 +0000
Message-Id: <1383822811-13145-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1383750760-25246-1-git-send-email-fdmanana@gmail.com>
References: <1383750760-25246-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_wait_ordered_range(), if we found an extent to the left
of the start of our desired wait range and the last byte of that
extent is 1 less than the desired range's start, we would would
wait for the IO completion of that extent and all other extents
to the left of that extent, unnecessarily.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated commit message.

 fs/btrfs/ordered-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 25a8f38..c37124b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -803,7 +803,7 @@ int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 			btrfs_put_ordered_extent(ordered);
 			break;
 		}
-		if (ordered->file_offset + ordered->len < start) {
+		if (ordered->file_offset + ordered->len <= start) {
 			btrfs_put_ordered_extent(ordered);
 			break;
 		}
-- 
1.7.9.5

