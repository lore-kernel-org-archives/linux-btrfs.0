Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49385 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdFCHiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:38:13 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 01/13] nvme-lightnvm: use blk_execute_rq in nvme_nvm_submit_user_cmd
Date: Sat,  3 Jun 2017 09:37:54 +0200
Message-Id: <20170603073806.2046-2-hch@lst.de>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
References: <20170603073806.2046-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of reinventing it poorly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
Reviewed-by: Javier González <javier@cnexlabs.com>
---
 drivers/nvme/host/lightnvm.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index f5df78ed1e10..f3885b5e56bd 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -571,13 +571,6 @@ static struct nvm_dev_ops nvme_nvm_dev_ops = {
 	.max_phys_sect		= 64,
 };
 
-static void nvme_nvm_end_user_vio(struct request *rq, int error)
-{
-	struct completion *waiting = rq->end_io_data;
-
-	complete(waiting);
-}
-
 static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 				struct nvme_ns *ns,
 				struct nvme_nvm_command *vcmd,
@@ -608,7 +601,6 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 	rq->timeout = timeout ? timeout : ADMIN_TIMEOUT;
 
 	rq->cmd_flags &= ~REQ_FAILFAST_DRIVER;
-	rq->end_io_data = &wait;
 
 	if (ppa_buf && ppa_len) {
 		ppa_list = dma_pool_alloc(dev->dma_pool, GFP_KERNEL, &ppa_dma);
@@ -662,9 +654,7 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 	}
 
 submit:
-	blk_execute_rq_nowait(q, NULL, rq, 0, nvme_nvm_end_user_vio);
-
-	wait_for_completion_io(&wait);
+	blk_execute_rq(q, NULL, rq, 0);
 
 	if (nvme_req(rq)->flags & NVME_REQ_CANCELLED)
 		ret = -EINTR;
-- 
2.11.0

