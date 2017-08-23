Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58951 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbdHWRKt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:10:49 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] block: add a __disk_get_part helper
Date: Wed, 23 Aug 2017 19:10:30 +0200
Message-Id: <20170823171032.30529-5-hch@lst.de>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
References: <20170823171032.30529-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This helper allows looking up a partion under RCU protection without
grabbing a reference to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h   |  2 ++
 block/genhd.c | 26 +++++++++++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 3a3d715bd725..fde8b351c166 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -204,6 +204,8 @@ static inline void elv_deactivate_rq(struct request_queue *q, struct request *rq
 		e->type->ops.sq.elevator_deactivate_req_fn(q, rq);
 }
 
+struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
+
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 int blk_should_fake_timeout(struct request_queue *);
 ssize_t part_timeout_show(struct device *, struct device_attribute *, char *);
diff --git a/block/genhd.c b/block/genhd.c
index 3380a1e73ea0..713b7d4fe7a1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -82,6 +82,15 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
 	}
 }
 
+struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
+{
+	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
+
+	if (unlikely(partno < 0 || partno >= ptbl->len))
+		return NULL;
+	return rcu_dereference(ptbl->part[partno]);
+}
+
 /**
  * disk_get_part - get partition
  * @disk: disk to look partition from
@@ -98,21 +107,12 @@ void part_in_flight(struct request_queue *q, struct hd_struct *part,
  */
 struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
 {
-	struct hd_struct *part = NULL;
-	struct disk_part_tbl *ptbl;
-
-	if (unlikely(partno < 0))
-		return NULL;
+	struct hd_struct *part;
 
 	rcu_read_lock();
-
-	ptbl = rcu_dereference(disk->part_tbl);
-	if (likely(partno < ptbl->len)) {
-		part = rcu_dereference(ptbl->part[partno]);
-		if (part)
-			get_device(part_to_dev(part));
-	}
-
+	part = __disk_get_part(disk, partno);
+	if (part)
+		get_device(part_to_dev(part));
 	rcu_read_unlock();
 
 	return part;
-- 
2.11.0

