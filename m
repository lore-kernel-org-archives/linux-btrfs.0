Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1F0C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F77121104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F77121104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbeKUOBa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 09:01:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbeKUOB3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 09:01:29 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13802356D3;
        Wed, 21 Nov 2018 03:28:58 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36DC810021B6;
        Wed, 21 Nov 2018 03:28:48 +0000 (UTC)
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
Subject: [PATCH V11 17/19] block: document usage of bio iterator helpers
Date:   Wed, 21 Nov 2018 11:23:25 +0800
Message-Id: <20181121032327.8434-18-ming.lei@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 21 Nov 2018 03:28:58 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now multi-page bvec is supported, some helpers may return page by
page, meantime some may return segment by segment, this patch
documents the usage.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 Documentation/block/biovecs.txt | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
index 25689584e6e0..bb008f7afb05 100644
--- a/Documentation/block/biovecs.txt
+++ b/Documentation/block/biovecs.txt
@@ -117,3 +117,27 @@ Other implications:
    size limitations and the limitations of the underlying devices. Thus
    there's no need to define ->merge_bvec_fn() callbacks for individual block
    drivers.
+
+Usage of helpers:
+=================
+
+* The following helpers whose names have the suffix of "_all" can only be used
+on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
+shouldn't use them because the bio may have been split before it reached the
+driver.
+
+	bio_for_each_segment_all()
+	bio_first_bvec_all()
+	bio_first_page_all()
+	bio_last_bvec_all()
+
+* The following helpers iterate over single-page bvecs. The passed 'struct
+bio_vec' will contain a single-page IO vector during the iteration
+
+	bio_for_each_segment()
+	bio_for_each_segment_all()
+
+* The following helpers iterate over single-page bvecs. The passed 'struct
+bio_vec' will contain a single-page IO vector during the iteration
+
+	bio_for_each_bvec()
-- 
2.9.5

