Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E185C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34A442086E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34A442086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbeJKNGb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:31 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52321 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727713AbeJKNGa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:30 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913758"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 991A24B6ED8D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:46 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:51 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/6] btrfs: delayed-ref: pass delayed_refs directly to btrfs_select_ref_head()
Date:   Thu, 11 Oct 2018 13:40:33 +0800
Message-ID: <20181011054038.5428-2-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 991A24B6ED8D.A9099
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since trans is only used for referring to delayed_refs, there is no need
to pass it instead of delayed_refs to btrfs_select_ref_head().

No functional change.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 5 +----
 fs/btrfs/delayed-ref.h | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7f567c944fec..13ae86252c4c 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -354,15 +354,12 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq)
 }
 
 struct btrfs_delayed_ref_head *
-btrfs_select_ref_head(struct btrfs_trans_handle *trans)
+btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
 {
-	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_head *head;
 	u64 start;
 	bool loop = false;
 
-	delayed_refs = &trans->transaction->delayed_refs;
-
 again:
 	start = delayed_refs->run_delayed_start;
 	head = find_ref_head(delayed_refs, start, 1);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index c3e3486a126c..aa66ad6919ab 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -264,7 +264,7 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 
 
 struct btrfs_delayed_ref_head *
-btrfs_select_ref_head(struct btrfs_trans_handle *trans);
+btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs);
 
 int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22b9269ae84c..22acc1545147 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2511,7 +2511,7 @@ static struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
 	int ret;
 
 	spin_lock(&delayed_refs->lock);
-	head = btrfs_select_ref_head(trans);
+	head = btrfs_select_ref_head(delayed_refs);
 	if (!head) {
 		spin_unlock(&delayed_refs->lock);
 		return head;
-- 
2.19.1



