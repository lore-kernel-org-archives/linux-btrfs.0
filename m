Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40352 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933923AbcKJUGL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 15:06:11 -0500
Date: Thu, 10 Nov 2016 23:04:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Ming Lei <ming.lei@canonical.com>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] block: precedence bug in bio_set_op_attrs() macro
Message-ID: <20161110200438.GA22854@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This code causes a problem for flush_epd_write_bio() because | has
higher precedence than ?: so it basically turns into:

	((bio)->bi_opf |= REQ_SYNC;

Which is wrong.

Fixes: ef295ecf090d ("block: better op and flags encoding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 562ac46..67fae32 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -208,7 +208,7 @@ enum req_flag_bits {
 
 /* obsolete, don't use in new code */
 #define bio_set_op_attrs(bio, op, op_flags) \
-	((bio)->bi_opf |= (op | op_flags))
+	((bio)->bi_opf |= ((op) | (op_flags)))
 
 static inline bool op_is_write(unsigned int op)
 {
