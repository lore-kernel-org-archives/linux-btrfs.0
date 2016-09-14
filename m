Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:20256
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751433AbcINJBW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:01:22 -0400
Subject: [PATCH 3/3] block: Improve bio_set_op_attrs() robustness
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
Message-ID: <2a6c6cbd-ccc6-ee89-99ca-c0267cf17ec0@sandisk.com>
Date: Wed, 14 Sep 2016 10:46:22 +0200
MIME-Version: 1.0
In-Reply-To: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since REQ_OP_BITS == 3 and __REQ_NR_BITS == 30 it is not that hard
to pass an op_flags argument to bio_set_op_attrs() that is larger
than the number of bits reserved for the op_flags argument. Complain
if this happens. Additionally, ensure that negative arguments trigger
a complaint (1 << ... is signed while 1U << ... is unsigned; adding
0U to an integer expression causes it to be promoted to an unsigned
type).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>
---
 include/linux/blk_types.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 311fa2f..53ee1a2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -93,11 +93,18 @@ struct bio {
 #define bio_flags(bio)	((bio)->bi_opf & ((1 << BIO_OP_SHIFT) - 1))
 #define bio_op(bio)	((bio)->bi_opf >> BIO_OP_SHIFT)
 
-#define bio_set_op_attrs(bio, op, op_flags) do {		\
-	WARN_ON(op >= (1 << REQ_OP_BITS));			\
-	(bio)->bi_opf = bio_flags(bio);				\
-	(bio)->bi_opf |= ((unsigned int) (op) << BIO_OP_SHIFT);	\
-	(bio)->bi_opf |= op_flags;				\
+#define bio_set_op_attrs(bio, op, op_flags) do {			\
+	if (__builtin_constant_p(op))					\
+		BUILD_BUG_ON((op) + 0U >= (1U << REQ_OP_BITS));		\
+	else								\
+		WARN_ON_ONCE((op) + 0U >= (1U << REQ_OP_BITS));		\
+	if (__builtin_constant_p(op_flags))				\
+		BUILD_BUG_ON((op_flags) + 0U >= (1U << BIO_OP_SHIFT));	\
+	else								\
+		WARN_ON_ONCE((op_flags) + 0U >= (1U << BIO_OP_SHIFT));	\
+	(bio)->bi_opf = bio_flags(bio);					\
+	(bio)->bi_opf |= (((op) + 0U) << BIO_OP_SHIFT);			\
+	(bio)->bi_opf |= (op_flags);					\
 } while (0)
 
 #define BIO_RESET_BYTES		offsetof(struct bio, bi_max_vecs)
-- 
2.10.0

