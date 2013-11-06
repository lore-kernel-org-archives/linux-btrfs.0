Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62987 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3KFPNB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 10:13:01 -0500
Received: by mail-wi0-f180.google.com with SMTP id ey11so3844627wid.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 07:13:00 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't wait for ordered data outside desired range
Date: Wed,  6 Nov 2013 15:12:40 +0000
Message-Id: <1383750760-25246-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_wait_ordered_range(), if we found an extent to the left
of the start of our desired wait range and the last byte of that
extent is 1 less than the desired range's start, we would would
wait for the IO completion of that extent unnecessarily.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
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

