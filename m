Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBD9C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D8C20855
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5D8C20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbeKZNOS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:14:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbeKZNOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:14:17 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04C4930841DE;
        Mon, 26 Nov 2018 02:21:41 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45B8F1054FBA;
        Mon, 26 Nov 2018 02:21:29 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V12 20/20] block: kill BLK_MQ_F_SG_MERGE
Date:   Mon, 26 Nov 2018 10:17:20 +0800
Message-Id: <20181126021720.19471-21-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 26 Nov 2018 02:21:41 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

QUEUE_FLAG_NO_SG_MERGE has been killed, so kill BLK_MQ_F_SG_MERGE too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-debugfs.c       | 1 -
 drivers/block/loop.c         | 2 +-
 drivers/block/nbd.c          | 2 +-
 drivers/block/rbd.c          | 2 +-
 drivers/block/skd_main.c     | 1 -
 drivers/block/xen-blkfront.c | 2 +-
 drivers/md/dm-rq.c           | 2 +-
 drivers/mmc/core/queue.c     | 3 +--
 drivers/scsi/scsi_lib.c      | 2 +-
 include/linux/blk-mq.h       | 1 -
 10 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index d752fe4461af..a6ec055b54fa 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -249,7 +249,6 @@ static const char *const alloc_policy_name[] = {
 static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(SHOULD_MERGE),
 	HCTX_FLAG_NAME(TAG_SHARED),
-	HCTX_FLAG_NAME(SG_MERGE),
 	HCTX_FLAG_NAME(BLOCKING),
 	HCTX_FLAG_NAME(NO_SCHED),
 };
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e3683211f12d..4cf5486689de 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1906,7 +1906,7 @@ static int loop_add(struct loop_device **l, int i)
 	lo->tag_set.queue_depth = 128;
 	lo->tag_set.numa_node = NUMA_NO_NODE;
 	lo->tag_set.cmd_size = sizeof(struct loop_cmd);
-	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	lo->tag_set.driver_data = lo;
 
 	err = blk_mq_alloc_tag_set(&lo->tag_set);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 08696f5f00bb..999c94de78e5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1570,7 +1570,7 @@ static int nbd_dev_add(int index)
 	nbd->tag_set.numa_node = NUMA_NO_NODE;
 	nbd->tag_set.cmd_size = sizeof(struct nbd_cmd);
 	nbd->tag_set.flags = BLK_MQ_F_SHOULD_MERGE |
-		BLK_MQ_F_SG_MERGE | BLK_MQ_F_BLOCKING;
+		BLK_MQ_F_BLOCKING;
 	nbd->tag_set.driver_data = nbd;
 
 	err = blk_mq_alloc_tag_set(&nbd->tag_set);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 8e5140bbf241..3dfd300b5283 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3988,7 +3988,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	rbd_dev->tag_set.ops = &rbd_mq_ops;
 	rbd_dev->tag_set.queue_depth = rbd_dev->opts->queue_depth;
 	rbd_dev->tag_set.numa_node = NUMA_NO_NODE;
-	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	rbd_dev->tag_set.nr_hw_queues = 1;
 	rbd_dev->tag_set.cmd_size = sizeof(struct work_struct);
 
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index a10d5736d8f7..a7040f9a1b1b 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -2843,7 +2843,6 @@ static int skd_cons_disk(struct skd_device *skdev)
 		skdev->sgs_per_request * sizeof(struct scatterlist);
 	skdev->tag_set.numa_node = NUMA_NO_NODE;
 	skdev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE |
-		BLK_MQ_F_SG_MERGE |
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(BLK_TAG_ALLOC_FIFO);
 	skdev->tag_set.driver_data = skdev;
 	rc = blk_mq_alloc_tag_set(&skdev->tag_set);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 0ed4b200fa58..d43a5677ccbc 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -977,7 +977,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	} else
 		info->tag_set.queue_depth = BLK_RING_SIZE(info);
 	info->tag_set.numa_node = NUMA_NO_NODE;
-	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	info->tag_set.cmd_size = sizeof(struct blkif_req);
 	info->tag_set.driver_data = info;
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1f1fe9a618ea..afbac62a02a2 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -536,7 +536,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	md->tag_set->ops = &dm_mq_ops;
 	md->tag_set->queue_depth = dm_get_blk_mq_queue_depth();
 	md->tag_set->numa_node = md->numa_node_id;
-	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	md->tag_set->nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
 	md->tag_set->driver_data = md;
 
diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 35cc138b096d..cc19e71c71d4 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -410,8 +410,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card)
 	else
 		mq->tag_set.queue_depth = MMC_QUEUE_DEPTH;
 	mq->tag_set.numa_node = NUMA_NO_NODE;
-	mq->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE |
-			    BLK_MQ_F_BLOCKING;
+	mq->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING;
 	mq->tag_set.nr_hw_queues = 1;
 	mq->tag_set.cmd_size = sizeof(struct mmc_queue_req);
 	mq->tag_set.driver_data = mq;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 78d6d05992b0..f5ffb97352f7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1902,7 +1902,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	shost->tag_set.queue_depth = shost->can_queue;
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
-	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	shost->tag_set.flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	shost->tag_set.driver_data = shost;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 929e8abc5535..ca7389d7e04f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -211,7 +211,6 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_SHARED	= 1 << 1,
-	BLK_MQ_F_SG_MERGE	= 1 << 2,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.9.5

