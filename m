Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35715 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054AbbFCTeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 15:34:17 -0400
Received: by qgg60 with SMTP id 60so8492962qgg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2015 12:34:16 -0700 (PDT)
From: jmaggard10@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH][RFC] Btrfs: Treat -EDQUOT like -ENOSPC during unlink
Date: Wed,  3 Jun 2015 12:34:04 -0700
Message-Id: <1433360044-9689-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Justin Maggard <jmaggard10@gmail.com>

Error messages saying, basically, "you don't have enough
free space to free up space" make people angry.

Sure, there are workarounds like truncating a file before
removing it; but it's certainly not obvious.  Unlink has a
special case if we cannot make our reservations the normal
way to try and see if there is enough slack room in the
global reserve to migrate.  Use the same retry for -EDQUOT.

There are certainly other (probably more proper) ways to
address this, but this is the least intrusive way that I
could think of.
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 742f65d..d247c2d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4000,10 +4000,10 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 	 * 1 for the inode
 	 */
 	trans = btrfs_start_transaction(root, 5);
-	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
+	if (!IS_ERR(trans) || (PTR_ERR(trans) != -ENOSPC && PTR_ERR(trans) != -EDQUOT))
 		return trans;
 
-	if (PTR_ERR(trans) == -ENOSPC) {
+	if (PTR_ERR(trans) == -ENOSPC || PTR_ERR(trans) == -EDQUOT) {
 		u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
 
 		trans = btrfs_start_transaction(root, 0);
-- 
2.4.2

