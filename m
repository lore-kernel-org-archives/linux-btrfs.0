Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BA6C43610
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A44B20865
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:18:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A44B20865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbeKZNLM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:11:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbeKZNLM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:11:12 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 982B789AC5;
        Mon, 26 Nov 2018 02:18:36 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA9725C1B2;
        Mon, 26 Nov 2018 02:18:18 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V12 05/20] block: remove bvec_iter_rewind()
Date:   Mon, 26 Nov 2018 10:17:05 +0800
Message-Id: <20181126021720.19471-6-ming.lei@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 26 Nov 2018 02:18:36 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 7759eb23fd980 ("block: remove bio_rewind_iter()") removes
bio_rewind_iter(), then no one uses bvec_iter_rewind() any more,
so remove it.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 02c73c6aa805..ba0ae40e77c9 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -92,30 +92,6 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	return true;
 }
 
-static inline bool bvec_iter_rewind(const struct bio_vec *bv,
-				     struct bvec_iter *iter,
-				     unsigned int bytes)
-{
-	while (bytes) {
-		unsigned len = min(bytes, iter->bi_bvec_done);
-
-		if (iter->bi_bvec_done == 0) {
-			if (WARN_ONCE(iter->bi_idx == 0,
-				      "Attempted to rewind iter beyond "
-				      "bvec's boundaries\n")) {
-				return false;
-			}
-			iter->bi_idx--;
-			iter->bi_bvec_done = __bvec_iter_bvec(bv, *iter)->bv_len;
-			continue;
-		}
-		bytes -= len;
-		iter->bi_size += len;
-		iter->bi_bvec_done -= len;
-	}
-	return true;
-}
-
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
 	for (iter = (start);						\
 	     (iter).bi_size &&						\
-- 
2.9.5

