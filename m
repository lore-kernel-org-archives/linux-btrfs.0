Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbcBPMT6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 07:19:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BAFFB2025A
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 12:19:57 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id A0C582025B
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 12:19:56 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix direct IO requests not reporting IO error to user space
Date: Tue, 16 Feb 2016 04:01:44 +0000
Message-Id: <1455595304-29320-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1455554316-1167-1-git-send-email-fdmanana@kernel.org>
References: <1455554316-1167-1-git-send-email-fdmanana@kernel.org>
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
or allocate its private object. This follows the convention of what is
done with other similar APIs such as bio_endio() where the caller is
responsible for setting the bi_error field in the bio it passes as an
argument to bio_endio().

This was detected by the new generic test cases in xfstests: 271, 272,
276 and 278. Which essentially setup a dm error target, then load the
error table, do a direct IO write and unload the error table. They
expect the write to fail with -EIO, which was not getting reported
when testing against btrfs.

Cc: stable@vger.kernel.org  # 4.3+
Fixes: 4246a0b63bd8 ("block: add a bi_error field to struct bio")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated commit message to reflect affected kernel versions.

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

