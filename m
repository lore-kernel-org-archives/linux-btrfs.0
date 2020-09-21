Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F3DC43469
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 14:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80F52076E
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 14:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgIUOow (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 10:44:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:56498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbgIUOot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 10:44:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 309A9B218;
        Mon, 21 Sep 2020 14:45:24 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        johannes.thumshirn@wdc.com, dsterba@suse.com,
        darrick.wong@oracle.com, josef@toxicpanda.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 15/15] iomap: Reinstate lockdep_assert_held in iomap_dio_rw()
Date:   Mon, 21 Sep 2020 09:43:53 -0500
Message-Id: <20200921144353.31319-16-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921144353.31319-1-rgoldwyn@suse.de>
References: <20200921144353.31319-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

btrfs holds inode_lock_shared() while performing DIO within EOF, so
lockdep_assert_held() check can be re-instated.

Revert 3ad99bec6e82 ("iomap: remove lockdep_assert_held()")

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/iomap/direct-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e01f81e7b76f..b5e030971001 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -421,6 +421,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
+	lockdep_assert_held(&inode->i_rwsem);
+
 	if (!count)
 		return NULL;
 
-- 
2.26.2

