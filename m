Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34587 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbcBOQim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 11:38:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 337B0203A9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 16:38:41 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 0BF1B2039E
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 16:38:39 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix direct IO requests not reporting IO error to user space
Date: Mon, 15 Feb 2016 16:38:36 +0000
Message-Id: <1455554316-1167-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If a bio for a direct IO request fails, we were not setting the error in
the parent bio (the main DIO bio), making us not return the error to
user space in btrfs_direct_IO(), that is, it made __blockdev_direct_IO()
return the number of bytes issued for IO and not the error a bio created
and submitted by btrfs_submit_direct() got from the block layer.
This essentially happens because when we call:

   dio_end_io(dio_bio, bio->bi_error);

It does not set dio_bio->bi_error to the value of the second argument.
So just add this missing assignment in endio callbacks, just as we do in
the error path at btrfs_submit_direct() when we fail to clone the dio bio
or allocate its private object.

This was detected by the new generic test cases in xfstests: 271, 272,
276 and 278. Which essentially setup a dm error target, then load the
error table, do a direct IO write and unload the error table. They
expect the write to fail with -EIO, which was not getting reported
when testing against btrfs.

Cc: stable@vger.kernel.org
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 600bf0d..e0ad8b2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7985,6 +7985,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 
 	kfree(dip);
 
+	dio_bio->bi_error = bio->bi_error;
 	dio_end_io(dio_bio, bio->bi_error);
 
 	if (io_bio->end_io)
@@ -8039,6 +8040,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 
 	kfree(dip);
 
+	dio_bio->bi_error = bio->bi_error;
 	dio_end_io(dio_bio, bio->bi_error);
 	bio_put(bio);
 }
-- 
2.7.0.rc3

