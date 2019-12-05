Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07899C2D0BF
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 15:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83B124654
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 15:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbfLEP4o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 10:56:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:35498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729790AbfLEP4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 10:56:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A86E0ADE4;
        Thu,  5 Dec 2019 15:56:41 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, hch@infradead.org,
        darrick.wong@oracle.com, fdmanana@kernel.org, nborisov@suse.com,
        dsterba@suse.cz, jthumshirn@suse.de,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/8] iomap: Remove lockdep_assert_held()
Date:   Thu,  5 Dec 2019 09:56:25 -0600
Message-Id: <20191205155630.28817-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191205155630.28817-1-rgoldwyn@suse.de>
References: <20191205155630.28817-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Filesystems such as btrfs can perform direct I/O without holding the
inode->i_rwsem in some of the cases like writing within i_size.
So, remove the check for lockdep_assert_held().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/iomap/direct-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 2dac380f88a0..dc420cb13878 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -410,8 +410,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
-	lockdep_assert_held(&inode->i_rwsem);
-
 	if (!count)
 		return 0;
 
-- 
2.16.4

