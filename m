Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48075 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967663AbdEZI4e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 04:56:34 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 02/13] scsi/osd: don't save block errors into req_results
Date: Fri, 26 May 2017 11:56:09 +0300
Message-Id: <20170526085620.3113-3-hch@lst.de>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We will only have sense data if the command exectured and got a SCSI
result, so this is pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

