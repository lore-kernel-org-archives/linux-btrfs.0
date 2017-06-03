Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45401 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdFCHir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:38:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 12/13] blk-mq: switch ->queue_rq return value to blk_status_t
Date: Sat,  3 Jun 2017 09:38:05 +0200
Message-Id: <20170603073806.2046-13-hch@lst.de>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
References: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the same values for use for request completion errors as the return
value from ->queue_rq.  BLK_STS_RESOURCE is special cased to cause
a requeue, and all the others are completed as-is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    | 37 ++++++++++++++++------------------
 drivers/block/loop.c              |  6 +++---
 drivers/block/mtip32xx/mtip32xx.c | 17 ++++++++--------
 drivers/block/nbd.c               | 12 ++++-------
 drivers/block/null_blk.c          |  4 ++--
 drivers/block/rbd.c               |  4 ++--
 drivers/block/virtio_blk.c        | 10 +++++-----
 drivers/block/xen-blkfront.c      |  8 ++++----
 drivers/md/dm-rq.c                |  8 ++++----
 drivers/mtd/ubi/block.c           |  6 +++---
 drivers/nvme/host/core.c          | 14 ++++++-------
 drivers/nvme/host/fc.c            | 23 +++++++++++----------
 drivers/nvme/host/nvme.h          |  2 +-
 drivers/nvme/host/pci.c           | 42 +++++++++++++++++++--------------------
 drivers/nvme/host/rdma.c          | 26 +++++++++++++-----------
 drivers/nvme/target/loop.c        | 17 ++++++++--------
 drivers/scsi/scsi_lib.c           | 30 ++++++++++++++--------------
 include/linux/blk-mq.h            |  7 ++-----
 18 files changed, 131 insertions(+), 142 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index adcc1c0dce6e..7af78b1e9db9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -924,7 +924,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct request *rq;
-	int errors, queued, ret = BLK_MQ_RQ_QUEUE_OK;
+	int errors, queued;
 
 	if (list_empty(list))
 		return false;
@@ -935,6 +935,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 	errors = queued = 0;
 	do {
 		struct blk_mq_queue_data bd;
+		blk_status_t ret;
 
 		rq = list_first_entry(list, struct request, queuelist);
 		if (!blk_mq_get_driver_tag(rq, &hctx, false)) {
@@ -975,25 +976,20 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 		}
 
 		ret = q->mq_ops->queue_rq(hctx, &bd);
-		switch (ret) {
-		case BLK_MQ_RQ_QUEUE_OK:
-			queued++;
-			break;
-		case BLK_MQ_RQ_QUEUE_BUSY:
+		if (ret == BLK_STS_RESOURCE) {
 			blk_mq_put_driver_tag_hctx(hctx, rq);
 			list_add(&rq->queuelist, list);
 			__blk_mq_requeue_request(rq);
 			break;
-		default:
-			pr_err("blk-mq: bad return on queue: %d\n", ret);
-		case BLK_MQ_RQ_QUEUE_ERROR:
+		}
+
+		if (unlikely(ret != BLK_STS_OK)) {
 			errors++;
 			blk_mq_end_request(rq, BLK_STS_IOERR);
-			break;
+			continue;
 		}
 
-		if (ret == BLK_MQ_RQ_QUEUE_BUSY)
-			break;
+		queued++;
 	} while (!list_empty(list));
 
 	hctx->dispatched[queued_to_index(queued)]++;
@@ -1031,7 +1027,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 		 * - blk_mq_run_hw_queue() checks whether or not a queue has
 		 *   been stopped before rerunning a queue.
 		 * - Some but not all block drivers stop a queue before
-		 *   returning BLK_MQ_RQ_QUEUE_BUSY. Two exceptions are scsi-mq
+		 *   returning BLK_STS_RESOURCE. Two exceptions are scsi-mq
 		 *   and dm-rq.
 		 */
 		if (!blk_mq_sched_needs_restart(hctx) &&
@@ -1410,7 +1406,7 @@ static void __blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie,
 	};
 	struct blk_mq_hw_ctx *hctx;
 	blk_qc_t new_cookie;
-	int ret;
+	blk_status_t ret;
 
 	if (q->elevator)
 		goto insert;
@@ -1426,18 +1422,19 @@ static void __blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie,
 	 * would have done
 	 */
 	ret = q->mq_ops->queue_rq(hctx, &bd);
-	if (ret == BLK_MQ_RQ_QUEUE_OK) {
+	switch (ret) {
+	case BLK_STS_OK:
 		*cookie = new_cookie;
 		return;
-	}
-
-	if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
+	case BLK_STS_RESOURCE:
+		__blk_mq_requeue_request(rq);
+		goto insert;
+	default:
 		*cookie = BLK_QC_T_NONE;
-		blk_mq_end_request(rq, BLK_STS_IOERR);
+		blk_mq_end_request(rq, ret);
 		return;
 	}
 
-	__blk_mq_requeue_request(rq);
 insert:
 	blk_mq_sched_insert_request(rq, false, true, false, may_sleep);
 }
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 183597053ce5..6506412a6498 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1642,7 +1642,7 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
-static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
@@ -1651,7 +1651,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(bd->rq);
 
 	if (lo->lo_state != Lo_bound)
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 
 	switch (req_op(cmd->rq)) {
 	case REQ_OP_FLUSH:
@@ -1666,7 +1666,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	kthread_queue_work(&lo->worker, &cmd->work);
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ee6f66bb50c7..d8618a71da74 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3633,8 +3633,8 @@ static bool mtip_check_unal_depth(struct blk_mq_hw_ctx *hctx,
 	return false;
 }
 
-static int mtip_issue_reserved_cmd(struct blk_mq_hw_ctx *hctx,
-				   struct request *rq)
+static blk_status_t mtip_issue_reserved_cmd(struct blk_mq_hw_ctx *hctx,
+		struct request *rq)
 {
 	struct driver_data *dd = hctx->queue->queuedata;
 	struct mtip_int_cmd *icmd = rq->special;
@@ -3642,7 +3642,7 @@ static int mtip_issue_reserved_cmd(struct blk_mq_hw_ctx *hctx,
 	struct mtip_cmd_sg *command_sg;
 
 	if (mtip_commands_active(dd->port))
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 
 	/* Populate the SG list */
 	cmd->command_header->opts =
@@ -3666,10 +3666,10 @@ static int mtip_issue_reserved_cmd(struct blk_mq_hw_ctx *hctx,
 
 	blk_mq_start_request(rq);
 	mtip_issue_non_ncq_command(dd->port, rq->tag);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return 0;
 }
 
-static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t mtip_queue_rq(struct blk_mq_hw_ctx *hctx,
 			 const struct blk_mq_queue_data *bd)
 {
 	struct request *rq = bd->rq;
@@ -3681,15 +3681,14 @@ static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return mtip_issue_reserved_cmd(hctx, rq);
 
 	if (unlikely(mtip_check_unal_depth(hctx, rq)))
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 
 	blk_mq_start_request(rq);
 
 	ret = mtip_submit_request(hctx, rq);
 	if (likely(!ret))
-		return BLK_MQ_RQ_QUEUE_OK;
-
-	return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_OK;
+	return BLK_STS_IOERR;
 }
 
 static void mtip_free_cmd(struct blk_mq_tag_set *set, struct request *rq,
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b2e5c15fcb4d..966bab81bfdb 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -469,7 +469,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 				nsock->pending = req;
 				nsock->sent = sent;
 			}
-			return BLK_MQ_RQ_QUEUE_BUSY;
+			return BLK_STS_RESOURCE;
 		}
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
 			"Send control failed (result %d)\n", result);
@@ -510,7 +510,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 					 */
 					nsock->pending = req;
 					nsock->sent = sent;
-					return BLK_MQ_RQ_QUEUE_BUSY;
+					return BLK_STS_RESOURCE;
 				}
 				dev_err(disk_to_dev(nbd->disk),
 					"Send data failed (result %d)\n",
@@ -798,7 +798,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 	return ret;
 }
 
-static int nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 			const struct blk_mq_queue_data *bd)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
@@ -822,13 +822,9 @@ static int nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * appropriate.
 	 */
 	ret = nbd_handle_cmd(cmd, hctx->queue_num);
-	if (ret < 0)
-		ret = BLK_MQ_RQ_QUEUE_ERROR;
-	if (!ret)
-		ret = BLK_MQ_RQ_QUEUE_OK;
 	complete(&cmd->send_complete);
 
-	return ret;
+	return ret < 0 ? BLK_STS_IOERR : BLK_STS_OK;
 }
 
 static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index e6b81d370882..586dfff5d53f 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -356,7 +356,7 @@ static void null_request_fn(struct request_queue *q)
 	}
 }
 
-static int null_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 			 const struct blk_mq_queue_data *bd)
 {
 	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
@@ -373,7 +373,7 @@ static int null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(bd->rq);
 
 	null_handle_cmd(cmd);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3e8b43d792c2..74a6791b15c8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4154,14 +4154,14 @@ static void rbd_queue_workfn(struct work_struct *work)
 	blk_mq_end_request(rq, errno_to_blk_status(result));
 }
 
-static int rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct request *rq = bd->rq;
 	struct work_struct *work = blk_mq_rq_to_pdu(rq);
 
 	queue_work(rbd_wq, work);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static void rbd_free_disk(struct rbd_device *rbd_dev)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 205b74d70efc..e59bd4549a8a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -214,7 +214,7 @@ static void virtblk_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 }
 
-static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 			   const struct blk_mq_queue_data *bd)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
@@ -246,7 +246,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 	}
 
 	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
@@ -276,8 +276,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
-			return BLK_MQ_RQ_QUEUE_BUSY;
-		return BLK_MQ_RQ_QUEUE_ERROR;
+			return BLK_STS_RESOURCE;
+		return BLK_STS_IOERR;
 	}
 
 	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
@@ -286,7 +286,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (notify)
 		virtqueue_notify(vblk->vqs[qid].vq);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 /* return id (s/n) string for *disk to *id_str
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index aedc3c759273..2f468cf86dcf 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -881,7 +881,7 @@ static inline bool blkif_request_flush_invalid(struct request *req,
 		 !info->feature_fua));
 }
 
-static int blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 			  const struct blk_mq_queue_data *qd)
 {
 	unsigned long flags;
@@ -904,16 +904,16 @@ static int blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	flush_requests(rinfo);
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 
 out_err:
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
-	return BLK_MQ_RQ_QUEUE_ERROR;
+	return BLK_STS_IOERR;
 
 out_busy:
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 	blk_mq_stop_hw_queue(hctx);
-	return BLK_MQ_RQ_QUEUE_BUSY;
+	return BLK_STS_RESOURCE;
 }
 
 static void blkif_complete_rq(struct request *rq)
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bee334389173..63402f8a38de 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -727,7 +727,7 @@ static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return __dm_rq_init_rq(set->driver_data, rq);
 }
 
-static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 			  const struct blk_mq_queue_data *bd)
 {
 	struct request *rq = bd->rq;
@@ -744,7 +744,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	if (ti->type->busy && ti->type->busy(ti))
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 
 	dm_start_request(md, rq);
 
@@ -762,10 +762,10 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
 		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 	}
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static const struct blk_mq_ops dm_mq_ops = {
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 3ecdb39d1985..c3963f880448 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -316,7 +316,7 @@ static void ubiblock_do_work(struct work_struct *work)
 	blk_mq_end_request(req, errno_to_blk_status(ret));
 }
 
-static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
 			     const struct blk_mq_queue_data *bd)
 {
 	struct request *req = bd->rq;
@@ -327,9 +327,9 @@ static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_READ:
 		ubi_sgl_init(&pdu->usgl);
 		queue_work(dev->wq, &pdu->work);
-		return BLK_MQ_RQ_QUEUE_OK;
+		return BLK_STS_OK;
 	default:
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 	}
 
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 07e95c7d837a..4e193b93d1d9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -283,7 +283,7 @@ static inline void nvme_setup_flush(struct nvme_ns *ns,
 	cmnd->common.nsid = cpu_to_le32(ns->ns_id);
 }
 
-static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
+static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmnd)
 {
 	unsigned short segments = blk_rq_nr_discard_segments(req), n = 0;
@@ -292,7 +292,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	range = kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
 	if (!range)
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 
 	__rq_for_each_bio(bio, req) {
 		u64 slba = nvme_block_nr(ns, bio->bi_iter.bi_sector);
@@ -306,7 +306,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	if (WARN_ON_ONCE(n != segments)) {
 		kfree(range);
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 	}
 
 	memset(cmnd, 0, sizeof(*cmnd));
@@ -320,7 +320,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	req->special_vec.bv_len = sizeof(*range) * segments;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
@@ -364,10 +364,10 @@ static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 }
 
-int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
+blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmd)
 {
-	int ret = BLK_MQ_RQ_QUEUE_OK;
+	blk_status_t ret = BLK_STS_OK;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		nvme_req(req)->retries = 0;
@@ -394,7 +394,7 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 	}
 
 	cmd->common.command_id = req->tag;
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5b14cbefb724..eb0973ac9e17 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1873,7 +1873,7 @@ nvme_fc_unmap_data(struct nvme_fc_ctrl *ctrl, struct request *rq,
  * level FC exchange resource that is also outstanding. This must be
  * considered in all cleanup operations.
  */
-static int
+static blk_status_t
 nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	struct nvme_fc_fcp_op *op, u32 data_len,
 	enum nvmefc_fcp_datadir	io_dir)
@@ -1888,10 +1888,10 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	 * the target device is present
 	 */
 	if (ctrl->rport->remoteport.port_state != FC_OBJSTATE_ONLINE)
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 
 	if (!nvme_fc_ctrl_get(ctrl))
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 
 	/* format the FC-NVME CMD IU and fcp_req */
 	cmdiu->connection_id = cpu_to_be64(queue->connection_id);
@@ -1939,8 +1939,9 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 		if (ret < 0) {
 			nvme_cleanup_cmd(op->rq);
 			nvme_fc_ctrl_put(ctrl);
-			return (ret == -ENOMEM || ret == -EAGAIN) ?
-				BLK_MQ_RQ_QUEUE_BUSY : BLK_MQ_RQ_QUEUE_ERROR;
+			if (ret == -ENOMEM || ret == -EAGAIN)
+				return BLK_STS_RESOURCE;
+			return BLK_STS_IOERR;
 		}
 	}
 
@@ -1966,19 +1967,19 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 		nvme_fc_ctrl_put(ctrl);
 
 		if (ret != -EBUSY)
-			return BLK_MQ_RQ_QUEUE_ERROR;
+			return BLK_STS_IOERR;
 
 		if (op->rq) {
 			blk_mq_stop_hw_queues(op->rq->q);
 			blk_mq_delay_queue(queue->hctx, NVMEFC_QUEUE_DELAY);
 		}
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 	}
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
-static int
+static blk_status_t
 nvme_fc_queue_rq(struct blk_mq_hw_ctx *hctx,
 			const struct blk_mq_queue_data *bd)
 {
@@ -1991,7 +1992,7 @@ nvme_fc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_command *sqe = &cmdiu->sqe;
 	enum nvmefc_fcp_datadir	io_dir;
 	u32 data_len;
-	int ret;
+	blk_status_t ret;
 
 	ret = nvme_setup_cmd(ns, rq, sqe);
 	if (ret)
@@ -2046,7 +2047,7 @@ nvme_fc_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
 	struct nvme_fc_fcp_op *aen_op;
 	unsigned long flags;
 	bool terminating = false;
-	int ret;
+	blk_status_t ret;
 
 	if (aer_idx > NVME_FC_NR_AEN_COMMANDS)
 		return;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9d6a070d4391..22ee60b2a3e8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -296,7 +296,7 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl);
 #define NVME_QID_ANY -1
 struct request *nvme_alloc_request(struct request_queue *q,
 		struct nvme_command *cmd, unsigned int flags, int qid);
-int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
+blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmd);
 int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 819898428763..430d085af31c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -427,7 +427,7 @@ static __le64 **iod_list(struct request *req)
 	return (__le64 **)(iod->sg + blk_rq_nr_phys_segments(req));
 }
 
-static int nvme_init_iod(struct request *rq, struct nvme_dev *dev)
+static blk_status_t nvme_init_iod(struct request *rq, struct nvme_dev *dev)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(rq);
 	int nseg = blk_rq_nr_phys_segments(rq);
@@ -436,7 +436,7 @@ static int nvme_init_iod(struct request *rq, struct nvme_dev *dev)
 	if (nseg > NVME_INT_PAGES || size > NVME_INT_BYTES(dev)) {
 		iod->sg = kmalloc(nvme_iod_alloc_size(dev, size, nseg), GFP_ATOMIC);
 		if (!iod->sg)
-			return BLK_MQ_RQ_QUEUE_BUSY;
+			return BLK_STS_RESOURCE;
 	} else {
 		iod->sg = iod->inline_sg;
 	}
@@ -446,7 +446,7 @@ static int nvme_init_iod(struct request *rq, struct nvme_dev *dev)
 	iod->nents = 0;
 	iod->length = size;
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static void nvme_free_iod(struct nvme_dev *dev, struct request *req)
@@ -616,21 +616,21 @@ static bool nvme_setup_prps(struct nvme_dev *dev, struct request *req)
 	return true;
 }
 
-static int nvme_map_data(struct nvme_dev *dev, struct request *req,
+static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct request_queue *q = req->q;
 	enum dma_data_direction dma_dir = rq_data_dir(req) ?
 			DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	int ret = BLK_MQ_RQ_QUEUE_ERROR;
+	blk_status_t ret = BLK_STS_IOERR;
 
 	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
 	iod->nents = blk_rq_map_sg(q, req, iod->sg);
 	if (!iod->nents)
 		goto out;
 
-	ret = BLK_MQ_RQ_QUEUE_BUSY;
+	ret = BLK_STS_RESOURCE;
 	if (!dma_map_sg_attrs(dev->dev, iod->sg, iod->nents, dma_dir,
 				DMA_ATTR_NO_WARN))
 		goto out;
@@ -638,7 +638,7 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 	if (!nvme_setup_prps(dev, req))
 		goto out_unmap;
 
-	ret = BLK_MQ_RQ_QUEUE_ERROR;
+	ret = BLK_STS_IOERR;
 	if (blk_integrity_rq(req)) {
 		if (blk_rq_count_integrity_sg(q, req->bio) != 1)
 			goto out_unmap;
@@ -658,7 +658,7 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 	cmnd->rw.dptr.prp2 = cpu_to_le64(iod->first_dma);
 	if (blk_integrity_rq(req))
 		cmnd->rw.metadata = cpu_to_le64(sg_dma_address(&iod->meta_sg));
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 
 out_unmap:
 	dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
@@ -688,7 +688,7 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 /*
  * NOTE: ns is NULL when called on the admin queue.
  */
-static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 			 const struct blk_mq_queue_data *bd)
 {
 	struct nvme_ns *ns = hctx->queue->queuedata;
@@ -696,7 +696,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *req = bd->rq;
 	struct nvme_command cmnd;
-	int ret = BLK_MQ_RQ_QUEUE_OK;
+	blk_status_t ret = BLK_STS_OK;
 
 	/*
 	 * If formated with metadata, require the block layer provide a buffer
@@ -705,38 +705,36 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 */
 	if (ns && ns->ms && !blk_integrity_rq(req)) {
 		if (!(ns->pi_type && ns->ms == 8) &&
-		    !blk_rq_is_passthrough(req)) {
-			blk_mq_end_request(req, BLK_STS_NOTSUPP);
-			return BLK_MQ_RQ_QUEUE_OK;
-		}
+		    !blk_rq_is_passthrough(req))
+			return BLK_STS_NOTSUPP;
 	}
 
 	ret = nvme_setup_cmd(ns, req, &cmnd);
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
+	if (ret)
 		return ret;
 
 	ret = nvme_init_iod(req, dev);
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
+	if (ret)
 		goto out_free_cmd;
 
-	if (blk_rq_nr_phys_segments(req))
+	if (blk_rq_nr_phys_segments(req)) {
 		ret = nvme_map_data(dev, req, &cmnd);
-
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
-		goto out_cleanup_iod;
+		if (ret)
+			goto out_cleanup_iod;
+	}
 
 	blk_mq_start_request(req);
 
 	spin_lock_irq(&nvmeq->q_lock);
 	if (unlikely(nvmeq->cq_vector < 0)) {
-		ret = BLK_MQ_RQ_QUEUE_ERROR;
+		ret = BLK_STS_IOERR;
 		spin_unlock_irq(&nvmeq->q_lock);
 		goto out_cleanup_iod;
 	}
 	__nvme_submit_cmd(nvmeq, &cmnd);
 	nvme_process_cq(nvmeq);
 	spin_unlock_irq(&nvmeq->q_lock);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 out_cleanup_iod:
 	nvme_free_iod(dev, req);
 out_free_cmd:
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 28bd255c144d..58d311e704e5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1448,7 +1448,7 @@ static inline bool nvme_rdma_queue_is_ready(struct nvme_rdma_queue *queue,
 	return true;
 }
 
-static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct nvme_ns *ns = hctx->queue->queuedata;
@@ -1459,27 +1459,28 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_command *c = sqe->data;
 	bool flush = false;
 	struct ib_device *dev;
-	int ret;
+	blk_status_t ret;
+	int err;
 
 	WARN_ON_ONCE(rq->tag < 0);
 
 	if (!nvme_rdma_queue_is_ready(queue, rq))
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 
 	dev = queue->device->dev;
 	ib_dma_sync_single_for_cpu(dev, sqe->dma,
 			sizeof(struct nvme_command), DMA_TO_DEVICE);
 
 	ret = nvme_setup_cmd(ns, rq, c);
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
+	if (ret)
 		return ret;
 
 	blk_mq_start_request(rq);
 
-	ret = nvme_rdma_map_data(queue, rq, c);
-	if (ret < 0) {
+	err = nvme_rdma_map_data(queue, rq, c);
+	if (err < 0) {
 		dev_err(queue->ctrl->ctrl.device,
-			     "Failed to map data (%d)\n", ret);
+			     "Failed to map data (%d)\n", err);
 		nvme_cleanup_cmd(rq);
 		goto err;
 	}
@@ -1489,17 +1490,18 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (req_op(rq) == REQ_OP_FLUSH)
 		flush = true;
-	ret = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
+	err = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
 			req->mr->need_inval ? &req->reg_wr.wr : NULL, flush);
-	if (ret) {
+	if (err) {
 		nvme_rdma_unmap_data(queue, rq);
 		goto err;
 	}
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 err:
-	return (ret == -ENOMEM || ret == -EAGAIN) ?
-		BLK_MQ_RQ_QUEUE_BUSY : BLK_MQ_RQ_QUEUE_ERROR;
+	if (err == -ENOMEM || err == -EAGAIN)
+		return BLK_STS_RESOURCE;
+	return BLK_STS_IOERR;
 }
 
 static int nvme_rdma_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index e503cfff0337..db8ebadf885b 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -159,17 +159,17 @@ nvme_loop_timeout(struct request *rq, bool reserved)
 	return BLK_EH_HANDLED;
 }
 
-static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct nvme_ns *ns = hctx->queue->queuedata;
 	struct nvme_loop_queue *queue = hctx->driver_data;
 	struct request *req = bd->rq;
 	struct nvme_loop_iod *iod = blk_mq_rq_to_pdu(req);
-	int ret;
+	blk_status_t ret;
 
 	ret = nvme_setup_cmd(ns, req, &iod->cmd);
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
+	if (ret)
 		return ret;
 
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
@@ -179,16 +179,15 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		nvme_cleanup_cmd(req);
 		blk_mq_start_request(req);
 		nvme_loop_queue_response(&iod->req);
-		return BLK_MQ_RQ_QUEUE_OK;
+		return BLK_STS_OK;
 	}
 
 	if (blk_rq_bytes(req)) {
 		iod->sg_table.sgl = iod->first_sgl;
-		ret = sg_alloc_table_chained(&iod->sg_table,
+		if (sg_alloc_table_chained(&iod->sg_table,
 				blk_rq_nr_phys_segments(req),
-				iod->sg_table.sgl);
-		if (ret)
-			return BLK_MQ_RQ_QUEUE_BUSY;
+				iod->sg_table.sgl))
+			return BLK_STS_RESOURCE;
 
 		iod->req.sg = iod->sg_table.sgl;
 		iod->req.sg_cnt = blk_rq_map_sg(req->q, req, iod->sg_table.sgl);
@@ -197,7 +196,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(req);
 
 	schedule_work(&iod->work);
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 }
 
 static void nvme_loop_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 67a67191520f..b5f310b9e910 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1812,15 +1812,15 @@ static void scsi_request_fn(struct request_queue *q)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
-static inline int prep_to_mq(int ret)
+static inline blk_status_t prep_to_mq(int ret)
 {
 	switch (ret) {
 	case BLKPREP_OK:
-		return BLK_MQ_RQ_QUEUE_OK;
+		return BLK_STS_OK;
 	case BLKPREP_DEFER:
-		return BLK_MQ_RQ_QUEUE_BUSY;
+		return BLK_STS_RESOURCE;
 	default:
-		return BLK_MQ_RQ_QUEUE_ERROR;
+		return BLK_STS_IOERR;
 	}
 }
 
@@ -1892,7 +1892,7 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	blk_mq_complete_request(cmd->request);
 }
 
-static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
+static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			 const struct blk_mq_queue_data *bd)
 {
 	struct request *req = bd->rq;
@@ -1900,14 +1900,14 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-	int ret;
+	blk_status_t ret;
 	int reason;
 
 	ret = prep_to_mq(scsi_prep_state_check(sdev, req));
-	if (ret != BLK_MQ_RQ_QUEUE_OK)
+	if (ret != BLK_STS_OK)
 		goto out;
 
-	ret = BLK_MQ_RQ_QUEUE_BUSY;
+	ret = BLK_STS_RESOURCE;
 	if (!get_device(&sdev->sdev_gendev))
 		goto out;
 
@@ -1920,7 +1920,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
-		if (ret != BLK_MQ_RQ_QUEUE_OK)
+		if (ret != BLK_STS_OK)
 			goto out_dec_host_busy;
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
@@ -1938,11 +1938,11 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
-		ret = BLK_MQ_RQ_QUEUE_BUSY;
+		ret = BLK_STS_RESOURCE;
 		goto out_dec_host_busy;
 	}
 
-	return BLK_MQ_RQ_QUEUE_OK;
+	return BLK_STS_OK;
 
 out_dec_host_busy:
 	atomic_dec(&shost->host_busy);
@@ -1955,12 +1955,14 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	put_device(&sdev->sdev_gendev);
 out:
 	switch (ret) {
-	case BLK_MQ_RQ_QUEUE_BUSY:
+	case BLK_STS_OK:
+		break;
+	case BLK_STS_RESOURCE:
 		if (atomic_read(&sdev->device_busy) == 0 &&
 		    !scsi_device_blocked(sdev))
 			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 		break;
-	case BLK_MQ_RQ_QUEUE_ERROR:
+	default:
 		/*
 		 * Make sure to release all allocated ressources when
 		 * we hit an error, as we will never see this command
@@ -1969,8 +1971,6 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
 		break;
-	default:
-		break;
 	}
 	return ret;
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0cf6735046d3..b144b7b0e104 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -87,7 +87,8 @@ struct blk_mq_queue_data {
 	bool last;
 };
 
-typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, const struct blk_mq_queue_data *);
+typedef blk_status_t (queue_rq_fn)(struct blk_mq_hw_ctx *,
+		const struct blk_mq_queue_data *);
 typedef enum blk_eh_timer_return (timeout_fn)(struct request *, bool);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
@@ -155,10 +156,6 @@ struct blk_mq_ops {
 };
 
 enum {
-	BLK_MQ_RQ_QUEUE_OK	= 0,	/* queued fine */
-	BLK_MQ_RQ_QUEUE_BUSY	= 1,	/* requeue IO for later */
-	BLK_MQ_RQ_QUEUE_ERROR	= 2,	/* end IO with error */
-
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_SHARED	= 1 << 1,
 	BLK_MQ_F_SG_MERGE	= 1 << 2,
-- 
2.11.0

