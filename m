Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9272FC28CF8
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 06:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 348442064E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 06:25:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 348442064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbeJOOJr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 10:09:47 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43764 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726164AbeJOOJq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 10:09:46 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46144637"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Oct 2018 14:25:48 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C1E9D4B6ED4D;
        Mon, 15 Oct 2018 14:25:44 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 15 Oct
 2018 14:25:49 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <nborisov@suse.com>
Subject: [PATCH] btrfs: delayed-ref: extract find_first_ref_head from find_ref_head
Date:   Mon, 15 Oct 2018 14:25:38 +0800
Message-ID: <20181015062538.30784-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: C1E9D4B6ED4D.AE8CF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The find_ref_head shouldn't return the first entry even if no exact match
is found. So move the hidden behavior to higher level.

Besides, remove the useless local variables in the btrfs_select_ref_head.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 45 +++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6e8be384398e..a92f104cf06f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -164,14 +164,28 @@ static struct btrfs_delayed_ref_node* tree_insert(struct rb_root_cached *root,
 	return NULL;
 }
 
+static struct btrfs_delayed_ref_head *find_first_ref_head(
+		struct btrfs_delayed_ref_root *dr)
+{
+	struct rb_node *n;
+	struct btrfs_delayed_ref_head *entry;
+
+	n = rb_first_cached(&dr->href_root);
+	if (!n)
+		return NULL;
+
+	entry = rb_entry(n, struct btrfs_delayed_ref_head, href_node);
+
+	return entry;
+}
+
 /*
  * find an head entry based on bytenr. This returns the delayed ref
  * head if it was able to find one, or NULL if nothing was in that spot.
  * If return_bigger is given, the next bigger entry is returned if no exact
- * match is found. But if no bigger one is found then the first node of the
- * ref head tree will be returned.
+ * match is found.
  */
-static struct btrfs_delayed_ref_head* find_ref_head(
+static struct btrfs_delayed_ref_head *find_ref_head(
 		struct btrfs_delayed_ref_root *dr, u64 bytenr,
 		bool return_bigger)
 {
@@ -195,10 +209,9 @@ static struct btrfs_delayed_ref_head* find_ref_head(
 		if (bytenr > entry->bytenr) {
 			n = rb_next(&entry->href_node);
 			if (!n)
-				n = rb_first_cached(&dr->href_root);
+				return NULL;
 			entry = rb_entry(n, struct btrfs_delayed_ref_head,
 					 href_node);
-			return entry;
 		}
 		return entry;
 	}
@@ -358,33 +371,25 @@ struct btrfs_delayed_ref_head *btrfs_select_ref_head(
 		struct btrfs_delayed_ref_root *delayed_refs)
 {
 	struct btrfs_delayed_ref_head *head;
-	u64 start;
-	bool loop = false;
 
 again:
-	start = delayed_refs->run_delayed_start;
-	head = find_ref_head(delayed_refs, start, true);
-	if (!head && !loop) {
+	head = find_ref_head(delayed_refs, delayed_refs->run_delayed_start,
+			     true);
+	if (!head && delayed_refs->run_delayed_start != 0) {
 		delayed_refs->run_delayed_start = 0;
-		start = 0;
-		loop = true;
-		head = find_ref_head(delayed_refs, start, true);
-		if (!head)
-			return NULL;
-	} else if (!head && loop) {
-		return NULL;
+		head = find_first_ref_head(delayed_refs);
 	}
+	if (!head)
+		return NULL;
 
 	while (head->processing) {
 		struct rb_node *node;
 
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



