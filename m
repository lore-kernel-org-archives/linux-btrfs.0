Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sjc00mx1.hgst.com ([199.255.44.36]:52723 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcEINPU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 09:15:20 -0400
From: Scott Talbert <scott.talbert@hgst.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
Date: Mon, 9 May 2016 09:14:28 -0400
Message-ID: <1462799668-26910-1-git-send-email-scott.talbert@hgst.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A 'struct bio' is allocated in scrub_missing_raid56_pages(), but it was never
freed anywhere.

Signed-off-by: Scott Talbert <scott.talbert@hgst.com>
---
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 82bedf9..607cc6e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2130,6 +2130,8 @@ static void scrub_missing_raid56_end_io(struct bio *bio)
 	if (bio->bi_error)
 		sblock->no_io_error_seen = 0;
 
+	bio_put(bio);
+
 	btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
 }
 
-- 
1.9.1

