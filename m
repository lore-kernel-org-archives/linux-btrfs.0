Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932356AbdHWRKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:10:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] block: reject attempts to allocate more than DISK_MAX_PARTS partitions
Date: Wed, 23 Aug 2017 19:10:29 +0200
Message-Id: <20170823171032.30529-4-hch@lst.de>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
References: <20170823171032.30529-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 2367087cdb7c..3380a1e73ea0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1357,6 +1357,13 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 	struct gendisk *disk;
 	struct disk_part_tbl *ptbl;
 
+	if (minors > DISK_MAX_PARTS) {
+		printk(KERN_ERR
+			"block: can't allocated more than %d partitions\n",
+			DISK_MAX_PARTS);
+		minors = DISK_MAX_PARTS;
+	}
+
 	disk = kzalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
 	if (disk) {
 		if (!init_part_stats(&disk->part0)) {
-- 
2.11.0

