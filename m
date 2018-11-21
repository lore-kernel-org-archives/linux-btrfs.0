Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F00C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 13:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD63A2146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 13:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ickD2/8q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD63A2146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbeKVAdu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 19:33:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33558 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbeKVAdu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6qaC5ctqcfZNBAwQZjm5V92BRb3gZykib6ec9HxPraA=; b=ickD2/8qSrS47XudZ4e/h4cU5C
        YG1qAzin9ANbz1FwvanmwZ0LwFJlbX8+ziCG4fxnI5Min6D3n5R4RzMtsQUBWP3eul144aYb/1MDE
        veu/4HY/4Xxv8kdVGomK2/CY5j6KHll5WZKtkKEyN3fVq/E3QZ9SsO6uFTS6NVEQtzHQXmtEmmeRU
        xlRWoRW/398Y8uZD9c9uuCdQR+an9/1ABMp/fCn0WeJpLn6aAwkL3kMlQO5oqcJyUSMSj52lxUhHk
        dQ0DFwdrlN3b8E+BM5CMv3BJRAkOOGl0EHyxFmnLlHyvPs0fSmsCNHjMQrl0NTScVBdzj3/SSwcNY
        EkkmFOWg==;
Received: from 089144201193.atnat0010.highway.a1.net ([89.144.201.193] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPT2E-0006gq-2L; Wed, 21 Nov 2018 13:59:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        linux-block@vger.kernel.org
Subject: [PATCH 2/2] btrfs: look at bi_size for repair decisions
Date:   Wed, 21 Nov 2018 14:59:08 +0100
Message-Id: <20181121135908.4720-3-hch@lst.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181121135908.4720-1-hch@lst.de>
References: <20181121135908.4720-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

bio_readpage_error currently uses bi_vcnt to decide if it is worth
retrying an I/O.  But the vector count is mostly an implementation
artifact - it really should figure out if there is more than a
single sector worth retrying.  Use bi_size for that and shift by
PAGE_SHIFT.  This really should be blocks/sectors, but given that
btrfs doesn't support a sector size different from the PAGE_SIZE
using the page size keeps the changes to a minimum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 2 +-
 include/linux/bio.h  | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 15fd46582bb2..40751e86a2a9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2368,7 +2368,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	int read_mode = 0;
 	blk_status_t status;
 	int ret;
-	unsigned failed_bio_pages = bio_pages_all(failed_bio);
+	unsigned failed_bio_pages = failed_bio->bi_iter.bi_size >> PAGE_SHIFT;
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 056fb627edb3..6f6bc331a5d1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -263,12 +263,6 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 		bv->bv_len = iter.bi_bvec_done;
 }
 
-static inline unsigned bio_pages_all(struct bio *bio)
-{
-	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	return bio->bi_vcnt;
-}
-
 static inline struct bio_vec *bio_first_bvec_all(struct bio *bio)
 {
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-- 
2.19.1

