Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59398 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3KAAqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 20:46:07 -0400
Received: by mail-pa0-f44.google.com with SMTP id fb1so3300079pad.31
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 17:46:06 -0700 (PDT)
Received: from himangi-Inspiron-N5110 ([14.139.82.6])
        by mx.google.com with ESMTPSA id pu5sm8598122pac.21.2013.10.31.17.46.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 31 Oct 2013 17:46:05 -0700 (PDT)
Date: Fri, 1 Nov 2013 06:16:00 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs:check-integrity.c: replace kmalloc with kmalloc_array
Message-ID: <20131101004559.GA3258@himangi-Inspiron-N5110gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch replaces kmalloc(size * nr, ) with kmalloc_array(nr, size)
as kmalloc_array() is preferred because it can check that the
calculation doesn't wrap and won't return a smaller allocation.

Reviewed-by: Zach Brown <zab@redhat.com>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 fs/btrfs/check-integrity.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1c47be1..d61ffef 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -3031,8 +3031,9 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			       (unsigned long long)bio->bi_sector, dev_bytenr,
 			       bio->bi_bdev);
 
-		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
-				       GFP_NOFS);
+		mapped_datav = kmalloc_array(bio->bi_vcnt,
+					     sizeof(*mapped_datav),
+					     GFP_NOFS);
 		if (!mapped_datav)
 			goto leave;
 		for (i = 0; i < bio->bi_vcnt; i++) {
-- 
1.7.9.5

