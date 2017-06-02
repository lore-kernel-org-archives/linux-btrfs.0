Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54353 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbdFBIBn (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Jun 2017 04:01:43 -0400
From: Guoqing Jiang <gqjiang@suse.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] btrfs: simplify code with bio_io_error
Date: Fri,  2 Jun 2017 16:08:50 +0800
Message-Id: <20170602080850.5410-1-gqjiang@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bio_io_error was introduced in the commit 4246a0b
("block: add a bi_error field to struct bio"), so
use it to simplify code.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe93..57335f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8649,8 +8649,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	 * callbacks - they require an allocated dip and a clone of dio_bio.
 	 */
 	if (io_bio && dip) {
-		io_bio->bi_error = -EIO;
-		bio_endio(io_bio);
+		bio_io_error(io_bio);
 		/*
 		 * The end io callbacks free our dip, do the final put on io_bio
 		 * and all the cleanup and final put for dio_bio (through
-- 
2.10.0

