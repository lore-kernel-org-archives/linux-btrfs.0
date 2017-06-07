Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33315 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdFGBAJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:09 -0400
Received: by mail-wr0-f193.google.com with SMTP id v104so11594230wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 7/7] Btrfs: end_workqueue_bio use switch case instead of else if
Date: Wed,  7 Jun 2017 03:58:44 +0300
Message-Id: <20170607005844.2078-8-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If arg to "switch case" is determined and it's a consecutive numbers
(This is enum btrfs_wq_endio_type)
Compiler can create jump table to optimize logic

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/disk-io.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d6718..72208826d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -802,18 +802,27 @@ static void end_workqueue_bio(struct bio *bio)
 	end_io_wq->error = bio->bi_error;

 	if (bio_op(bio) == REQ_OP_WRITE) {
-		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
+		switch (end_io_wq->metadata) {
+		case BTRFS_WQ_ENDIO_DATA:
+			wq = fs_info->endio_write_workers;
+			func = btrfs_endio_write_helper;
+			break;
+		case BTRFS_WQ_ENDIO_METADATA:
 			wq = fs_info->endio_meta_write_workers;
 			func = btrfs_endio_meta_write_helper;
-		} else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE) {
+			break;
+		case BTRFS_WQ_ENDIO_FREE_SPACE:
 			wq = fs_info->endio_freespace_worker;
 			func = btrfs_freespace_write_helper;
-		} else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56) {
+			break;
+		case BTRFS_WQ_ENDIO_RAID56:
 			wq = fs_info->endio_raid56_workers;
 			func = btrfs_endio_raid56_helper;
-		} else {
+			break;
+		case BTRFS_WQ_ENDIO_DIO_REPAIR:
 			wq = fs_info->endio_write_workers;
 			func = btrfs_endio_write_helper;
+			break;
 		}
 	} else {
 		if (unlikely(end_io_wq->metadata ==
--
2.13.0
