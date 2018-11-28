Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19065C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6DA82081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6DA82081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbeK1OVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:21:45 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3863 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726942AbeK1OVp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:21:45 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48767083"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:21:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D28844B6AE19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:21:36 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 28 Nov
 2018 11:21:42 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs: remove always true if branch in find_delalloc_range
Date:   Wed, 28 Nov 2018 11:21:30 +0800
Message-ID: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: D28844B6AE19.A8492
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The @found is always false when it comes to the if branch. Besides, the
bool type is more suitable for @found.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 582b4b1c41e0..b4ee3399be96 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1461,7 +1461,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	struct rb_node *node;
 	struct extent_state *state;
 	u64 cur_start = *start;
-	u64 found = 0;
+	bool found = false;
 	u64 total_bytes = 0;
 
 	spin_lock(&tree->lock);
@@ -1472,8 +1472,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	 */
 	node = tree_search(tree, cur_start);
 	if (!node) {
-		if (!found)
-			*end = (u64)-1;
+		*end = (u64)-1;
 		goto out;
 	}
 
@@ -1493,7 +1492,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			*cached_state = state;
 			refcount_inc(&state->refs);
 		}
-		found++;
+		found = true;
 		*end = state->end;
 		cur_start = state->end + 1;
 		node = rb_next(node);
-- 
2.19.2



