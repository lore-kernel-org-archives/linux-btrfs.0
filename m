Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43894 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdFCHiQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:38:16 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 02/13] scsi/osd: don't save block errors into req_results
Date: Sat,  3 Jun 2017 09:37:55 +0200
Message-Id: <20170603073806.2046-3-hch@lst.de>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
References: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We will only have sense data if the command executed and got a SCSI
result, so this is pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/osd/osd_initiator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 8a1b94816419..14785177ce7b 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -477,7 +477,7 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 			     int error)
 {
 	or->async_error = error;
-	or->req_errors = scsi_req(req)->result ? : error;
+	or->req_errors = scsi_req(req)->result;
 	or->sense_len = scsi_req(req)->sense_len;
 	if (or->sense_len)
 		memcpy(or->sense, scsi_req(req)->sense, or->sense_len);
-- 
2.11.0

