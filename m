Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43033 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeH1DwZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id j26-v6so319089pfi.10
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:31 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [RFC PATCH v2 2/6] ext4: use iocb->private instead of bh->b_private
Date: Mon, 27 Aug 2018 17:03:15 -0700
Message-Id: <344cfe9b7dfc03ccfde2bf28c1ac74ec887cdc0d.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

As part of simplifying all of the private data passed around for direct
I/O, bh->b_private will no longer be passed to dio_iodone_t. iocb is
still available there, however, so convert ext4 to use it. Note that
ext4_file_write_iter() also uses iocb->private, but
ext4_direct_IO_write() resets it to NULL after reading it.

Also note that the comment above ext4_should_dioread_nolock() is no
longer accurate. It seems that it should be possible to remove the data
journaling restriction now?

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/ext4/inode.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18ad91b1c8f6..841d79919cef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -884,18 +884,16 @@ static int ext4_dio_get_block_unwritten_async(struct kiocb *iocb,
 	/*
 	 * When doing DIO using unwritten extents, we need io_end to convert
 	 * unwritten extents to written on IO completion. We allocate io_end
-	 * once we spot unwritten extent and store it in b_private. Generic
-	 * DIO code keeps b_private set and furthermore passes the value to
-	 * our completion callback in 'private' argument.
+	 * once we spot unwritten extent and store it in iocb->private.
 	 */
 	if (!ret && buffer_unwritten(bh_result)) {
-		if (!bh_result->b_private) {
+		if (!iocb->private) {
 			ext4_io_end_t *io_end;
 
 			io_end = ext4_init_io_end(inode, GFP_KERNEL);
 			if (!io_end)
 				return -ENOMEM;
-			bh_result->b_private = io_end;
+			iocb->private = io_end;
 			ext4_set_io_unwritten_flag(inode, io_end);
 		}
 		set_buffer_defer_completion(bh_result);
@@ -3617,7 +3615,7 @@ const struct iomap_ops ext4_iomap_ops = {
 static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private)
 {
-        ext4_io_end_t *io_end = private;
+        ext4_io_end_t *io_end = iocb->private;
 
 	/* if not async direct IO just return */
 	if (!io_end)
-- 
2.18.0
