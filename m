Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B0DC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C53652085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C53652085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbeJKNG0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:26 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbeJKNG0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:26 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913757"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C0E874B6EDA2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:48 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:53 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] btrfs: simplify btrfs_select_ref_head and cleanup some local variables
Date:   Thu, 11 Oct 2018 13:40:37 +0800
Message-ID: <20181011054038.5428-6-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: C0E874B6EDA2.AB8FA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If the return value of find_ref_head() is NULL, the only possibility is
that delayed_refs' head ref rbtree is empty. Hence, the second
find_ref_head() is pointless.

Besides, the local variables loop and start are unnecessary, just remove
them.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 885581852bea..2726d2fb4bbe 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -354,20 +354,11 @@ struct btrfs_delayed_ref_head *
 btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
 {
 	struct btrfs_delayed_ref_head *head;
-	u64 start;
-	bool loop = false;
 
 again:
-	start = delayed_refs->run_delayed_start;
-	head = find_ref_head(delayed_refs, start, 1);
-	if (!head && !loop) {
+	head = find_ref_head(delayed_refs, delayed_refs->run_delayed_start, 1);
+	if (!head) {
 		delayed_refs->run_delayed_start = 0;
-		start = 0;
-		loop = true;
-		head = find_ref_head(delayed_refs, start, 1);
-		if (!head)
-			return NULL;
-	} else if (!head && loop) {
 		return NULL;
 	}
 
@@ -376,11 +367,9 @@ btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
 
 		node = rb_next(&head->href_node);
 		if (!node) {
-			if (loop)
+			if (delayed_refs->run_delayed_start == 0)
 				return NULL;
 			delayed_refs->run_delayed_start = 0;
-			start = 0;
-			loop = true;
 			goto again;
 		}
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
-- 
2.19.1



