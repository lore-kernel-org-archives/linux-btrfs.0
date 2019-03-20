Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A9CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F15D02184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfCTG2J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:28:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:39818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727452AbfCTG2I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:28:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 292BEAD3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:28:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5.3 07/11] btrfs: extent_io: Handle error better in extent_write_locked_range()
Date:   Wed, 20 Mar 2019 14:27:45 +0800
Message-Id: <20190320062749.30953-8-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Do proper cleanup if we hit any error in extent_write_locked_range(),
and check the return value of flush_write_bio().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ad7c6afe623..c688049ccfc3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4077,7 +4077,6 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode)
 {
 	int ret = 0;
-	int flush_ret;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
@@ -4110,8 +4109,12 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 		start += PAGE_SIZE;
 	}
 
-	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
+	ASSERT(ret <= 0);
+	if (ret < 0) {
+		end_write_bio(&epd, ret);
+		return ret;
+	}
+	ret = flush_write_bio(&epd);
 	return ret;
 }
 
-- 
2.21.0

