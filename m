Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A911C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7352086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA7352086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbeK1OEP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:15 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727115AbeK1OEO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:14 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766238"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E54E54B734AB
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:10 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:16 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 06/17] btrfs: priority alloc: introduce three macros to mark block group status
Date:   Wed, 28 Nov 2018 11:11:37 +0800
Message-ID: <20181128031148.357-7-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: E54E54B734AB.A8B78
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In origin design, the order of space_info::block_groups is changed only
when add/remove block group(s).

In design of priority aware allocator, block groups may be moved from
one priority tree to another one. What the operation is usually that
1)  lock block_group
    down_write first_tree
    down_write second_tree
    do unlink
    ....
    do link
    up_write second_tree
    up_write first_tree
    unlock blcok_group
However, the expected order in find_free_extent() is
2)  down_read tree
    lock block_group
    ...
    unlock block_group
    up_read tree

Obviously, orders of operation 1 and operation 2 are on the contrary
and will cause dead lock.

The ugly method is to introduce special status to mark block group
status.
Then:

1) After priority changed:
    lock block_group
    mark block_group to be updated
    unlock blcok_group

    down_write first_tree
    down_write second_tree

    lock block_group
    check block group should be moved
    do unlink
    ....
    do link
    unlock blcok_group
    up_write second_tree
    up_write first_tree

2) find_free_extent():
    down_read tree
    lock block_group
    check the block group is not in special status
    ...
    unlock block_group
    up_read tree

This patch introduce three macros to represents block group is removing
/need to updated / busy.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d63078930a1e..5bae757786dc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -31,6 +31,15 @@
 
 #undef SCRAMBLE_DELAYED_REFS
 
+/* The block group is used by find_free_extent() */
+#define PRIORITY_BG_BUSY -1
+
+/* The block group is in remove or removed */
+#define PRIORITY_BG_DELETED -2
+
+/* The block group' priority needs to be updated */
+#define PRIORITY_BG_UPDATING -3
+
 /*
  * control flags for do_chunk_alloc's force field
  * CHUNK_ALLOC_NO_FORCE means to only allocate a chunk
-- 
2.19.1



