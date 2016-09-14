Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:44975
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750746AbcINJAy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:00:54 -0400
Subject: [PATCH 1/3] block: Document that bio_op() uses the data type of
 bio.bi_opf
To: Jens Axboe <axboe@fb.com>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
CC: Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <5e51ae40-994c-1f83-0575-6505662fb138@sandisk.com>
Date: Wed, 14 Sep 2016 10:44:12 +0200
MIME-Version: 1.0
In-Reply-To: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make it clear that the sizeof(unsigned int) expression in BIO_OP_SHIFT
refers to the bi_opf member of struct bio.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>
---
 include/linux/blk_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 436f43f..1e1ef21 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -89,7 +89,7 @@ struct bio {
 	struct bio_vec		bi_inline_vecs[0];
 };
 
-#define BIO_OP_SHIFT	(8 * sizeof(unsigned int) - REQ_OP_BITS)
+#define BIO_OP_SHIFT	(8 * FIELD_SIZEOF(struct bio, bi_opf) - REQ_OP_BITS)
 #define bio_op(bio)	((bio)->bi_opf >> BIO_OP_SHIFT)
 
 #define bio_set_op_attrs(bio, op, op_flags) do {		\
-- 
2.10.0

