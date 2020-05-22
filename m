Return-Path: <SRS0=4/Cm=7E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4D2C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 May 2020 12:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9855C206D5
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 May 2020 12:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgEVMjE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:39:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:59084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgEVMjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 May 2020 08:39:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD621AF23;
        Fri, 22 May 2020 12:39:05 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     hch@infradead.org, dsterba@suse.cz,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/7] iomap: Remove lockdep_assert_held()
Date:   Fri, 22 May 2020 07:38:33 -0500
Message-Id: <20200522123837.1196-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522123837.1196-1-rgoldwyn@suse.de>
References: <20200522123837.1196-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Filesystems such as btrfs can perform direct I/O without holding the
inode->i_rwsem in some of the cases like writing within i_size.
So, remove the check for lockdep_assert_held() in iomap_dio_rw()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap/direct-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f88ba6e7f6af..e4addfc58107 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -416,8 +416,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
-	lockdep_assert_held(&inode->i_rwsem);
-
 	if (!count)
 		return 0;
 
-- 
2.25.0

