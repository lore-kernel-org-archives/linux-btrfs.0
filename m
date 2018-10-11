Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD249C46463
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1BE2086E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB1BE2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbeJKNG3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:29 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38796 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727713AbeJKNG3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:29 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913762"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 174564B6ED8F
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:47 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:51 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] btrfs: delayed-ref: pass delayed_refs directly to btrfs_delayed_ref_lock()
Date:   Thu, 11 Oct 2018 13:40:34 +0800
Message-ID: <20181011054038.5428-3-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 174564B6ED8F.ACE2D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since trans is only used for referring to delayed_refs, there is no need
to pass it instead of delayed_refs to btrfs_delayed_ref_lock().

No functional change.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 5 +----
 fs/btrfs/delayed-ref.h | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 13ae86252c4c..885581852bea 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -204,12 +204,9 @@ static struct btrfs_delayed_ref_head* find_ref_head(
 	return NULL;
 }
 
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head)
 {
-	struct btrfs_delayed_ref_root *delayed_refs;
-
-	delayed_refs = &trans->transaction->delayed_refs;
 	lockdep_assert_held(&delayed_refs->lock);
 	if (mutex_trylock(&head->mutex))
 		return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index aa66ad6919ab..ef6f5cf75b3e 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -255,7 +255,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 bytenr);
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head);
 static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22acc1545147..77156bd2a9a7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2521,7 +2521,7 @@ static struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
 	 * Grab the lock that says we are going to process all the refs for
 	 * this head
 	 */
-	ret = btrfs_delayed_ref_lock(trans, head);
+	ret = btrfs_delayed_ref_lock(delayed_refs, head);
 	spin_unlock(&delayed_refs->lock);
 
 	/*
-- 
2.19.1



