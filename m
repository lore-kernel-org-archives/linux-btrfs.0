Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAFAC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816A02085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 816A02085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbeJKNGe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:34 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52321 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727713AbeJKNGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:33 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913770"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:53 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 556AB4B6ED8D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:49 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:54 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] btrfs: switch return_bigger to bool in find_ref_head
Date:   Thu, 11 Oct 2018 13:40:38 +0800
Message-ID: <20181011054038.5428-7-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 556AB4B6ED8D.ABAE7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Using bool is more suitable than int here, and add the comment about the
return_bigger.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 2726d2fb4bbe..61a19376239e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -168,11 +168,12 @@ static struct btrfs_delayed_ref_node* tree_insert(struct rb_root_cached *root,
  * find an head entry based on bytenr. This returns the delayed ref
  * head if it was able to find one, or NULL if nothing was in that spot.
  * If return_bigger is given, the next bigger entry is returned if no exact
- * match is found.
+ * match is found. But if no bigger one is found then the first node of the
+ * ref head tree will be returned.
  */
 static struct btrfs_delayed_ref_head* find_ref_head(
 		struct btrfs_delayed_ref_root *dr, u64 bytenr,
-		int return_bigger)
+		bool return_bigger)
 {
 	struct rb_root *root = &dr->href_root.rb_root;
 	struct rb_node *n;
@@ -356,7 +357,8 @@ btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
 	struct btrfs_delayed_ref_head *head;
 
 again:
-	head = find_ref_head(delayed_refs, delayed_refs->run_delayed_start, 1);
+	head = find_ref_head(delayed_refs, delayed_refs->run_delayed_start,
+			     true);
 	if (!head) {
 		delayed_refs->run_delayed_start = 0;
 		return NULL;
@@ -894,7 +896,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs, u64 bytenr)
 {
-	return find_ref_head(delayed_refs, bytenr, 0);
+	return find_ref_head(delayed_refs, bytenr, false);
 }
 
 void __cold btrfs_delayed_ref_exit(void)
-- 
2.19.1



