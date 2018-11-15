Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36D9C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 08:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A38842077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 08:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A38842077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbeKOTBf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 14:01:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbeKOTBf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 14:01:35 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C14ABDE1;
        Thu, 15 Nov 2018 08:54:41 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C235C1019638;
        Thu, 15 Nov 2018 08:54:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ming Lei <ming.lei@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH V10 05/19] block: introduce bvec_last_segment()
Date:   Thu, 15 Nov 2018 16:52:52 +0800
Message-Id: <20181115085306.9910-6-ming.lei@redhat.com>
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 15 Nov 2018 08:54:41 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

BTRFS and guard_bio_eod() need to get the last singlepage segment
from one multipage bvec, so introduce this helper to make them happy.

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org
Cc: Boaz Harrosh <ooo@electrozaur.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 3d61352cd8cf..01616a0b6220 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -216,4 +216,29 @@ static inline bool mp_bvec_iter_advance(const struct bio_vec *bv,
 	.bi_bvec_done	= 0,						\
 }
 
+/*
+ * Get the last singlepage segment from the multipage bvec and store it
+ * in @seg
+ */
+static inline void bvec_last_segment(const struct bio_vec *bvec,
+		struct bio_vec *seg)
+{
+	unsigned total = bvec->bv_offset + bvec->bv_len;
+	unsigned last_page = total / PAGE_SIZE;
+
+	if (last_page * PAGE_SIZE == total)
+		last_page--;
+
+	seg->bv_page = nth_page(bvec->bv_page, last_page);
+
+	/* the whole segment is inside the last page */
+	if (bvec->bv_offset >= last_page * PAGE_SIZE) {
+		seg->bv_offset = bvec->bv_offset % PAGE_SIZE;
+		seg->bv_len = bvec->bv_len;
+	} else {
+		seg->bv_offset = 0;
+		seg->bv_len = total - last_page * PAGE_SIZE;
+	}
+}
+
 #endif /* __LINUX_BVEC_ITER_H */
-- 
2.9.5

