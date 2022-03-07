Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DF8C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Mar 2022 00:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbiCGAnH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Mar 2022 19:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiCGAnH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2022 19:43:07 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475C028E02;
        Sun,  6 Mar 2022 16:42:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6NhnNp_1646613727;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V6NhnNp_1646613727)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 08:42:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] btrfs: Fix non-kernel-doc comment
Date:   Mon,  7 Mar 2022 08:42:04 +0800
Message-Id: <20220307004204.25417-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Clean up the following clang-w1 warning:

fs/btrfs/space-info.c:1594: warning: This comment starts with '/**', but
isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Trye to reserve metadata bytes from the block_rsv's space.

fs/btrfs/space-info.c:1629: warning: This comment starts with '/**', but
isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Try to reserve data bytes for an allocation.

fs/btrfs/space-info.c:1468: warning: This comment starts with '/**', but
isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Try to reserve bytes from the block_rsv's space.

fs/btrfs/space-info.c:1375: warning: This comment starts with '/**', but
isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Do the appropriate flushing and waiting for a ticket.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/btrfs/space-info.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 9652dd042c20..37b3b6f107ee 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1372,7 +1372,7 @@ static void wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 }
 
 /**
- * Do the appropriate flushing and waiting for a ticket
+ * handle_reserve_ticket - Do the appropriate flushing and waiting for a ticket
  *
  * @fs_info:    the filesystem
  * @space_info: space info for the reservation
@@ -1465,7 +1465,7 @@ static inline bool can_steal(enum btrfs_reserve_flush_enum flush)
 }
 
 /**
- * Try to reserve bytes from the block_rsv's space
+ * __reserve_bytes - Try to reserve bytes from the block_rsv's space
  *
  * @fs_info:    the filesystem
  * @space_info: space info we want to allocate from
@@ -1591,7 +1591,8 @@ static int __reserve_bytes(struct btrfs_fs_info *fs_info,
 }
 
 /**
- * Trye to reserve metadata bytes from the block_rsv's space
+ * btrfs_reserve_metadata_bytes - Trye to reserve metadata bytes from
+ * the block_rsv's space
  *
  * @fs_info:    the filesystem
  * @block_rsv:  block_rsv we're allocating for
@@ -1626,7 +1627,7 @@ int btrfs_reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 }
 
 /**
- * Try to reserve data bytes for an allocation
+ * btrfs_reserve_data_bytes - Try to reserve data bytes for an allocation
  *
  * @fs_info: the filesystem
  * @bytes:   number of bytes we need
-- 
2.20.1.7.g153144c

